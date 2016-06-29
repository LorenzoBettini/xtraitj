package xtraitj.scoping

import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import xtraitj.xtraitj.XtraitjPackage

class XtraitjIndex {
	@Inject ResourceDescriptionsProvider rdp

	@Inject IContainer.Manager cm

	def getVisibleEObjectDescriptions(EObject o, EClass type) {
		o.getVisibleContainers.map[ container |
			container.getExportedObjectsByType(type)
		].flatten
	}

	def getVisibleDeclarationDescriptions(EObject o) {
		o.getVisibleEObjectDescriptions(XtraitjPackage.eINSTANCE.TJDeclaration)
	}

	def getVisibleContainers(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		val rd = index.getResourceDescription(o.eResource.URI)
		cm.getVisibleContainers(rd, index)
	}

}
