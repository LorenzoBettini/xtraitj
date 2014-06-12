package xtraitj.ui.tests

import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.jdt.core.IJavaProject
import org.eclipse.jdt.core.JavaCore
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.util.JavaProjectSetupUtil
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.util.PluginProjectFactory
import org.eclipse.xtext.xbase.junit.ui.AbstractContentAssistTest
import org.junit.AfterClass
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjUiInjectorProvider
import xtraitj.ui.internal.XtraitjActivator
import xtraitj.tests.utils.ui.PDETargetPlatformUtils

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjUiInjectorProvider))
class XtraitjContentAssistTest extends AbstractContentAssistTest {

	static IJavaProject pluginJavaProject
	
	val static PROJECT_NAME = "customPluginProject"
	
	@BeforeClass
	def static void setUp() {
		PDETargetPlatformUtils.setTargetPlatform();
		
		val injector = XtraitjActivator.getInstance().getInjector(XtraitjActivator.XTRAITJ_XTRAITJ);
		val projectFactory = injector.getInstance(PluginProjectFactory);
		projectFactory.setProjectName(PROJECT_NAME);
		projectFactory.addFolders(newArrayList("src"));
		projectFactory.addBuilderIds(
			JavaCore.BUILDER_ID, 
			"org.eclipse.pde.ManifestBuilder",
			"org.eclipse.pde.SchemaBuilder",
			XtextProjectHelper.BUILDER_ID);
		projectFactory.addProjectNatures(
			JavaCore.NATURE_ID, 
			"org.eclipse.pde.PluginNature", 
			XtextProjectHelper.NATURE_ID
		);
		projectFactory.addRequiredBundles(newArrayList(
				"xtraitj.runtime.requirements"));
		val result = projectFactory.createProject(new NullProgressMonitor(), null);
		JavaProjectSetupUtil.makeJava5Compliant(JavaCore.create(result));
		pluginJavaProject = JavaProjectSetupUtil.findJavaProject(PROJECT_NAME);
	}
	
	@AfterClass
	def static void tearDown() {
		pluginJavaProject.project.delete(true, new NullProgressMonitor)
	}
	
	override getJavaProject(ResourceSet resourceSet) {
		pluginJavaProject
	}

	val T = '''
		trait T {
			String s;
			Object m() { return null; }
		}
		'''

	@Test
	def void testRenameMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[rename '''
		).assertText('m', 's')
	}

	@Test
	def void testHideMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[hide '''
		).assertText('m')
	}

	@Test
	def void testAliasMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[alias '''
		).assertText('m')
	}

	@Test
	def void testRestrictMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[restrict '''
		).assertText('m')
	}

	@Test
	def void testPrivateMethod() {
		newBuilder.append(
		'''
		trait T {
			private String m() { null; }
			String n() { null; }
		}
		
		trait T1 uses T[rename '''
		).assertText('n')
	}

	@Test
	def void testRedirectMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[redirect '''
		).assertText('m', 's')
		.append(" m to ").assertText('m', 's')
	}

	@Test
	def void testImplementsInterface() {
		newBuilder.append(
		'''
		import java.util.List
		
		class C implements Lis'''
		).assertProposal('List')
	}

	@Test
	def void testImplementsNotClass() {
		newBuilder.append(
		'''
		import java.util.LinkedList
		
		class C implements LinkedL'''
		).assertText()
	}

}