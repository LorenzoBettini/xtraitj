package xtraitj.jvmmodel

import com.google.inject.Inject
import java.util.HashMap
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.common.types.JvmAnnotationTarget
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmStringAnnotationValue
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmUpperBound
import org.eclipse.xtext.common.types.TypesFactory
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociator
import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator.JvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod
import xtraitj.runtime.lib.annotation.XtraitjRequiredField
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod
import xtraitj.runtime.lib.annotation.XtraitjTraitClass
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface
import xtraitj.types.XtraitjTypeParameterHelper
import xtraitj.util.XtraitjAnnotatedElementHelper
import xtraitj.xtraitj.TJAliasOperation
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJHideOperation
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJRedirectOperation
import xtraitj.xtraitj.TJRenameOperation
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference
import xtraitj.xtraitj.TJTypeParameterDeclarator

import static extension xtraitj.util.XtraitjModelUtil.*
import static extension xtraitj.jvmmodel.XtraitjResolvedOperationUtil.*
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation

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
	
	@Inject	IJvmModelAssociator associator
	@Inject TypesFactory typesFactory
	
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
				TJTrait: {
					e.inferTraitClass(acceptor, maps)
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
				val allDefinedOperations = traitRef.
					getXtraitjResolvedOperationsFromMap(maps.traitInterfaceResolvedOperationsMap).
						definedMethods
				for (traitMethod : allDefinedOperations) {
					val name = traitMethod.declaration.simpleName
					members += traitRef.toMethodDelegate(traitMethod, 
						inferredClass, traitRef.traitFieldName, name, "_"+name
					) => [
						copyAnnotationsFrom(traitMethod)
					]
				}
			}
   			
   		])
   	}

   	def inferTraitInterface(TJTrait t, JvmDeclaredTypeAcceptor acceptor, 
   		XtraitjMaps maps
   	) {
   		val traitInterface = t.toInterface(t.traitInterfaceName) [
			annotateAsTrait
		]
		
		maps.typesMap.put(t.traitInterfaceName, traitInterface)
		
		acceptor.later.add(
			traitInterface -> [
   				declaredType |
   				
   				// type parameters must be set in the inferred Java interface at this
   				// stage, otherwise operation resolution will not work correctly in the
   				// presence of type parameters and type arguments
   				// (type arguments would be bound to the trait's type parameters, instead
   				// of the inferred Java interface's type parameters)
   				copyTypeParametersAndRebind(traitInterface, t)
   			]
		)

		inferInterfaceForTraitReferencesWithOperations(t, traitInterface, acceptor, maps)
		
		acceptor.accept(traitInterface) [
			// this ensures that we collect resolved operations also for interfaces
			// inferred for trait references with alteration operations
			t.traitReferences.collectInterfaceResolvedOperations(it, maps)
			
			t.addSuperTypesFromTraitReferences(it, maps)
			
			documentation = t.documentation
   			
			for (field : t.fields) {
				members += field.toGetter(field.name, field.type) => [
					annotateAsRequiredField
					abstract = true
					// this must not be rebound using the return type of the operation:
					// it won't be resolved after Xtext 2.7.3
					// since it's not contained in any resource yet
					// we must use the field.type that can be resolved
					returnType = field.type.rebindTypeParameters(traitInterface, null)
				]
				members += field.toSetter(field.name, field.type) => [
					annotateAsRequiredFieldSetter
		   			abstract = true
		   			// we can use the type references of the inferred operation
		   			// since they're already resolved.
		   			rebindTypeParameters(traitInterface)
		   		]
			}
			
			for (method : t.methods) {
				if (!method.isPrivate)
					members += method.toAbstractMethod(traitInterface) => [
	   					translateAnnotations(method.annotations)
	   					annotateAsDefinedMethod
	   				]
			}
			
			for (method : t.requiredMethods) {
				members += method.toAbstractMethod(traitInterface) => [
					annotateAsRequiredMethod
				]
			}
		]
				
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
   				
   				// type parameters must be set in the inferred Java interface at this
   				// stage, otherwise operation resolution will not work correctly in the
   				// presence of type parameters and type arguments
   				// (type arguments would be bound to the trait's type parameters, instead
   				// of the inferred Java interface's type parameters)
   				traitExpressionInterface.copyTypeParameters(t.containingDeclaration.typeParameters)
   				
				t.collectUnmodifiedInterfaceResolvedOperations(jvmGenericType, maps)
   			]
		)	

		acceptor.accept(traitExpressionInterface) [
			val ops = t.getXtraitjResolvedOperationsFromMap(maps.traitUnmodifiedInterfaceResolvedOperationsMap).allDeclarations
			
			// we must first add methods that are related to alteration operations...
			for (op : ops) {
				val relatedOperations = t.traitOperationsForJvmOp(op)
				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
				
				val jvmop = op.declaration
				val origName = jvmop.simpleName
				
				if (!relatedOperations.empty) {
					if (renameOperation != null && renameOperation.newname != null) {
						val newname = renameOperation.newname
						
						members += renameOperation.toAbstractMethod
							(op, origName.renameGetterOrSetter(newname)) => [
										copyAllAnnotationsFrom(op)
										annotateAsRenamedMethod(origName) 
									]
						if (jvmop.annotatedRequiredField()) {
							members += renameOperation.toAbstractSetterDelegateFromGetter
								(op, newname) => [
									annotateAsRequiredFieldSetter
									rebindTypeParameters(traitExpressionInterface)
								]
						}
					}
					// hidden methods are simply not inserted in this interface

					if (aliasOperation != null && aliasOperation.newname != null) {
						
						val newname = aliasOperation.newname
						
						members += aliasOperation.toAbstractMethod
							(op, newname) => [
								copyAllAnnotationsFrom(op)
							]
						
						if (renameOperation == null && hideOperation == null && restrictOperation == null) {
							// we need to add also the original method
							members += aliasOperation.toAbstractMethod
								(op, origName) => [
									copyAllAnnotationsFrom(op)
								]
						}
					}
						
					// restricted methods are added as required methods
					if (restrictOperation != null) {
						members += restrictOperation.toAbstractMethod(op, jvmop.simpleName) => [
							copyAllAnnotationsButDefinedFrom(op)
							annotateAsRequiredMethod
						]
					}
				}
			}
			
			// and then the remaining ones if not already present;
			// e.g., a rename operation can rename a provided method so that it
			// matches a required one, so we must have already added the renamed version
			// (see xtraitj.tests.XtraitjWithOperationsCompilerTest.testTraitRenameRequiredMethodToProvided)
			for (op : ops) {
				val relatedOperations = t.traitOperationsForJvmOp(op)
				val jvmop = op.declaration
				
				if (relatedOperations.empty && !members.alreadyDefined(jvmop)) {
					members += t.toAbstractMethod(op, jvmop.simpleName) => [
						copyAllAnnotationsFrom(op)
					]
					if (jvmop.annotatedRequiredField()) {
						members += t.toAbstractSetterDelegateFromGetter(op) => [
							annotateAsRequiredFieldSetter
							rebindTypeParameters(traitExpressionInterface)
						]
					}
				}
			}
		]
		
	}

	def void inferTraitExpressionClass(TJTraitReference t, JvmGenericType containingDeclarationInferredType, 
		IJvmDeclaredTypeAcceptor acceptor,
		XtraitjMaps maps
	) {
		val traitExpressionClassName = t.traitExpressionClassName
		
		val traitReferenceClass = t.toClass(traitExpressionClassName)
		
		maps.typesMap.put(traitExpressionClassName, traitReferenceClass)
		
		acceptor.accept(traitReferenceClass) [
			
			traitReferenceClass.copyTypeParameters(t.containingDeclaration.typeParameters)
			
			val transformedTraitInterfaceTypeRef = t.traitReferenceToInterfaceJvmTypeReference(it, maps)
			
			superTypes += transformedTraitInterfaceTypeRef.cloneWithProxies
			superTypes += t.trait.cloneWithProxies
			
			val traitFieldName = t.traitFieldNameForOperations
		
			val constructorName = it.simpleName
			
			members += t.containingDeclaration.
				toField(delegateFieldName, transformedTraitInterfaceTypeRef)

			// this assumes that the Impl class for the trait has already been inferred
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
			
			val allDeclarations = 
				t.getXtraitjResolvedOperationsFromMap(maps.traitInterfaceResolvedOperationsMap)
					.allDeclarations
			val allOriginalDeclarations = 
				t.getXtraitjResolvedOperationsFromMap(maps.traitUnmodifiedInterfaceResolvedOperationsMap)
					.allDeclarations
			
			for (tOp : t.operations) {
				val origName = tOp.member?.simpleName
				switch(tOp) {
					TJRenameOperation: {
						handleRenameOperation(tOp, allDeclarations, it, traitFieldName)
					}
					TJHideOperation: {
						// and we need to retrieve the corresponding resolved operation
						// i.e., the one where type arguments are already resolved
						// but we need to search in the original declarations
						val resolvedOp = allOriginalDeclarations.findFirst[origName == simpleName]
						
						if (resolvedOp != null) {
							// example T1[hide m]
							// m cannot be required
							// m is forwarded to T1._m
							// _m2 is forwarded to T1._m
							members += tOp.
								toMethodDelegate(
									resolvedOp,
									it,
									traitFieldName,
									origName,
									origName.underscoreName
								)
						}
					}
					TJAliasOperation: {
						val newname = tOp.newname
						// and we need to retrieve the corresponding resolved operation
						// i.e., the one where type arguments are already resolved
						val resolvedOp = allDeclarations.findFirst[newname == simpleName]
						
						// example T1[alias m as oldm]
						// m cannot be required
						
						if (resolvedOp != null) {
							// oldm is forwarded to delegate.oldm
							members += tOp.
								toMethodDelegate(
									resolvedOp,
									it,
									delegateFieldName,
									newname,
									newname
								)
							// _oldm is forwarded to T1._m
							members += tOp.
								toMethodDelegate(
									resolvedOp,
									it,
									traitFieldName,
									newname.underscoreName,
									origName.underscoreName
								) => [
									copyAllAnnotationsFrom(resolvedOp)
							]
						}
					}
					TJRestrictOperation: {
						// and we need to retrieve the corresponding resolved operation
						// i.e., the one where type arguments are already resolved
						// but we need to search in the original declarations
						val resolvedOp = allOriginalDeclarations.findFirst[origName == simpleName]
						
						// example T1[restrict m]
						
						// m is forwarded to delegate.m
						if (resolvedOp != null) {
							members += tOp.
								toMethodDelegate(
									resolvedOp,
									it,
									delegateFieldName,
									origName,
									origName
								)
						}
					}
					TJRedirectOperation: {
						handleRedirectOperation(tOp, allDeclarations, it, traitFieldName)
					}
				}
			}
			
			addDelegates(#[t], it, maps.traitUnmodifiedInterfaceResolvedOperationsMap)
		]
	}
	
	private def handleRenameOperation(TJRenameOperation tOp, Iterable<IResolvedOperation> allDeclarations, JvmGenericType it, String traitFieldName) {
		val origName = tOp.member?.simpleName
		
		val newname = if (!tOp.field) {
			tOp.newname
		} else {
			// make sure we take the jvmOp's name
			// since the member in the rename operation is bound
			// to the getter in case of a field
			origName.renameGetterOrSetter(tOp.newname)
		}
		
		// and we need to retrieve the corresponding resolved operation
		// i.e., the one where type arguments are already resolved
		val resolvedOp = allDeclarations.findFirst[newname == simpleName]
		
		if (resolvedOp != null) {
			if (!tOp.field) {
				val requiredMethod = resolvedOp.annotatedRequiredMethod()
				
				if (requiredMethod) {
					// make sure we take the jvmOp's name
					// since the member in the rename operation is bound
					// to the getter in case of a field
					
					// m is forwarded to this.m2()
					members += tOp.
						toMethodDelegate(
							resolvedOp,
							it,
							"this",
							origName,
							newname
						)
					// m2 is forwarded to delegate.m2()
					members += tOp.
						toMethodDelegate(
							resolvedOp,
							it,
							delegateFieldName,
							newname,
							newname
						) => [
							copyAllAnnotationsFrom(resolvedOp)
						]
					
				} else {
					// m is forwarded to this.m2
					members += tOp.
						toMethodDelegate(
							resolvedOp,
							it,
							"this",
							origName,
							newname
						)
					// m2 is forwarded to delegate.m2
					members += tOp.
						toMethodDelegate(
							resolvedOp,
							it,
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
							it,
							traitFieldName,
							newname.underscoreName,
							origName.underscoreName
						)
				}
			} else {
				// example T1[rename field m to m2]
		
				// m is forwarded to this.m2()
				members += tOp.
					toMethodDelegate(
						resolvedOp,
						it,
						"this",
						origName,
						newname
					)
				// m2 is forwarded to delegate.m2()
				members += tOp.
					toMethodDelegate(
						resolvedOp,
						it,
						delegateFieldName,
						newname,
						newname
					) => [ copyAllAnnotationsFrom(resolvedOp) ]
				
				// and now the setter
				val origSetterName = origName.stripGetter
				val newSetterName = newname.stripGetter
				
				members += tOp.
					toSetterMethodDelegate(
						resolvedOp,
						"this",
						origSetterName,
						newSetterName
					) => [m | m.rebindTypeParameters(it)]
				// m2 is forwarded to delegate.m2()
				members += tOp.
					toSetterMethodDelegate(
						resolvedOp,
						delegateFieldName,
						newSetterName,
						newSetterName
					) => [m | m.rebindTypeParameters(it)]
			}
		}
	}

	private def handleRedirectOperation(TJRedirectOperation tOp, Iterable<IResolvedOperation> allDeclarations, JvmGenericType it, String traitFieldName) {
		val origName = tOp.member?.simpleName
		
		if (origName == null) {
			// member is not resolved
			return
		}
		
		val newname = if (!tOp.field) {
			tOp.member2?.simpleName
		} else {
			// make sure we take the jvmOp's name
			// since the member in the redirect operation is bound
			// to the getter in case of a field
			origName.renameGetterOrSetter(tOp.member2?.simpleName.stripGetter)
			// and we need to strip the getter prefix, since for redirect the
			// the 'to' part is actually a JvmOperation (i.e., a getter for fields)
		}
		
		// and we need to retrieve the corresponding resolved operation
		// i.e., the one where type arguments are already resolved
		val resolvedOp = allDeclarations.findFirst[newname == simpleName]
		
		if (resolvedOp != null) {
			// example T1[redirect m to m1]
			// m is forwarded to delegate.m1
			members += tOp.
				toMethodDelegate(
					resolvedOp,
					it,
					delegateFieldName,
					origName,
					newname
				) => [
						copyAllAnnotationsFrom(resolvedOp)
					]
			if (tOp.field) {
				// example T1[redirect field m to m2]
		
				// and now the setter
				val origSetterName = origName.stripGetter
				val newSetterName = newname.stripGetter
				
				members += tOp.
					toSetterMethodDelegate(
						resolvedOp,
						delegateFieldName,
						origSetterName,
						newSetterName
					) => [m | m.rebindTypeParameters(it)]
			}
		}
	}

   	def void inferTraitClass(TJTrait t, IJvmDeclaredTypeAcceptor acceptor,
   		XtraitjMaps maps
   	) {
   		val traitClass = t.toClass(t.traitClassName)
		
		maps.typesMap.put(t.traitClassName, traitClass)
		
		inferClassForTraitReferencesWithOperations(t, traitClass, acceptor, maps)
   		
		acceptor.accept(traitClass) [
			copyTypeParametersAndRebind(traitClass, t)
		
			// the interface is surely associated in the model inferrer
			// since the trait element is in the input file we're processing
			val traitInterfaceTypeRef = t.associatedInterface

			val transformedTraitInterfaceTypeRef = 
				traitInterfaceTypeRef.
						transformTypeParametersIntoTypeArguments(traitClass)
			
			superTypes += transformedTraitInterfaceTypeRef

   			documentation = t.documentation
   			
   			annotateAsTraitClass

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
			
   			for (field : t.fields) {
   				members += toGetterDelegate(field) => [
   					annotateAsRequiredField
   					rebindTypeParameters(traitClass)
   				]
   				members += field.toSetterDelegate => [
   					rebindTypeParameters(traitClass)
   				]
   			}
   			
   			for (aMethod : t.requiredMethods)
   				members += aMethod.toMethodDelegate(traitClass, delegateFieldName) => [
   					annotateAsRequiredMethod
   				]
   			
   			for (method : t.methods) {
   				if (method.isPrivate) {
   					members += method.toTraitMethod(traitClass, method.name) => [
	   					translateAnnotations(method.annotations)
	   				]
   				} else {
   					// first infer the method with the original body to make
   					// type parameters work correctly
   					
	   				// _m() { original m's body }
	   				val actualMethod = method.toTraitMethod(traitClass, method.name.underscoreName)
   					
   					// m() { _delegate.m(); }
   					val delegateMethod = method.toMethodDelegate(traitClass, delegateFieldName) => [
	   					annotateAsDefinedMethod
   						translateAnnotations(method.annotations)
	   				]
   					
	   				members += delegateMethod
	   				members += actualMethod
				}
   			}
   			
   			addDelegates(t.traitReferences, it, maps.traitInterfaceResolvedOperationsMap)
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

	def private addSuperTypesFromTraitReferences(TJDeclaration d, JvmGenericType it, XtraitjMaps maps) {
		for (tRef : d.traitReferences) {
			superTypes += tRef.traitReferenceToInterfaceJvmTypeReference(it, maps).cloneWithProxies
		}
	}

   	def private toGetterDelegate(JvmGenericType target, TJMember m) {
   		m.toGetter(m.name, m.type) => [
   			method |
   			method.body = [
   				append('''return «delegateFieldName».«method.simpleName»();''')
   			]
   		]
   	}

   	def private toSetterDelegate(TJMember m) {
   		m.toSetter(m.name, m.type) => [
   			method |
   			method.body = [append('''«delegateFieldName».«method.simpleName»(«m.name»);''')]
   		]
   	}

	/**
	 * This also rebinds type parameters since the inferred methods are based on signatures of
	 * resolved operations taken from interfaces and possible type parameter references would
	 * be resolved (scoped) to the original elements, while they must be solved using the
	 * current target (the JvmGenericType that will own these methods).
	 */
	def private toMethodDelegate(TJMethodDeclaration m, JvmGenericType containerTypeDecl, String delegateFieldName) {
		m.toMethod(m.name, m.type) [
			documentation = m.documentation

			copyTypeParameters(m.typeParameters)
			
			returnType = m.type.rebindTypeParameters(containerTypeDecl, it)

			for (p : m.params) {
				parameters += p.toParameter(p.name, p.parameterType.rebindTypeParameters(containerTypeDecl, it))
			}
			val args = m.params.map[name].join(", ")
			if (m.type?.simpleName != "void")
				body = [append('''return «delegateFieldName».«m.name»(«args»);''')]
			else
				body = [append('''«delegateFieldName».«m.name»(«args»);''')]
		]
	}

	/**
	 * This also rebinds type parameters since the inferred methods are based on signatures of
	 * resolved operations taken from interfaces and possible type parameter references would
	 * be resolved (scoped) to the original elements, while they must be solved using the
	 * current target (the JvmGenericType that will own these methods).
	 */
	def private toMethodDelegate(EObject source, IResolvedOperation op, JvmGenericType target, String delegateFieldName, String methodName, String methodToDelegate) {
		val o = op.declaration
		val m = o.originalSource ?: source
		m.toMethod(methodName, op.returnType) [
			documentation = o.documentation
			
			copyTypeParameters(o.typeParameters)

			returnType = returnType.rebindTypeParameters(target, it)
	
			val paramTypeIt = op.parametersTypes.iterator
			for (p : o.parameters) {
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
	}

	def private toSetterMethodDelegate(EObject source, IResolvedOperation op, String delegateFieldName, String methodName, String methodToDelegate) {
		source.toSetter(methodName, op.returnType) => [
			val origFieldName = methodToDelegate.stripGetter
			parameters.head.name = origFieldName
			body = [append('''«delegateFieldName».«methodToDelegate.toSetterName»(«origFieldName»);''')]
		]
	}

	def private toTraitMethod(TJMethod method, JvmGenericType containerTypeDecl, String name) {
		method.toMethod(name, method.type) [
			documentation = method.documentation
			
			copyTypeParameters(method.typeParameters)
			
			returnType = method.type.rebindTypeParameters(containerTypeDecl, it)
			
			for (p : method.params) {
				parameters += p.toParameter(p.name, p.parameterType.rebindTypeParameters(containerTypeDecl, it))
			}
			body = method.body
		]
	}

	def private traitReferenceToInterfaceJvmTypeReference(TJTraitReference traitRef, 
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		if (!traitRef.operations.empty) {
			return traitRef.buildTypeRefForTraitExpression(containingDeclarationInferredType, maps)
		} else {
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
		val containingDeclTypeParams = containingDeclarationInferredType.typeParameters
		// it is crucial to use as type arguments type references to the type
		// parameters of the containing inferred JvmGenericType
		// DON'T use references to the original type parameters of the
		// trait element in the AST! 
		val typeArguments = containingDeclTypeParams.map[typeRef]
		return mapped.typeRef(typeArguments)
	}

	/**
	 * This builds a type reference to a trait class inferred for this very program
	 * that represents a trait reference with operations.
	 */
	def private buildClassTypeRefForTraitExpression(TJTraitReference t, 
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		val mapped = maps.typesMap.get(t.traitExpressionClassName)
		val containingDeclTypeParams = containingDeclarationInferredType.typeParameters
		// it is crucial to use as type arguments type references to the type
		// parameters of the containing inferred JvmGenericType
		// DON'T use references to the original type parameters of the
		// trait element in the AST! 
		val typeArguments = containingDeclTypeParams.map[typeRef]
		return mapped.typeRef(typeArguments)
	}

	def buildTypeRef(TJTraitReference t, XtraitjMaps maps) {
		val typeRef = t.trait
		
		val typeKey = typeRef.traitInterfaceName
		buildTypeRefInternal(typeRef, typeKey, maps)
	}
	
	private def buildTypeRefInternal(JvmParameterizedTypeReference typeRef, String typeKey, XtraitjMaps maps) {
		val mapped = maps.typesMap.get(typeKey)
		val typeArguments = typeRef.arguments.map[cloneWithProxies]
		
		if (mapped != null) {
			if (mapped.typeParameters.size != typeArguments.size) {
				// we can't assume that the referred type exists
				// nor that the type arguments we pass are correct
				return typeRef(mapped)
			} else {
				return typeRef(mapped, typeArguments)
			}
		} else {
			if (typeKey != "void") {
				return typeRef(typeKey, typeArguments)
			} else {
				// we'll deal with void problems in the validator
				return typeRef(typeKey)
			}
		}
	}

	def private traitReferenceToClassJvmTypeReference(TJTraitReference traitRef, 
		JvmGenericType containingDeclarationInferredType, XtraitjMaps maps
	) {
		if (!traitRef.operations.empty) {
			return traitRef.buildClassTypeRefForTraitExpression(containingDeclarationInferredType, maps)
		} else {
			return traitRef.buildTraitClassTypeRef(maps)
		}
	}

	def buildTraitClassTypeRef(TJTraitReference t, XtraitjMaps maps) {
		val typeRef = t.trait
		buildTraitClassTypeRef(typeRef, maps)
	}
	
	private def buildTraitClassTypeRef(JvmParameterizedTypeReference typeRef, XtraitjMaps maps) {
		val typeKey = typeRef.traitClassName
		buildTypeRefInternal(typeRef, typeKey, maps)
	}

	def private toAbstractMethod(TJMethodDeclaration m, JvmGenericType containerTypeDecl) {
		m.toMethod(m.name, m.type) [
			documentation = m.documentation

			copyTypeParametersAndRebind(m)
			
			returnType = m.type.rebindTypeParameters(containerTypeDecl, it)

			for (p : m.params) {
				parameters += p.toParameter(p.name, p.parameterType.rebindTypeParameters(containerTypeDecl, it))
			}
			abstract = true
		]
	}

	def private toAbstractMethod(EObject source, IResolvedOperation m, String name) {
		val op = m.declaration
		source.toMethod(name, m.returnType) [
			documentation = op.documentation
			
			copyTypeParameters(op.typeParameters)
			
			val paramTypeIt = m.parametersTypes.iterator
			for (p : op.parameters) {
				parameters += source.toParameter(p.name, paramTypeIt.next)
			}
			abstract = true
		]
	}

	def private addDelegates(List<TJTraitReference> traitReferences, JvmGenericType it, XtraitjResolvedOperationsMap map) {
		for (tRef : traitReferences) {
			val resolvedOps = tRef.getXtraitjResolvedOperationsFromMap(map)
			
			// first delegates for implemented methods 
			for (op : resolvedOps.definedMethods) {
				if (!members.alreadyDefined(op.declaration)) {
   					val methodName = op.simpleName
   					// m() { _delegate.m(); }
   					members += tRef.toMethodDelegate(op, it,
	   						delegateFieldName, methodName, methodName
	   					) => [ 
		   					annotateAsDefinedMethod
		   				]
   					// _m() { delegate to trait defining the method }
   					members += tRef.toMethodDelegate(op, it,
   						tRef.traitFieldName, methodName.underscoreName,
   						methodName.underscoreName
   					)
				}
			}
		}

		for (tRef : traitReferences) {
			val resolvedOps = tRef.getXtraitjResolvedOperationsFromMap(map)
			
			for (op : resolvedOps.requiredFields) {
				val jvmOp = op.declaration
				if (!members.alreadyDefined(jvmOp)) {
   					// this is the getter
   					val name = jvmOp.simpleName
   					members += tRef.toMethodDelegate(op, it,
						delegateFieldName, name, name) => [
		   					annotateAsRequiredField
		   				]
	   				members += tRef.toSetterDelegateFromGetter(op, it)
   				}
			}
			
			// then delegates for required methods
			for (op : resolvedOps.requiredMethods) {
				val jvmOp = op.declaration
				if (!members.alreadyDefined(jvmOp) && !members.alreadyDefined(jvmOp)) {
					val name = jvmOp.simpleName
   					members += tRef.toMethodDelegate(op, it,
						delegateFieldName, name, name) => [
		   					annotateAsRequiredMethod
		   				]
				}
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

	def private toSetterDelegateFromGetter(EObject source, IResolvedOperation op, JvmGenericType target) {
   		val fieldName = op.simpleName.stripGetter
   		source.toSetter(fieldName, op.returnType.rebindTypeParameters(target, null)) => [
   			method |
   			method.body = [append('''«delegateFieldName».«method.simpleName»(«fieldName»);''')]
   		]
   	}

	def private toAbstractSetterDelegateFromGetter(EObject source, IResolvedOperation op) {
   		val fieldName = op.simpleName.stripGetter
   		source.toSetter(fieldName, op.returnType) => [
   			abstract = true
   		]
   	}

	def private toAbstractSetterDelegateFromGetter(EObject source, IResolvedOperation op, String newName) {
   		source.toSetter(newName, op.returnType) => [
   			abstract = true
   		]
   	}

	def private void annotateAsTrait(JvmAnnotationTarget target) {
		target.annotateAsXtraitjElement(XtraitjTraitInterface)
	}

	def private void annotateAsTraitClass(JvmAnnotationTarget target) {
		target.annotateAsXtraitjElement(XtraitjTraitClass)
	}

	def private void annotateAsRequiredField(JvmMember target) {
		target.annotateAsXtraitjElement(XtraitjRequiredField)
	}

	def private void annotateAsRequiredFieldSetter(JvmMember target) {
		target.annotateAsXtraitjElement(XtraitjRequiredFieldSetter)
	}

	def private void annotateAsRequiredMethod(JvmMember target) {
		target.annotateAsXtraitjElement(XtraitjRequiredMethod)
	}

	def private void annotateAsDefinedMethod(JvmMember target) {
		target.annotateAsXtraitjElement(XtraitjDefinedMethod)
	}

	def private void annotateAsXtraitjElement(JvmAnnotationTarget target, Class<?> annotationType) {
		// the target can be null in an incomplete program
		if (target != null) {
			target.annotations += annotationRef(annotationType)
		}
	}

	def private void annotateAsRenamedMethod(JvmMember target, String originalName) {
		// we need to keep track of all the methods renamed, that is, the
		// method renamed by this method and recursively possible methods renamed
		// by the renamed method (this will make method resolution work as expected).
		var annot = target.annotations.findFirst[renameAnnotation]
		if (annot == null) {
			annot = annotationRef(XtraitjRenamedMethod, originalName)
			target.annotations += annot
		} else {
			annot.getExplicitValues().filter(JvmStringAnnotationValue).head.
				values += originalName
		}
	}

	private def copyTypeParametersAndRebind(JvmTypeParameterDeclarator target, TJTypeParameterDeclarator t) {
		val originalTypeParameters = t.typeParameters
		target.copyTypeParameters(originalTypeParameters)
		
		val map = new HashMap<JvmTypeParameter, JvmTypeParameter>  
		var i = 0	
	   	for (typePar : target.typeParameters) {
	   		typePar.rebindConstraintsTypeParameters(originalTypeParameters.get(i), target, null, map)
	   		i = i + 1
	   	}
	}

	def private void copyTypeParameters(JvmTypeParameterDeclarator target, List<JvmTypeParameter> typeParameters) {
		for (typeParameter : typeParameters) {
			val clonedTypeParameter = typeParameter.cloneWithProxies();
			if (clonedTypeParameter != null) {
				target.typeParameters += clonedTypeParameter
				associator.associate(typeParameter, clonedTypeParameter);
			}
		}
		target.fixTypeParameters
	}

	def private void fixTypeParameters(JvmTypeParameterDeclarator target) {
		for (typeParameter : target.getTypeParameters()) {
			var upperBoundSeen = 
				typeParameter.constraints.exists[it instanceof JvmUpperBound]
			if (!upperBoundSeen) {
				val upperBound = typesFactory.createJvmUpperBound();
				upperBound.setTypeReference(typeRef(Object))
				typeParameter.getConstraints().add(upperBound);
			}
		}
	}

	def private void copyAnnotationsFrom(JvmOperation target, IResolvedOperation xop) {
		target.annotations += xop.declaration.annotations.
			filterOutXtraitjAnnotations.map[EcoreUtil2.cloneWithProxies(it)]
	}

	def private void copyAllAnnotationsFrom(JvmOperation target, IResolvedOperation xop) {
		target.annotations += xop.declaration.annotations.map[EcoreUtil2.cloneWithProxies(it)]
	}

	def private void copyAllAnnotationsButDefinedFrom(JvmOperation target, IResolvedOperation xop) {
		target.annotations += xop.declaration.annotations.
			filterOutXtraitjDefinedAnnotations.map[EcoreUtil2.cloneWithProxies(it)]
	}

	def private void translateAnnotations(JvmAnnotationTarget target, List<XAnnotation> annotations) {
		var annotationsToAdd = annotations.filterNull.filter[annotationType != null]
		
		for (a : annotationsToAdd) {
			val associatedElements = a.jvmElements
			if (!associatedElements.empty) {
				// transform it to List to avoid concurrent modification exception
				associatedElements.toList.forEach[assoc | associator.removeAllAssociation(assoc)]
			}
			target.addAnnotation(a)
		}
	}

	def private transformTypeParametersIntoTypeArguments(JvmParameterizedTypeReference typeRef, JvmGenericType traitClassInferredType) {
		val newRef = typeRef.cloneWithProxies 
		if (newRef instanceof JvmParameterizedTypeReference) {
			newRef.arguments.clear
		
			for (typePar : traitClassInferredType.typeParameters) {
				newRef.arguments += typeRef(typePar)
			}
		
		}
		
		newRef
	}
}
