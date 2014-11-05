package xtraitj.jvmmodel

import java.util.List
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import org.eclipse.xtext.xbase.typesystem.references.ITypeReferenceOwner
import xtraitj.types.XtraitjTypeParameterHelper

/**
 * Stores IResolvedOperation information for required fields, required methods
 * and defined methods of a trait.
 * 
 * @author Lorenzo Bettini
 * 
 */
class XtraitjResolvedOperations {

	private List<IResolvedOperation> requiredFields;

	private List<IResolvedOperation> requiredMethods;

	private List<IResolvedOperation> definedMethods;
	
	private XtraitjTypeParameterHelper typeParameterHelper;

	new(
		List<IResolvedOperation> requiredFields,
		List<IResolvedOperation> requiredMethods,
		List<IResolvedOperation> definedMethods,
		XtraitjTypeParameterHelper typeParameterHelper
	) {
		this.requiredFields = requiredFields
		this.requiredMethods = requiredMethods
		this.definedMethods = definedMethods
		this.typeParameterHelper = typeParameterHelper
	}

	def getRequiredFields() {
		return this.requiredFields
	}

	def getRequiredMethods() {
		return this.requiredMethods
	}

	def getDefinedMethods() {
		return this.definedMethods
	}

	def getDeclaredMethods() {
		return requiredMethods + definedMethods
	}

	def getAllDeclarations() {
		return requiredFields + declaredMethods
	}

	def getAllRequirements() {
		return requiredFields + requiredMethods
	}

	/**
	 * Triggers resolution of return type and parameter types
	 */
	def resolveAll() {
		requiredFields.resolve
		requiredMethods.resolve
		definedMethods.resolve
	}

	def private resolve(Iterable<IResolvedOperation> resolvedOperations) {
		for (o : resolvedOperations) {
			val contextType = o.contextType
			val typeDeclarator = contextType.type
			if (typeDeclarator instanceof JvmTypeParameterDeclarator) {
				/*
				 * The following operations are crucial to have a correct resolution of
				 * the operation.
				 * 
				 * Since for the same trait we infer a Java interface and a Java class,
				 * the possible type parameter references must be correctly bound to
				 * the Java interface's type parameters, NOT to the Java class' ones.
				 * 
				 * For example,
				 * 
				 * trait MyTrait<T> {
				 *    List<T> m() {...}
				 * }
				 * 
				 * If we need to resolve m in the context of MyTrait<String>, the
				 * T of List<T> must be bound to the Java interface MyTrait<T>, and
				 * NOT to the Java class MyTraitImpl<T>.
				 * 
				 * To be sure that it happens consistently we need to perform a
				 * manual rebinding.
				 * 
				 * We cannot rely on scoping since that will always bound type parameter
				 * references to the last inferred type for the trait; when traits are spread
				 * through several files such behavior will break the operation resolution
				 * (on the other hand, for correct type checking of method bodies, type parameter
				 * references have to be bound to the inferred Java class' type parameters,
				 * so we can't change such scoping behavior).
				 * 
				 * So we don't modify the scoping behavior, but for operation resolution
				 * we implement a kind of custom scoping by performing manual rebinding.
				 * 
				 * When such manual rebinding is performed, operation resolution will
				 * work correctly.
				 */
				
				val declaration = o.declaration
				val owner = contextType.getOwner();
				val typeRefToResolve = declaration.returnType
				val resolved = resolveTypeRef(owner, typeRefToResolve)
				declaration.returnType = typeParameterHelper.rebindTypeParameters(resolved, typeDeclarator, null)
				
				for (p : declaration.parameters) {
					val unresolvedTypePar = p.parameterType
					val resolvedTypePar = resolveTypeRef(owner, unresolvedTypePar)
					p.parameterType = typeParameterHelper.rebindTypeParameters(resolvedTypePar, typeDeclarator, null)
				}
			}
			
			o.resolvedReturnType
			o.resolvedParameterTypes
		}
	}

	/**
	 * Triggers resolution of type reference, including its type parameters.
	 * In order to do so, we need to create a LightweightTypeReference using the
	 * ITypeReferenceOwner and then get the corresponding JvmTypeReference.
	 */
	private def resolveTypeRef(ITypeReferenceOwner owner, JvmTypeReference typeRefToResolve) {
		val lightweightTypeRef = owner.toLightweightTypeReference(typeRefToResolve);
		lightweightTypeRef.toTypeReference
	}
}
