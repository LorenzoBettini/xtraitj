package xtraitj.jvmmodel

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

	def final getTypesMap() {
		return typesMap
	}

	def final getTraitInterfaceResolvedOperationsMap() {
		return traitInterfaceResolvedOperationsMap
	}

	def final getTraitUnmodifiedInterfaceResolvedOperationsMap() {
		return traitUnmodifiedInterfaceResolvedOperationsMap
	}

}
