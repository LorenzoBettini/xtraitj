/*
 * generated by Xtext
 */
package xtraitj.validation

import com.google.common.collect.Lists
import com.google.inject.Inject
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmUpperBound
import org.eclipse.xtext.common.types.TypesPackage
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.xbase.annotations.validation.XbaseWithAnnotationsJavaValidator
import org.eclipse.xtext.xbase.jvmmodel.ILogicalContainerProvider
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import org.eclipse.xtext.xbase.typesystem.util.Multimaps2
import org.eclipse.xtext.xbase.validation.IssueCodes
import xtraitj.jvmmodel.XtraitjJvmModelHelper
import xtraitj.jvmmodel.XtraitjJvmModelUtil
import xtraitj.typing.XtraitjTypingUtil
import xtraitj.util.XtraitjAnnotatedElementHelper
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJOperation
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.XtraitjPackage

import static extension xtraitj.util.XtraitjModelUtil.*
import org.eclipse.xtext.xbase.typesystem.^override.IOverrideCheckResult.OverrideCheckDetails

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class XtraitjValidator extends XbaseWithAnnotationsJavaValidator {

	public static val PREFIX = "xtraitj."

	public static val DEPENDENCY_CYCLE = PREFIX + "DependencyCycle"
	
	public static val TRAIT_INITIALIZES_FIELD = PREFIX + "TraitInitializesField"
	
	public static val MISSING_REQUIRED_FIELD = "xtraitj.MissingRequiredField"

	public static val INCOMPATIBLE_REQUIRED_FIELD = "xtraitj.IncompatibleRequiredField"

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

	public static val DUPLICATE_CONSTRUCTOR = PREFIX + "DuplicateConstructor"
	
	public static val DUPLICATE_PARAM = PREFIX + "DuplicateParameter"

	public static val FIELD_CONFLICT = PREFIX + "FieldConflict"
	
	public static val METHOD_CONFLICT = PREFIX + "MethodConflict"
	
	public static val MEMBER_ALREADY_EXISTS = PREFIX + "MemberAlreadyExists"

	public static val WRONG_CONSTRUCTOR_NAME = PREFIX + "WrongConstructorName"
	
	public static val ANNOTATION_ON_TRAIT_FIELD = PREFIX + "AnnotationOnTraitField"
	
	@Inject extension XtraitjJvmModelUtil
	@Inject extension XtraitjJvmModelHelper
	@Inject extension XtraitjTypingUtil
	@Inject extension XtraitjAnnotatedElementHelper
	
	@Inject
	private ILogicalContainerProvider logicalContainerProvider
	
	override protected getEPackages() {
		val ePackages = Lists.newArrayList(super.getEPackages());
		ePackages.add(XtraitjPackage.eINSTANCE);
		return ePackages;
	}
	
	/**
	 * We must override this to avoid the Xbase validator to consider
	 * a static context also the case when the type parameter of
	 * an inferred trait interface is used in the inferred method
	 * of the corresponding inferred trait class.
	 * The implementation in XbaseJavaValidator looks like this
	 * 
	 * <pre>
	 * if(element instanceof JvmDeclaredType)
	 *	return ((JvmDeclaredType) element).isStatic() || ((JvmDeclaredType)element).getDeclaringType() == null;
	 * </pre>
	 */
	override protected boolean isStaticContext(EObject element) {
		if(element instanceof JvmGenericType) {
			if (element.associatedTrait != null
					||
					element.associatedTraitReference != null
					||
					element.associatedTJClass!= null)
				return element.static;
		}
		return super.isStaticContext(element);
	}

	/**
	 * This is an additional check we have to perform, since for a trait we infer
	 * several Java elements; the Xbase implementation of checkTypeParameterNotUsedInStaticContext
	 * seems to assume that the type parameter is declared in one place only; we
	 * need to do the same even for our classes.
	 */
	@Check 
	def void checkTypeParameterRefersToContainerTraitOrClass(JvmTypeReference ref) {
		val type = ref.type
		if(type instanceof JvmTypeParameter) {
			val container = type.eContainer
			
			if (!(container instanceof TJTrait || container instanceof TJClass))
				return; // nothing to check
			
			var EObject currentParent = logicalContainerProvider.getNearestLogicalContainer(ref);
			while(currentParent != null) {
				if(currentParent == type.eContainer())
					return;
				
				// check that this inferred type is associated to the same trait of the container
				// of the type parameter (same for Xtraitj class)
				if (currentParent instanceof JvmGenericType) {
					var EObject associated = currentParent.associatedTrait
					if (associated == null)
						associated = currentParent.associatedTJClass
					if (associated != null) {
						if (associated !== container)
							error("Cannot make a static reference to the non-static type " + type.getName(), 
								ref, TypesPackage.Literals.JVM_PARAMETERIZED_TYPE_REFERENCE__TYPE, -1, IssueCodes.STATIC_ACCESS_TO_INSTANCE_MEMBER);
					}
				}
				currentParent = currentParent.eContainer();
			}
		}
	}

	@Check def void checkDependencyCycle(TJTrait t) {
		val inferredType = t.associatedInterfaceType
		if (inferredType.hasCycleInHierarchy(newHashSet())) {
			error(
				"Cycle in dependency of '" + t.name + "'",
				XtraitjPackage::eINSTANCE.TJDeclaration_Name,
				DEPENDENCY_CYCLE
			)
		}
	}

	def private boolean hasCycleInHierarchy(JvmGenericType type, Set<JvmGenericType> processedSuperTypes) {
		if (processedSuperTypes.contains(type))
			return true;
		processedSuperTypes.add(type);
		for (JvmTypeReference superTypeRef : type.getSuperTypes()) {
			if (superTypeRef.getType() instanceof JvmGenericType) {
				if (hasCycleInHierarchy(superTypeRef.getType() as JvmGenericType, processedSuperTypes))
					return true;
			}
		}
		processedSuperTypes.remove(type);
		return false;
	}

	@Check def void checkTraitFields(TJTrait t) {
		for (f : t.fields) {
			if (f.init != null) {
				error(
					"Traits cannot initialize fields",
					f,
					XtraitjPackage::eINSTANCE.TJField_Init,
					TRAIT_INITIALIZES_FIELD
				)
			}
			if (!f.annotations.empty) {
				error(
					"Traits cannot annotate fields",
					f,
					XtraitjPackage::eINSTANCE.TJField_Annotations,
					ANNOTATION_ON_TRAIT_FIELD
				)
			}
		}
	}

	@Check def void checkClassProvidesAllRequirements(TJClass c) {
		val type = c.associatedJavaClass
		val operations = type.getResolvedOperations
		
		val missingOrMismatchFields = <String>newHashSet()

		for (op : operations.declaredOperations) {
			val allInherited = op.getOverriddenAndImplementedMethods()
			for(inherited: allInherited) {
				if (inherited.getOverrideCheckResult().hasProblems()) {
					val details = inherited.getOverrideCheckResult().getDetails();
					if (details.contains(OverrideCheckDetails.RETURN_MISMATCH)) {
						if (inherited.declaration.annotatedRequiredField) {
							errorMismatchRequiredField(op, inherited)
							missingOrMismatchFields.add(op.fieldName)
						}		
					}
				}
			}
		}
		
		for (op : operations.allOperations) {
			val decl = op.declaration
			if (decl.isAbstract && decl.declaringType != type) {
				if (decl.annotatedRequiredField) {
					errorMissingRequiredField(op)
					missingOrMismatchFields.add(op.fieldName)
				} else if (decl.annotatedRequiredFieldSetter) {
					if (!missingOrMismatchFields.contains(decl.fieldName)) {
						// check that an error has not already been reported
						// when examining the getter
						errorMissingRequiredField(op)
					}
				} else {
					errorMissingRequiredMethod(decl, op)
				}
			}
		}
		
		
//		for (requiredField : c.xtraitjJvmAllRequiredFieldOperations) {
//			if (c.fields.findMatchingField(requiredField) == null) {
//				error(
//					"Class must provide required field '" +
//						requiredField.fieldRepresentation + "'",
//					XtraitjPackage::eINSTANCE.TJDeclaration_TraitExpression,
//					MISSING_REQUIRED_FIELD,
//					requiredField.op.simpleName,
//					requiredField.returnType.identifier
//				)
//			}
//		}
//		for (requiredMethod : c.xtraitjJvmAllRequiredMethodOperations) {
//			if (c.xtraitjJvmAllMethodOperations.findMatchingMethod(requiredMethod) == null) {
//				error(
//					"Class must provide required method '" +
//						requiredMethod.methodRepresentation + "'",
//					XtraitjPackage::eINSTANCE.TJDeclaration_TraitExpression,
//					MISSING_REQUIRED_METHOD
//				)
//			}
//		}
//		for (method : c.xtraitjJvmAllInterfaceMethods) {
//			if (c.xtraitjJvmAllMethodOperations.findMatchingOperation(method) == null) {
//				error(
//					"Class must provide interface method '" +
//						method.methodRepresentation + "'",
//					XtraitjPackage::eINSTANCE.TJDeclaration_Name,
//					MISSING_INTERFACE_METHOD
//				)
//			}
//		}
	}
	
	private def errorMissingRequiredField(IResolvedOperation op) {
		error(
			"Class must provide required field '" +
				op.fieldRepresentation + "'",
			XtraitjPackage.eINSTANCE.TJDeclaration_TraitExpression,
			MISSING_REQUIRED_FIELD,
			op.declaration.simpleName, // this will be used by the Quickfix
			op.resolvedReturnType.identifier // this will be used by the Quickfix
		)
	}

	private def errorMismatchRequiredField(IResolvedOperation resolved, IResolvedOperation inherited) {
		error(
			"Incompatible field '" +
				resolved.fieldRepresentation +
				"' for required field '" +
				inherited.fieldRepresentation + "'",
			XtraitjPackage.eINSTANCE.TJDeclaration_TraitExpression,
			INCOMPATIBLE_REQUIRED_FIELD
		)
	}

	private def errorMissingRequiredMethod(JvmOperation decl, IResolvedOperation op) {
		error(
			"Class must provide required method '" +
				decl.methodRepresentation + "'",
			XtraitjPackage.eINSTANCE.TJDeclaration_TraitExpression,
			MISSING_REQUIRED_METHOD
		)
	}

//	private def errorMismatchRequiredMethod(JvmOperation decl, IResolvedOperation op) {
//		error(
//			"Class must provide required method '" +
//				decl.methodRepresentation + "'",
//			XtraitjPackage.eINSTANCE.TJDeclaration_TraitExpression,
//			MISSING_REQUIRED_METHOD
//		)
//	}

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

	@Check def void checkDuplicateMembers(TJDeclaration d) {
		val map = duplicatesMultimap
		
		for (m : d.members) {
			map.put(m.name, m)
		}
		
		for (entry : map.asMap.entrySet) {
			val duplicates = entry.value
			if (duplicates.size > 1) {
				for (m : duplicates)
					error(
						"Duplicate member '" +
						m.name + "'",
						m,
						XtraitjPackage.eINSTANCE.TJMember_Name,
						DUPLICATE_MEMBER
					)
			}
		}
	}

	@Check def void checkDuplicateDeclarations(TJProgram p) {
		val map = duplicatesMultimap
		
		for (d : p.elements) {
			map.put(d.name, d)
		}
		
		for (entry : map.asMap.entrySet) {
			val duplicates = entry.value
			if (duplicates.size > 1) {
				for (d : duplicates)
					error(
						"Duplicate declaration '" +
							d.name + "'",
						d,
						XtraitjPackage.eINSTANCE.TJDeclaration_Name,
						DUPLICATE_DECLARATION
					)
			}
		}
	}

	@Check def void checkDuplicateParameterNames(TJOperation op) {
		val map = duplicatesMultimap
		
		for (p : op.params) {
			map.put(p.name, p)
		}
		
		for (entry : map.asMap.entrySet) {
			val duplicates = entry.value
			if (duplicates.size > 1) {
				for (d : duplicates)
					error(
						"Duplicate parameter '" +
							d.name + "'",
						d,
						TypesPackage.eINSTANCE.jvmFormalParameter_Name,
						DUPLICATE_PARAM
					)
			}
		}
	}

//	@Check def void checkConflicts(TJDeclaration d) {
//		for (t1 : d.traitReferences) {
//			for (f1 : t1.xtraitjJvmAllRequiredFieldOperations) {
//				for (t2 : d.traitReferences) {
//					if (t1 != t2) {
//						if (t2.xtraitjJvmAllRequiredFieldOperations.exists[conflictsWith(f1)]) {
//							error(
//								"Field conflict '" + 
//								f1.fieldRepresentation + "' in " +
//								t1.trait.typeRefRepr,
//								t1,
//								null,
//								FIELD_CONFLICT
//							)
//						}			
//					}
//				}
//			}
//			
//			for (f1 : t1.xtraitjJvmAllRequiredMethodOperations) {
//				for (t2 : d.traitReferences) {
//					if (t1 != t2) {
//						if (t2.xtraitjJvmAllRequiredMethodOperations.exists[conflictsWith(f1)]) {
//							error(
//								"Method conflict '" + 
//								f1.methodRepresentation + "' in " +
//								t1.trait.typeRefRepr,
//								t1,
//								null,
//								METHOD_CONFLICT
//							)
//						}			
//					}
//				}
//			}
//
//			for (f1 : t1.xtraitjJvmAllMethodOperations) {
//				for (t2 : d.traitReferences) {
//					if (t1 != t2) {
//						if (t2.xtraitjJvmAllMethodOperations.exists[f1.op.simpleName == op.simpleName]) {
//							error(
//								"Method conflict '" + 
//								f1.methodRepresentation + "' in " +
//								t1.trait.typeRefRepr,
//								t1,
//								null,
//								METHOD_CONFLICT
//							)
//						}			
//					}
//				}
//			}
//		}
//	}

//	@Check def void checkConflicts(TJField f) {
//		if (f.containingTrait == null)
//			return;
//		
//		for (t1 : f.containingTrait.traitReferences) {
//			val conflict = t1.
//				jvmAllRequiredFieldOperations.
//				findFirst[simpleName.stripGetter == f.name]
//			if (conflict != null) {
//				error(
//					"Field conflict '" + 
//					conflict.fieldRepresentation + "' in " +
//					t1.trait.name,
//					t1,
//					null,
//					FIELD_CONFLICT
//				)
//				
//				error(
//					"Field conflict '" + 
//					f.name + "'",
//					XtraitjPackage::eINSTANCE.TJMember_Name,
//					FIELD_CONFLICT
//				)
//			}
//		}
//	}
//
//	@Check def void checkConflicts(TJRequiredMethod m) {
//		// a required method conflicts with any declared method
//		// of the used traits
//		for (t1 : m.containingTrait.traitReferences) {
//			val conflict = t1.
//				jvmAllOperations.
//				findFirst[simpleName == m.name]
//			if (conflict != null) {
//				error(
//					"Method conflict '" + 
//					conflict.methodRepresentation + "' in " +
//					t1.trait.name,
//					t1,
//					null,
//					METHOD_CONFLICT
//				)
//				
//				error(
//					"Method conflict '" + 
//					m.name + "'",
//					XtraitjPackage::eINSTANCE.TJMember_Name,
//					METHOD_CONFLICT
//				)
//			}
//		}
//	}
//
//	@Check def void checkConflicts(TJMethod m) {
//		// a defined method conflicts with any defined method
//		// of the used traits
//		for (t1 : m.containingTrait.traitReferences) {
//			val conflict = t1.
//				jvmAllMethodOperations.
//				findFirst[simpleName == m.name]
//			if (conflict != null) {
//				error(
//					"Method conflict '" + 
//					conflict.methodRepresentation + "' in " +
//					t1.trait.name,
//					t1,
//					null,
//					METHOD_CONFLICT
//				)
//				
//				error(
//					"Method conflict '" + 
//					m.name + "'",
//					XtraitjPackage::eINSTANCE.TJMember_Name,
//					METHOD_CONFLICT
//				)
//			}
//		}
//	}
//

	/**
	 * Check that there are no duplicate trait references (without
	 * operations) to the same trait (which would be useless and
	 * would cause Java compiler errors).
	 */
	@Check def void checkDuplicateTraitReference(TJDeclaration c) {
		val referencesWithNoOperations = 
			c.traitReferences.filter[
				operations.empty
			]
		for (ref : referencesWithNoOperations) {
			if (referencesWithNoOperations.findFirst[
				ref != it && ref.trait.simpleName == it.trait.simpleName
			] != null) {
				error(
					"Duplicate trait reference '" +
						ref.trait.simpleName + "'",
					ref,
					null,
					DUPLICATE_TRAIT_REFERENCE
				)
			}
		}
	}
//
//	@Check def void checkTraitHideOperation(TJHideOperation op) {
//		op.errorForRequiredMember("hide", HIDING_REQUIRED)
//	}
//
//	@Check def void checkTraitAliasOperation(TJAliasOperation op) {
//		op.errorForRequiredMember("alias", ALIASING_REQUIRED)
//		op.errorForAlterationToExistingMember(op.newname, XtraitjPackage::eINSTANCE.TJAliasOperation_Newname)
//	}
//
//	@Check def void checkTraitRenameOperation(TJRenameOperation op) {
//		op.errorForAlterationToExistingMember(op.newname, XtraitjPackage::eINSTANCE.TJRenameOperation_Newname)
//	}
//
//	@Check def void checkTraitRestrictOperation(TJRestrictOperation op) {
//		op.errorForRequiredMember("restrict", RESTRICTING_REQUIRED)
//	}
//
//	def private errorForRequiredMember(TjTraitOperationForProvided op, 
//				String opName, String issue) {
//		val member = op.member
//		if (member != null && member.required) {
//			error(
//				"Cannot " + opName + " required method '" +
//					member.simpleName + "'",
//				XtraitjPackage::eINSTANCE.TJTraitOperation_Member,
//				issue
//			)
//		}
//	}
//
//	def private errorForAlterationToExistingMember(TJTraitOperation op, 
//				String newname, EStructuralFeature feature) {
//		if (op.containingTraitOperationExpression.trait.jvmAllOperations.
//			exists[simpleName == newname]
//		) {
//			error(
//				"Member already exists '" +
//					newname + "'",
//				feature,
//				MEMBER_ALREADY_EXISTS
//			)
//		}
//	}
//
//	@Check def void checkRedirect(TJRedirectOperation op) {
//		if (op.member != null && op.member2 != null) {
//			val sourceMember = op.member.originalSource
//			val sourceMember2 = op.member2.originalSource
//			if (op.member == op.member2) {
//				error(
//					"Redirect to the same member '" + sourceMember.name + "'",
//					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
//					REDIRECT_TO_SAME_MEMBER
//				)
//			} else if (sourceMember instanceof TJField && sourceMember2 instanceof TJMethodDeclaration) {
//				error(
//					"Cannot redirect field '" +
//						sourceMember.name + "'" + " to method '" +
//						sourceMember2.name +"'",
//					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
//					FIELD_REDIRECTED_TO_METHOD
//				)
//			} else if (sourceMember instanceof TJMethodDeclaration && sourceMember2 instanceof TJField) {
//				error(
//					"Cannot redirect method '" +
//						sourceMember.name + "'" + " to field '" +
//						sourceMember2.name +"'",
//					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
//					METHOD_REDIRECTED_TO_FIELD
//				)
//			} else if (!op.member2.compliant(op.member)) {
//				error(
//					"'" +
//					op.member2.memberRepresentation + "'" + 
//					" is not compliant with '" +
//					op.member.memberRepresentation +"'",
//					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
//					REDIRECT_NOT_COMPLIANT
//				)
//			}
//		}
//	}
//
	@Check
	def void checkConstructorName(TJClass cl) {
		for (cons : cl.constructors) {
			if (cl.name != cons.name) {
				error(
					"Wrong constructor name '" + cons.name + "'",
					cons,
					XtraitjPackage.eINSTANCE.TJConstructor_Name,
					WRONG_CONSTRUCTOR_NAME
				)
			}			
		}
	}

	@Check
	def void checkDuplicateConstructors(TJClass cl) {
		val type = cl.associatedJavaClass
		
		val resolvedOperations = type.resolvedOperations
		val constructors = resolvedOperations.declaredConstructors
		
		val map = duplicatesMultimap
		
		for (cons : constructors) {
			map.put(cons.resolvedErasureSignature, cons)
		}
		
		for (entry : map.asMap.entrySet) {
			val duplicates = entry.value
			if (duplicates.size > 1) {
				for (d : duplicates)
					error(
						"Duplicate constructor '" + d.simpleSignature + "'",
						d.associatedSource,
						XtraitjPackage.eINSTANCE.TJConstructor_Name,
						DUPLICATE_CONSTRUCTOR
					)
			}
		}
	}

	@Check def void checkTypeArgsAgainstTypeParameters(TJDeclaration d) {
		for (t1 : d.traitReferences) {
			val ref = t1.trait
			val type = ref.type
			if (type instanceof JvmGenericType) {
				val typeParams = type.typeParameters
				val typeArgs = ref.arguments
				
				val numTypeParameters = typeParams.size();
				val numTypeArguments = typeArgs.size();
				if(numTypeParameters == numTypeArguments) {
					// if not, the error is reported by JvmTypeReferencesValidator
					for (i : 0..<numTypeArguments) {
						val arg = typeArgs.get(i)
						val param = typeParams.get(i)
						
						val upperBound = param.constraints.findFirst[it instanceof JvmUpperBound]
						
						if (upperBound !== null && !t1.isSubtype(arg, upperBound.typeReference)) {
							error("The type " 
								+ arg.simpleName
								+ " is not a valid substitute for the bounded parameter " 
								+ param.simpleName
								+ " "
								+ upperBound.simpleName,
								arg,
								TypesPackage.Literals.JVM_PARAMETERIZED_TYPE_REFERENCE__TYPE,
								IssueCodes.TYPE_BOUNDS_MISMATCH);
						}
					}
				}
			}
		}
	}

//	def private typeRefRepr(JvmTypeReference typeRef) {
//		typeRef.simpleName
//	}

	def private <K, T> duplicatesMultimap() {
		return Multimaps2.<K, T> newLinkedHashListMultimap();
	}

}
