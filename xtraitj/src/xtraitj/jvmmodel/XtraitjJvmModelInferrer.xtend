package xtraitj.jvmmodel

import com.google.inject.Inject
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.xtraitj.TJAliasOperation
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJHideOperation
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJRenameOperation
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitExpression
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.TraitJModelUtil.*
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJRedirectOperation

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
		p.elements.filter(typeof(TJTrait)).forEach[
			inferTraitInterface(acceptor)
		]

		p.elements.filter(typeof(TJTrait)).forEach[
			inferTraitClass(acceptor)
		]
		
		p.elements.filter(typeof(TJClass)).forEach[
			inferClass(acceptor)
		]
   	}
   	
   	def void inferClass(TJClass c, IJvmDeclaredTypeAcceptor acceptor) {
   		val inferredClass = c.toClass(c.fullyQualifiedName)
   		
   		// it is crucial to infer interfaces for trait operation expressions
		// first, so that when we add methods to this class
		// we can see all the methods which are possibly provided
		// by the trait operation expressions (possibly after renaming)

		// infer interfaces first for trait operation expressions		
		c.traitOperationExpressions.forEach[
			inferTraitExpressionInterface(acceptor)
		]

		// then we can infer the corresponding classes
		c.traitOperationExpressions.forEach[
			inferTraitExpressionClass(acceptor)
		]
   		
   		acceptor.accept(inferredClass).initializeLater[
   			documentation = c.documentation
   			c.fields.forEach[
   				field |
   				members += field.toField(field.name, field.type) [
   					if (field.init != null)
   						initializer = field.init
   				]
				members += field.toGetter(field.name, field.type)
				members += field.toSetter(field.name, field.type)
   			]
   			
   			for (cons : c.constructors) {
   				members += cons.toConstructor[
   					for (p : cons.params) {
   						parameters += p.toParameter(p.name, p.parameterType)
   					}
   					body = cons.body
   				]
   			}
   			
   			c.traitExpression.traitReferences.forEach[
   				traitExp | 
   				superTypes += traitExp.associatedInterface
   				members += traitExp.toTraitField
   				// do not delegate to a trait who requires that operation
   				// but to the one which actually implements it
   				traitExp.jvmAllMethodOperations.forEach [
   					traitMethod |
   					members += traitMethod.toMethodDelegate(traitExp.traitFieldName)
   				]
   			]
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

	def toTraitFieldDeclaration(TJTraitReference e) {
		e.toField(e.traitFieldName, e.associatedInterface)
	}
   	
   	def inferTraitInterface(TJTrait t, IJvmDeclaredTypeAcceptor acceptor) {
   		val traitInterface = t.toInterface(t.traitInterfaceName) [
   			// it is crucial to insert, at this stage, into the inferred interface all
   			// members which are specified in the trait, so that, later
   			// we also add the members we "inherit" from used traits 
			t.fields.forEach[
				field |
				members += field.toGetterAbstract
				members += field.toSetterAbstract
			]
			t.methods.forEach[
				method |
				if (!method.isPrivate)
					members += method.toAbstractMethod
			]
			t.requiredMethods.forEach[
				method |
				members += method.toAbstractMethod
			]
		]

		// it is crucial to infer interfaces for trait operation expressions
		// first, so that when we add methods to the interface of this
		// trait, we can see all the methods which are possibly provided
		// by the trait operation expressions (possibly after renaming)

		// infer interfaces first for trait operation expressions		
		t.traitOperationExpressions.forEach[
			inferTraitExpressionInterface(acceptor)
		]

		// then we can infer the corresponding classes
		t.traitOperationExpressions.forEach[
			inferTraitExpressionClass(acceptor)
		]

		acceptor.accept(traitInterface).initializeLater [
			if (t.traitExpression != null)
				(newArrayList => [collectSuperInterfaces(t.traitExpression)]).forEach [ 
					superInterface |
					superTypes += superInterface
				]
			
			// methods which are defined in any of the used traits
			// must be explicitly inserted in the interface, even if inherited
			// (it is safe to do so, since they have the same signature)
			// this way, in this interface, the inserted Java methods are
			// associated to defined methods in the corresponding trait
			t.traitReferences.forEach[
				traitExp |
				traitExp.jvmAllMethodOperations.forEach[
					op |
					members += op.toAbstractMethod
				]
			]
		]
				
		traitInterface
   	}

	def void inferTraitExpressionInterface(TJTraitReference t, IJvmDeclaredTypeAcceptor acceptor) {
		acceptor.accept(
			t.toInterface(t.traitExpressionInterfaceName) []
		).initializeLater[
			t.trait.jvmAllOperations.forEach [
				jvmOp |
				val relatedOperations = t.operationsForJvmOp(jvmOp)
				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
				
				if (relatedOperations.empty) {
					members += jvmOp.toAbstractMethod(jvmOp.simpleName)
				} else {
					if (renameOperation != null) {
						members += jvmOp.toAbstractMethod
							(jvmOp.simpleName.renameGetterOrSetter(renameOperation.newname))
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
							restrictOperation.toAbstractMethod(jvmOp, jvmOp.simpleName)
					}
				}
			]
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
		acceptor.accept(
			t.toClass(t.traitExpressionClassName)
		).initializeLater[
			superTypes += t.associatedInterface
			superTypes += t.trait.associatedInterface
			
			val traitFieldName = t.traitFieldNameForOperations
			
			members += t.containingDeclaration.
				toField(delegateFieldName, t.associatedInterface)
			members += t.
				toField(traitFieldName, t.trait.associatedClass)
			
			members += t.toConstructor[
   				parameters += t.toParameter("delegate", t.associatedInterface)
				body = [
					it.append('''this.«delegateFieldName» = delegate;''')
					newLine.append('''«traitFieldName» = ''')
				   	append('''new ''')
					append(t.trait.associatedClass.type)
					append("(this);")	
	   			]
			]
			
			// operations of the referred trait in this trait operation
			t.trait.jvmAllOperations.forEach [
				jvmOp |
				
				val relatedOperations = t.operationsForJvmOp(jvmOp)
				val renameOperation = relatedOperations.filter(typeof(TJRenameOperation)).head
				val hideOperation = relatedOperations.filter(typeof(TJHideOperation)).head
				val aliasOperation = relatedOperations.filter(typeof(TJAliasOperation)).head
				val restrictOperation = relatedOperations.filter(typeof(TJRestrictOperation)).head
				val redirectOperation = relatedOperations.filter(typeof(TJRedirectOperation)).head
				
				if (renameOperation == null && hideOperation == null && redirectOperation == null) {
					// if the method is not removed we must also add the
					// same forwarding for the original name
					members += jvmOp.
							toMethodDelegate(delegateFieldName,
								jvmOp.simpleName,
								jvmOp.simpleName
							)
					// if it's restricted the original version will not
					// be called.
					if (!jvmOp.required && restrictOperation == null) {
						members += jvmOp.
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
						members += jvmOp.
							toMethodDelegate(
								"this",
								jvmOp.simpleName,
								newname
							)
						// m2 is forwarded to delegate.m2()
						members += jvmOp.
							toMethodDelegate(
								delegateFieldName,
								newname,
								newname
							)
					} else {
						// m is forwared to this.m2
						members += jvmOp.
						toMethodDelegate(
							"this",
							renameOperation.member.simpleName,
							renameOperation.newname
						)
						// m2 is forwarded to delegate.m2
						members += jvmOp.
							toMethodDelegate(
								delegateFieldName,
								renameOperation.newname,
								renameOperation.newname
							)
						// _m2 is forwarded to T1._m
						members += jvmOp.
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
					members += jvmOp.
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
					members += jvmOp.
						toMethodDelegate(
							delegateFieldName,
							aliasOperation.newname,
							aliasOperation.newname
						)
					// _oldm is forwarded to T1._m
					members += jvmOp.
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
						members += jvmOp.
							toMethodDelegate(
								delegateFieldName,
								jvmOp.simpleName,
								jvmOp.simpleName.renameGetterOrSetter(
									redirectOperation.member2.simpleName.stripGetter
								)
							)
					} else {
						members += jvmOp.
							toMethodDelegate(
								delegateFieldName,
								redirectOperation.member.simpleName,
								redirectOperation.member2.simpleName
							)
					}
				}
			]
		]
	}

	def void collectSuperInterfaces(List<JvmTypeReference> typeRefs, TJTraitExpression e) {
		e.traitReferences.forEach[
			val i = associatedInterface
			if (i != null)
				typeRefs += i
		]
	}

   	def void inferTraitClass(TJTrait t, IJvmDeclaredTypeAcceptor acceptor) {
   		acceptor.accept(
   			t.toClass(t.traitClassName)
   		).initializeLater[
   			documentation = t.documentation
   			val traitInterfaceTypeRef = t.associatedInterface
			
			superTypes += traitInterfaceTypeRef
   			
   			members += t.toField(delegateFieldName, traitInterfaceTypeRef)
   			
   			t.traitReferences.forEach[
   				traitExp | 
   				members += traitExp.toField
   					(traitExp.traitFieldName, traitExp.associatedClass)
   			]
   			
   			members += t.toConstructor[
   				parameters += t.toParameter("delegate", traitInterfaceTypeRef)
				body = [
					it.append('''this.«delegateFieldName» = delegate;''')
					t.traitExpression.traitReferences.forEach[
		   				traitExp |
		   				newLine.append('''«traitExp.traitFieldName» = ''')
		   				append('''new ''')
						append(traitExp.associatedClass.type)
						append("(delegate);")
					]
	   			]
			]
   			
   			t.fields.forEach[
   				field |
   				members += field.toGetterDelegate
   				members += field.toSetterDelegate
   			]
   			
   			t.requiredMethods.forEach [
   				aMethod |
   				members += aMethod.toMethodDelegate(delegateFieldName)
   			]
   			
   			t.methods.forEach [
   				method |
   				if (method.isPrivate) {
   					members += method.toTraitMethod(method.name)
   				} else {
   					// m() { _delegate.m(); }
	   				members += method.toMethodDelegate(delegateFieldName)
	   				// _m() { original m's body }
	   				members += method.toTraitMethod(method.name.underscoreName)
				}
   			]
   			
   			t.traitReferences.forEach[
   				traitExp |
   				// first delegates for implemented methods 
   				traitExp.jvmAllMethodOperations.forEach [
   					traitMethod |
   					// m() { _delegate.m(); }
   					members += traitMethod.toMethodDelegate(
   						delegateFieldName, traitMethod.simpleName, traitMethod.simpleName 
   					)
   					// _m() { delegate to trait defining the method }
   					members += traitMethod.toMethodDelegate(
   						traitExp.traitFieldName, traitMethod.simpleName.underscoreName,
   						traitMethod.simpleName.underscoreName
   					)
   				]
   			]
   			
   			t.traitReferences.forEach[
   				traitExp |
   				// then delegates for required methods
   				traitExp.jvmAllOperations.filter[required].forEach [
   					op |
   					if (!members.alreadyDefined(op)) {
   						if (op.sourceField != null)
   							members += op.toMethodDelegate(
   								delegateFieldName,
   								op.simpleName, op.simpleName
   							)
   						else
   							members += op.toMethodDelegate(
   								delegateFieldName,
   								op.simpleName, op.simpleName
   							)
   					}
   				]
   			]
   		]
   	}
   	
   	def private underscoreName(String name) {
   		"_" + name
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

   	def toGetterDelegate(TJMember m) {
   		m.toGetterDelegate(delegateFieldName)
   	}

   	def toSetterDelegate(TJMember m) {
   		m.toSetterDelegate(delegateFieldName)
   	}

   	def toGetterDelegate(TJMember m, String delegateFieldName) {
   		m.toGetter(m.name, m.type) => [
   			method |
   			method.body = [append('''return «delegateFieldName».«method.simpleName»();''')]
   		]
   	}

   	def toSetterDelegate(TJMember m, String delegateFieldName) {
   		m.toSetter(m.name, m.type) => [
   			method |
   			method.body = [append('''«delegateFieldName».«method.simpleName»(«m.name»);''')]
   		]
   	}

	def toMethodDelegate(JvmOperation op, String delegateFieldName) {
		val m = op.originalSource ?: op
		m.toMethod(op.simpleName, op.returnType) [
			documentation = m.documentation
			for (p : op.parameters) {
				parameters += p.toParameter(p.name, p.parameterType)
			}
			val args = op.parameters.map[name].join(", ")
			if (op.returnType?.simpleName != "void")
				body = [append('''return «delegateFieldName»._«op.simpleName»(«args»);''')]
			else
				body = [append('''«delegateFieldName»._«op.simpleName»(«args»);''')]
		]
	}

	def toMethodDelegate(JvmOperation op, String delegateFieldName, String methodName, String methodToDelegate) {
		val m = op.originalSource ?: op
		m.toMethod(methodName, op.returnType) [
			documentation = m.documentation
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

	def toMethodDelegate(TJMethodDeclaration m, String delegateFieldName) {
		m.toMethod(m.name, m.type) [
			documentation = m.documentation
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
			for (p : m.params) {
				parameters += p.toParameter(p.name, p.parameterType)
			}
			abstract = true
		]
	}

	def toAbstractMethod(JvmOperation m) {
		m.toAbstractMethod(m.simpleName)
	}

	def toAbstractMethod(JvmOperation m, String name) {
		m.originalSource.toAbstractMethod(m, name)
	}

	def toAbstractMethod(EObject source, JvmOperation m, String name) {
		source.toMethod(name, m.returnType) [
			documentation = m.documentation
			for (p : m.parameters) {
				parameters += p.toParameter(p.name, p.parameterType)
			}
			abstract = true
		]
	}

	def toTraitMethod(TJMethod method, String name) {
		method.toMethod(name, method.type) [
			documentation = method.documentation
			for (p : method.params) {
				parameters += p.toParameter(p.name, p.parameterType)
			}
			body = method.body
		]
	}

	def traitInterfaceName(TJTraitReference e) {
		e.trait?.traitInterfaceName
	}

	def traitClassName(TJTraitReference e) {
		e.trait?.traitClassName
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

   	def traitClassName(TJTrait t) {
   		val n = t.fullyQualifiedName
   		n.skipLast(1).append("traits").append("impl").
   			append(n.lastSegment).toString + "Impl"
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

}

