package xtraitj.jvmmodel

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.typesystem.^override.OverrideHelper
import java.util.List
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import xtraitj.util.XtraitjAnnotatedElementHelper
import xtraitj.typing.XtraitjTypingUtil
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.common.types.JvmOperation
import com.google.inject.Singleton

@Singleton
class XtraitjJvmModelHelper {
	@Inject extension OverrideHelper
	@Inject extension XtraitjAnnotatedElementHelper
	@Inject extension XtraitjTypingUtil
	
	val static objectClassName = Object.simpleName
	
	/**
	 * Excludes methods declared in java.lang.Object.
	 * The operations will have type parameters instantiated
	 */
	def getOperations(JvmTypeReference typeRef) {
		typeRef.getOperations(typeRef)
	}

	/**
	 * Excludes methods declared in java.lang.Object.
	 * The operations will have type parameters instantiated
	 */
	def getOperations(JvmTypeReference typeRef, EObject context) {
		typeRef.toLightweightTypeReference(context).resolvedOperations.allOperations.filter[
			declaration.declaringType.notJavaLangObject
		]
	}

	/**
	 * Resolves the given operation in the context of a type reference, for example
	 * 
	 * <pre>
	 * trait T1&lt;T&gt; {
	 *   T m() ...
	 * }
	 * trait T2 uses T1&lt;String&gt;[rename m as n]
	 * </pre>
	 * 
	 * Then m must be resolved as String m using T1&lt;String&gt; as the type context
	 */
	def getResolvedOperation(JvmTypeReference typeRef, EObject context, JvmOperation op) {
		typeRef.toLightweightTypeReference(context).resolvedOperations.getResolvedOperation(op)
	}

	def isNotJavaLangObject(JvmType type) {
		type.simpleName != objectClassName
	}

	def getXtraitjResolvedOperations(JvmTypeReference typeRef) {
		typeRef.getXtraitjResolvedOperations(typeRef)
	}

	def getXtraitjResolvedOperations(JvmTypeReference typeRef, EObject context) {
		val List<IResolvedOperation> requiredFields = newArrayList
		val List<IResolvedOperation> requiredMethods = newArrayList
		val List<IResolvedOperation> definedMethods = newArrayList
		
		for (o : typeRef.getOperations(context)) {
			val declaration = o.declaration
			if (declaration.annotatedRequiredField)
				requiredFields += o
			else if (declaration.annotatedRequiredMethod)
				requiredMethods += o
			else if (declaration.annotatedDefinedMethod)
				definedMethods += o
		}
		
		new XtraitjResolvedOperations(requiredFields, requiredMethods, definedMethods)
	}
}
