package xtraitj.ui.tests

import com.google.inject.Inject
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.emf.ecore.EValidator
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjUiInjectorProvider
import xtraitj.tests.utils.ui.PDETargetPlatformUtils
import xtraitj.tests.utils.ui.PluginProjectHelper

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*
import org.eclipse.core.resources.IMarker

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjUiInjectorProvider))
class XtraitjWorkbenchTest extends AbstractWorkbenchTest {

	@Inject PluginProjectHelper pluginProjectHelper;

	@BeforeClass
	def static void setTargetPlatform() {
		PDETargetPlatformUtils.setTargetPlatform();
	}

	@Test
	def void testSingleProject() {
		createXtraitjPluginProject("testProject1")
		val file = createFile("testProject1" + "/src/test.xtraitj", "trait T1 {}")
		waitForAutoBuildAndAssertNoErrors(file)
	}

	@Test
	def void testRequiredProjectFirst() {
		createXtraitjPluginProject("testProject1")
		val file = createFile("testProject1" + "/src/test.xtraitj",
		'''
		package tests;
		
		trait T1 {
			String m();
		}
		'''
		)
		waitForAutoBuildAndAssertNoErrors(file)
		
		createXtraitjPluginProject("testProject2", "testProject1")
		val file2 = createFile("testProject2" + "/src/test.xtraitj",
		'''
		package tests;
		
		trait T2 uses T1 {
			String useM() {
				return m();
			}
		}
		'''
		)
		waitForAutoBuildAndAssertNoErrors(file2)
	}

	@Test
	def void testRequiredProjectFirstAndRenameInSecondProject() {
		createXtraitjPluginProject("testProject1")
		val file = createFile("testProject1" + "/src/test.xtraitj",
		'''
		package tests;
		
		trait T1<T> {
			T m(T t);
		}
		'''
		)
		waitForAutoBuildAndAssertNoErrors(file)
		
		createXtraitjPluginProject("testProject2", "testProject1")
		val file2 = createFile("testProject2" + "/src/test.xtraitj",
		'''
		package tests;
		
		trait T2<U> uses T1<U>[rename m to n] {
			U useN(U u) {
				return n(u);
			}
		}
		'''
		)
		waitForAutoBuildAndAssertNoErrors(file2)
	}

	@Test
	def void testRequiredProjectsAfterwards() {
		createXtraitjPluginProject("testProject2", "testProject1")
		val file2 = createFile("testProject2" + "/src/test.xtraitj",
		'''
		package tests;
		
		trait T2 uses T1 {
			String useM() {
				return m();
			}
		}
		'''
		)
		// the required project is still not there
		// so we expect errors
		waitForAutoBuildAndAssertErrors(file2)

		createXtraitjPluginProject("testProject1")
		createFile("testProject1" + "/src/test.xtraitj",
		'''
		package tests;
		
		trait T1 {
			String m();
		}
		'''
		)
		
		// the required project there and the errors should go away
		waitForAutoBuildAndAssertNoErrors(file2)
	}

	@Test
	def void testForClassRequiredProjectsAfterwards() {
		createXtraitjPluginProject("testProject2", "testProject1")
		val file2 = createFile("testProject2" + "/src/test.xtraitj",
		'''
		package tests;
		
		class C<U> uses T1<U> {
			U f;
		}
		'''
		)
		// the required project is still not there
		// so we expect errors
		waitForAutoBuildAndAssertErrors(file2)

		createXtraitjPluginProject("testProject1")
		createFile("testProject1" + "/src/test.xtraitj",
		'''
		package tests;
		
		trait T1<T> {
			T f;
			
			T m() { return f; }
		}
		'''
		)
		
		// the required project there and the errors should go away
		waitForAutoBuildAndAssertNoErrors(file2)
	}

	def waitForAutoBuildAndAssertNoErrors(IFile file) {
		waitForAutoBuild();
		assertNoErrors(file)
	}

	def waitForAutoBuildAndAssertErrors(IFile file) {
		waitForAutoBuild();
		assertErrors(file)
	}

	def assertNoErrors(IFile file) {
		val markers = file.findMarkers(EValidator.MARKER, true, IResource.DEPTH_INFINITE)
		assertEquals(
			"unexpected errors:\n" +
			markers.map[getAttribute(IMarker.LOCATION) + 
				", " + getAttribute(IMarker.MESSAGE)].join("\n"),
			0, 
			markers.size
		)
	}

	def assertErrors(IFile file) {
		assertTrue("expected errors but none found", 
			file.findMarkers(EValidator.MARKER, true, IResource.DEPTH_INFINITE).size > 0
		)
	}

	private def createXtraitjPluginProject(String projectName, String... requiredBundles) {
		pluginProjectHelper.createJavaPluginProject(
			projectName,
			(requiredBundles + newArrayList("xtraitj.runtime.requirements")).toList,
			#["tests"] // the package of exported elements
		)
	}

}
