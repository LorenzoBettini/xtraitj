package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.scoping.XtraitjXbaseBatchScopeProvider
import xtraitj.xtraitj.TJHideOperation
import xtraitj.xtraitj.TJRenameOperation
import xtraitj.xtraitj.TJRestrictOperation
import xtraitj.xtraitj.XtraitjPackage

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjScopeProviderTest extends XtraitjAbstractTest {
	@Inject extension XtraitjXbaseBatchScopeProvider

	val memberFeature = XtraitjPackage::eINSTANCE.TJTraitOperation_Member

	@Test def void testTraitRenameOperations() {
		traitRenameOperations.parse.
			renameOperation.assertScope
			(memberFeature, "s, n, m, t1")
	}

	@Test def void testTraitRenameFieldOperations() {
		traitRenameField.parse.
			renameOperation.assertScope
			(memberFeature, "fieldB, fieldS, n, m")
	}

	@Test def void testTraitHideOperations() {
		traitHide.parse.
			hideOperation.assertScope
			(memberFeature, "p, m, n")
	}

	@Test def void testTraitRestrictOperations() {
		traitRestrict.parse.
			restrictOperation.assertScope
			(memberFeature, "p, m, n")
	}

	def private renameOperation(EObject o) {
		o.eAllContents.filter(typeof(TJRenameOperation)).head
	}

	def private hideOperation(EObject o) {
		o.eAllContents.filter(typeof(TJHideOperation)).head
	}

	def private restrictOperation(EObject o) {
		o.eAllContents.filter(typeof(TJRestrictOperation)).head
	}

	def private assertScope(EObject o, EReference ref, String expected) {
		expected.assertEquals
			(o.getScope(ref).allElements.map[name].join(", "))
	}
}