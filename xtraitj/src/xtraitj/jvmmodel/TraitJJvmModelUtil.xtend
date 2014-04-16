package xtraitj.jvmmodel

import com.google.inject.Inject
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
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.typing.TraitJTypingUtil
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJRequiredMethod
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.TraitJModelUtil.*

/**
 * <p>Infers a JVM model from the source model.</p> 
 *
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>     
 */
class TraitJJvmModelUtil {

	@Inject extension TypeReferences
	@Inject extension IJvmModelAssociations
	@Inject extension TraitJTypingUtil
	@Inject extension JvmTypesBuilder
	@Inject extension IQualifiedNameProvider

	def associatedInterface(TJTraitReference t) {
		val associated = t.associatedInterfaceType
		if (t.operations.empty)
			associated?.createTypeRef(
				t.arguments.map[cloneWithProxies]
			)
		else
			associated?.createTypeRef
	}

	def associatedTraitInterface(TJTraitReference t) {
		t.trait.associatedInterfaceType?.createTypeRef(
			t.arguments.map[cloneWithProxies]
		)
	}

	def associatedTraitClass(TJTraitReference t) {
		t.trait.associatedClassType?.createTypeRef(
			t.arguments.map[cloneWithProxies]
		)
	}

	def associatedInterfaceType(TJTraitReference t) {
		if (t.operations.empty)
			return t.trait.associatedInterfaceType
		return t._associatedInterfaceType
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

	def associatedClass(TJTraitReference t) {
		val associatedType = t.associatedClassType
		if (t.operations.empty)
			associatedType?.createTypeRef(
				t.arguments.map[cloneWithProxies]
			)
		else
			associatedType?.createTypeRef
	}

	def associatedClassType(TJTraitReference t) {
		if (t.operations.empty)
			return t.trait.associatedClassType
		return t._associatedClassType
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

	def jvmAllFeatures(TJTrait t) {
		t._jvmAllFeatures.filter[
			// must correspond to something in the program
			!sourceElements.empty
		]
	}

	def _jvmAllFeatures(TJTrait t) {
		t.associatedInterfaceType?.allFeatures ?:
			emptyList
	}

	def _jvmAllFeatures(TJTraitReference t) {
		t.associatedInterfaceType?.allFeatures ?:
			emptyList
	}

	def jvmAllOperations(TJTrait t) {
		t.jvmAllFeatures.filter(typeof(JvmOperation))
	}

	def xtraitjJvmAllFieldOperations(TJTraitReference t) {
		t.jvmAllFeatures.filter(typeof(JvmOperation)).
			filter[sourceField != null].createXtraitjJvmOperations(t)
	}

	def xtraitjJvmAllRequiredOperations(TJTraitReference t) {
		t.jvmAllFeatures.filter(typeof(JvmOperation)).
			filter[required].createXtraitjJvmOperations(t)
	}

	def xtraitjJvmAllMethodOperations(TJTraitReference t) {
		t.jvmAllMethodOperations.createXtraitjJvmOperations(t)
	}

	def xtraitjJvmAllMethodDeclarationOperations(TJTraitReference t) {
		t.jvmAllMethodDeclarationOperations.createXtraitjJvmOperations(t)
	}

	def jvmAllOperations(TJTraitReference t) {
		t.jvmAllFeatures.filter(typeof(JvmOperation))
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

	def jvmAllFeatures(TJTraitReference t) {
		t._jvmAllFeatures.filter[
			// must correspond to something in the program
			!sourceElements.empty
		]
	}

	def _jvmAllOperations(TJTraitReference t) {
		t.associatedInterfaceType?.allFeatures ?:
			emptyList
	}

	def jvmAllMethodOperations(TJTraitReference e) {
		e._jvmAllOperations.
			filter(typeof(JvmOperation)).
				filter[sourceMethod != null]
			// filter[sourceField == null && sourceMethod != null]
	}

	def jvmAllMethodDeclarationOperations(TJTraitReference e) {
		e._jvmAllOperations.
			filter(typeof(JvmOperation)).
				filter[sourceMethodDeclaration != null]
	}

	def jvmAllInterfaceMethods(TJClass e) {
		e.interfaces.map[type].filter(typeof(JvmGenericType)).
			map[allFeatures].flatten.filter(typeof(JvmOperation)).
				filter[declaringType.identifier != "java.lang.Object"]
	}

	def jvmAllRequiredMethodOperations(TJTraitReference e) {
		e._jvmAllOperations.
			filter(typeof(JvmOperation)).
				filter[requiredMethod]
	}

	def jvmAllRequiredMethodOperations(TJTrait e) {
		e.jvmAllOperations.
			filter(typeof(JvmOperation)).
				filter[requiredMethod]
	}

	def jvmAllRequiredMethodOperations(TJClass e) {
		e.jvmAllRequiredMethodOperationsFromReferences
	}

	def jvmAllRequiredMethodOperationsFromReferences(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[jvmAllRequiredMethodOperations].flatten
	}

	def jvmAllFieldOperations(TJTrait e) {
		e.jvmAllOperations.
			filter(typeof(JvmOperation)).
				filter[sourceField != null]
	}

	def jvmAllFieldOperations(TJTraitReference e) {
		e._jvmAllOperations.
			filter(typeof(JvmOperation)).
				filter[sourceField != null]
	}

	def xtraitjJvmAllRequiredFieldOperations(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[traitRef | 
				traitRef.jvmAllRequiredFieldOperations.
					createXtraitjJvmOperations(traitRef)
			].flatten
	}

	def xtraitjJvmAllRequiredMethodOperations(TJClass e) {
		e.xtraitjJvmAllRequiredMethodOperationsFromReferences
	}

	def xtraitjJvmAllRequiredMethodOperationsFromReferences(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[
				traitRef |
				traitRef.jvmAllRequiredMethodOperations.
					createXtraitjJvmOperations(traitRef)
			].flatten
	}

	def xtraitjJvmAllMethodOperations(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[traitRef | 
				traitRef.jvmAllMethodOperations.
					createXtraitjJvmOperations(traitRef)
			].flatten
	}

	/**
	 * Do not put the operations corresponding to set methods
	 * since we want a single operation for each field (while
	 * in Java there will be both getter and setter)
	 */
	def jvmAllRequiredFieldOperations(TJTraitReference e) {
		e.jvmAllFieldOperations.filter[!(simpleName.startsWith("set"))]
	}

	def originalSource(JvmMember o) {
		o.sourceElements.findFirst[(it instanceof TJMember)] as TJMember
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

	def isRequired(XtraitjJvmOperation o) {
		o.op.required
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
			type.sameType(member.returnType)
		]
	}

	def findMatchingMethod(Iterable<? extends XtraitjJvmOperation> candidates, XtraitjJvmOperation member) {
		candidates.findFirst[
			op.simpleName == member.op.simpleName &&
			compliant(it, member)
		]
	}

	def findMatchingOperation(Iterable<? extends XtraitjJvmOperation> candidates, JvmOperation member) {
		candidates.findFirst[
			op.simpleName == member.simpleName &&
			compliant(it, member)
		]
	}

	/**
	 * it's return type must be subtype of member's return type
	 * and parameters' types must be the same
	 */
	def compliant(XtraitjJvmOperation it, XtraitjJvmOperation member) {
		returnType.isSubtype(member.returnType) &&
		parametersTypes.size == member.parametersTypes.size &&
		{
			var ok = true
			val paramIterator = parametersTypes.iterator
			val memberParamIterator = member.parametersTypes.iterator
			while (paramIterator.hasNext && ok) {
				if (!paramIterator.next.sameType
						(memberParamIterator.next))
					ok = false
			}
			ok
		}
	}

	/**
	 * it's return type must be subtype of member's return type
	 * and parameters' types must be the same
	 */
	def compliant(XtraitjJvmOperation it, JvmOperation member) {
		returnType.isSubtype(member.returnType) &&
		parametersTypes.size == member.parameters.size &&
		{
			var ok = true
			val paramIterator = parametersTypes.iterator
			val memberParamIterator = member.parameters.iterator
			while (paramIterator.hasNext && ok) {
				if (!paramIterator.next.sameType
						(memberParamIterator.next.parameterType))
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
		returnType.isSubtype(member.returnType) &&
		parameters.size == member.parameters.size &&
		{
			var ok = true
			val paramIterator = parameters.iterator
			val memberParamIterator = member.parameters.iterator
			while (paramIterator.hasNext && ok) {
				if (!paramIterator.next.parameterType.sameType
						(memberParamIterator.next.parameterType))
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
		if (opName.startsWith("get") && opName.length() > 3 && Character::isUpperCase(opName.charAt(3)))
			return "get" + newname.toFirstUpper

		if (opName.startsWith("is") && opName.length() > 2 && Character::isUpperCase(opName.charAt(2)))
			return "is" + newname.toFirstUpper

		if (opName.startsWith("set") && opName.length() > 3 && Character::isUpperCase(opName.charAt(3)))
			return "set" + newname.toFirstUpper
		
		return newname
	}

	def stripGetter(String opName) {
		if (opName.startsWith("get") && opName.length() > 3 && Character::isUpperCase(opName.charAt(3)))
			return Introspector::decapitalize(opName.substring(3));

		if (opName.startsWith("is") && opName.length() > 2 && Character::isUpperCase(opName.charAt(2)))
			return Introspector::decapitalize(opName.substring(2));
		
		return opName
	}

	def isValidInterface(JvmParameterizedTypeReference t) {
		try {
			(t.type as JvmGenericType).interface
		} catch (Throwable e) {
			return false
		}
	}

	def conflictsWith(JvmOperation f1, JvmOperation f2) {
		f1 != f2 && 
		f1.simpleName == f2.simpleName &&
		!f1.compliant(f2)
	}

	def createXtraitjJvmOperations(Iterable<JvmOperation> ops, TJTraitReference traitReference) {
		ops.map[createXtraitjJvmOperation(traitReference)].filter[
			// we must discard elements where type parameters (excluding the ones occurring
			// in the type arguments) are still present
			// this happens if we redefined a method with type params in a trait
			// interface using a method with type params already instantiated
			!hasTypeParametersDeclaredInJvmType(traitReference.arguments)
		]
	}

	def createXtraitjJvmOperation(JvmOperation op, TJTraitReference traitReference) {
		val arguments = traitReference.arguments
		new XtraitjJvmOperation(
			op,
			op.returnType.replaceTypeParameters(arguments),
			op.parameters.map[
				parameterType.replaceTypeParameters(arguments)
			]
		)
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

	def traitClassName(TJTrait t) {
   		val n = t.fullyQualifiedName
   		n.skipLast(1).append("traits").append("impl").
   			append(n.lastSegment).toString + "Impl"
   	}
}

