package xtraitj.ui.tests

import com.google.inject.Inject
import org.eclipse.core.runtime.CoreException
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil
import org.eclipse.xtext.ui.tests.editor.outline.AbstractOutlineWorkbenchTest
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjUiInjectorProvider
import xtraitj.tests.utils.ui.PDETargetPlatformUtils
import xtraitj.tests.utils.ui.PluginProjectHelper
import xtraitj.ui.internal.XtraitjActivator

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjUiInjectorProvider))
class XtraitjOutlineTest extends AbstractOutlineWorkbenchTest {
	
	@Inject PluginProjectHelper projectHelper
	
	override protected getEditorId() {
		XtraitjActivator.XTRAITJ_XTRAITJ
	}

	@BeforeClass
	def static void setUpTargetPlatform() {
		PDETargetPlatformUtils.setTargetPlatform();
	}

	override protected createjavaProject(String projectName) throws CoreException {
		projectHelper.createJavaPluginProject
			(projectName, newArrayList("xtraitj.runtime.requirements"))
	}

	@Test
	def void testOutlineOfWizardProject() {
		'''
/*
 * This is an example Xtraitj program
 */

package my.traits;

import main.CInterface
import java.util.List

trait T {
	String s;
	// you can use full Java generics
	List<? extends String> strings;

	String m() {
		if (strings != null)
			return strings.toString 
		else
			return this.s;
	}
}

class C implements CInterface uses T {
	String s = "aString";
	List<? extends String> strings = null;
	
	// default constructor
	C() {}
	
	C(Iterable<String> iterable) {
		// map, toFirstUpper, toList are extension methods
		// [...] is a lambda expression
		strings = iterable.map[toFirstUpper].toList
	}
}
		'''.assertAllLabels(
'''
my.traits
import declarations
T
  s : String
  strings : List<? extends String>
  m() : String
C
  T
  requirements
    s : String
    strings : List<? extends String>
  provides
    m() : String
  s : String
  strings : List<? extends String>
  C()
  C(Iterable<String>)
'''
		)
	}

	@Test
	def void testOutlineForRequirements() {
		'''
package my.traits

trait T1 {
	String s;
	int m(String a);
}

trait T2 uses T1 {
	
}
		'''.assertAllLabels(
'''
my.traits
T1
  s : String
  m(String) : int
T2
  T1
  requirements
    s : String
    m(String) : int
'''
		)
	}

	@Test
	def void testOutlineOfRequirementsFromInterface() {
		IResourcesSetupUtil.createFile(TEST_PROJECT + "/src/CInterface.java",
'''
public interface CInterface {
	String m(String s);
}
'''.toString);

		IResourcesSetupUtil.waitForAutoBuild
		
		'''
package my.traits;

class C implements CInterface {
}
		'''.assertAllLabels(
'''
my.traits
C
  requirements
    m(String) : String
'''
		)
	}

	@Test
	def void testOutlineOfRequirementsFromGenericInterface() {
		IResourcesSetupUtil.createFile(TEST_PROJECT + "/src/CInterface.java",
'''
import java.util.List;

public interface CInterface<T> {
	List<T> m(T s);
}
'''.toString);

		IResourcesSetupUtil.waitForAutoBuild
		
		'''
package my.traits;

class C implements CInterface<String> {
}
		'''.assertAllLabels(
'''
my.traits
C
  requirements
    m(String) : List<String>
'''
		)
	}

	@Test
	def void testOutlineForFieldRequirementsInClass() {
		'''
package my.traits;

trait T1 {
	String s;
}

class C uses T1 {
	String s;
}
		'''.assertAllLabels(
'''
my.traits
T1
  s : String
C
  T1
  requirements
    s : String
  s : String
'''
		)
	}

	@Test
	def void testOutlineForProvides() {
		'''
package my.traits;

trait T1 {
	String s;
	int m(String a) { return 0; }
}

trait T2 uses T1 {
	String n(int i) { return ""; }
}

trait T3 uses T2 {
	
}

class C uses T3 {
	String s;
}
		'''.assertAllLabels(
'''
my.traits
T1
  s : String
  m(String) : int
T2
  T1
  requirements
    s : String
  provides
    m(String) : int
  n(int) : String
T3
  T2
  requirements
    s : String
  provides
    n(int) : String
    m(String) : int
C
  T3
  requirements
    s : String
  provides
    n(int) : String
    m(String) : int
  s : String
'''
		)
	}

	@Test
	def void testOutlineForConstructors() {
		'''
package my.traits;

class C {
	String s;
	C() {}
	C(int i, String s) {}
}
		'''.assertAllLabels(
'''
my.traits
C
  s : String
  C()
  C(int, String)
'''
		)
	}

	@Test
	def void testOutlineForInstantiatedGenerics() {
		'''
package my.traits;

trait T1<T> {
	T s;
	T m(T a);
	T n(T i) { return i; }
}

trait T2 uses T1<String> {
	
}
		'''.assertAllLabels(
'''
my.traits
T1
  s : T
  m(T) : T
  n(T) : T
T2
  T1<String>
  requirements
    s : String
    m(String) : String
  provides
    n(String) : String
'''
		)
	}
}