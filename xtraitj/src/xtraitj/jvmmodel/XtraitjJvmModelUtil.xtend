package xtraitj.jvmmodel

import com.google.inject.Inject
import com.google.inject.Singleton
import java.beans.Introspector
import java.util.List
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmFeature
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmWildcardTypeReference
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.util.Strings
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xtype.XFunctionTypeRef
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.typing.XtraitjTypingUtil
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJRequiredMethod
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitOperation
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.XtraitjModelUtil.*

/**
 * <p>Infers a JVM model from the source model.</p> 
 *
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>     
 */
@Singleton
class XtraitjJvmModelUtil {

	@Inject extension TypeReferences
	@Inject extension IJvmModelAssociations
	@Inject extension XtraitjTypingUtil
	@Inject extension JvmTypesBuilder
	@Inject extension IQualifiedNameProvider
	@Inject extension XtraitjJvmModelHelper
	@Inject extension XtraitjGeneratorExtensions

	def associatedAdapterInterface(TJTraitReference t) {
		t.traitExpressionInterfaceName.getTypeForName(t //,
			//t.trait.arguments.map[cloneWithProxies]
		) as JvmParameterizedTypeReference
	}

	def associatedInterface(TJTrait t) {
		t.associatedInterfaceType?.createTypeRef()
	}

	def associatedInterfaceType(TJTrait t) {
		t._associatedInterfaceType
	}

	def _associatedInterfaceType(EObject t) {
		t.jvmElements.filter(typeof(JvmGenericType)).
			filter[interface].head
	}

	def associatedClass(TJTrait t) {
		t.associatedClassType?.createTypeRef()
	}

	def associatedClassType(TJTrait t) {
		t._associatedClassType
	}

	def _associatedClassType(EObject t) {
		t.jvmElements.filter(typeof(JvmGenericType)).
			filter[!interface].head
	}

	def sourceField(JvmMember f) {
		f.sourceElements.findFirst[(it instanceof TJField)] as TJField
	}

	def sourceMethod(JvmFeature f) {
		f.sourceElements.findFirst[(it instanceof TJMethod)] as TJMethod
	}

	def sourceMethodDeclaration(JvmFeature f) {
		f.sourceElements.findFirst[(it instanceof TJMethodDeclaration)] as TJMethodDeclaration
	}

	def sourceRequiredMethod(JvmFeature f) {
		f.sourceElements.findFirst[(it instanceof TJRequiredMethod)] as TJRequiredMethod
	}

	def sourceRestricted(JvmFeature f) {
		f.sourceElements.findFirst[(it instanceof TJRestrictOperation)] as TJRestrictOperation
	}

	def xtraitjJvmAllRequiredFieldOperations(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[traitRef | 
				traitRef.traitReferenceJavaType.getXtraitjResolvedOperations.requiredFields
			].flatten
	}

	def xtraitjJvmAllRequiredMethodOperations(TJClass e) {
		e.xtraitjJvmAllRequiredMethodOperationsFromReferences
	}

	def computeXtraitjResolvedOperations(JvmTypeReference ref, EObject context) {
		ref.getXtraitjResolvedOperations(context)
	}

	def xtraitjJvmAllRequiredMethodOperationsFromReferences(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[
				traitRef |
				traitRef.traitReferenceJavaType.getXtraitjResolvedOperations.requiredMethods
			].flatten
	}

	def xtraitjJvmAllMethodOperations(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[traitRef | 
				traitRef.traitReferenceJavaType.getXtraitjResolvedOperations.declaredMethods
			].flatten
	}

	def computeAndResolveXtraitjResolvedOperations(JvmTypeReference e, EObject context) {
		e.computeXtraitjResolvedOperations(context) => [resolveAll]
	}

	def originalSource(JvmMember o) {
		o.sourceElements.findFirst[
			(it instanceof TJMember)
			||
			(it instanceof TJTraitOperation)
		]
	}

	def defines(TJTrait t, JvmMember m) {
		t.members.exists[name == m.simpleName]
	}

	def memberByName(Iterable<JvmOperation> members, String name) {
		members.findFirst[name == simpleName]
	}

	def alreadyDefined(Iterable<JvmMember> members, JvmMember m) {
		members.exists[simpleName == m.simpleName]
	}

	def isRequired(JvmMember m) {
		m.sourceElements.exists[
			(it instanceof TJRequiredMethod) ||
			(it instanceof TJField) ||
			(it instanceof TJRestrictOperation)
		]
	}

	def isRequiredMethod(JvmMember m) {
		m.sourceElements.exists[
			(it instanceof TJRequiredMethod) ||
			(it instanceof TJRestrictOperation)
		]
	}

	def associatedTrait(JvmTypeParameterDeclarator type) {
		type.sourceElements.filter(TJTrait).head
	}

	def associatedTraitReference(JvmTypeParameterDeclarator type) {
		type.sourceElements.filter(TJTraitReference).head
	}

	def associatedTJClass(JvmTypeParameterDeclarator type) {
		type.sourceElements.filter(TJClass).head
	}

	def memberRepresentation(JvmMember m) {
		if (m instanceof JvmOperation) {
			if (m.sourceField != null)
				return m.fieldRepresentation
			else
				return m.methodRepresentation
		} else {
			return m.simpleName
		}
	}

	def fieldRepresentation(XtraitjJvmOperation f) {
		f.returnType?.simpleName + " " + 
			f.op.fieldName
	}

	def fieldRepresentation(JvmOperation f) {
		f.returnType?.simpleName + " " + 
			f.fieldName
	}

	def methodRepresentation(XtraitjJvmOperation m) {
		m.returnType?.simpleName + " " + m.op.simpleName +
			"(" +
			m.parametersTypes.map[simpleName].join(", ")
			+ ")"
	}

	def methodRepresentation(JvmOperation m) {
		m.returnType?.simpleName + " " + m.simpleName +
			"(" +
			m.parameters.map[parameterType?.simpleName].join(", ")
			+ ")"
	}

	/**
	 * To each field a JvmOperation will correspond in the Java model
	 * which is the getter method, thus, we need to recover the
	 * original field name.
	 */
	def fieldName(JvmOperation f) {
		f.simpleName.replaceFirst("get", "").
			replaceFirst("is", "").toFirstLower
	}

	def findMatchingField(Iterable<? extends TJField> candidates, XtraitjJvmOperation member) {
		candidates.findFirst[
			name == member.op.fieldName &&
			it.sameType(type, member.returnType)
		]
	}

	def findMatchingMethod(Iterable<? extends XtraitjJvmOperation> candidates, XtraitjJvmOperation member) {
		candidates.findFirst[
			op.simpleName == member.op.simpleName &&
			compliant(it, member)
		]
	}

	def findMatchingOperation(Iterable<? extends XtraitjJvmOperation> candidates, XtraitjJvmOperation member) {
		candidates.findFirst[
			op.simpleName == member.op.simpleName &&
			compliant(it, member)
		]
	}

	/**
	 * it's return type must be subtype of member's return type
	 * and parameters' types must be the same
	 */
	def compliant(XtraitjJvmOperation it, XtraitjJvmOperation member) {
		val context = it.op
		context.isSubtype(returnType, member.returnType) &&
		parametersTypes.size == member.parametersTypes.size &&
		{
			var ok = true
			val paramIterator = parametersTypes.iterator
			val memberParamIterator = member.parametersTypes.iterator
			while (paramIterator.hasNext && ok) {
				if (!context.sameType
						(paramIterator.next, memberParamIterator.next))
					ok = false
			}
			ok
		}
	}

	def findMatchingMethod(Iterable<? extends JvmOperation> candidates, JvmOperation member) {
		candidates.findFirst[
			simpleName == member.simpleName &&
			compliant(it, member)
		]
	}

	/**
	 * it's return type must be subtype of member's return type
	 * and parameters' types must be the same
	 */
	def compliant(JvmOperation it, JvmOperation member) {
		it.isSubtype(returnType, member.returnType) &&
		parameters.size == member.parameters.size &&
		{
			var ok = true
			val paramIterator = parameters.iterator
			val memberParamIterator = member.parameters.iterator
			while (paramIterator.hasNext && ok) {
				if (!it.sameType
						(paramIterator.next.parameterType, memberParamIterator.next.parameterType))
					ok = false
			}
			ok
		}
	}
	
	def compliant(JvmMember m1, JvmMember m2) {
		try {
			return (m1 as JvmOperation).compliant(m2 as JvmOperation)
		} catch (Throwable t) {
			return false
		}
	}

	def renameGetterOrSetter(String opName, String newname) {
		if (opName === null)
			return ""
		
		if (opName.startsWith("get") && opName.length() > 3 && Character::isUpperCase(opName.charAt(3)))
			return "get" + newname.toFirstUpper

		if (opName.startsWith("is") && opName.length() > 2 && Character::isUpperCase(opName.charAt(2)))
			return "is" + newname.toFirstUpper

		if (opName.startsWith("set") && opName.length() > 3 && Character::isUpperCase(opName.charAt(3)))
			return "set" + newname.toFirstUpper
		
		return newname
	}

	def stripGetter(String opName) {
		if (opName === null)
			return ""
		
		if (opName.startsWith("get") && opName.length() > 3 && Character::isUpperCase(opName.charAt(3)))
			return Introspector::decapitalize(opName.substring(3));

		if (opName.startsWith("is") && opName.length() > 2 && Character::isUpperCase(opName.charAt(2)))
			return Introspector::decapitalize(opName.substring(2));
		
		return opName
	}

	def toSetterName(String opName) {
		"set" + Strings.toFirstUpper(opName)
	}

	def fromGetterToSetterName(String opName) {
		opName.stripGetter.toSetterName
	}

	def isValidInterface(JvmParameterizedTypeReference t) {
		try {
			(t.type as JvmGenericType).interface
		} catch (Throwable e) {
			return false
		}
	}

	def conflictsWith(XtraitjJvmOperation f1, XtraitjJvmOperation f2) {
		f1.op != f2.op && 
		f1.op.simpleName == f2.op.simpleName &&
		!f1.compliant(f2)
	}

	def JvmTypeReference replaceTypeParameters(JvmTypeReference typeRef, List<JvmTypeReference> typeArguments) {
		if (typeRef == null)
			return null
		
		val type = typeRef.type
		if (type instanceof JvmTypeParameter) {
			// retrieve the index in the type parameters/arguments list
			val declarator = type.declarator
			// don't substitute type parameters of the method itself
			if (declarator instanceof JvmType) {
				val pos = declarator.typeParameters.indexOf(type)
				if (pos < typeArguments.size)
					return typeArguments.get(pos)
			}
		}
		
		val newTypeRef = typeRef.cloneWithProxies
		if (newTypeRef instanceof JvmParameterizedTypeReference) {
			val arguments = (typeRef as JvmParameterizedTypeReference).arguments
			val newArguments = newTypeRef.arguments
			// IMPORTANT: get the argument from the original arguments, not
			// from the cloned one
			if (!arguments.empty) {
				for (i : 0..arguments.size - 1) {
					newArguments.set(i, 
						arguments.get(i).replaceTypeParameters(typeArguments).cloneWithProxies
					)
				}
				return newTypeRef
			} else {
				return typeRef
			}
		}
		
		if (newTypeRef instanceof XFunctionTypeRef) {
			val funTypeRef = (typeRef as XFunctionTypeRef)
			
			newTypeRef.returnType = funTypeRef.returnType.
				replaceTypeParameters(typeArguments).cloneWithProxies
			
			val paramTypes = funTypeRef.paramTypes
			val newParamTypes = newTypeRef.paramTypes
			if (!paramTypes.empty) {
				for (i : 0..paramTypes.size - 1) {
					newParamTypes.set(
						i,
						paramTypes.get(i).replaceTypeParameters(typeArguments).cloneWithProxies
					)
				}
			}
			return newTypeRef
		}
		
		if (newTypeRef instanceof JvmWildcardTypeReference) {
			val constraints = (typeRef as JvmWildcardTypeReference).constraints
			val newConstraints = newTypeRef.constraints
			// IMPORTANT: get the constraint from the original constraints, not
			// from the cloned one
			if (!constraints.empty) {
				for (i : 0..constraints.size - 1) {
					newConstraints.get(i).typeReference = 
						constraints.get(i).typeReference.
							replaceTypeParameters(typeArguments).
								cloneWithProxies
				}
				return newTypeRef
			} else {
				return typeRef
			}
		}
		
		return typeRef
	}

	/**
	 * Retrieve the main inferred method, i.e., the one with the same name
	 * of the original method, in the class inferred for the trait, without the
	 * underscore (since that is the one that will be linked in method invocations
	 * in other methods).
	 */
	def traitClassInferredMethod(TJMethod m, Set<EObject> elements) {
		val methodNameToSearch = m.containingTrait.traitClassName + "." + m.name
		
		elements.filter(typeof(JvmOperation)).
			findFirst[
				((if (eContainer != null)
					eContainer.fullyQualifiedName + "."
				else 
					"") + simpleName) == 
				methodNameToSearch
			]
	}

	def allJvmElements(EObject o) {
		o.jvmElements
	}
	
	def underscoreName(String name) {
   		"_" + name
   	}

	def operationsForJvmOp(TJTraitReference t, XtraitjJvmOperation jvmOp) {
		t.operations.filter[
			member?.simpleName == jvmOp.op.simpleName ||
			{
				val memberSourceField = member?.sourceField 
				val jvmOpSourceField = jvmOp.op.sourceField;
				(
					memberSourceField != null &&
					jvmOpSourceField != null &&
					memberSourceField == jvmOpSourceField
				)
			}
		]
	}

	def traitReferenceJavaType(TJTraitReference t) {
		if (t.operations.empty)
			t.trait.cloneWithProxies as JvmParameterizedTypeReference
		else
			t.traitExpressionClassName.getTypeForName(t) as JvmParameterizedTypeReference
	}

}

