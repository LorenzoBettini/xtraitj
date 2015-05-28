package xtraitj.jvmmodel

import com.google.inject.Inject
import com.google.inject.Singleton
import java.beans.Introspector
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmFeature
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.util.Strings
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedConstructor
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.typing.XtraitjTypingUtil
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitOperation
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.jvmmodel.XtraitjResolvedOperationUtil.*
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

	def associatedInterface(TJTrait t) {
		t.associatedInterfaceType.createTypeRef()
	}

	/**
	 * For a trait returns the inferred Java interface,
	 * for a class the inferred Java class
	 */
	def associatedJavaType(TJDeclaration d) {
		if (d instanceof TJTrait) {
			return d.associatedInterfaceType
		} else {
			return d.associatedJavaClass
		}
	}

	def associatedInterfaceType(TJTrait t) {
		t._associatedInterfaceType
	}

	def _associatedInterfaceType(EObject t) {
		t.jvmElements.filter(typeof(JvmGenericType)).
			filter[interface].head
	}

	def associatedJavaClass(EObject t) {
		t.jvmElements.filter(JvmGenericType).head
	}

	def sourceField(JvmMember f) {
		f.sourceElements.findFirst[(it instanceof TJField)] as TJField
	}

	def sourceMethodDeclaration(JvmFeature f) {
		f.sourceElements.findFirst[(it instanceof TJMethodDeclaration)] as TJMethodDeclaration
	}

	def associatedSource(IResolvedConstructor cons) {
		cons.declaration.sourceElements.head
	}

	def computeXtraitjResolvedOperations(JvmTypeReference ref, EObject context) {
		ref.getXtraitjResolvedOperations(context)
	}

	def computeAndResolveXtraitjResolvedOperations(JvmTypeReference e, EObject context) {
		e.computeXtraitjResolvedOperations(context)// => [resolveAll]
	}

	def originalSource(JvmMember o) {
		o.sourceElements.findFirst[
			(it instanceof TJMember)
			||
			(it instanceof TJTraitOperation)
		]
	}

	def alreadyDefined(Iterable<JvmMember> members, JvmMember m) {
		members.exists[simpleName == m.simpleName]
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

	def fieldRepresentation(IResolvedOperation f) {
		f.resolvedReturnType.simpleName + " " + f.fieldName
	}

	def methodRepresentation(IResolvedOperation m) {
		m.resolvedReturnType.simpleName + " " + m.simpleSignature
	}

	def fieldName(IResolvedOperation o) {
		o.declaration.fieldName
	}

	/**
	 * To each field a JvmOperation will correspond in the Java model
	 * a getter method and a setter method, thus, we need to recover the
	 * original field name.
	 * 
	 * IMPORTANT: we assume that the JvmOperation is actually a getter.
	 */
	def fieldName(JvmMember f) {
		val simpleName = f.simpleName
		
		simpleName.replaceFirst("get", "").
				replaceFirst("is", "").toFirstLower			
	}

	/**
	 * Finds a member, IResolvedOperation, using the name of the toFind operation.
	 * It is responsibility of the caller to know whether we are searching a get method
	 * corresponding to a field.
	 */
	def findOperationByName(Iterable<IResolvedOperation> ops, IResolvedOperation toFind) {
		ops.findFirst[ op | op.declaration.simpleName == toFind.declaration.simpleName]
	}

	/**
	 * o1's return type must be the same as of o2's return type
	 * and parameters' types must be the same
	 */
	def exact(IResolvedOperation o1, IResolvedOperation o2) {
		compliant(o1, o2, true)
	}

	/**
	 * o1's return type must be subtype of o2's return type
	 * and parameters' types must be the same
	 */
	def compliant(IResolvedOperation o1, IResolvedOperation o2) {
		compliant(o1, o2, false)
	}

	/**
	 * o1's return type must be subtype of o2's return type
	 * (or the same if strict is true)
	 * and parameters' types must be the same
	 */
	def compliant(IResolvedOperation o1, IResolvedOperation o2, boolean strict) {
		val params1 = o1.resolvedParameterTypes
		val params2 = o2.resolvedParameterTypes
		
		val returnTypeCheck = 
			if (strict)
				o1.resolvedReturnType.sameType(o2.resolvedReturnType)
			else
				o1.resolvedReturnType.isSubtype(o2.resolvedReturnType);
		
		if (returnTypeCheck && params1.size == params2.size) {
			for (i : 0..<params1.size) {
				if (!params1.get(i).sameType(params2.get(i))) {
					return false
				}								
			}
			return true
		}
		return false
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

	def isValidInterface(JvmParameterizedTypeReference t) {
		val type = t.type
		if (type instanceof JvmGenericType) {
			return type.interface
		} else {
			return false
		}
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

	def traitOperationsForJvmOp(TJTraitReference t, IResolvedOperation op) {
		t.operations.filter[
			member?.simpleName == op.simpleName
		]
	}

	def traitReferenceJavaType(TJTraitReference t) {
		if (t.operations.empty)
			t.trait.cloneWithProxies as JvmParameterizedTypeReference
		else
			t.traitExpressionClassName.getTypeForName(t) as JvmParameterizedTypeReference
	}

}

