package xtraitj.jvmmodel

import java.util.List
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation

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

	new(
		List<IResolvedOperation> requiredFields,
		List<IResolvedOperation> requiredMethods,
		List<IResolvedOperation> definedMethods
	) {
		this.requiredFields = requiredFields
		this.requiredMethods = requiredMethods
		this.definedMethods = definedMethods
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
			o.resolvedReturnType
			o.resolvedParameterTypes
		}
	} 
}
