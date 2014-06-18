package xtraitj.compiler

import com.google.inject.Inject
import java.util.HashMap
import java.util.Map
import org.eclipse.xtext.common.types.JvmConstraintOwner
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmWildcardTypeReference
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.xbase.compiler.DisableCodeGenerationAdapter
import org.eclipse.xtext.xbase.compiler.IGeneratorConfigProvider
import org.eclipse.xtext.xbase.compiler.JvmModelGenerator
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xtype.XFunctionTypeRef
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.jvmmodel.XtraitjJvmModelHelper
import xtraitj.jvmmodel.XtraitjJvmModelUtil
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.XtraitjModelUtil.*

class XtraitjJvmModelGenerator extends JvmModelGenerator {
	
	@Inject extension XtraitjGeneratorExtensions
	@Inject extension JvmTypesBuilder
	@Inject extension XtraitjJvmModelUtil
	@Inject extension XtraitjJvmModelHelper
	
	@Inject IGeneratorConfigProvider generatorConfigProvider
	
	override dispatch void internalDoGenerate(JvmDeclaredType type, IFileSystemAccess fsa) {
		if (DisableCodeGenerationAdapter.isDisabled(type))
			return;
		if(type.qualifiedName != null) {
			val genericType = type as JvmGenericType
			val t = genericType.associatedTrait
			if (t !== null) {
				if (genericType.interface) {
					preprocessTraitInterface(t, genericType)
					fsa.generateFile(t.traitInterfaceName.replace('.', '/') + '.java', 
						genericType.generateType(generatorConfigProvider.get(type))
					)					
				} else {
					preprocessTraitClass(t, genericType)
					fsa.generateFile(type.qualifiedName.replace('.', '/') + '.java', 
						type.generateType(generatorConfigProvider.get(type))
					)
				}
			} else {
				// we can assume it's an Xtraitj class
				preprocessClassInferredType(genericType)
				super._internalDoGenerate(type, fsa)
			}
		}
	}
	
	def preprocessTraitInterface(TJTrait t, JvmGenericType it) {
//		val traitInterface = t.toInterface(t.traitInterfaceName) [
//			documentation = t.documentation
//			
//			t.annotateAsTrait(it)
		
		   	copyTypeParameters(t.traitTypeParameters)

			val map = new HashMap<JvmTypeParameter, JvmTypeParameter>		   	
		   	for (typePar : typeParameters) {
		   		typePar.rebindConstraintsTypeParameters(it, map)
		   	}
		   	
		   	for (traitRef : t.traitExpression.traitReferences) {
		   		val superTypeRef = traitRef.traitReferenceJavaType
		   		superTypeRef.transformClassReferenceToInterfaceReference
   				superTypes += superTypeRef
   			}
		   			
			for (field : t.fields) {
				members += field.toGetterAbstract(it) => [
					field.annotateAsRequiredField(it)
				]
				members += field.toSetterAbstract(it)
			}
			
			for (method : t.methods) {
				if (!method.isPrivate)
					members += method.toAbstractMethod(it) => [
	   					translateAnnotations(method.annotations)
	   					method.annotateAsDefinedMethod(it)
	   				]
			}
			
			for (method : t.requiredMethods) {
				members += method.toAbstractMethod(it) => [
					method.annotateAsRequiredMethod(it)
				]
			}
//		]
//		traitInterface
	}
	
	def preprocessTraitClass(TJTrait t, JvmGenericType it) {
		val traitInterfaceTypeRef = t.associatedInterface
			
		val transformedTraitInterfaceTypeRef = traitInterfaceTypeRef.
						transformTypeParametersIntoTypeArguments(t)
						
		superTypes.add(0, transformedTraitInterfaceTypeRef)
		
		members.add(0, t.toConstructor[
			simpleName = t.name
			parameters += t.toParameter("delegate", transformedTraitInterfaceTypeRef)
			body = [
				it.append('''this.«delegateFieldName» = delegate;''')
				for (traitExp : t.traitExpression.traitReferences) {
	   				newLine.append('''«traitExp.traitFieldName» = ''')
	   				append('''new ''')
					append(traitExp.traitReferenceJavaType.type)
					append("(delegate);")
				}
   			]
		])

		for (traitExp : t.traitReferences)
			members.add(0, traitExp.toField
				(traitExp.traitFieldName, traitExp.traitReferenceJavaType))

		members.add(0, t.toField(delegateFieldName, transformedTraitInterfaceTypeRef))
		
		// remove the default constructor
		members.remove(members.size - 1)
	}

	def preprocessClassInferredType(JvmGenericType type) {
		for (s : type.superTypes) {
			val superTypeRef = (s as JvmParameterizedTypeReference)
			
			superTypeRef.transformClassReferenceToInterfaceReference
		}
	}

	def transformClassReferenceToInterfaceReference(JvmParameterizedTypeReference superTypeRef) {
		// we must transform the references to Trait classes
		// into references to Trait interfaces
		val t = (superTypeRef.type as JvmGenericType)
		if (!t.isInterface && t.notJavaLangObject) {
			// then it's the reference to a trait class
			superTypeRef.type = t.superTypes.head.type
		}
	}

   	def toGetterAbstract(TJMember m, JvmTypeParameterDeclarator target) {
   		m.toGetter(m.name, m.type.rebindTypeParameters(target)) => [
   			abstract = true
   		]
   	}

   	def toSetterAbstract(TJMember m, JvmTypeParameterDeclarator target) {
   		m.toSetter(m.name, m.type.rebindTypeParameters(target)) => [
   			abstract = true
   		]
   	}

	def toAbstractMethod(TJMethodDeclaration m, JvmTypeParameterDeclarator target) {
		m.toMethod(m.name, m.type) [
			documentation = m.documentation

			copyTypeParameters(m.typeParameters)
			
			returnType = returnType.rebindTypeParameters(target)

			for (p : m.params) {
				parameters += p.toParameter(p.name, p.parameterType.rebindTypeParameters(target))
			}
			abstract = true
		]
	}

	/**
	 * It is crucial to rebind the type parameter reference to the
	 * interface inferred for the trait, otherwise the type parameter
	 * will point to the class inferred for the trait and we
	 * get IllegalArgumentException during the typing (the reference owner
	 * is different)
	 */
	def JvmTypeReference rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator target) {
		typeRef.rebindTypeParameters(target, newHashMap())
	}

	def JvmTypeReference rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator target, Map<JvmTypeParameter, JvmTypeParameter> visited) {
		val reboundTypeRef = typeRef.cloneWithProxies
		
		if (reboundTypeRef instanceof JvmParameterizedTypeReference) {
			val type = reboundTypeRef.type
			
			if (type instanceof JvmTypeParameter) {
				var typePar = visited.get(type)
				
				if (typePar === null) {
					typePar = target.typeParameters.findFirst[name == reboundTypeRef.type.simpleName]
					
					visited.put(type, typePar)
					
					rebindConstraintsTypeParameters(typePar, target, visited)
				}
				
				reboundTypeRef.type = typePar
			}
			
			// rebind type arguments as well
			val arguments = reboundTypeRef.arguments
			for (i : 0..<arguments.size()) {
				arguments.set(i, arguments.get(i).rebindTypeParameters(target, visited))
			}
			
			return reboundTypeRef
		}

		if (reboundTypeRef instanceof JvmWildcardTypeReference) {
			reboundTypeRef.rebindConstraintsTypeParameters(target, visited)
			return reboundTypeRef
		}
		
		if (reboundTypeRef instanceof XFunctionTypeRef) {
			val reboundReturnTypeRef = reboundTypeRef.returnType.rebindTypeParameters(target, visited)
			reboundTypeRef.returnType = reboundReturnTypeRef
			return reboundTypeRef
		}
		
		return typeRef
	}
	
	protected def rebindConstraintsTypeParameters(JvmConstraintOwner constraintOwner, JvmTypeParameterDeclarator target, Map<JvmTypeParameter, JvmTypeParameter> visited) {
		val constraints = constraintOwner.constraints
		for (i : 0..<constraints.size) {
			val constraint = constraints.get(i)
			constraint.typeReference = constraint.typeReference.rebindTypeParameters(target, visited)
		}
	}

	def traitReferenceJavaType(TJTraitReference t) {
		if (t.operations.empty)
			t.trait.cloneWithProxies as JvmParameterizedTypeReference
		else
			t.newTypeRef(t.traitExpressionClassName) as JvmParameterizedTypeReference
	}


}