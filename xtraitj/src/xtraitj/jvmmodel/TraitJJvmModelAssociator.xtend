package xtraitj.jvmmodel

import com.google.inject.Singleton
import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator
import org.eclipse.emf.ecore.EObject
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJTraitReference

@Singleton
class TraitJJvmModelAssociator extends JvmModelAssociator {
	
	override getSourceElements(EObject jvmElement) {
		val result = super.getSourceElements(jvmElement)
		
		if (!result.empty || jvmElement == null)
			return result
		
		try {
			// check whether it is contained in a trait or class
			val decl = super.getSourceElements(jvmElement.eContainer).filter[
				it instanceof TJTraitReference || it instanceof TJDeclaration
			]
			
			if (!decl.empty) {
				for (r : jvmElement.eResource().resourceSet.resources) {
					val map = targetToSourceMap(r);
					val sources = map.get(jvmElement);
					if (sources != null)
						return sources;
				}
			}
		} catch (Throwable t) {
			// ignore and go on with the empty result
		}
		
		return result
	}
	
}