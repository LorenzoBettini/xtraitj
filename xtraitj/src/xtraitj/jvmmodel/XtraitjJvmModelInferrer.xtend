package xtraitj.jvmmodel

import com.google.inject.Inject
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.xtraitj.TJAliasOperation
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJHideOperation
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJRedirectOperation
import xtraitj.xtraitj.TJRenameOperation
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitExpression
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.TraitJModelUtil.*

/**
 * <p>Infers a JVM model from the source model.</p> 
 *
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>     
 */
class XtraitjJvmModelInferrer extends AbstractModelInferrer {

	@Inject extension JvmTypesBuilder
	@Inject extension IQualifiedNameProvider
	@Inject extension TraitJJvmModelUtil

	/**
	 * The dispatch method {@code infer} is called for each instance of the
	 * given element's type that is contained in a resource.
	 * 
	 * @param element
	 *            the model to create one or more
	 *            {@link org.eclipse.xtext.common.types.JvmDeclaredType declared
	 *            types} from.
	 * @param acceptor
	 *            each created
	 *            {@link org.eclipse.xtext.common.types.JvmDeclaredType type}
	 *            without a container should be passed to the acceptor in order
	 *            get attached to the current resource. The acceptor's
	 *            {@link IJvmDeclaredTypeAcceptor#accept(org.eclipse.xtext.common.types.JvmDeclaredType)
	 *            accept(..)} method takes the constructed empty type for the
	 *            pre-indexing phase. This one is further initialized in the
	 *            indexing phase using the closure you pass to the returned
	 *            {@link org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor.IPostIndexingInitializing#initializeLater(org.eclipse.xtext.xbase.lib.Procedures.Procedure1)
	 *            initializeLater(..)}.
	 * @param isPreIndexingPhase
	 *            whether the method is called in a pre-indexing phase, i.e.
	 *            when the global index is not yet fully updated. You must not
	 *            rely on linking using the index if isPreIndexingPhase is
	 *            <code>true</code>.
	 */
   	def dispatch void infer(TJProgram p, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		val traits = p.traits
		for (t : traits)
			t.inferTraitInterface(acceptor)

		for (t : traits)
			t.inferTraitClass(acceptor)
		
		for (c : p.classes)
			c.inferClass(acceptor)
   	}
   	
   	def void inferClass(TJClass c, IJvmDeclaredTypeAcceptor acceptor) {
   		val inferredClass = c.toClass(c.fullyQualifiedName)
   		
   		inferredClass.copyTypeParameters(c.typeParameters)
   		
   		// it is crucial to infer interfaces for trait operation expressions
		// first, so that when we add methods to this class
		// we can see all the methods which are possibly provided
		// by the trait operation expressions (possibly after renaming)

		// infer interfaces first for trait operation expressions		
		for (it : c.traitOperationExpressions)
			inferTraitExpressionInterface(acceptor)

		// then we can infer the corresponding classes
		for (it : c.traitOperationExpressions)
			inferTraitExpressionClass(acceptor)
   		
   		acceptor.accept(inferredClass).initializeLater[
   			documentation = c.documentation
   			
   			for (i : c.interfaces) {
   				superTypes += i.cloneWithProxies
   			}
   			
   			for (field : c.fields) {
   				members += field.toField(field.name, field.type) [
   					if (field.init != null)
   						initializer = field.init
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
   			
   			for (traitExp : c.traitExpression.traitReferences) {
   				superTypes += traitExp.associatedInterface
   				members += traitExp.toTraitField
   				// do not delegate to a trait who requires that operation
   				// but to the one which actually implements it
   				for (traitMethod : traitExp.xtraitjJvmAllMethodOperations)
   					members += traitMethod.toMethodDelegate(traitExp.traitFieldName)
   			}
   		]
   	}

	def toTraitField(TJTraitReference e) {
		e.toField(e.traitFieldName, e.associatedClass) [
			initializer = [
				append('''new ''')
				append(e.associatedClass.type)
				append("(this)")
			]
		]
	}

   	def inferTraitInterface(TJTrait t, IJvmDeclaredTypeAcceptor acceptor) {
   		val traitInterface = t.toInterface(t.traitInterfaceName) [
   			copyTypeParameters(t.traitTypeParameters)
   			
   			// it is crucial to insert, at this stage, into the inferred interface all
   			// members which are specified in the trait, so that, later
   			// we also add the members we "inherit" from used traits 
			for (field : t.fields) {
				members += field.toGetterAbstract
				members += field.toSetterAbstract
			}
			
			for (method : t.methods) {
				if (!method.isPrivate)
					members += method.toAbstractMethod
			}
			
			for (method : t.requiredMethods)
				members += method.toAbstractMethod
		]

		// it is crucial to infer interfaces for trait operation expressions
		// first, so that when we add methods to the interface of this
		// trait, we can see all the methods which are possibly provided
		// by the trait operation expressions (possibly after renaming)

		// infer interfaces first for trait operation expressions		
		for (it : t.traitOperationExpressions)
			inferTraitExpressionInterface(acceptor)

		// then we can infer the corresponding classes
		for (it : t.traitOperationExpressions)
			inferTraitExpressionClass(acceptor)

		acceptor.accept(traitInterface).initializeLater [
			if (t.traitExpression != null)
				for (superInterface : (newArrayList => [collectSuperInterfaces(t.traitExpression)])) 
					superTypes += superInterface
			
			// methods which are defined in any of the used traits
			// must be explicitly inserted in the interface, even if inherited
			// (it is safe to do so, since they have the same signature)
			// this way, in this interface, the inserted Java methods are
			// associated to defined methods in the corresponding trait
			for (traitRef : t.traitReferences) {
				if (traitRef.arguments.empty)
					for (op: traitRef.xtraitjJvmAllMethodOperations) {
						members += op.toAbstractMethod
					}
				else {
					for (op: traitRef.xtraitjJvmAllMethodDeclarationOperations) {
						if (!members.alreadyDefined(op.op))
							members += op.toAbstractMethod
					} // in the presence of generics also inserts
					// required methods with type parameters instantiated
					
					// and also getters/setters with type parameters instantiated
					for (op: traitRef.xtraitjJvmAllFieldOperations) {
						if (!members.alreadyDefined(op.op))
							members += op.toAbstractMethod
					}
				}
			}
		]
				
		traitInterface
   	}

	def void inferTraitExpressionInterface(TJTraitReference t, IJvmDeclaredTypeAcceptor acceptor) {
		acceptor.accept(
			t.toInterface(t.traitExpressionInterfaceName) [
				copyTypeParameters(t.containingDeclaration.typeParameters)
			]
		).initializeLater[
			for (jvmOp : t.trait.jvmAllOperations) {
				val relatedOperations = t.operationsForJvmOp(jvmOp)
				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
				
				val xop = jvmOp.createXtraitjJvmOperation(t)
				
				if (relatedOperations.empty) {
					members += xop.toAbstractMethod(jvmOp.simpleName)
				} else {
					if (renameOperation != null) {
						members += xop.toAbstractMethod
							(jvmOp.simpleName.renameGetterOrSetter(renameOperation.newname))
					}
					// hidden methods are simply not inserted in this interface
					if (aliasOperation != null) {
						members += xop.toAbstractMethod(aliasOperation.newname)
						if (renameOperation == null && hideOperation == null && restrictOperation == null) {
							// we need to add also the original method
							members += xop.toAbstractMethod(aliasOperation.member.simpleName)
						}
					}
					// restricted methods are added and associated to the
					// operation itself
					if (restrictOperation != null) {
						members += 
							restrictOperation.toAbstractMethod(xop, jvmOp.simpleName)
					}
				}
			}
		]
	}

	def operationsForJvmOp(TJTraitReference t, JvmOperation jvmOp) {
		t.operations.filter[
			member?.simpleName == jvmOp.simpleName ||
			{
				val memberSourceField = member?.sourceField 
				val jvmOpSourceField = jvmOp.sourceField;
				(
					memberSourceField != null &&
					jvmOpSourceField != null &&
					memberSourceField == jvmOpSourceField
				)
			}
		]
	}

	def void inferTraitExpressionClass(TJTraitReference t, IJvmDeclaredTypeAcceptor acceptor) {
		val traitReferenceClass = t.toClass(t.traitExpressionClassName)
		
		traitReferenceClass.copyTypeParameters(t.containingDeclaration.typeParameters)
		
		acceptor.accept(traitReferenceClass).initializeLater[
			val traitRefAssociatedInterface = t.associatedInterface
			superTypes += traitRefAssociatedInterface
			val traitAssociatedInterface = t.associatedTraitInterface
			superTypes += traitAssociatedInterface
			
			val traitFieldName = t.traitFieldNameForOperations
			
			members += t.containingDeclaration.
				toField(delegateFieldName, traitRefAssociatedInterface)
			members += t.
				toField(traitFieldName, t.associatedTraitClass)
			
			members += t.toConstructor[
   				parameters += t.toParameter("delegate", traitRefAssociatedInterface)
				body = [
					it.append('''this.«delegateFieldName» = delegate;''')
					newLine.append('''«traitFieldName» = ''')
				   	append('''new ''')
					append(t.trait.associatedClass.type)
					append("(this);")	
	   			]
			]
			
			// operations of the referred trait in this trait operation
			for (jvmOp : t.trait.jvmAllOperations) {
				val relatedOperations = t.operationsForJvmOp(jvmOp)
				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
				val redirectOperation = relatedOperations.filter(typeof(TJRedirectOperation)).head
				
				val xop = jvmOp.createXtraitjJvmOperation(t)
				
				if (renameOperation == null && hideOperation == null && redirectOperation == null) {
					// if the method is not removed we must also add the
					// same forwarding for the original name
					members += xop.
							toMethodDelegate(delegateFieldName,
								jvmOp.simpleName,
								jvmOp.simpleName
							)
					// if it's restricted the original version will not
					// be called.
					if (!jvmOp.required && restrictOperation == null) {
						members += xop.
							toMethodDelegate(traitFieldName,
								jvmOp.simpleName.underscoreName,
								jvmOp.simpleName.underscoreName
							)						
					}
				}
				if (renameOperation != null) {
					// example T1[rename m -> m2]
					
					if (jvmOp.isRequired) {
						// make sure we take the jvmOp's name
						// since the member in the rename operation is bound
						// to the getter in case of a field
						val newname = 
							jvmOp.simpleName.renameGetterOrSetter(renameOperation.newname)
						// m is forwarded to this.m2()
						members += xop.
							toMethodDelegate(
								"this",
								jvmOp.simpleName,
								newname
							)
						// m2 is forwarded to delegate.m2()
						members += xop.
							toMethodDelegate(
								delegateFieldName,
								newname,
								newname
							)
					} else {
						// m is forwarded to this.m2
						members += xop.
						toMethodDelegate(
							"this",
							renameOperation.member.simpleName,
							renameOperation.newname
						)
						// m2 is forwarded to delegate.m2
						members += xop.
							toMethodDelegate(
								delegateFieldName,
								renameOperation.newname,
								renameOperation.newname
							)
						// _m2 is forwarded to T1._m
						members += xop.
							toMethodDelegate(
								traitFieldName,
								renameOperation.newname.underscoreName,
								renameOperation.member.simpleName.underscoreName
							)
					}
				}
				if (hideOperation != null) {
					// example T1[hide m]
					// m cannot be required
					// m is forwarded to T1._m
					// _m2 is forwarded to T1._m
					members += xop.
						toMethodDelegate(
							traitFieldName,
							hideOperation.member.simpleName,
							hideOperation.member.simpleName.underscoreName
						)
				}
				if (aliasOperation != null) {
					// example T1[alias m as oldm]
					// m cannot be required
					// oldm is forwarded to delegate.oldm
					members += xop.
						toMethodDelegate(
							delegateFieldName,
							aliasOperation.newname,
							aliasOperation.newname
						)
					// _oldm is forwarded to T1._m
					members += xop.
						toMethodDelegate(
							traitFieldName,
							aliasOperation.newname.underscoreName,
							aliasOperation.member.simpleName.underscoreName
						)
				}
				if (redirectOperation != null && redirectOperation.member2 != null) {
					// example T1[redirect m to m1]
					// m is forwarded to delegate.m1
					if (jvmOp.isRequired) {
						// make sure we take the jvmOp's name
						// since the members in the redirect operation are bound
						// to the getter in case of a field
						members += xop.
							toMethodDelegate(
								delegateFieldName,
								jvmOp.simpleName,
								jvmOp.simpleName.renameGetterOrSetter(
									redirectOperation.member2.simpleName.stripGetter
								)
							)
					} else {
						members += xop.
							toMethodDelegate(
								delegateFieldName,
								redirectOperation.member.simpleName,
								redirectOperation.member2.simpleName
							)
					}
				}
			}
		]
	}

	def void collectSuperInterfaces(List<JvmTypeReference> typeRefs, TJTraitExpression e) {
		for (it : e.traitReferences) {
			val	i = associatedInterface
			if (i != null)
				typeRefs += i
		}
	}

   	def void inferTraitClass(TJTrait t, IJvmDeclaredTypeAcceptor acceptor) {
   		val traitClass = t.toClass(t.traitClassName)
		
		// immediately copy type parameters, otherwise, when processing possible
		// trait operations involving this trait the corresponding inferred class
		// does not expose type parameters yet
		traitClass.copyTypeParameters(t.traitTypeParameters)
   		
		acceptor.accept(traitClass).initializeLater[

   			documentation = t.documentation
   			val traitInterfaceTypeRef = t.associatedInterface
			
			val transformedTraitInterfaceTypeRef = traitInterfaceTypeRef.
							transformTypeParametersIntoTypeArguments(t)
			superTypes += transformedTraitInterfaceTypeRef
   			
   			members += t.toField(delegateFieldName, transformedTraitInterfaceTypeRef)
   			
   			for (traitExp : t.traitReferences)
   				members += traitExp.toField
   					(traitExp.traitFieldName, traitExp.associatedClass)
   			
   			members += t.toConstructor[
   				parameters += t.toParameter("delegate", transformedTraitInterfaceTypeRef)
				body = [
					it.append('''this.«delegateFieldName» = delegate;''')
					for (traitExp : t.traitExpression.traitReferences) {
		   				newLine.append('''«traitExp.traitFieldName» = ''')
		   				append('''new ''')
						append(traitExp.associatedClass.type)
						append("(delegate);")
					}
	   			]
			]
   			
   			for (field : t.fields) {
   				members += toGetterDelegate(field)
   				members += field.toSetterDelegate
   			}
   			
   			for (aMethod : t.requiredMethods)
   				members += aMethod.toMethodDelegate(delegateFieldName)
   			
   			for (method : t.methods) {
   				if (method.isPrivate) {
   					members += method.toTraitMethod(method.name)
   				} else {
   					// first infer the method with the original body to make
   					// type parameters work correctly
   					
	   				// _m() { original m's body }
	   				val actualMethod = method.toTraitMethod(method.name.underscoreName)
   					
   					// m() { _delegate.m(); }
   					val delegateMethod = method.toMethodDelegate(delegateFieldName)
   					
	   				members += delegateMethod
	   				members += actualMethod
				}
   			}
   			
   			for (traitRef : t.traitReferences) {
   				// first delegates for implemented methods 
   				for (traitMethod : traitRef.xtraitjJvmAllMethodOperations) {
   					val methodName = traitMethod.op.simpleName
   					// m() { _delegate.m(); }
   					members += traitMethod.toMethodDelegate(
   						delegateFieldName, methodName, methodName
   					)
   					// _m() { delegate to trait defining the method }
   					members += traitMethod.toMethodDelegate(
   						traitRef.traitFieldName, methodName.underscoreName,
   						methodName.underscoreName
   					)
   				}
   			}
   			
   			for (traitRef : t.traitReferences) {
   				// then delegates for required methods
   				for (op : traitRef.xtraitjJvmAllRequiredOperations)
   					if (!members.alreadyDefined(op.op)) {
   						members += op.toMethodDelegate(
   							delegateFieldName,
   							op.op.simpleName, op.op.simpleName)
   					}
   			}
   		]
   	}

	def private transformTypeParametersIntoTypeArguments(JvmParameterizedTypeReference typeRef, EObject ctx) {
		val newRef = typeRef.cloneWithProxies 
		if (newRef instanceof JvmParameterizedTypeReference) {
			newRef.arguments.clear
		
			for (typePar : typeRef.arguments) {
//				val type = typesFactory.createJvmGenericType
//				type.setSimpleName(typePar.simpleName)
				newRef.arguments += newTypeRef(typePar.type)
			}
		
		}
		
		newRef
	}
   	
   	def toGetterAbstract(TJMember m) {
   		m.toGetter(m.name, m.type) => [
   			abstract = true
   		]
   	}

   	def toSetterAbstract(TJMember m) {
   		m.toSetter(m.name, m.type) => [
   			abstract = true
   		]
   	}

   	def toGetterDelegate(JvmGenericType type, TJMember m) {
   		m.toGetter(m.name, m.type.rebindTypeParameters(type)) => [
   			method |
   			method.body = [
   				append('''return «delegateFieldName».«method.simpleName»();''')
   			]
   		]
   	}

	/**
	 * It is crucial to rebind the type parameter reference to the
	 * class inferred for the trait, otherwise the type parameter
	 * will point to the interface inferred for the trait and we
	 * get IllegalArgumentException during the typing (the reference owner
	 * is different)
	 */
	def protected rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator target) {
		val reboundTypeRef = typeRef.cloneWithProxies
		if (reboundTypeRef instanceof JvmParameterizedTypeReference && reboundTypeRef.type instanceof JvmTypeParameter) {
			val rebound = reboundTypeRef as JvmParameterizedTypeReference
			val typePar = target.typeParameters.findFirst[name == rebound.type.simpleName]
			rebound.type = typePar
			return rebound
		} else
			return typeRef
	}

   	def toSetterDelegate(TJMember m) {
   		m.toSetter(m.name, m.type) => [
   			method |
   			method.body = [append('''«delegateFieldName».«method.simpleName»(«m.name»);''')]
   		]
   	}

	def toMethodDelegate(XtraitjJvmOperation op, String delegateFieldName) {
		op.toMethodDelegate(delegateFieldName, op.op.simpleName, "_"+op.op.simpleName)
	}

	def toMethodDelegate(XtraitjJvmOperation op, String delegateFieldName, String methodName, String methodToDelegate) {
		val o = op.op
		val m = o.originalSource ?: o
		if (!o.typeParameters.empty)
			m.toMethod(methodName, op.returnType) [
				documentation = m.documentation
				
				if (m instanceof TJMethodDeclaration) {
					copyTypeParameters(o.typeParameters)
				}
	
				returnType = returnType.rebindTypeParameters(it)
	
				val paramTypeIt = op.parametersTypes.iterator
				for (p : o.parameters) {
					parameters += p.toParameter(p.name, paramTypeIt.next.rebindTypeParameters(it))
				}
				val args = o.parameters.map[name].join(", ")
				if (op.returnType?.simpleName != "void")
					body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
				else
					body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
			]
		else // if there's no type params we can make things simpler
			m.toMethod(methodName, op.returnType) [
				documentation = m.documentation
				
				val paramTypeIt = op.parametersTypes.iterator
				for (p : o.parameters) {
					parameters += p.toParameter(p.name, paramTypeIt.next)
				}
				val args = o.parameters.map[name].join(", ")
				if (op.returnType?.simpleName != "void")
					body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
				else
					body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
			] // and we can navigate to the original method
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

	def toAbstractMethod(TJMethodDeclaration m) {
		m.toMethod(m.name, m.type) [
			documentation = m.documentation

			copyTypeParameters(m.typeParameters)

			for (p : m.params) {
				parameters += p.toParameter(p.name, p.parameterType)
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

   	def traitInterfaceName(TJTrait t) {
   		val n = t.fullyQualifiedName
   		n.skipLast(1).append("traits").
   			append(n.lastSegment).toString// + "Interface"
   	}

   	def traitExpressionInterfaceName(TJTraitReference t) {
   		val n = t.containingDeclaration.fullyQualifiedName
   		n.skipLast(1).append("traits").
   			append(t.adapterName).toString// + "Interface"
   	}

   	def traitExpressionClassName(TJTraitReference t) {
   		val n = t.containingDeclaration.fullyQualifiedName
   		n.skipLast(1).append("traits").append("impl").
   			append(t.adapterName).toString + "Impl"
   	}

	def adapterName(TJTraitReference t) {
		t.syntheticName + "_Adapter"
	}

	def syntheticName(TJTraitReference t) {
		t.containingDeclaration.name + "_" +
		t.trait.name + "_" +
		t.containingDeclaration.traitOperationExpressions.indexOf(t)
	}

	def delegateFieldName() {
		"_delegate"
	}

	def traitFieldName(TJTraitReference e) {
		if (e.operations.empty)
			return e.trait?.traitFieldName
		return "_" + e.syntheticName
	}

	def traitFieldNameForOperations(TJTraitReference e) {
		return e.trait?.traitFieldName + "_" +
				e.containingDeclaration.traitReferences.indexOf(e)
	}

	def traitFieldName(TJTrait t) {
		"_" + t.name
	}

	def protected void copyTypeParameters(JvmTypeParameterDeclarator target, List<JvmTypeParameter> typeParameters) {
		for (typeParameter : typeParameters) {
			val clonedTypeParameter = typeParameter.cloneWithProxies();
			if (clonedTypeParameter != null) {
				target.typeParameters += clonedTypeParameter
			}
		}
	}

}

