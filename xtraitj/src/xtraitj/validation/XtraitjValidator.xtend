/*
 * generated by Xtext
 */
package xtraitj.validation

import com.google.common.collect.ListMultimap
import com.google.common.collect.Lists
import com.google.inject.Inject
import java.util.List
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmUpperBound
import org.eclipse.xtext.common.types.TypesPackage
import org.eclipse.xtext.common.types.impl.JvmVoidImpl
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
import xtraitj.xtraitj.TJAliasOperation
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJHideOperation
import xtraitj.xtraitj.TJOperation
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJRedirectOperation
import xtraitj.xtraitj.TJRenameOperation
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitOperation
import xtraitj.xtraitj.TJTraitOperationForFieldOrMethod
import xtraitj.xtraitj.TJTraitOperationForProvided
import xtraitj.xtraitj.TJTraitReference
import xtraitj.xtraitj.XtraitjPackage

import static extension xtraitj.util.XtraitjModelUtil.*

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

	public static val INCOMPATIBLE_REQUIRED_METHOD = "xtraitj.IncompatibleRequiredMethod"

	public static val HIDING_REQUIRED = PREFIX + "HidingRequired"

	public static val ALIASING_REQUIRED = PREFIX + "AliasingRequired"

	public static val RESTRICTING_REQUIRED = PREFIX + "RestrictingRequired"
	
	public static val FIELD_REDIRECTED_TO_METHOD = PREFIX + "FieldRedirectedToMethod"
	
	public static val FIELD_REDIRECTED_NOT_FIELD = PREFIX + "FieldRedirectedNotField"
	
	public static val METHOD_REDIRECTED_TO_FIELD = PREFIX + "MethodRedirectedToField"
	
	public static val METHOD_REDIRECTED_NOT_METHOD = PREFIX + "MethodRedirectedNotMethod"
	
	public static val REDIRECT_NOT_COMPLIANT = PREFIX + "RedirectNotCompliant"
	
	public static val REDIRECT_TO_SAME_MEMBER = PREFIX + "RedirectToSameMember"
	
	public static val FIELD_RENAME_NOT_FIELD = PREFIX + "FieldRenameNotField"
	
	public static val METHOD_RENAME_NOT_METHOD = PREFIX + "MethodRenameNotMethod"

	public static val NOT_AN_INTERFACE = PREFIX + "NotAnInterface"

	public static val NOT_A_TRAIT = PREFIX + "NotATrait"
	
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

	@Check
	def void checkClassProvidesAllRequirements(TJClass c) {
		val type = c.associatedJavaClass
		val operations = type.getResolvedOperations.allOperations.filter[!(declaration.isAbstract)]
		
		for (interf : c.interfaces) {
			val interfaceOps = interf.getOperations(interf)
			checkRequirements(c, interfaceOps, operations, 
				TypesPackage.eINSTANCE.jvmParameterizedTypeReference_Type
			) [ interf ]
		}
		
		for (traitRef : c.traitReferences) {
			val requirements = traitRef.getTraitReferenceXtraitjResolvedOperations(type).allRequirements.map[resolvedOperation]
			checkRequirements(c, requirements, operations, 
				XtraitjPackage.eINSTANCE.TJTraitReference_Trait
			) [ traitRef ]
		}
	}

	private def checkRequirements(TJClass c, 
		Iterable<IResolvedOperation> requirements, 
		Iterable<IResolvedOperation> definedOps,
		EStructuralFeature feature,
		()=>EObject errorSourceProvider
	) {
		// setter methods are skipped, since we check getter methods
		for (req : requirements.filter[!annotatedRequiredFieldSetter]) {
			val withTheSameName = definedOps.findOperationByName(req)
			val correspondsToField = req.annotatedRequiredField
			if (withTheSameName == null) {
				if (correspondsToField) {
					error(
						"Class " + c.name + " must provide required field '" +
							req.fieldRepresentation + "'",
						errorSourceProvider.apply(),
						feature,
						MISSING_REQUIRED_FIELD
					)
				} else {
					error(
						"Class " + c.name + " must provide required method '" +
							req.methodRepresentation + "'",
						errorSourceProvider.apply(),
						feature,
						MISSING_REQUIRED_METHOD
					)	
				}
			} else {
				if (correspondsToField) {
					if (!withTheSameName.exact(req)) {
						// fields are invariant (due to getter and setter)
						// so the type must be the same
						error(
							"Class " + c.name + ": Incompatible field '" +
								withTheSameName.fieldRepresentation +
								"' for required field '" +
								req.fieldRepresentation + "'",
							errorSourceProvider.apply(),
							feature,
							INCOMPATIBLE_REQUIRED_FIELD
						)
					}
				} else {
					if (!withTheSameName.compliant(req)) {
						// there's a method with the same name but it's not compliant
						error(
							"Class " + c.name + ": Incompatible method '" +
								withTheSameName.methodRepresentation +
								"' for required method '" +
								req.methodRepresentation + "'",
							errorSourceProvider.apply(),
							feature,
							INCOMPATIBLE_REQUIRED_METHOD
						)
					}
				}
			}
		}
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

	@Check def void checkUsesRefersToATraitInterface(TJDeclaration d) {
		for (t : d.traitReferences) {
			val typeRef = t.trait
			// a JvmVoidImpl means a non resolved type, and that problem
			// has already been reported
			if (!(typeRef.type instanceof JvmVoidImpl) && !typeRef.annotatedTraitInterface) {
				error(
					"Not a trait reference '" +
						typeRef.simpleName + "'",
					t,
					null,
					NOT_A_TRAIT
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

	@Check def void checkConflicts(TJDeclaration d) {
		val type = d.associatedJavaType
		val localOps = 
			if (d instanceof TJTrait) {
				type.resolvedOperations.declaredOperations
			} else {
				// for classes we don't check the locally defined fields
				// which are provided, thus they're not conflicts at all
				emptyList
			};
		
		val conflicts = newConflictTable
		
		val localSeen = newHashMap()
		
		// a defined method is allowed to fulfill a required method from another trait
		val conflictFinderForDeclaredMethods = 
			[List<Pair<EObject, IResolvedOperation>> existing, IResolvedOperation current |
				existing.findFirst[ 
					ex |
					val op = ex.value
						
						if (op.annotatedRequiredField || op.annotatedDefinedMethod) {
							return true // always a conflict
						} else {
							// a defined method in the current trait is allowed
							// fulfill a required method from a used trait
							return !(op.annotatedRequiredMethod
								&&
								current.annotatedDefinedMethod
								&&
								op.compliant(current))
						}
					]
			]

		for (traitRef : d.traitReferences) {
			val traitRefOps = traitRef.getTraitReferenceXtraitjResolvedOperations(type)
			
			// only if the existing required field is not strictly compliant
			checkTraitReferenceConflicts(
				traitRef, traitRefOps.requiredFields.map[resolvedOperation], conflicts
			) [existing, current | existing.findFirst[ ex | !ex.value.exact(current)]]
			
			checkTraitReferenceConflicts(
				traitRef, traitRefOps.requiredMethods.map[resolvedOperation], conflicts
			) [existing, current | existing.findFirst[ ex | !ex.value.compliant(current)]]
			
			checkTraitReferenceConflicts(
				traitRef, traitRefOps.definedMethods.map[resolvedOperation], conflicts,
				conflictFinderForDeclaredMethods)
		}
		
		
		for (op : localOps) {
			val key = op.declaration.simpleName
			// conflicting elements in the same declaration are reported as
			// duplicate members in the validator, so we skip them here
			localSeen.put(key, op)
		}
		
		val localFilteredOps = localSeen.values.toList
		checkTraitReferenceConflicts(
				d, localFilteredOps, conflicts, conflictFinderForDeclaredMethods)
		
		for (entry : conflicts.asMap.entrySet) {
			val duplicates = entry.value
			if (duplicates.size > 1) {
				for (dup : duplicates) {
					val owner = dup.key
					val op = dup.value
					
					errorConflicting(owner, op)
				}
			}
		}
	}
	
	private def checkTraitReferenceConflicts(EObject owner, 
		List<IResolvedOperation> operations,
		ListMultimap<String, Pair<EObject, IResolvedOperation>> conflicts,
		(List<Pair<EObject, IResolvedOperation>>, IResolvedOperation)=>Pair<EObject, IResolvedOperation> conflictFinder
	) {
		for (current : operations) {
			val resolvedDecl = current.getDeclaration();
			
			val simpleName = resolvedDecl.getSimpleName()
			val existing = conflicts.get(simpleName);
			if (!existing.empty) {
				val conflicting = conflictFinder.apply(existing, current)
				if (conflicting != null) {
					existing.add(owner -> current)
				}
			} else {
				conflicts.put(simpleName, owner -> current)
			}
		}
	}
	
	private def errorConflicting(EObject owner, IResolvedOperation op) {
		var source = owner
		var errorMessage = ""
		var issue = ""
		
		val isRequiredField = op.annotatedRequiredField
		
		if (isRequiredField) {
			errorMessage = "Field conflict '" + op.fieldRepresentation + "'"
			issue = FIELD_CONFLICT
			if (owner instanceof TJTraitReference) {
				errorMessage += " in " + owner.typeRefRepr
			} else {
				source = op.declaration.sourceField
			}
		} else {
			errorMessage = "Method conflict '" + op.methodRepresentation + "'"
			issue = METHOD_CONFLICT
			if (owner instanceof TJTraitReference) {
				errorMessage += " in " + owner.typeRefRepr
			} else {
				source = op.declaration.sourceMethodDeclaration
			}
		}
		
		error(
			errorMessage,
			source,
			null,
			issue
		)
	}

	def private newConflictTable() {
		val ListMultimap<String, Pair<EObject, IResolvedOperation>> conflicts = Multimaps2.newLinkedHashListMultimap();
		return conflicts;
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

	@Check def void checkTraitHideOperation(TJHideOperation op) {
		op.errorForRequiredMember("hide", HIDING_REQUIRED)
	}

	@Check def void checkTraitAliasOperation(TJAliasOperation op) {
		op.errorForRequiredMember("alias", ALIASING_REQUIRED)
		op.errorForAlterationToExistingMember(op.newname, XtraitjPackage.eINSTANCE.TJAliasOperation_Newname)
	}

	@Check def void checkTraitRenameOperation(TJRenameOperation op) {
		checkCorrectFieldOrMethodOperation(op, "Rename", FIELD_RENAME_NOT_FIELD, METHOD_RENAME_NOT_METHOD)
		op.errorForAlterationToExistingMember(op.newname, XtraitjPackage.eINSTANCE.TJRenameOperation_Newname)
	}

	@Check def void checkTraitRestrictOperation(TJRestrictOperation op) {
		op.errorForRequiredMember("restrict", RESTRICTING_REQUIRED)
	}

	def private errorForRequiredMember(TJTraitOperationForProvided op, 
				String opName, String issue) {
		val member = op.member
		if (member != null && member.annotatedRequiredMethod) {
			error(
				"Cannot " + opName + " required method '" +
					member.simpleName + "'",
				XtraitjPackage::eINSTANCE.TJTraitOperation_Member,
				issue
			)
		}
	}

	def private errorForAlterationToExistingMember(TJTraitOperation o, 
				String newname, EStructuralFeature feature) {
		if (o.member == null) {
			return; // linking error already reported
		}
		
		val allDeclarations = o.xtraitjResolvedOperations.allDeclarations
		val exists =
			if (o.member.annotatedRequiredField) {
				allDeclarations.exists[op.fieldName == newname]
			} else {
				allDeclarations.exists[op.simpleName == newname]
			};
		
		if (exists) {
			error(
				"Member already exists '" +
					newname + "'",
				feature,
				MEMBER_ALREADY_EXISTS
			)
		}
	}

	@Check def void checkRedirect(TJRedirectOperation op) {
		val member1 = op.member
		val member2 = op.member2
		if (member1 != null && member2 != null) {
			if (op.member == op.member2) {
				val memberName = if (member1.annotatedRequiredField) member1.fieldName else member1.simpleName;
				error(
					"Redirect to the same member '" + memberName + "'",
					XtraitjPackage::eINSTANCE.TJRedirectOperation_Member2,
					REDIRECT_TO_SAME_MEMBER
				)
			} else {
				if (checkCorrectRedirectionForFieldAndMethod(op, member1, member2)) {
					val resolvedOps = op.xtraitjResolvedOperations.allDeclarations
					val resolved1 = resolvedOps.findFirst[it.op == member1].resolvedOperation
					val resolved2 = resolvedOps.findFirst[it.op == member2].resolvedOperation
					if (op.field) {
						if (!resolved2.exact(resolved1)) {
							error(
								"field '" +
								resolved2.fieldRepresentation + "'" + 
								" is not compliant with '" +
									resolved1.fieldRepresentation +"'",
									XtraitjPackage.eINSTANCE.TJRedirectOperation_Member2,
									REDIRECT_NOT_COMPLIANT
							)
						}
					} else {
						if (!resolved2.compliant(resolved1)) {
							error(
								"'" +
								resolved2.methodRepresentation + "'" + 
								" is not compliant with '" +
									resolved1.methodRepresentation +"'",
									XtraitjPackage.eINSTANCE.TJRedirectOperation_Member2,
									REDIRECT_NOT_COMPLIANT
							)
						}
					}
				}
			}
		}
	}

	/**
	 * This assumes that both members are not null.
	 * 
	 * @return true if check succeeded
	 */
	private def checkCorrectRedirectionForFieldAndMethod(TJRedirectOperation op, JvmMember member1, JvmMember member2) {
		if (checkCorrectFieldOrMethodOperation(op, "Redirect", FIELD_REDIRECTED_NOT_FIELD, METHOD_REDIRECTED_NOT_METHOD)) {
			if (op.field) {
				if (!member2.annotatedRequiredField) {
					error(
						"Cannot redirect field '" +
							member1.fieldName + "'" + " to method '" +
							member2.simpleName +"'",
						XtraitjPackage.eINSTANCE.TJRedirectOperation_Member2,
						FIELD_REDIRECTED_TO_METHOD
					)
					return false
				}
			} else {
				if (member2.annotatedRequiredField) {
					error(
						"Cannot redirect method '" +
							member1.simpleName + "'" + " to field '" +
							member2.fieldName +"'",
						XtraitjPackage.eINSTANCE.TJRedirectOperation_Member2,
						METHOD_REDIRECTED_TO_FIELD
					)
					return false
				}
			}
			return true
		}
		return false
	}

	/**
	 * Check whether an operation based on 'field' feature actually refers to a field or a
	 * method. If not, generates the error and returns false. It assumes that the member of the
	 * operation is not null (i.e., resolved).
	 * 
	 * @return true if check succeeded
	 */
	private def checkCorrectFieldOrMethodOperation(TJTraitOperationForFieldOrMethod op, String opDesc, String issueForField, String issueForMethod) {
		val member1 = op.member
		if (op.field) {
			if (!member1.annotatedRequiredField) {
				error(
					opDesc + " field using a method: '" +
						member1.simpleName + "'",
					XtraitjPackage.eINSTANCE.TJTraitOperation_Member,
					issueForField
				)
				return false
			}
		} else {
			if (member1.annotatedRequiredField) {
				error(
					opDesc + " method using a field: '" +
						member1.fieldName + "'",
					XtraitjPackage.eINSTANCE.TJTraitOperation_Member,
					issueForMethod
				)
				return false
			}
		}
		return true
	}

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

	def private typeRefRepr(TJTraitReference traitRef) {
		traitRef.trait.typeRefRepr
	}

	def private typeRefRepr(JvmTypeReference typeRef) {
		typeRef.simpleName
	}

	def private <K, T> duplicatesMultimap() {
		return Multimaps2.<K, T> newLinkedHashListMultimap();
	}

}
