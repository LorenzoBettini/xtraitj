package xtraitj.jvmmodel

import com.google.inject.Inject
import java.util.Map
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor.IPostIndexingInitializing
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.types.XtraitjTraitOperationWrapperFactory
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
	@Inject XtraitjTraitOperationWrapperFactory xtraitjTraitOperationWrapperFactory

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
	 *            indexing phase using the closure you pass to the returned
	 *            {@link IPostIndexingInitializing#initializeLater(org.eclipse.xtext.xbase.lib.Procedures.Procedure1)
	 *            initializeLater(..)}.
	 * @param isPreIndexingPhase
	 *            whether the method is called in a pre-indexing phase, i.e.
	 *            when the global index is not yet fully updated. You must not
	 *            rely on linking using the index if isPreIndexingPhase is
	 *            <code>true</code>.
	 */
   	def dispatch void infer(TJProgram p, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
   		val Map<String,JvmGenericType> typesMap = newHashMap()
   		
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
					e.inferTraitInterface(acceptor, typesMap)
					// so that in the model generator when we generate the class the
					// interface has already been enriched
					e.inferTraitClass(acceptor, typesMap)
				}
				TJClass: e.inferClass(acceptor, typesMap)
			}
		}
   	}
   	
   	def void inferClass(TJClass c, IJvmDeclaredTypeAcceptor acceptor, Map<String,JvmGenericType> typesMap) {
   		val inferredClass = c.toClass(c.fullyQualifiedName)
   		
   		inferredClass.copyTypeParameters(c.typeParameters)
   		
   		// it is crucial to infer interfaces for trait operation expressions
		// first, so that when we add methods to this class
		// we can see all the methods which are possibly provided
		// by the trait operation expressions (possibly after renaming)

		inferTypesForTraitReferencesWithOperations(c, inferredClass, acceptor, typesMap)
   		
   		acceptor.accept(inferredClass).initializeLater[
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
   			
   			c.addSuperTypesFromTraitReferences(it, typesMap)
   			
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
   		]
   	}

   	def inferTraitInterface(TJTrait t, IJvmDeclaredTypeAcceptor acceptor, Map<String,JvmGenericType> typesMap) {
   		// this is a minimal inference, the interface will be filled up by
   		// XtraitjJvmModelGenerator
   		val traitInterface = t.toInterface(t.traitInterfaceName) [
			documentation = t.documentation
			
			t.annotateAsTrait(it)

//   			copyTypeParameters(t.traitTypeParameters)
   			
//   			// it is crucial to insert, at this stage, into the inferred interface all
//   			// members which are specified in the trait, so that, later
//   			// we also add the members we "inherit" from used traits 
//			for (field : t.fields) {
//				members += field.toGetterAbstract => [
//					field.annotateAsRequiredField(it)
//				]
//				members += field.toSetterAbstract
//			}
//			
//			for (method : t.methods) {
//				if (!method.isPrivate)
//					members += method.toAbstractMethod => [
//	   					translateAnnotations(method.annotations)
//	   					method.annotateAsDefinedMethod(it)
//	   				]
//			}
//			
//			for (method : t.requiredMethods) {
//				members += method.toAbstractMethod => [
//					method.annotateAsRequiredMethod(it)
//				]
//			}
		]
		
		typesMap.put(t.traitInterfaceName, traitInterface)
		
		acceptor.accept(traitInterface)

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

	def void inferTraitExpressionInterface(TJTraitReference t, IJvmDeclaredTypeAcceptor acceptor) {
		// this is a minimal inference, the interface will be filled up by
   		// XtraitjJvmModelGenerator
		acceptor.accept(
			t.toInterface(t.traitExpressionInterfaceName)
			[
				//copyTypeParameters(t.containingDeclaration.typeParameters)
			]
		)
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
		IJvmDeclaredTypeAcceptor acceptor, Map<String,JvmGenericType> typesMap
	) {
		val traitExpressionClassName = t.traitExpressionClassName
		
		val traitReferenceClass = t.toClass(traitExpressionClassName)
		
		//traitReferenceClass.copyTypeParameters(t.containingDeclaration.typeParameters)
		traitReferenceClass.copyTypeParameters(containingDeclarationInferredType.typeParameters)
		
		typesMap.put(traitExpressionClassName, traitReferenceClass)
		
		acceptor.accept(traitReferenceClass).initializeLater[
			
			superTypes += t.trait.cloneWithProxies
			
			for (tOp : t.operations) {
				switch(tOp) {
					TJRenameOperation: {
						if (tOp.field) {
							members += xtraitjTraitOperationWrapperFactory.createRenameOperationWrapperForGetter(tOp, t.trait) => [
								tOp.associate(it)
							]
							members += xtraitjTraitOperationWrapperFactory.createPrivateGetterOperationWrapper(tOp, t.trait) => [
								tOp.associate(it)
							]
							members += xtraitjTraitOperationWrapperFactory.createRenameOperationWrapperForSetter(tOp, t.trait) => [
								tOp.associate(it)
							]
							members += xtraitjTraitOperationWrapperFactory.createPrivateSetterOperationWrapper(tOp, t.trait) => [
								tOp.associate(it)
							]
						} else {
							members += xtraitjTraitOperationWrapperFactory.createPrivateOperationWrapper(tOp, t.trait) => [
								tOp.associate(it)
							]
							members += xtraitjTraitOperationWrapperFactory.createRenameOperationWrapper(tOp, t.trait) => [
								tOp.associate(it)
							]
						}
					}
				}
			}
			
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

   	def void inferTraitClass(TJTrait t, IJvmDeclaredTypeAcceptor acceptor, Map<String,JvmGenericType> typesMap) {
   		val traitClass = t.toClass(t.traitClassName)
		
		// immediately copy type parameters, otherwise, when processing possible
		// trait operations involving this trait the corresponding inferred class
		// does not expose type parameters yet
		traitClass.copyTypeParameters(t.traitTypeParameters)
		
		typesMap.put(t.name, traitClass)
		
	   	inferTypesForTraitReferencesWithOperations(t, traitClass, acceptor, typesMap)
   		
		acceptor.accept(traitClass).initializeLater[

   			documentation = t.documentation
   			
   			t.annotateAsTraitClass(it)

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
   			
   			t.addSuperTypesFromTraitReferences(it, typesMap)
   			
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
				
	def inferTypesForTraitReferencesWithOperations(TJDeclaration d, JvmGenericType inferredType, IJvmDeclaredTypeAcceptor acceptor, Map<String, JvmGenericType> typesMap) {
		for (tRef : d.traitReferences) {
			if (!tRef.operations.empty) {
				tRef.inferTraitExpressionInterface(acceptor)
				tRef.inferTraitExpressionClass(inferredType, acceptor, typesMap)
			}
		}
	}

	def addSuperTypesFromTraitReferences(TJDeclaration d, JvmGenericType it, Map<String, JvmGenericType> typesMap) {
		// Xbase collects candidate features starting with the first superTypes (it looks so)
		// Since trait references with operations could make some methods as private
		// it is crucial to put the trait references WITHOUT operations first, so that,
		// for instance, non renamed methods (original ones) are correctly bound:
		// T uses T1[rename m to n], T1
		// the rename operation hides the original m, but the original one must
		// still be visible from the trait reference without operation T1
		
		// we need these supertypes for validation
		// but we'll remove them in the generator
		for (tRef : d.traitReferences.filter[operations.empty]) {
			superTypes += tRef.traitReferenceCopy(it, typesMap)
		}
		
		for (tRef : d.traitReferences.filter[!operations.empty]) {
			superTypes += tRef.traitReferenceCopy(it, typesMap)
		}
	}

   	def toGetterDelegate(JvmGenericType type, TJMember m) {
   		// m.toGetter(m.name, m.type.rebindTypeParameters(type)) => [
   		m.toGetter(m.name, m.type) => [
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

	def protected traitReferenceCopy(TJTraitReference traitRef, 
		JvmGenericType containingDeclarationInferredType, Map<String, JvmGenericType> typesMap
	) {
		if (!traitRef.operations.empty) {
			//return traitRef.newTypeRef(traitRef.traitExpressionClassName)
			return traitRef.buildTypeRefForTraitExpression(containingDeclarationInferredType, typesMap)
		} else {
			return traitRef.trait.cloneWithProxies
		}
	}

	/**
	 * This builds a type reference to a trait class inferred for this very program
	 * that represents a trait reference with operations.
	 */
	def buildTypeRefForTraitExpression(TJTraitReference t, 
		JvmGenericType containingDeclarationInferredType, Map<String, JvmGenericType> typesMap
	) {
		val mapped = typesMap.get(t.traitExpressionClassName)
		//return mapped.newTypeRef(t.trait.arguments.map[cloneWithProxies])
		val containingDeclTypeParams = containingDeclarationInferredType.typeParameters
		// it is crucial to use as type arguments type references to the type
		// parameters of the containing inferred JvmGenericType
		// DON'T use references to the original type parameters of the
		// trait element in the AST! 
		val typeArguments = containingDeclTypeParams.map[newTypeRef]
		return mapped.newTypeRef(typeArguments)
	}

}

