package xtraitj.jvmmodel

import com.google.inject.Inject
import java.beans.Introspector
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmFeature
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.typing.TraitJTypingUtil
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
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

	def associatedInterface(TJTraitReference t) {
		t.associatedInterfaceType?.createTypeRef(
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
		t.associatedClassType?.createTypeRef(
			t.arguments.map[cloneWithProxies]
		)
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

	def xtraitjJvmAllOperations(TJTraitReference t) {
		t.jvmAllFeatures.filter(typeof(JvmOperation)).map[createXtraitjJvmOperation(t)]
	}

	def xtraitjJvmAllMethodOperations(TJTraitReference t) {
		t.jvmAllMethodOperations.map[createXtraitjJvmOperation(t)]
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

	def jvmAllMethodOperations(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[jvmAllMethodOperations].flatten
	}

	def jvmAllMethods(TJClass e) {
		val _associatedClassType1 = e._associatedClassType
		if (_associatedClassType1 != null)
			_associatedClassType1.allFeatures.
				filter(typeof(JvmOperation))
		else
			emptyList
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
				traitRef.jvmAllRequiredFieldOperations.map[
					createXtraitjJvmOperation(traitRef)
				]
			].flatten
	}

	def xtraitjJvmAllRequiredMethodOperations(TJClass e) {
		e.xtraitjJvmAllRequiredMethodOperationsFromReferences
	}

	def xtraitjJvmAllRequiredMethodOperationsFromReferences(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[
				traitRef |
				traitRef.jvmAllRequiredMethodOperations.map[
					createXtraitjJvmOperation(traitRef)
				]
			].flatten
	}

	def xtraitjJvmAllMethodOperations(TJDeclaration e) {
		e.traitExpression.traitReferences.
			map[traitRef | 
				traitRef.jvmAllMethodOperations.map[
					createXtraitjJvmOperation(traitRef)
				]
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
			m.parametersType.map[simpleName].join(", ")
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

	/**
	 * it's return type must be subtype of member's return type
	 * and parameters' types must be the same
	 */
	def compliant(XtraitjJvmOperation it, XtraitjJvmOperation member) {
		returnType.isSubtype(member.returnType) &&
		parametersType.size == member.parametersType.size &&
		{
			var ok = true
			val paramIterator = parametersType.iterator
			val memberParamIterator = member.parametersType.iterator
			while (paramIterator.hasNext && ok) {
				if (!paramIterator.next.sameType
						(memberParamIterator.next))
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
		val type = typeRef.type
		if (type instanceof JvmTypeParameter) {
			// retrieve the index in the type parameters/arguments list
			val declarator = type.declarator
			val pos = declarator.typeParameters.indexOf(type)
			if (pos < typeArguments.size)
				return typeArguments.get(pos).replaceTypeParameters(typeArguments)
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
		
		return typeRef
	}
}

