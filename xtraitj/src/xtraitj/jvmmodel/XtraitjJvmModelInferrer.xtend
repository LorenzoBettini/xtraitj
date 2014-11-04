package xtraitj.jvmmodel

import com.google.inject.Inject
import java.util.HashMap
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator.JvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.types.XtraitjTypeParameterHelper
import xtraitj.util.XtraitjAnnotatedElementHelper
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJRenameOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.XtraitjModelUtil.*

/**
 * <p>Infers a JVM model from the source model.</p> 
 *
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>     
 */
class XtraitjJvmModelInferrer extends AbstractModelInferrer {

	@Inject extension JvmTypesBuilder
	@Inject extension IQualifiedNameProvider
	@Inject extension XtraitjJvmModelUtil
	@Inject extension XtraitjGeneratorExtensions
	@Inject extension IJvmModelAssociations
	@Inject extension XtraitjTypeParameterHelper
	@Inject extension XtraitjAnnotatedElementHelper
	
	/**
	 * The dispatch method {@code infer} is called for each instance of the
	 * given element's type that is contained in a resource.
	 * 
	 * @param element
	 *            the model to create one or more
	 *            {@link JvmDeclaredType declared
	 *            types} from.
	 * @param acceptor
	 *            each created
	 *            {@link JvmDeclaredType type}
	 *            without a container should be passed to the acceptor in order
	 *            get attached to the current resource. The acceptor's
	 *            {@link IJvmDeclaredTypeAcceptor#accept(org.eclipse.xtext.common.types.JvmDeclaredType)
	 *            accept(..)} method takes the constructed empty type for the
	 *            pre-indexing phase. This one is further initialized in the
	 *            indexing phase using the lambda you pass.
	 * @param isPreIndexingPhase
	 *            whether the method is called in a pre-indexing phase, i.e.
	 *            when the global index is not yet fully updated. You must not
	 *            rely on linking using the index if isPreIndexingPhase is
	 *            <code>true</code>.
	 */
   	def dispatch void infer(TJProgram p, JvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
   		val maps = new XtraitjMaps
   		
   		val dependiences = new XtraitjDependencies(p).dependencies
   		
//		val traits = p.traits
//		for (t : traits) {
//			// infer interfaces and classes in this order
//			t.inferTraitInterface(acceptor, typesMap)
//			// so that in the model generator when we generate the class the
//			// interface has already been enriched
//			t.inferTraitClass(acceptor, typesMap)
//		}
//		
//		for (c : p.classes)
//			c.inferClass(acceptor, typesMap)
		
		for (e : dependiences) {
			switch(e) {
				TJTrait: {
					// infer interfaces and classes in this order
					e.inferTraitInterface(acceptor, maps)
				}
			}
		}

		for (e : dependiences) {
			switch(e) {
				TJClass: {
					e.inferClass(acceptor, maps)
				}
			}
		}

		for (e : dependiences) {
			switch(e) {
				TJTrait: {
					e.inferTraitClass(acceptor, maps)
				}
				TJClass: {
					e.inferClassContents(acceptor, maps)
				}
			}
		}
   	}
   	
   	/**
   	 * This method only infers the JvmDeclaredType for the TJClass and record the
   	 * resolvedOperations for its trait references; these must be computed and resolved
   	 * before inferring traits' Java classes (see the method {@link #collectInterfaceResolvedOperations}).
   	 */
   	def void inferClass(TJClass c, JvmDeclaredTypeAcceptor acceptor,
   		XtraitjMaps maps
   	) {
   		val inferredClass = c.toClass(c.fullyQualifiedName)
   		
   		inferredClass.copyTypeParameters(c.typeParameters)
   		
   		// it is crucial to infer interfaces for trait operation expressions
		// first, so that when we add methods to this class
		// we can see all the methods which are possibly provided
		// by the trait operation expressions (possibly after renaming)

		inferInterfaceForTraitReferencesWithOperations(c, inferredClass, acceptor, maps)
   		
   		acceptor.accept(inferredClass) [
   			c.traitReferences.collectInterfaceResolvedOperations(it, maps)
   		]
   		
   		inferClassForTraitReferencesWithOperations(c, inferredClass, acceptor, maps)
   	}

	/**
	 * This actually infers class contents.
	 * 
	 * For a TJClass we need to split the inference since it depends both on the
	 * resolved methods of trait references and the inferred classes for traits.
	 */
   	def void inferClassContents(TJClass c, JvmDeclaredTypeAcceptor acceptor,
   		XtraitjMaps maps
   	) {
   		val inferredClass = c.jvmElements.filter(JvmGenericType).head
   		acceptor.later.add(inferredClass -> [
   			declaredType |
   			val it = declaredType as JvmGenericType
   			documentation = c.documentation
   			
   			for (i : c.interfaces) {
   				superTypes += i.cloneWithProxies
   			}
   			
   			for (field : c.fields) {
   				members += field.toField(field.name, field.type) [
   					if (field.init != null)
   						initializer = field.init
   					translateAnnotations(field.annotations)
   				]
				members += field.toGetter(field.name, field.type)
				members += field.toSetter(field.name, field.type)
   			}
   			
   			for (cons : c.constructors) {
   				members += cons.toConstructor[
   					for (p : cons.params) {
   						parameters += p.toParameter(p.name, p.parameterType)
   					}
   					body = cons.body
   				]
   			}
   			
   			c.addSuperTypesFromTraitReferences(it, maps)
   			
   			for (traitRef : c.traitReferences) {
//				val realRef = traitRef.traitReferenceJavaType
				val realRef = traitRef.traitReferenceToClassJvmTypeReference(it, maps)
				
				members += traitRef.toField(traitRef.traitFieldName, realRef) [
					initializer = [
						append('''new ''')
						append(realRef.type)
						append("(this)")
					]
				]
				
				// do not delegate to a trait who requires that operation
	   			// but to the one which actually implements it
				for (traitMethod : traitRef.getAllDefinedMethodOperationsFromMap(maps.traitInterfaceResolvedOperationsMap))
					members += traitMethod.toMethodDelegate(traitRef.traitFieldName) => [
						copyAnnotationsFrom(traitMethod)
					]
			}
   			
//   			for (traitRef : c.traitReferences) {
//   				// we need these supertypes for validation
//   				// but we'll remove them in the generator
//   				superTypes += traitRef.traitReferenceCopy(typesMap)
//   				
////   				// do not delegate to a trait who requires that operation
////   				// but to the one which actually implements it
////   				val realRef = traitRef.buildTypeRef(typesMap)
////   				
////   				members += traitRef.toField(traitRef.traitFieldName, realRef) [
////					initializer = [
////						append('''new ''')
////						append(realRef.type)
////						append("(this)")
////					]
////				]
//   				
////   				for (traitMethod : realRef.xtraitjJvmAllDefinedMethodOperations(traitRef))
////   					members += traitMethod.toMethodDelegate(traitRef.traitFieldName) => [
////   						copyAnnotationsFrom(traitMethod)
////   					]
//   			}
   		])
   	}

   	def inferTraitInterface(TJTrait t, JvmDeclaredTypeAcceptor acceptor, 
   		XtraitjMaps maps
   	) {
   		val traitInterface = t.toInterface(t.traitInterfaceName) [
			t.annotateAsTrait(it)
		]
		
		maps.typesMap.put(t.traitInterfaceName, traitInterface)
		
		acceptor.later.add(
			traitInterface -> [
   				declaredType |
   				t.traitReferences.collectInterfaceResolvedOperations(declaredType as JvmGenericType, maps)
   			]
		)

		inferInterfaceForTraitReferencesWithOperations(t, traitInterface, acceptor, maps)
		
		// TODO: this should be optmized so that we don't resolve the operations
		// for something that has already been resolved in the first run
		// or simply in the first run we infer only for trait references without
		// alteration operations?
		
		// this second run ensures that we collect resolved operations also for interfaces
		// inferred for trait references with alteration operations
		acceptor.later.add(
			traitInterface -> [
   				declaredType |
   				t.traitReferences.collectInterfaceResolvedOperations(declaredType as JvmGenericType, maps)
   			]
		)

		acceptor.accept(traitInterface) [
			t.addSuperTypesFromTraitReferences(it, maps)
			
			documentation = t.documentation
			
			copyTypeParameters(t.traitTypeParameters)
   			
   			// it is crucial to insert, at this stage, into the inferred interface all
   			// members which are specified in the trait, so that, later
   			// we also add the members we "inherit" from used traits 
			for (field : t.fields) {
				members += field.toGetter(field.name, field.type) => [
					field.annotateAsRequiredField(it)
					abstract = true
				]
				members += field.toSetter(field.name, field.type) => [
		   			abstract = true
		   		]
			}
			
			for (method : t.methods) {
				if (!method.isPrivate)
					members += method.toAbstractMethod => [
	   					translateAnnotations(method.annotations)
	   					method.annotateAsDefinedMethod(it)
	   				]
			}
			
			for (method : t.requiredMethods) {
				members += method.toAbstractMethod => [
					method.annotateAsRequiredMethod(it)
				]
			}
			
//			t.traitReferences.collectInterfaceResolvedOperations(it, typesMap, resolvedOperationsMap)
		]

//		// it is crucial to infer interfaces for trait operation expressions
//		// first, so that when we add methods to the interface of this
//		// trait, we can see all the methods which are possibly provided
//		// by the trait operation expressions (possibly after renaming)
//
//		// infer interfaces first for trait operation expressions		
//		for (it : t.traitOperationExpressions)
//			inferTraitExpressionInterface(acceptor)
//
//		// then we can infer the corresponding classes
//		for (it : t.traitOperationExpressions)
//			inferTraitExpressionClass(acceptor)
//
//		acceptor.accept(traitInterface).initializeLater [
//			if (t.traitExpression != null)
//				for (superInterface : (newArrayList => [collectSuperInterfaces(t.traitExpression)])) {
//					superTypes += superInterface
//				}	
//			
//			// methods which are defined in any of the used traits
//			// must be explicitly inserted in the interface, even if inherited
//			// (it is safe to do so, since they have the same signature)
//			// this way, in this interface, the inserted Java methods are
//			// associated to defined methods in the corresponding trait
////			for (traitRef : t.traitReferences) {
////				if (traitRef.arguments.empty)
////					for (op: traitRef.xtraitjJvmAllMethodOperations) {
////						members += op.toAbstractMethod
////					}
////				else {
////					for (op: traitRef.xtraitjJvmAllMethodDeclarationOperations) {
////						if (!members.alreadyDefined(op.op))
////							members += op.toAbstractMethod
////					} // in the presence of generics also inserts
////					// required methods with type parameters instantiated
////					
////					// and also getters/setters with type parameters instantiated
////					for (op: traitRef.xtraitjJvmAllFieldOperations) {
////						if (!members.alreadyDefined(op.op))
////							members += op.toAbstractMethod
////					}
////				}
////			}
//		]
				
		traitInterface
   	}

	def void inferTraitExpressionInterface(TJTraitReference t, JvmGenericType containingDeclarationInferredType, 
		JvmDeclaredTypeAcceptor acceptor, 
		XtraitjMaps maps
   	) {
		val traitExpressionInterface = t.toInterface(t.traitExpressionInterfaceName) []
		
		maps.typesMap.put(t.traitExpressionInterfaceName, traitExpressionInterface)
		
		acceptor.later.add(
			traitExpressionInterface -> [
   				declaredType |
   				val jvmGenericType = declaredType as JvmGenericType
				t.collectUnmodifiedInterfaceResolvedOperations(jvmGenericType, maps)
//   				t.collectInterfaceResolvedOperations(jvmGenericType, maps)
   			]
		)	

		acceptor.accept(traitExpressionInterface) [
			copyTypeParameters(t.containingDeclaration.typeParameters)
			
			for (jvmOp : t.xtraitjJvmAllOperations) {
				val relatedOperations = t.operationsForJvmOp(jvmOp)
				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
	//				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
	//				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
	//				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
				
				val op = jvmOp.op
				
				if (relatedOperations.empty) {
					members += jvmOp.toAbstractMethod(op.simpleName) => [
						copyAllAnnotationsFrom(op)
					]
					if (op.annotatedRequiredField())
						members += t.toAbstractSetterDelegateFromGetter(jvmOp)
				} else {
					if (renameOperation != null) {
						val newname = renameOperation.newname
						val origName = op.simpleName
						members += jvmOp.toAbstractMethod
							(origName.renameGetterOrSetter(newname)) => [
										copyAllAnnotationsFrom(op)
										op.annotateAsRenamedMethod(it, origName) 
									]
						if (op.annotatedRequiredField()) {
							members += t.toAbstractSetterDelegateFromGetter
								(jvmOp, newname)
						}
					}
	//					// hidden methods are simply not inserted in this interface
	//					if (aliasOperation != null) {
	//						members += jvmOp.toAbstractMethod(aliasOperation.newname)
	//						if (renameOperation == null && hideOperation == null && restrictOperation == null) {
	//							// we need to add also the original method
	//							members += jvmOp.toAbstractMethod(aliasOperation.member.simpleName)
	//						}
	//					}
	//					// restricted methods are added and associated to the
	//					// operation itself
	//					if (restrictOperation != null) {
	//						members += 
	//							restrictOperation.toAbstractMethod(jvmOp, op.simpleName)
	//					}
				}
			}
			
//			t.collectInterfaceResolvedOperations(it, maps)
		]
		
//		.initializeLater[
//			for (jvmOp : t.xtraitjJvmAllOperations) {
//				val relatedOperations = t.operationsForJvmOp(jvmOp)
//				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
//				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
//				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
//				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
//				
//				if (relatedOperations.empty) {
//					members += jvmOp.toAbstractMethod(jvmOp.op.simpleName)
//				} else {
//					if (renameOperation != null) {
//						members += jvmOp.toAbstractMethod
//							(jvmOp.op.simpleName.renameGetterOrSetter(renameOperation.newname))
//					}
//					// hidden methods are simply not inserted in this interface
//					if (aliasOperation != null) {
//						members += jvmOp.toAbstractMethod(aliasOperation.newname)
//						if (renameOperation == null && hideOperation == null && restrictOperation == null) {
//							// we need to add also the original method
//							members += jvmOp.toAbstractMethod(aliasOperation.member.simpleName)
//						}
//					}
//					// restricted methods are added and associated to the
//					// operation itself
//					if (restrictOperation != null) {
//						members += 
//							restrictOperation.toAbstractMethod(jvmOp, jvmOp.op.simpleName)
//					}
//				}
//			}
//		]
	}

	def void inferTraitExpressionClass(TJTraitReference t, JvmGenericType containingDeclarationInferredType, 
		IJvmDeclaredTypeAcceptor acceptor,
		XtraitjMaps maps
	) {
		val traitExpressionClassName = t.traitExpressionClassName
		
		val traitReferenceClass = t.toClass(traitExpressionClassName)
		
		//traitReferenceClass.copyTypeParameters(t.containingDeclaration.typeParameters)
		traitReferenceClass.copyTypeParameters(containingDeclarationInferredType.typeParameters)
		
		maps.typesMap.put(traitExpressionClassName, traitReferenceClass)
		
		acceptor.accept(traitReferenceClass) [
			
			// the interface for the adapter class
			val traitRefAssociatedInterface = t.associatedAdapterInterface
			
			val transformedTraitInterfaceTypeRef = traitRefAssociatedInterface.
							transformTypeParametersIntoTypeArguments(t.containingDeclaration)
			
			superTypes += transformedTraitInterfaceTypeRef.cloneWithProxies
			superTypes += t.trait.cloneWithProxies
			
			val traitFieldName = t.traitFieldNameForOperations
		
			val constructorName = it.simpleName
			
			members += t.containingDeclaration.
				toField(delegateFieldName, transformedTraitInterfaceTypeRef)

			val traitFieldTypeRef = t.trait.buildTraitClassTypeRef(maps)
			members += t.toField(traitFieldName, traitFieldTypeRef)
			
			members += t.toConstructor[
				simpleName = constructorName
				parameters += t.toParameter("delegate", transformedTraitInterfaceTypeRef)
				body = [
					it.append('''this.«delegateFieldName» = delegate;''')
					newLine.append('''«traitFieldName» = ''')
				   	append('''new ''')
					append(traitFieldTypeRef.type)
					append("(this);")	
	   			]
			]
			
			// we need the JvmOperation with resolved type arguments
			val allDeclarations = t.getAllDeclaredOperationsFromMap(maps.traitInterfaceResolvedOperationsMap).toList
			
			for (tOp : t.operations) {
				switch(tOp) {
					TJRenameOperation: {
						if (!tOp.field) {
							// and we need to retrieve the corresponding resolved operation
							// i.e., the one where type arguments are already resolved
							val resolvedOp = allDeclarations.map[op].findFirst[tOp.newname == simpleName]
							val origName = tOp.member.simpleName
	
							val requiredMethod = resolvedOp.annotatedRequiredMethod()
							
							if (requiredMethod) {
								// make sure we take the jvmOp's name
								// since the member in the rename operation is bound
								// to the getter in case of a field
								val newname = 
									resolvedOp.simpleName.renameGetterOrSetter(tOp.newname)
								// m is forwarded to this.m2()
								members += tOp.
									toMethodDelegate(
										resolvedOp,
										"this",
										origName,
										newname
									)
								// m2 is forwarded to delegate.m2()
								members += tOp.
									toMethodDelegate(
										resolvedOp,
										delegateFieldName,
										newname,
										newname
									) => [
										copyAllAnnotationsFrom(resolvedOp)
									]
								
							} else {
								// m is forwarded to this.m2
								val newname = tOp.newname
								
								members += tOp.
									toMethodDelegate(
										resolvedOp,
										"this",
										origName,
										newname
									)
								// m2 is forwarded to delegate.m2
								members += tOp.
									toMethodDelegate(
										resolvedOp,
										delegateFieldName,
										newname,
										newname
									) => [ 
										copyAllAnnotationsFrom(resolvedOp)
									]
								// _m2 is forwarded to T1._m
								members += tOp.
									toMethodDelegate(
										resolvedOp,
										traitFieldName,
										newname.underscoreName,
										origName.underscoreName
									)
							}
						}
					
					}
				}
			}
			
			addDelegates(#[t], it, maps.traitUnmodifiedInterfaceResolvedOperationsMap)
			
//			for (tOp : t.operations) {
//				switch(tOp) {
//					TJRenameOperation: {
//						if (tOp.field) {
//							members += xtraitjTraitOperationWrapperFactory.createRenameOperationWrapperForGetter(tOp, t.trait) => [
//								tOp.associate(it)
//							]
//							members += xtraitjTraitOperationWrapperFactory.createPrivateGetterOperationWrapper(tOp, t.trait) => [
//								tOp.associate(it)
//							]
//							members += xtraitjTraitOperationWrapperFactory.createRenameOperationWrapperForSetter(tOp, t.trait) => [
//								tOp.associate(it)
//							]
//							members += xtraitjTraitOperationWrapperFactory.createPrivateSetterOperationWrapper(tOp, t.trait) => [
//								tOp.associate(it)
//							]
//						} else {
//							members += xtraitjTraitOperationWrapperFactory.createPrivateOperationWrapper(tOp, t.trait) => [
//								tOp.associate(it)
//							]
//							members += xtraitjTraitOperationWrapperFactory.createRenameOperationWrapper(tOp, t.trait) => [
//								tOp.associate(it)
//							]
//						}
//					}
//				}
//			}
			
//			// the interface for the adapter class
//			val traitRefAssociatedInterface = t.associatedInterface
//			superTypes += traitRefAssociatedInterface
//			// the interface of the original trait
//			val traitAssociatedInterface = t.traitReferenceCopy
//			superTypes += traitAssociatedInterface
//			
//			val traitFieldName = t.traitFieldNameForOperations
//			
//			members += t.containingDeclaration.
//				toField(delegateFieldName, traitRefAssociatedInterface)
//			members += t.
//				toField(traitFieldName, t.associatedTraitClass)
//			
//			members += t.toConstructor[
//   				parameters += t.toParameter("delegate", traitRefAssociatedInterface)
//				body = [
//					it.append('''this.«delegateFieldName» = delegate;''')
//					newLine.append('''«traitFieldName» = ''')
//				   	append('''new ''')
//					append(t.trait.associatedClass.type)
//					append("(this);")	
//	   			]
//			]
//			
//			// operations of the referred trait in this trait operation
//			for (jvmOp : t.trait.jvmAllOperations) {
//				val relatedOperations = t.operationsForJvmOp(jvmOp)
//				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
//				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
//				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
//				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
//				val redirectOperation = relatedOperations.filter(typeof(TJRedirectOperation)).head
//				
//				val xop = jvmOp.createXtraitjJvmOperation(t)
//				
//				if (renameOperation == null && hideOperation == null && redirectOperation == null) {
//					// if the method is not removed we must also add the
//					// same forwarding for the original name
//					members += xop.
//							toMethodDelegate(delegateFieldName,
//								jvmOp.simpleName,
//								jvmOp.simpleName
//							)
//					// if it's restricted the original version will not
//					// be called.
//					if (!jvmOp.required && restrictOperation == null) {
//						members += xop.
//							toMethodDelegate(traitFieldName,
//								jvmOp.simpleName.underscoreName,
//								jvmOp.simpleName.underscoreName
//							)						
//					}
//				}
//				if (renameOperation != null) {
//					// example T1[rename m -> m2]
//					
//					if (jvmOp.isRequired) {
//						// make sure we take the jvmOp's name
//						// since the member in the rename operation is bound
//						// to the getter in case of a field
//						val newname = 
//							jvmOp.simpleName.renameGetterOrSetter(renameOperation.newname)
//						// m is forwarded to this.m2()
//						members += xop.
//							toMethodDelegate(
//								"this",
//								jvmOp.simpleName,
//								newname
//							)
//						// m2 is forwarded to delegate.m2()
//						members += xop.
//							toMethodDelegate(
//								delegateFieldName,
//								newname,
//								newname
//							)
//					} else {
//						// m is forwarded to this.m2
//						members += xop.
//						toMethodDelegate(
//							"this",
//							renameOperation.member.simpleName,
//							renameOperation.newname
//						)
//						// m2 is forwarded to delegate.m2
//						members += xop.
//							toMethodDelegate(
//								delegateFieldName,
//								renameOperation.newname,
//								renameOperation.newname
//							)
//						// _m2 is forwarded to T1._m
//						members += xop.
//							toMethodDelegate(
//								traitFieldName,
//								renameOperation.newname.underscoreName,
//								renameOperation.member.simpleName.underscoreName
//							)
//					}
//				}
//				if (hideOperation != null) {
//					// example T1[hide m]
//					// m cannot be required
//					// m is forwarded to T1._m
//					// _m2 is forwarded to T1._m
//					members += xop.
//						toMethodDelegate(
//							traitFieldName,
//							hideOperation.member.simpleName,
//							hideOperation.member.simpleName.underscoreName
//						)
//				}
//				if (aliasOperation != null) {
//					// example T1[alias m as oldm]
//					// m cannot be required
//					// oldm is forwarded to delegate.oldm
//					members += xop.
//						toMethodDelegate(
//							delegateFieldName,
//							aliasOperation.newname,
//							aliasOperation.newname
//						)
//					// _oldm is forwarded to T1._m
//					members += xop.
//						toMethodDelegate(
//							traitFieldName,
//							aliasOperation.newname.underscoreName,
//							aliasOperation.member.simpleName.underscoreName
//						)
//				}
//				if (redirectOperation != null && redirectOperation.member2 != null) {
//					// example T1[redirect m to m1]
//					// m is forwarded to delegate.m1
//					if (jvmOp.isRequired) {
//						// make sure we take the jvmOp's name
//						// since the members in the redirect operation are bound
//						// to the getter in case of a field
//						members += xop.
//							toMethodDelegate(
//								delegateFieldName,
//								jvmOp.simpleName,
//								jvmOp.simpleName.renameGetterOrSetter(
//									redirectOperation.member2.simpleName.stripGetter
//								)
//							)
//					} else {
//						members += xop.
//							toMethodDelegate(
//								delegateFieldName,
//								redirectOperation.member.simpleName,
//								redirectOperation.member2.simpleName
//							)
//					}
//				}
//			}
		]
	}

   	def void inferTraitClass(TJTrait t, IJvmDeclaredTypeAcceptor acceptor,
   		XtraitjMaps maps
   	) {
   		val traitClass = t.toClass(t.traitClassName)
		
		// immediately copy type parameters, otherwise, when processing possible
		// trait operations involving this trait the corresponding inferred class
		// does not expose type parameters yet
//		traitClass.copyTypeParameters(t.traitTypeParameters)
		
		maps.typesMap.put(t.traitClassName, traitClass)
		
		inferClassForTraitReferencesWithOperations(t, traitClass, acceptor, maps)
		
		
//	   	inferTypesForTraitReferencesWithOperations(t, traitClass, acceptor, typesMap, resolvedOperationsMap)
   		
		acceptor.accept(traitClass) [
		
			// the interface is surely associated in the model inferrer
			// since the trait element is in the input file we're processing
			val traitInterfaceTypeRef = t.associatedInterface
			
			val transformedTraitInterfaceTypeRef = traitInterfaceTypeRef.
						transformTypeParametersIntoTypeArguments(t)
			
			superTypes += transformedTraitInterfaceTypeRef

//   			t.addSuperTypesFromTraitReferences(it, typesMap)
			
			traitClass.copyTypeParameters(t.traitTypeParameters)
			
			val map = new HashMap<JvmTypeParameter, JvmTypeParameter>		   	
		   	for (typePar : typeParameters) {
		   		typePar.rebindConstraintsTypeParameters(it, null, map)
		   	}

   			documentation = t.documentation
   			
   			t.annotateAsTraitClass(it)

			members += t.toField(delegateFieldName, transformedTraitInterfaceTypeRef)
   			
   			for (traitRef : t.traitReferences) {
				members += traitRef.toField
					(traitRef.traitFieldName, traitRef.traitReferenceToClassJvmTypeReference(it, maps))
			}

			members += t.toConstructor[
				c |
				c.simpleName = t.name
				c.parameters += t.toParameter("delegate", transformedTraitInterfaceTypeRef)
				c.body = [
					a |
					a.append('''this.«delegateFieldName» = delegate;''')
					for (traitRef : t.traitReferences) {
		   				a.newLine.append('''«traitRef.traitFieldName» = ''')
		   				a.append('''new ''')
						a.append(traitRef.traitReferenceToClassJvmTypeReference(it, maps).type)
						a.append("(delegate);")
					}
	   			]
			]
			
   			

//   			val traitInterfaceTypeRef = t.associatedInterface
//			
//			val transformedTraitInterfaceTypeRef = traitInterfaceTypeRef.
//							transformTypeParametersIntoTypeArguments(t)
//			superTypes += transformedTraitInterfaceTypeRef
   			
//   			members += t.toField(delegateFieldName, transformedTraitInterfaceTypeRef)
//   			
//   			for (traitExp : t.traitReferences)
//   				members += traitExp.toField
//   					(traitExp.traitFieldName, traitExp.associatedClass)
//   			
//   			members += t.toConstructor[
//   				parameters += t.toParameter("delegate", transformedTraitInterfaceTypeRef)
//				body = [
//					it.append('''this.«delegateFieldName» = delegate;''')
//					for (traitExp : t.traitExpression.traitReferences) {
//		   				newLine.append('''«traitExp.traitFieldName» = ''')
//		   				append('''new ''')
//						append(traitExp.associatedClass.type)
//						append("(delegate);")
//					}
//	   			]
//			]
   			
   			for (field : t.fields) {
   				members += toGetterDelegate(field) => [
   					field.annotateAsRequiredField(it)
   				]
   				members += field.toSetterDelegate
   			}
   			
   			for (aMethod : t.requiredMethods)
   				members += aMethod.toMethodDelegate(delegateFieldName) => [
   					aMethod.annotateAsRequiredMethod(it)
   				]
   			
   			for (method : t.methods) {
   				if (method.isPrivate) {
   					members += method.toTraitMethod(method.name) => [
	   					translateAnnotations(method.annotations)
	   				]
   				} else {
   					// first infer the method with the original body to make
   					// type parameters work correctly
   					
	   				// _m() { original m's body }
	   				val actualMethod = method.toTraitMethod(method.name.underscoreName)
   					
   					// m() { _delegate.m(); }
   					val delegateMethod = method.toMethodDelegate(delegateFieldName) => [
	   					method.annotateAsDefinedMethod(it)
	   				]
   					
   					delegateMethod.translateAnnotations(method.annotations)
   					
	   				members += delegateMethod
	   				members += actualMethod
				}
   			}
   			
   			addDelegates(t.traitReferences, it, maps.traitInterfaceResolvedOperationsMap)
   			
//   			for (tRef : t.traitReferences) {
//   				// we need these supertypes for validation
//   				// but we'll remove them in the generator
//   				superTypes += tRef.traitReferenceCopy(typesMap)
////   				
////   				val traitRef = tRef.buildTypeRef(typesMap)
////   				// first delegates for implemented methods 
////   				for (traitMethod : traitRef.xtraitjJvmAllDefinedMethodOperations(tRef)) {
////   					if (!members.alreadyDefined(traitMethod.op)) {
////	   					val methodName = traitMethod.op.simpleName
////	   					// m() { _delegate.m(); }
////	   					members += traitMethod.toMethodDelegate(
////		   						delegateFieldName, methodName, methodName
////		   					) => [ 
////			   					traitMethod.op.annotateAsDefinedMethod(it)
////			   				]
////	   					// _m() { delegate to trait defining the method }
////	   					members += traitMethod.toMethodDelegate(
////	   						tRef.traitFieldName, methodName.underscoreName,
////	   						methodName.underscoreName
////	   					)
////   					}
////   				}
//   			}
   			
//   			for (tRef : t.traitReferences) {
//   				val traitRef = tRef.buildTypeRef(typesMap)
//   				
//   				for (op : traitRef.xtraitjJvmAllRequiredFieldOperations(tRef)) {
//   					if (!members.alreadyDefined(op.op)) {
//	   					// this is the getter
//	   					members += op.toMethodDelegate(
//								delegateFieldName,
//								op.op.simpleName, op.op.simpleName) => [
//		   					op.op.annotateAsRequiredField(it)
//		   				]
//		   				members += op.toSetterDelegateFromGetter
//	   				}
//   				}
//   				
//   				// then delegates for required methods
//   				// TODO deal with restrict
//   				// see old xtraitjJvmAllRequiredOperations
//   				for (op : traitRef.xtraitjJvmAllRequiredMethodOperations(tRef))
//   					if (!members.alreadyDefined(op.op)) {
//   						members += op.toMethodDelegate(
//	   							delegateFieldName,
//	   							op.op.simpleName, op.op.simpleName) => [
//		   					op.op.annotateAsRequiredMethod(it)
//		   				]
//   					}
//   			}
   		]
   	}
				
	def inferInterfaceForTraitReferencesWithOperations(TJDeclaration d, JvmGenericType inferredType, JvmDeclaredTypeAcceptor acceptor,
		XtraitjMaps maps
	) {
		for (tRef : d.traitReferences) {
			if (!tRef.operations.empty) {
				tRef.inferTraitExpressionInterface(inferredType, acceptor, maps)
			}
		}
	}

	def inferClassForTraitReferencesWithOperations(TJDeclaration d, JvmGenericType inferredType, IJvmDeclaredTypeAcceptor acceptor,
		XtraitjMaps maps
	) {
		for (tRef : d.traitReferences) {
			if (!tRef.operations.empty) {
				tRef.inferTraitExpressionClass(inferredType, acceptor, maps)
			}
		}
	}

	def addSuperTypesFromTraitReferences(TJDeclaration d, JvmGenericType it, XtraitjMaps maps) {
		// Xbase collects candidate features starting with the first superTypes (it looks so)
		// Since trait references with operations could make some methods as private
		// it is crucial to put the trait references WITHOUT operations first, so that,
		// for instance, non renamed methods (original ones) are correctly bound:
		// T uses T1[rename m to n], T1
		// the rename operation hides the original m, but the original one must
		// still be visible from the trait reference without operation T1
		
		// we need these supertypes for validation
		// but we'll remove them in the generator
//		for (tRef : d.traitReferences.filter[operations.empty]) {
//			superTypes += tRef.traitReferenceCopy(it, typesMap)
//		}
//		
//		for (tRef : d.traitReferences.filter[!operations.empty]) {
//			superTypes += tRef.traitReferenceCopy(it, typesMap)
//		}
		
		for (tRef : d.traitReferences) {
			superTypes += tRef.traitReferenceToInterfaceJvmTypeReference(it, maps).cloneWithProxies
		}
	}

   	def toGetterDelegate(JvmGenericType target, TJMember m) {
   		// m.toGetter(m.name, m.type.rebindTypeParameters(type)) => [
   		m.toGetter(m.name, m.type.rebindTypeParameters(target, null)) => [
   			method |
   			method.body = [
   				append('''return «delegateFieldName».«method.simpleName»();''')
   			]
   		]
   	}

   	def toSetterDelegate(TJMember m) {
   		m.toSetter(m.name, m.type) => [
   			method |
   			method.body = [append('''«delegateFieldName».«method.simpleName»(«m.name»);''')]
   		]
   	}

	def toMethodDelegate(TJMethodDeclaration m, String delegateFieldName) {
		m.toMethod(m.name, m.type) [
			documentation = m.documentation

			copyTypeParameters(m.typeParameters)

			for (p : m.params) {
				parameters += p.toParameter(p.name, p.parameterType)
			}
			val args = m.params.map[name].join(", ")
			if (m.type?.simpleName != "void")
				body = [append('''return «delegateFieldName».«m.name»(«args»);''')]
			else
				body = [append('''«delegateFieldName».«m.name»(«args»);''')]
		]
	}

	def private toMethodDelegate(EObject source, JvmOperation op, String delegateFieldName, String methodName, String methodToDelegate) {
		//val o = op.jvmOperation
		source.toMethod(methodName, op.returnType) [
			documentation = op.documentation
			
			copyTypeParameters(op.typeParameters)
			
			for (p : op.parameters) {
				parameters += p.toParameter(p.name, p.parameterType)
			}
			val args = op.parameters.map[name].join(", ")
			if (op.returnType?.simpleName != "void")
				body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
			else
				body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
		]
	}

	def toTraitMethod(TJMethod method, String name) {
		method.toMethod(name, method.type) [
			documentation = method.documentation
			
			copyTypeParameters(method.typeParameters)
			
			for (p : method.params) {
				parameters += p.toParameter(p.name, p.parameterType)
			}
			body = method.body
		]
	}

	def private traitReferenceToInterfaceJvmTypeReference(TJTraitReference traitRef, 
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		if (!traitRef.operations.empty) {
			//return traitRef.newTypeRef(traitRef.traitExpressionClassName)
			return traitRef.buildTypeRefForTraitExpression(containingDeclarationInferredType, maps)
		} else {
//			return traitRef.trait.cloneWithProxies
			return traitRef.buildTypeRef(maps)
		}
	}

	def private traitReferenceToUnmodifiedInterfaceJvmTypeReference(TJTraitReference traitRef, 
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		return traitRef.buildTypeRef(maps)
	}

	/**
	 * This builds a type reference to a trait interface inferred for this very program
	 * that represents a trait reference with operations.
	 */
	def private buildTypeRefForTraitExpression(TJTraitReference t, 
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		val mapped = maps.typesMap.get(t.traitExpressionInterfaceName)
		//return mapped.newTypeRef(t.trait.arguments.map[cloneWithProxies])
		val containingDeclTypeParams = containingDeclarationInferredType.typeParameters
		// it is crucial to use as type arguments type references to the type
		// parameters of the containing inferred JvmGenericType
		// DON'T use references to the original type parameters of the
		// trait element in the AST! 
		val typeArguments = containingDeclTypeParams.map[newTypeRef]
		return mapped.newTypeRef(typeArguments)
	}

	/**
	 * This builds a type reference to a trait class inferred for this very program
	 * that represents a trait reference with operations.
	 */
	def private buildClassTypeRefForTraitExpression(TJTraitReference t, 
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		val mapped = maps.typesMap.get(t.traitExpressionClassName)
		//return mapped.newTypeRef(t.trait.arguments.map[cloneWithProxies])
		val containingDeclTypeParams = containingDeclarationInferredType.typeParameters
		// it is crucial to use as type arguments type references to the type
		// parameters of the containing inferred JvmGenericType
		// DON'T use references to the original type parameters of the
		// trait element in the AST! 
		val typeArguments = containingDeclTypeParams.map[newTypeRef]
		return mapped.newTypeRef(typeArguments)
	}

	def buildTypeRef(TJTraitReference t, XtraitjMaps maps) {
		val typeRef = t.trait
		// here instead proxy resolution seems to be necessary
		// val type = typeRef.getTypeWithoutProxyResolution
		val type = typeRef.type
		if (type.eIsProxy()) {
			val mapped = maps.typesMap.get(typeRef.getJvmTypeReferenceString)
			if (mapped !== null)
				return mapped.newTypeRef(typeRef.arguments.map[cloneWithProxies])
		}
		typeRef
	}

	def private traitReferenceToClassJvmTypeReference(TJTraitReference traitRef, 
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		if (!traitRef.operations.empty) {
			//return traitRef.newTypeRef(traitRef.traitExpressionClassName)
			return traitRef.buildClassTypeRefForTraitExpression(containingDeclarationInferredType, maps)
		} else {
//			return traitRef.trait.cloneWithProxies
			return traitRef.buildTraitClassTypeRef(maps)
		}
	}

	def buildTraitClassTypeRef(TJTraitReference t, XtraitjMaps maps) {
		val typeRef = t.trait
		buildTraitClassTypeRef(typeRef, maps)
	}
	
	private def buildTraitClassTypeRef(JvmParameterizedTypeReference typeRef, XtraitjMaps maps) {
		val typeKey = typeRef.traitClassName
		val mapped = maps.typesMap.get(typeKey)
		if (mapped != null) {
			return typeRef(mapped, typeRef.arguments.map[cloneWithProxies])
		} else {
			return typeRef(typeKey, typeRef.arguments.map[cloneWithProxies])
		}
	}

	def private toAbstractMethod(XtraitjJvmOperation m, String name) {
		m.op.originalSource.toAbstractMethod(m, name)
	}

	def private toAbstractMethod(TJMethodDeclaration m) {
		m.toMethod(m.name, m.type) [
			documentation = m.documentation

			copyTypeParameters(m.typeParameters)
			
			//returnType = returnType.rebindTypeParameters(target, it)

			for (p : m.params) {
				//parameters += p.toParameter(p.name, p.parameterType.rebindTypeParameters(target, it))
				parameters += p.toParameter(p.name, p.parameterType)
			}
			abstract = true
		]
	}

	def private toAbstractMethod(EObject source, XtraitjJvmOperation m, String name) {
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

	def private addDelegates(List<TJTraitReference> traitReferences, JvmGenericType it, XtraitjResolvedOperationsMap map) {
		for (tRef : traitReferences) {
			// first delegates for implemented methods 
			for (traitMethod : tRef.getAllDefinedMethodOperationsFromMap(map)) {
				if (!members.alreadyDefined(traitMethod.op)) {
   					val methodName = traitMethod.op.simpleName
   					// m() { _delegate.m(); }
   					members += traitMethod.toMethodDelegate(it,
	   						delegateFieldName, methodName, methodName
	   					) => [ 
		   					traitMethod.op.annotateAsDefinedMethod(it)
		   				]
   					// _m() { delegate to trait defining the method }
   					members += traitMethod.toMethodDelegate(it,
   						tRef.traitFieldName, methodName.underscoreName,
   						methodName.underscoreName
   					)
				}
			}
		}
		
		for (tRef : traitReferences) {
			for (op : tRef.getAllRequiredFieldOperationsFromMap(map)) {
				if (!members.alreadyDefined(op.op)) {
   					// this is the getter
   					members += op.toMethodDelegate(it,
						delegateFieldName,
						op.op.simpleName, op.op.simpleName) => [
		   					op.op.annotateAsRequiredField(it)
		   				]
	   				members += tRef.toSetterDelegateFromGetter(op, it)
   				}
			}
			
			// then delegates for required methods
			// TODO deal with restrict
			// see old xtraitjJvmAllRequiredOperations
			for (op : tRef.getAllRequiredMethodOperationsFromMap(map))
				if (!members.alreadyDefined(op.op) && !members.alreadyDefined(op.op)) {
					members += op.toMethodDelegate(it,
						delegateFieldName,
						op.op.simpleName, op.op.simpleName) => [
		   					op.op.annotateAsRequiredMethod(it)
		   				]
				}
		}
	}
	
	/**
	 * This must be called when inferring Java interfaces for traits, so that all the
	 * methods of the used traits with possible type arguments are correctly resolved.
	 * At this stage, in fact, Java classes for traits are not yet inferred, thus we don't have
	 * wrong scoping resolutions for type parameters (that would prevent correct operation resolutions).
	 */
	def private collectInterfaceResolvedOperations(List<TJTraitReference> traitReferences, 
			JvmGenericType containingDeclarationInferredType, XtraitjMaps maps) {
		for (tRef : traitReferences) {
			collectInterfaceResolvedOperations(tRef, containingDeclarationInferredType, maps)
		}
	}
	
	private def collectInterfaceResolvedOperations(TJTraitReference tRef,
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		val traitRef = tRef.traitReferenceToInterfaceJvmTypeReference(containingDeclarationInferredType, maps)
		maps.traitInterfaceResolvedOperationsMap.put(tRef, traitRef.computeAndResolveXtraitjResolvedOperations(tRef))
	}

	private def collectUnmodifiedInterfaceResolvedOperations(TJTraitReference tRef,
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		val traitRef = tRef.traitReferenceToUnmodifiedInterfaceJvmTypeReference(containingDeclarationInferredType, maps)
		val resolvedOperations = traitRef.computeAndResolveXtraitjResolvedOperations(tRef)
		maps.traitUnmodifiedInterfaceResolvedOperationsMap.put(tRef, resolvedOperations)
	}

	/**
	 * If there's no entry in the map it means that we are referring to a Java interface corresponding
	 * to a trait defined elsewhere (i.e., not in this input file); in such case we compute the resolved operations
	 * and we also store them in the map for efficiency.
	 */
	def private getXtraitjResolvedOperationsFromMap(TJTraitReference tRef, XtraitjResolvedOperationsMap map) {
		val result = map.get(tRef)
		if (result == null) {
			val computed = tRef.traitReferenceJavaType.computeXtraitjResolvedOperations(tRef)
			map.put(tRef, computed)
			return computed
		}
		return result
	}

	def private getAllDeclaredOperationsFromMap(TJTraitReference tRef, XtraitjResolvedOperationsMap map) {
		tRef.getXtraitjResolvedOperationsFromMap(map).allDeclarations.
					createXtraitjJvmOperations
	}

	def private getAllDefinedMethodOperationsFromMap(TJTraitReference tRef, XtraitjResolvedOperationsMap map) {
		tRef.getXtraitjResolvedOperationsFromMap(map).definedMethods.
					createXtraitjJvmOperations
	}

	def private getAllRequiredFieldOperationsFromMap(TJTraitReference tRef, XtraitjResolvedOperationsMap map) {
		tRef.getXtraitjResolvedOperationsFromMap(map).requiredFields.
					createXtraitjJvmOperations
	}

	def private getAllRequiredMethodOperationsFromMap(TJTraitReference tRef, XtraitjResolvedOperationsMap map) {
		tRef.getXtraitjResolvedOperationsFromMap(map).requiredMethods.
					createXtraitjJvmOperations
	}

	/**
	 * This also rebinds type parameters since the inferred methods are based on signatures of
	 * resolved operations taken from interfaces and possible type parameter references would
	 * be resolved (scoped) to the original elements, while they must be solved using the
	 * current target (the JvmGenericType that will own these methods).
	 */
	def private toMethodDelegate(XtraitjJvmOperation op, JvmGenericType target, String delegateFieldName, String methodName, String methodToDelegate) {
		val o = op.op
		val m = o.originalSource ?: o
//		if (!o.typeParameters.empty)
			m.toMethod(methodName, op.returnType) [
				documentation = m.documentation
				
//				if (m instanceof TJMethodDeclaration) {
					copyTypeParameters(o.typeParameters)
//				}
	
				returnType = returnType.rebindTypeParameters(target, it)
		
				val paramTypeIt = op.parametersTypes.iterator
				for (p : o.parameters) {
					//parameters += p.toParameter(p.name, paramTypeIt.next.rebindTypeParameters(it))
					// don't associate the parameter to p, since p is not part of the source tree
					// java.lang.IllegalArgumentException: The source element must be part of the source tree.
					parameters += m.toParameter(p.name, paramTypeIt.next.rebindTypeParameters(target, it))
				}
				val args = o.parameters.map[name].join(", ")
				if (op.returnType?.simpleName != "void")
					body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
				else
					body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
			]
//		else // if there's no type params we can make things simpler
//			m.toMethod(methodName, op.returnType) [
//				documentation = m.documentation
//				
//				val paramTypeIt = op.parametersTypes.iterator
//				for (p : o.parameters) {
//					parameters += p.toParameter(p.name, paramTypeIt.next)
//				}
//				val args = o.parameters.map[name].join(", ")
//				if (op.returnType?.simpleName != "void")
//					body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
//				else
//					body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
//			] // and we can navigate to the original method
	}
	
	def private toSetterDelegateFromGetter(EObject source, XtraitjJvmOperation op, JvmGenericType target) {
   		val fieldName = op.op.simpleName.stripGetter
   		source.toSetter(fieldName, op.returnType.rebindTypeParameters(target, null)) => [
   			method |
   			method.body = [append('''«delegateFieldName».«method.simpleName»(«fieldName»);''')]
   		]
   	}

	def private toAbstractSetterDelegateFromGetter(EObject source, XtraitjJvmOperation op) {
   		val fieldName = op.op.simpleName.stripGetter
   		source.toSetter(fieldName, op.returnType) => [
   			abstract = true
   		]
   	}

	def private toAbstractSetterDelegateFromGetter(EObject source, XtraitjJvmOperation op, String newName) {
   		source.toSetter(newName, op.returnType) => [
   			abstract = true
   		]
   	}
}

