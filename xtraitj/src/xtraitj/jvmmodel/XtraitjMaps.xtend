package xtraitj.jvmmodel

import org.eclipse.xtext.common.types.JvmGenericType
import xtraitj.xtraitj.TJTraitReference

/**
 * A utility class containing maps for Java types inferred for elements
 * of the same Xtraitj program file and for resolved operations.
 * 
 * @author Lorenzo Bettini
 */
class XtraitjMaps {
	val typesMap = new XtraitjJvmGenericTypeMap
	val traitInterfaceResolvedOperationsMap = new XtraitjResolvedOperationsMap()
	val traitUnmodifiedInterfaceResolvedOperationsMap = new XtraitjResolvedOperationsMap()

	def getJvmGenericType(String s) {
		typesMap.get(s)
	}
	
	def void putJvmGenericType(String s, JvmGenericType type) {
		typesMap.put(s, type)
	}

	def getTraitInferfaceResolvedOperations(TJTraitReference traitRef) {
		traitInterfaceResolvedOperationsMap.get(traitRef)
	}

	def void putTraitInferfaceResolvedOperations(TJTraitReference traitRef, XtraitjResolvedOperations resolvedOperations) {
		traitInterfaceResolvedOperationsMap.put(traitRef, resolvedOperations)
	}

	def getTraitUnmodifiedInferfaceResolvedOperations(TJTraitReference traitRef) {
		traitUnmodifiedInterfaceResolvedOperationsMap.get(traitRef)
	}

	def void putTraitUnmodifiedInferfaceResolvedOperations(TJTraitReference traitRef, XtraitjResolvedOperations resolvedOperations) {
		traitUnmodifiedInterfaceResolvedOperationsMap.put(traitRef, resolvedOperations)
	}

}
