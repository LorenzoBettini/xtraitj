package xtraitj.jvmmodel

import com.google.inject.Inject
import com.google.inject.Singleton
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import org.eclipse.xtext.xbase.typesystem.^override.OverrideHelper
import org.eclipse.xtext.xbase.typesystem.^override.ResolvedFeatures
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.types.XtraitjTypeParameterHelper
import xtraitj.typing.XtraitjTypingUtil
import xtraitj.util.XtraitjAnnotatedElementHelper
import xtraitj.xtraitj.TJTraitOperation
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.XtraitjModelUtil.*

@Singleton
class XtraitjJvmModelHelper {
	@Inject extension OverrideHelper overrideHelper
	@Inject extension XtraitjAnnotatedElementHelper
	@Inject extension XtraitjTypingUtil
	@Inject extension XtraitjGeneratorExtensions
	@Inject private XtraitjTypeParameterHelper typeParameterHelper
	@Inject private TypeReferences references;

	def getResolvedOperations(JvmDeclaredType type) {
		overrideHelper.getResolvedFeatures(type)
	}
	
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
	def getOperations(JvmDeclaredType type) {
		type.resolvedOperations.operationsExcludingJavaObject
	}

	/**
	 * Excludes methods declared in java.lang.Object.
	 * The operations will have type parameters instantiated
	 */
	def getOperations(JvmTypeReference typeRef, EObject context) {
		val resolvedOps = typeRef.toLightweightTypeReference(context).resolvedFeatures
		getOperationsExcludingJavaObject(resolvedOps)
	}
	
	private def getOperationsExcludingJavaObject(ResolvedFeatures resolvedOps) {
		resolvedOps.allOperations.filter[
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
		typeRef.toLightweightTypeReference(context).resolvedFeatures.getResolvedOperation(op)
	}

	def getXtraitjResolvedOperations(TJTraitOperation op) {
		op.containingTraitOperationExpression.trait.xtraitjResolvedOperations
	}

	def getXtraitjResolvedOperations(JvmTypeReference typeRef) {
		typeRef.getXtraitjResolvedOperations(typeRef)
	}

	def getXtraitjResolvedOperations(JvmTypeReference typeRef, EObject context) {
		val resolvedOps = typeRef.getOperations(context)
		getXtraitjResolvedOperations(resolvedOps)
	}

	/**
	 * The resolution of operations takes into consideration possible alteration
	 * operations.  The inferredContainingType is the JvmGenericType inferred for the
	 * TJDeclration containing the trait reference
	 */
	def getTraitReferenceXtraitjResolvedOperations(TJTraitReference traitRef, JvmGenericType inferredContainingType) {
		var typeRef = traitRef.trait
		if (traitRef.operations.empty) {
			typeRef.getXtraitjResolvedOperations(traitRef)
		} else {
			references.getTypeForName(traitRef.traitExpressionInterfaceName, traitRef,
				inferredContainingType.typeParameters.map[references.createTypeRef(it)])
				.getXtraitjResolvedOperations(traitRef)
		}
	}

	/**
	 * Collects the ones from used traits and implemented interfaces
	 */
	def getXtraitjResolvedOperationsFromSuperTypes(JvmDeclaredType declaredType, EObject context) {
		val resolvedOps = declaredType.superTypes.
			map[getOperations(context)].flatten
		getXtraitjResolvedOperations(resolvedOps)
	}

	/**
	 * Excludes the ones declared in the type passed as parameters
	 */
	def getXtraitjResolvedOperationsNotDeclared(JvmGenericType type) {
		val resolvedOps = type.getOperations.filter[declaration.declaringType != type]
		getXtraitjResolvedOperations(resolvedOps)
	}

	private def getXtraitjResolvedOperations(Iterable<IResolvedOperation> resolvedOps) {
		val List<IResolvedOperation> requiredFields = newArrayList
		val List<IResolvedOperation> requiredMethods = newArrayList
		val List<IResolvedOperation> definedMethods = newArrayList
		
		for (o : resolvedOps) {
			val declaration = o.declaration
			if (declaration.annotatedRequiredField)
				requiredFields += o
			else if (declaration.annotatedRequiredMethod)
				requiredMethods += o
			else if (declaration.annotatedDefinedMethod)
				definedMethods += o
		}
		
		new XtraitjResolvedOperations(requiredFields, requiredMethods, definedMethods, typeParameterHelper)
	}

	/**
	 * This does not filter requirements and declarations; it should be used to collect
	 * and resolve operations from type references that refer to standard Java interfaces.
	 */
	def getXtraitjJvmOperationsFromJavaInterfaces(Iterable<JvmParameterizedTypeReference> typeReferences, EObject context) {
		typeReferences.map[getOperations(context)].flatten
	}

}
