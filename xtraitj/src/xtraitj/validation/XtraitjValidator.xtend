/*
 * generated by Xtext
 */
package xtraitj.validation

import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import xtraitj.jvmmodel.TraitJJvmModelUtil
import xtraitj.xtraitj.TJAliasOperation
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJHideOperation
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJRedirectOperation
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TjTraitOperationForProvided
import xtraitj.xtraitj.XtraitjPackage

import static extension xtraitj.util.TraitJModelUtil.*
import xtraitj.xtraitj.TJRequiredMethod
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJTraitOperation
import org.eclipse.emf.ecore.EStructuralFeature
import xtraitj.xtraitj.TJRenameOperation
import xtraitj.xtraitj.TJConstructor

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class XtraitjValidator extends AbstractXtraitjValidator {

	public static val PREFIX = "xtraitj."

	public static val DEPENDENCY_CYCLE = PREFIX + "DependencyCycle"
	
	public static val TRAIT_INITIALIZES_FIELD = PREFIX + "TraitInitializesField"
	
	public static val MISSING_REQUIRED_FIELD = PREFIX + "MissingRequiredField"

	public static val MISSING_REQUIRED_METHOD = PREFIX + "MissingRequiredMethod"

	public static val MISSING_INTERFACE_METHOD = PREFIX + "MissingInterfaceMethod"
	
	public static val HIDING_REQUIRED = PREFIX + "HidingRequired"

	public static val ALIASING_REQUIRED = PREFIX + "AliasingRequired"

	public static val RESTRICTING_REQUIRED = PREFIX + "RestrictingRequired"
	
	public static val FIELD_REDIRECTED_TO_METHOD = PREFIX + "FieldRedirectedToMethod"
	
	public static val METHOD_REDIRECTED_TO_FIELD = PREFIX + "MethodRedirectedToField"
	
	public static val REDIRECT_NOT_COMPLIANT = PREFIX + "RedirectNotCompliant"
	
	public static val REDIRECT_TO_SAME_MEMBER = PREFIX + "RedirectToSameMember"
	
	public static val NOT_AN_INTERFACE = PREFIX + "NotAnInterface"
	
	public static val DUPLICATE_TRAIT_REFERENCE = PREFIX + "DuplicateTraitReference"
	
	public static val DUPLICATE_MEMBER = PREFIX + "DuplicateMember"
	
	public static val DUPLICATE_DECLARATION = PREFIX + "DuplicateDeclaration"
	
	public static val FIELD_CONFLICT = PREFIX + "FieldConflict"
	
	public static val METHOD_CONFLICT = PREFIX + "MethodConflict"
	
	public static val MEMBER_ALREADY_EXISTS = PREFIX + "MemberAlreadyExists"

	public static val WRONG_CONSTRUCTOR_NAME = PREFIX + "WrongConstructorName"
	
	@Inject extension TraitJJvmModelUtil

	@Check def void checkDependencyCycle(TJTrait t) {
		if (t.allTraitsDependency.exists[it == t]) {
			error(
				"Cycle in dependency of '" + t.name + "'",
				XtraitjPackage::eINSTANCE.TJDeclaration_Name,
				DEPENDENCY_CYCLE
			)
		}
	}

	@Check def void checkFieldInitialization(TJField f) {
		if (f.init != null && f.eContainer instanceof TJTrait) {
			error(
				"Traits cannot initialize fields",
				XtraitjPackage::eINSTANCE.TJField_Init,
				TRAIT_INITIALIZES_FIELD
			)
		}	
	}

	@Check def void checkClassProvidesAllRequirements(TJClass c) {
		c.jvmAllRequiredFieldOperations.forEach[
			requiredField |
			if (c.fields.findMatchingField(requiredField) == null) {
				error(
					"Class must provide required field '" +
						requiredField.fieldRepresentation + "'",
					XtraitjPackage::eINSTANCE.TJDeclaration_TraitExpression,
					MISSING_REQUIRED_FIELD
				)
			}
		]
		c.jvmAllRequiredMethodOperations.forEach[
			requiredMethod |
			if (c.jvmAllMethodOperations().findMatchingMethod(requiredMethod) == null) {
				error(
					"Class must provide required method '" +
						requiredMethod.methodRepresentation + "'",
					XtraitjPackage::eINSTANCE.TJDeclaration_TraitExpression,
					MISSING_REQUIRED_METHOD
				)
			}
		]
		c.jvmAllInterfaceMethods.forEach[
			method |
			if (c.jvmAllMethods.findMatchingMethod(method) == null) {
				error(
					"Class must provide interface method '" +
						method.methodRepresentation + "'",
					XtraitjPackage::eINSTANCE.TJDeclaration_Name,
					MISSING_INTERFACE_METHOD
				)
			}
		]
	}

	@Check def void checkImplementsInterfaces(TJClass c) {
		for (i : c.interfaces) {
			if (!i.validInterface) {
				error(
					"Not a valid interface '" +
						i.simpleName + "'",
					i,
					null,
					NOT_AN_INTERFACE
				)
			}
		}
	}

	@Check def void checkDuplicateMembers(TJMember m) {
		if (m.containingDeclaration.members.
			exists[it != m && it.name == m.name]
		) {
			error(
					"Duplicate member '" +
						m.name + "'",
					XtraitjPackage::eINSTANCE.TJMember_Name,
					DUPLICATE_MEMBER
				)
		}
	}

	@Check def void checkDuplicateDeclaration(TJDeclaration d) {
		if (d.containingProgram.elements.exists[it != d && name == d.name]) {
			error(
					"Duplicate declaration '" +
						d.name + "'",
					XtraitjPackage::eINSTANCE.TJDeclaration_Name,
					DUPLICATE_DECLARATION
				)
		}
	}

	@Check def void checkConflicts(TJDeclaration d) {
		for (t1 : d.traitReferences) {
			for (f1 : t1.jvmAllRequiredFieldOperations) {
				for (t2 : d.traitReferences) {
					if (t1 != t2) {
						if (t2.jvmAllRequiredFieldOperations.exists[conflictsWith(f1)]) {
							error(
								"Field conflict '" + 
								f1.fieldRepresentation + "' in " +
								t1.trait.name,
								t1,
								null,
								FIELD_CONFLICT
							)
						}			
					}
				}
			}
			
			for (f1 : t1.jvmAllRequiredMethodOperations) {
				for (t2 : d.traitReferences) {
					if (t1 != t2) {
						if (t2.jvmAllRequiredMethodOperations.exists[conflictsWith(f1)]) {
							error(
								"Method conflict '" + 
								f1.methodRepresentation + "' in " +
								t1.trait.name,
								t1,
								null,
								METHOD_CONFLICT
							)
						}			
					}
				}
			}

			for (f1 : t1.jvmAllMethodOperations) {
				for (t2 : d.traitReferences) {
					if (t1 != t2) {
						if (t2.jvmAllMethodOperations.exists[f1.simpleName == simpleName]) {
							error(
								"Method conflict '" + 
								f1.methodRepresentation + "' in " +
								t1.trait.name,
								t1,
								null,
								METHOD_CONFLICT
							)
						}			
					}
				}
			}
		}
	}

	@Check def void checkConflicts(TJField f) {
		if (f.containingTrait == null)
			return;
		
		for (t1 : f.containingTrait.traitReferences) {
			val conflict = t1.
				jvmAllRequiredFieldOperations.
				findFirst[simpleName.stripGetter == f.name]
			if (t1 != null) {
				error(
					"Field conflict '" + 
					conflict.fieldRepresentation + "' in " +
					t1.trait.name,
					t1,
					null,
					FIELD_CONFLICT
				)
				
				error(
					"Field conflict '" + 
					f.name + "'",
					XtraitjPackage::eINSTANCE.TJMember_Name,
					FIELD_CONFLICT
				)
			}
		}
	}

	@Check def void checkConflicts(TJRequiredMethod m) {
		if (m.containingTrait == null)
			return;
		
		// a required method conflicts with any declared method
		// of the used traits
		for (t1 : m.containingTrait.traitReferences) {
			val conflict = t1.
				jvmAllOperations.
				findFirst[simpleName == m.name]
			if (t1 != null) {
				error(
					"Method conflict '" + 
					conflict.methodRepresentation + "' in " +
					t1.trait.name,
					t1,
					null,
					METHOD_CONFLICT
				)
				
				error(
					"Method conflict '" + 
					m.name + "'",
					XtraitjPackage::eINSTANCE.TJMember_Name,
					METHOD_CONFLICT
				)
			}
		}
	}

	@Check def void checkConflicts(TJMethod m) {
		if (m.containingTrait == null)
			return;
		
		// a defined method conflicts with any defined method
		// of the used traits
		for (t1 : m.containingTrait.traitReferences) {
			val conflict = t1.
				jvmAllMethodOperations.
				findFirst[simpleName == m.name]
			if (t1 != null) {
				error(
					"Method conflict '" + 
					conflict.methodRepresentation + "' in " +
					t1.trait.name,
					t1,
					null,
					METHOD_CONFLICT
				)
				
				error(
					"Method conflict '" + 
					m.name + "'",
					XtraitjPackage::eINSTANCE.TJMember_Name,
					METHOD_CONFLICT
				)
			}
		}
	}

	/**
	 * Check that there are no duplicate trait references (without
	 * operations) to the same trait (which would be useless and
	 * would cause Java compiler errors).
	 */
	@Check def void checkDuplicateTraitReference(TJClass c) {
		val referencesWithNoOperations = 
			c.traitExpression.traitReferences.filter[
				operations.empty
			]
		for (ref : referencesWithNoOperations) {
			if (referencesWithNoOperations.findFirst[
				ref != it && ref.trait == it.trait
			] != null) {
				error(
					"Duplicate trait reference '" +
						ref.trait.name + "'",
					ref,
					null,
					DUPLICATE_TRAIT_REFERENCE
				)
			}
		}
	}

	@Check def void checkTraitHideOperation(TJHideOperation op) {
		op.errorForRequiredMember("hide", HIDING_REQUIRED)
	}

	@Check def void checkTraitAliasOperation(TJAliasOperation op) {
		op.errorForRequiredMember("alias", ALIASING_REQUIRED)
		op.errorForAlterationToExistingMember(op.newname, XtraitjPackage::eINSTANCE.TJAliasOperation_Newname)
	}

	@Check def void checkTraitRenameOperation(TJRenameOperation op) {
		op.errorForAlterationToExistingMember(op.newname, XtraitjPackage::eINSTANCE.TJRenameOperation_Newname)
	}

	@Check def void checkTraitRestrictOperation(TJRestrictOperation op) {
		op.errorForRequiredMember("restrict", RESTRICTING_REQUIRED)
	}
	
	def private errorForRequiredMember(TjTraitOperationForProvided op, 
				String opName, String issue) {
		val member = op.member
		if (member != null && member.required) {
			error(
				"Cannot " + opName + " required method '" +
					member.simpleName + "'",
				XtraitjPackage::eINSTANCE.TJTraitOperation_Member,
				issue
			)
		}
	}

	def private errorForAlterationToExistingMember(TJTraitOperation op, 
				String newname, EStructuralFeature feature) {
		if (op.containingTraitOperationExpression.trait.members.
			exists[name == newname]
		) {
			error(
				"Member already exists '" +
					newname + "'",
				feature,
				MEMBER_ALREADY_EXISTS
			)
		}
	}

	@Check def void checkRedirect(TJRedirectOperation op) {
		if (op.member != null && op.member2 != null) {
			val sourceMember = op.member.originalSource
			val sourceMember2 = op.member2.originalSource
			if (op.member == op.member2) {
				error(
					"Redirect to the same member '" + sourceMember.name + "'",
					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
					REDIRECT_TO_SAME_MEMBER
				)
			} else if (sourceMember instanceof TJField && sourceMember2 instanceof TJMethodDeclaration) {
				error(
					"Cannot redirect field '" +
						sourceMember.name + "'" + " to method '" +
						sourceMember2.name +"'",
					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
					FIELD_REDIRECTED_TO_METHOD
				)
			} else if (sourceMember instanceof TJMethodDeclaration && sourceMember2 instanceof TJField) {
				error(
					"Cannot redirect method '" +
						sourceMember.name + "'" + " to field '" +
						sourceMember2.name +"'",
					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
					METHOD_REDIRECTED_TO_FIELD
				)
			} else if (!op.member2.compliant(op.member)) {
				error(
					"'" +
					op.member2.memberRepresentation + "'" + 
					" is not compliant with '" +
					op.member.memberRepresentation +"'",
					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
					REDIRECT_NOT_COMPLIANT
				)
			}
		}
	}

	@Check
	def void checkConstructorName(TJConstructor cons) {
		if (cons.containingDeclaration?.name != cons.name) {
			error(
				"Wrong constructor name '" + cons.name + "'",
				XtraitjPackage.eINSTANCE.TJConstructor_Name,
				WRONG_CONSTRUCTOR_NAME
			)
		}
	} 
}
