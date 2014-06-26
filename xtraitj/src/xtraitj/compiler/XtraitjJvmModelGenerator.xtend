package xtraitj.compiler

import com.google.inject.Inject
import java.util.HashMap
import java.util.LinkedList
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.common.types.JvmConstraintOwner
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmWildcardTypeReference
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.xbase.compiler.JvmModelGenerator
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xtype.XFunctionTypeRef
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.jvmmodel.XtraitjJvmModelHelper
import xtraitj.jvmmodel.XtraitjJvmModelUtil
import xtraitj.jvmmodel.XtraitjJvmOperation
import xtraitj.types.XtraitjTraitOperationWrapper
import xtraitj.util.XtraitjAnnotatedElementHelper
import xtraitj.xtraitj.TJAliasOperation
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJHideOperation
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJRenameOperation
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.XtraitjModelUtil.*

class XtraitjJvmModelGenerator extends JvmModelGenerator {
	
	@Inject extension XtraitjGeneratorExtensions
	@Inject extension JvmTypesBuilder
	@Inject extension XtraitjJvmModelUtil
	@Inject extension XtraitjJvmModelHelper
	@Inject extension XtraitjAnnotatedElementHelper
	
	override void doGenerate(Resource input, IFileSystemAccess fsa) {
		val traitsMembersMap = new HashMap<TJTrait, List<JvmMember>>
		val traitRefsMembersMap = new HashMap<TJTraitReference, List<JvmMember>>
		
		// first we need to preprocess all the inferred types
		for (obj : input.contents) {
			if (obj instanceof JvmGenericType) {
				if(obj.qualifiedName != null) {
					val t = obj.associatedTrait
					if (t !== null) {
						val members = new LinkedList<JvmMember>
						traitsMembersMap.put(t, members)
						if (obj.interface) {
							preprocessTraitInterface(t, obj)
						} else {
							preprocessTraitClass(t, obj, members)
						}
					} else {
						val tRef = obj.associatedTraitReference
						if (tRef !== null) {
							val members = new LinkedList<JvmMember>
							traitRefsMembersMap.put(tRef, members)
							if (obj.interface) {
								preprocessTraitExpressionInterface(tRef, obj)
							} else {
								preprocessTraitExpressionClass(tRef, obj, members)
							}
						} else {
							// we can assume it's an Xtraitj class
							obj.associatedTJClass.preprocessClass(obj)
						}
					}
				}
			}
		}
		
		// then we can fix superTypes references (superclasses are turned into
		// corresponding interfaces)
		for (obj : input.contents) {
			if (obj instanceof JvmGenericType) {
				if(obj.qualifiedName != null) {
					val t = obj.associatedTrait
					if (t !== null) {
						val members = traitsMembersMap.get(t)
						if (!obj.interface) {
							preprocessTraitClassSuperTypes(t, obj, members)
						}
					} else {
						val tRef = obj.associatedTraitReference
						if (tRef !== null) {
							val members = traitRefsMembersMap.get(tRef)
							if (!obj.interface) {
								preprocessTraitExpressionClassSuperTypes(tRef, obj, members)
							}	
						} else {
							// we can assume it's an Xtraitj class
							obj.associatedTJClass.preprocessClassSuperTypes(obj)
						}
					}
				}
			}
		}
		
		// final we do the actual generation
		for (obj : input.contents) {
			obj.internalDoGenerate(fsa)
		}
	}
	
//	override dispatch void internalDoGenerate(JvmDeclaredType type, IFileSystemAccess fsa) {
//		if (DisableCodeGenerationAdapter.isDisabled(type))
//			return;
//		if(type.qualifiedName != null) {
//			val genericType = type as JvmGenericType
//			val t = genericType.associatedTrait
//			if (t !== null) {
//				if (genericType.interface) {
//					preprocessTraitInterface(t, genericType)
//					fsa.generateFile(t.traitInterfaceName.replace('.', '/') + '.java', 
//						genericType.generateType(generatorConfigProvider.get(type))
//					)					
//				} else {
//					preprocessTraitClass(t, genericType)
//					fsa.generateFile(type.qualifiedName.replace('.', '/') + '.java', 
//						type.generateType(generatorConfigProvider.get(type))
//					)
//				}
//			} else {
//				// we can assume it's an Xtraitj class
//				genericType.associatedTJClass.preprocessClass(genericType)
//				super._internalDoGenerate(type, fsa)
//			}
//		}
//	}
	
	def preprocessTraitInterface(TJTrait t, JvmGenericType it) {
//		val traitInterface = t.toInterface(t.traitInterfaceName) [
//			documentation = t.documentation
//			
//			t.annotateAsTrait(it)
		
		   	copyTypeParameters(t.traitTypeParameters)

			val map = new HashMap<JvmTypeParameter, JvmTypeParameter>		   	
		   	for (typePar : typeParameters) {
		   		typePar.rebindConstraintsTypeParameters(it, null, map)
		   	}
		   	
		   	for (traitRef : t.traitReferences) {
		   		val superTypeRef = traitRef.traitReferenceJavaType
		   		t.transformClassReferenceToInterfaceReference(superTypeRef)
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

	def preprocessTraitExpressionInterface(TJTraitReference t, JvmGenericType it) {
//		val traitInterface = t.toInterface(t.traitInterfaceName) [
//			documentation = t.documentation
//			
//			t.annotateAsTrait(it)
		
		   	copyTypeParameters(t.trait.typeParametersOfReferredType)

			for (jvmOp : t.xtraitjJvmAllOperations) {
				val relatedOperations = t.operationsForJvmOp(jvmOp)
				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
				
				val op = jvmOp.op
				
				if (relatedOperations.empty) {
					members += jvmOp.toAbstractMethod(op.simpleName)
					if (op.annotatedRequiredField())
						members += jvmOp.toAbstractSetterDelegateFromGetter
				} else {
					if (renameOperation != null) {
						members += jvmOp.toAbstractMethod
							(op.simpleName.renameGetterOrSetter(renameOperation.newname))
					}
					// hidden methods are simply not inserted in this interface
					if (aliasOperation != null) {
						members += jvmOp.toAbstractMethod(aliasOperation.newname)
						if (renameOperation == null && hideOperation == null && restrictOperation == null) {
							// we need to add also the original method
							members += jvmOp.toAbstractMethod(aliasOperation.member.simpleName)
						}
					}
					// restricted methods are added and associated to the
					// operation itself
					if (restrictOperation != null) {
						members += 
							restrictOperation.toAbstractMethod(jvmOp, op.simpleName)
					}
				}
			}
//		]
//		traitInterface
	}
	
	def preprocessTraitClass(TJTrait t, JvmGenericType it, List<JvmMember> collectedMembers) {
		val traitInterfaceTypeRef = t.associatedInterface
			
		val transformedTraitInterfaceTypeRef = traitInterfaceTypeRef.
						transformTypeParametersIntoTypeArguments(t)
		
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
		members.remove(it.members.size - 1)
		
		for (tRef : t.traitReferences) {
			val traitRef = tRef.trait
			// first delegates for implemented methods 
			for (traitMethod : traitRef.xtraitjJvmAllDefinedMethodOperations(tRef)) {
				if (!collectedMembers.alreadyDefined(traitMethod.op)) {
   					val methodName = traitMethod.op.simpleName
   					// m() { _delegate.m(); }
   					collectedMembers += traitMethod.toMethodDelegate(
	   						delegateFieldName, methodName, methodName
	   					) => [ 
		   					traitMethod.op.annotateAsDefinedMethod(it)
		   				]
   					// _m() { delegate to trait defining the method }
   					collectedMembers += traitMethod.toMethodDelegate(
   						tRef.traitFieldName, methodName.underscoreName,
   						methodName.underscoreName
   					)
				}
			}
		}
		
		for (tRef : t.traitReferences) {
			val traitRef = tRef.trait
			
			for (op : traitRef.xtraitjJvmAllRequiredFieldOperations(tRef)) {
				if (!collectedMembers.alreadyDefined(op.op)) {
   					// this is the getter
   					collectedMembers += op.toMethodDelegate(
							delegateFieldName,
							op.op.simpleName, op.op.simpleName) => [
	   					op.op.annotateAsRequiredField(it)
	   				]
	   				collectedMembers += op.toSetterDelegateFromGetter
   				}
			}
			
			// then delegates for required methods
			// TODO deal with restrict
			// see old xtraitjJvmAllRequiredOperations
			for (op : traitRef.xtraitjJvmAllRequiredMethodOperations(tRef))
				if (!members.alreadyDefined(op.op) && !collectedMembers.alreadyDefined(op.op)) {
					collectedMembers += op.toMethodDelegate(
   							delegateFieldName,
   							op.op.simpleName, op.op.simpleName) => [
	   					op.op.annotateAsRequiredMethod(it)
	   				]
				}
		}
		
//		// remove superclasses added in the inferrer
//		superTypes.removeAll(superTypes.filter[!(type as JvmGenericType).interface])
//						
//		superTypes.add(0, transformedTraitInterfaceTypeRef)
	}

	def preprocessTraitExpressionClass(TJTraitReference t, JvmGenericType it, List<JvmMember> collectedMembers) {
		// the interface for the adapter class
		val traitRefAssociatedInterface = t.associatedAdapterInterface
		
		val traitFieldName = t.traitFieldNameForOperations
		
		members.add(0, t.toConstructor[
			simpleName = t.traitExpressionClassName
			parameters += t.toParameter("delegate", traitRefAssociatedInterface)
			body = [
				it.append('''this.«delegateFieldName» = delegate;''')
				newLine.append('''«traitFieldName» = ''')
			   	append('''new ''')
				append(t.trait.type)
				append("(this);")	
   			]
		])
		members.add(0, t.
			toField(traitFieldName, t.trait))
		members.add(0, t.containingDeclaration.
			toField(delegateFieldName, traitRefAssociatedInterface))
		
		// remove the default constructor
		members.remove(it.members.size - 1)
		
		for (xop : members.filter(XtraitjTraitOperationWrapper)) {
			val traitOp = xop.operation
			val origOp = xop.jvmOperation

			val requiredField = origOp.annotatedRequiredField()
			val requiredMethod = origOp.annotatedRequiredMethod()

			switch (traitOp) {
				TJRenameOperation: {
					// example T1[rename m -> m2]
					
					if (requiredField || requiredMethod) {
						// make sure we take the jvmOp's name
						// since the member in the rename operation is bound
						// to the getter in case of a field
						val newname = 
							origOp.simpleName.renameGetterOrSetter(traitOp.newname)
						// m is forwarded to this.m2()
						collectedMembers += xop.
							toMethodDelegate(
								"this",
								origOp.simpleName,
								newname
							)
						// m2 is forwarded to delegate.m2()
						collectedMembers += xop.
							toMethodDelegate(
								delegateFieldName,
								newname,
								newname
							)
						
						if (requiredField) {
							val origSetterName = origOp.simpleName.toSetterName
							val newSetterName = newname.toSetterName
							
							collectedMembers += xop.
								toMethodDelegate(
									"this",
									origSetterName,
									newSetterName
								)
							// m2 is forwarded to delegate.m2()
							collectedMembers += xop.
								toMethodDelegate(
									delegateFieldName,
									newSetterName,
									newSetterName
								)
						}
					} else {
						// m is forwarded to this.m2
						val newname = traitOp.newname
						val origname = origOp.simpleName
						collectedMembers += xop.
						toMethodDelegate(
							"this",
							origname,
							newname
						)
						// m2 is forwarded to delegate.m2
						collectedMembers += xop.
							toMethodDelegate(
								delegateFieldName,
								newname,
								newname
							)
						// _m2 is forwarded to T1._m
						collectedMembers += xop.
							toMethodDelegate(
								traitFieldName,
								newname.underscoreName,
								origname.underscoreName
							)
					}
				}
			}
		}
		
//		// remove superclasses added in the inferrer
//		superTypes.removeAll(superTypes.filter[!(type as JvmGenericType).interface])
//						
//		superTypes.add(0, transformedTraitInterfaceTypeRef)
	}

	def preprocessTraitClassSuperTypes(TJTrait t, JvmGenericType it, List<JvmMember> collectedMembers) {
		val traitInterfaceTypeRef = t.associatedInterface
			
		val transformedTraitInterfaceTypeRef = traitInterfaceTypeRef.
						transformTypeParametersIntoTypeArguments(t)

		members += collectedMembers
		
		// remove superclasses added in the inferrer
		superTypes.removeAll(superTypes.filter[!(type as JvmGenericType).interface])

		// and add the actual interfaces						
		superTypes.add(0, transformedTraitInterfaceTypeRef)
	}

	def preprocessTraitExpressionClassSuperTypes(TJTraitReference t, JvmGenericType it, List<JvmMember> collectedMembers) {
		// the interface for the adapter class
		val traitRefAssociatedInterface = t.associatedAdapterInterface
		superTypes.add(0, traitRefAssociatedInterface)
		
		transformSuperclassReferencesIntoInterfacesReferences
		
		// remove all the XtraitjTraitOperationWrappers
		members.removeAll(members.filter(XtraitjTraitOperationWrapper))
		// and add the new collected members
		members += collectedMembers
	}

	def preprocessClass(TJClass c, JvmGenericType it) {
		// transformSuperclassReferencesIntoInterfacesReferences()
		
		for (traitRef : c.traitReferences) {
			val realRef = traitRef.trait
			
			members += traitRef.toField(traitRef.traitFieldName, realRef) [
				initializer = [
					append('''new ''')
					append(realRef.type)
					append("(this)")
				]
			]
			
			// do not delegate to a trait who requires that operation
   			// but to the one which actually implements it
			for (traitMethod : realRef.xtraitjJvmAllDefinedMethodOperations(traitRef))
				members += traitMethod.toMethodDelegate(traitRef.traitFieldName) => [
					copyAnnotationsFrom(traitMethod)
				]
		}
	}

	def preprocessClassSuperTypes(TJClass c, JvmGenericType it) {
		transformSuperclassReferencesIntoInterfacesReferences()
	}

	def transformSuperclassReferencesIntoInterfacesReferences(JvmGenericType type) {
		for (s : type.superTypes) {
			val superTypeRef = (s as JvmParameterizedTypeReference)
			
			type.transformClassReferenceToInterfaceReference(superTypeRef)
		}
	}

	def transformClassReferenceToInterfaceReference(EObject context, JvmParameterizedTypeReference superTypeRef) {
		// we must transform the references to Trait classes
		// into references to Trait interfaces
		val t = (superTypeRef.type as JvmGenericType)
		if (!t.isInterface && t.notJavaLangObject) {
			// then it's the reference to a trait class
			// and we turn it into a reference to the corresponding interface
			superTypeRef.type = context.newTypeRef(
				superTypeRef.type.identifier.removeTypeArgs.traitInterfaceName
			).type
			
			// superTypeRef.type = t.superTypes.head.type
		}
	}

   	def toGetterAbstract(TJMember m, JvmTypeParameterDeclarator target) {
   		m.toGetter(m.name, m.type.rebindTypeParameters(target, null)) => [
   			abstract = true
   		]
   	}

   	def toSetterAbstract(TJMember m, JvmTypeParameterDeclarator target) {
   		m.toSetter(m.name, m.type.rebindTypeParameters(target, null)) => [
   			abstract = true
   		]
   	}

	def toAbstractMethod(TJMethodDeclaration m, JvmTypeParameterDeclarator target) {
		m.toMethod(m.name, m.type) [
			documentation = m.documentation

			copyTypeParameters(m.typeParameters)
			
			returnType = returnType.rebindTypeParameters(target, it)

			for (p : m.params) {
				parameters += p.toParameter(p.name, p.parameterType.rebindTypeParameters(target, it))
			}
			abstract = true
		]
	}

	def toAbstractMethod(XtraitjJvmOperation m) {
		m.toAbstractMethod(m.op.simpleName)
	}

	def toAbstractMethod(XtraitjJvmOperation m, String name) {
		m.op.originalSource.toAbstractMethod(m, name)
	}

	def toAbstractMethod(EObject source, XtraitjJvmOperation m, String name) {
		val op = m.op
		source.toMethod(name, m.returnType) [
			documentation = m.op.documentation
			
			copyTypeParameters(op.typeParameters)
			
			val paramTypeIt = m.parametersTypes.iterator
			for (p : m.op.parameters) {
				parameters += p.toParameter(p.name, paramTypeIt.next)
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
	def JvmTypeReference rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator containerTypeDecl, JvmTypeParameterDeclarator containerOperation) {
		typeRef.rebindTypeParameters(containerTypeDecl, containerOperation, newHashMap())
	}

	def JvmTypeReference rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator containerTypeDecl, 
			JvmTypeParameterDeclarator containerOperation, Map<JvmTypeParameter, JvmTypeParameter> visited
	) {
		val reboundTypeRef = typeRef.cloneWithProxies
		
		if (reboundTypeRef instanceof JvmParameterizedTypeReference) {
			val type = reboundTypeRef.type
			
			if (type instanceof JvmTypeParameter) {
				var typePar = visited.get(type)
				
				if (typePar === null) {
					typePar = findCorrespondingTypeParameter(containerTypeDecl, reboundTypeRef)
					
					// the typePar can now be null if it refers to a method's generic type
					if (typePar === null && containerOperation !== null) {
						typePar = findCorrespondingTypeParameter(containerOperation, reboundTypeRef)
					}					
					
					if (typePar !== null) {
						visited.put(type, typePar)

						rebindConstraintsTypeParameters(typePar, containerTypeDecl, containerOperation, visited)

						reboundTypeRef.type = typePar
					}
				}
			}
			
			// rebind type arguments as well
			val arguments = reboundTypeRef.arguments
			for (i : 0..<arguments.size()) {
				arguments.set(i, arguments.get(i).rebindTypeParameters(containerTypeDecl, containerOperation, visited))
			}
			
			return reboundTypeRef
		}

		if (reboundTypeRef instanceof JvmWildcardTypeReference) {
			reboundTypeRef.rebindConstraintsTypeParameters(containerTypeDecl, containerOperation, visited)
			return reboundTypeRef
		}
		
		if (reboundTypeRef instanceof XFunctionTypeRef) {
			val reboundReturnTypeRef = reboundTypeRef.returnType.rebindTypeParameters(containerTypeDecl, containerOperation, visited)
			reboundTypeRef.returnType = reboundReturnTypeRef
			return reboundTypeRef
		}
		
		return typeRef
	}
	
	def findCorrespondingTypeParameter(JvmTypeParameterDeclarator declarator, JvmParameterizedTypeReference reboundTypeRef) {
		declarator.typeParameters.findFirst[name == reboundTypeRef.type.simpleName]
	}
	
	protected def rebindConstraintsTypeParameters(JvmConstraintOwner constraintOwner, JvmTypeParameterDeclarator containerDecl, JvmTypeParameterDeclarator containerOperation, Map<JvmTypeParameter, JvmTypeParameter> visited) {
		val constraints = constraintOwner.constraints
		for (i : 0..<constraints.size) {
			val constraint = constraints.get(i)
			constraint.typeReference = constraint.typeReference.rebindTypeParameters(containerDecl, containerOperation, visited)
		}
	}

	def traitReferenceJavaType(TJTraitReference t) {
		if (t.operations.empty)
			t.trait.cloneWithProxies as JvmParameterizedTypeReference
		else
			t.newTypeRef(t.traitExpressionClassName) as JvmParameterizedTypeReference
	}


}