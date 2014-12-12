package xtraitj.jvmmodel

import java.util.LinkedList
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJProgram

import static extension xtraitj.util.XtraitjModelUtil.*
import java.util.Set

/**
 * Dependencies among traits and classes during the inferrer when trait references (that is,
 * JvmParameterizedTypeReferences) are still not resolved.
 */
class XtraitjDependencies {

	var TJProgram program

	val LinkedList<TJDeclaration> dependencies = newLinkedList()
	
	val Set<TJDeclaration> processed = newHashSet()

	new(TJProgram program) {
		this.program = program
		for (e : program.elements) {
			e.addDependency
		}
	}

	def private void addDependency(TJDeclaration e) {
		val pos = dependencies.indexOf(e)
		if (pos >= 0) {
			return
		}
		for (traitRef : e.traitReferences) {
			val typeRef = traitRef.trait
			val type = typeRef.getTypeWithoutProxyResolution
			if (type != null && type.eIsProxy) {
				val n = typeRef.jvmTypeReferenceString
				val declaration = program.elements.findFirst[name == n]
				if (declaration !== null && !processed.contains(declaration)) {
					processed.add(declaration)
					declaration.addDependency
				}
			}
		}
		dependencies.add(e)
	}

	def getDependencies() {
		dependencies
	}
}
