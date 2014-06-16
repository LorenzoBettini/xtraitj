package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.eclipse.xtext.xbase.lib.util.ReflectExtensions

import static extension org.junit.Assert.*

class AbstractXtraitjCompilerTest {
	@Inject extension ReflectExtensions
	
	def protected void assertTraitAdapterJavaInterface(CompilationTestHelper.Result r, String name, CharSequence expected) {
		r.assertTraitJavaInterface(name + "_Adapter", expected)
	}

	def protected void assertTraitJavaInterface(CompilationTestHelper.Result r, String name, CharSequence expected) {
		r.assertJavaCode(name + "Interface", expected)
	}

	def protected void assertTraitAdapterJavaClass(CompilationTestHelper.Result r, String name, CharSequence expected) {
		r.assertTraitJavaClass(name + "_Adapter", expected)
	}

	def protected void assertTraitJavaClass(CompilationTestHelper.Result r, String name, CharSequence expected) {
		r.assertJavaCode(name, expected)
	}

	def protected void assertTraitAdapterJavaInterface(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
		r.assertTraitJavaInterface(packageName, name + "_Adapter", expected)
	}

	def protected void assertTraitJavaInterface(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
		r.assertJavaCode(packageName + "." + name + "Interface", expected)
	}

	def protected void assertTraitAdapterJavaClass(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
		r.assertTraitJavaClass(packageName, name + "_Adapter", expected)
	}

	def protected void assertTraitJavaClass(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
		r.assertJavaCode(packageName + "." + name, expected)
	}

	def protected void assertJavaClass(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
		r.assertJavaCode(packageName + "." + name, expected)
	}

	def protected void assertJavaClass(CompilationTestHelper.Result r, String name, CharSequence expected) {
		r.assertJavaCode(name, expected)
	}
	
	def protected void assertJavaCode(CompilationTestHelper.Result r, String name, CharSequence expected) {
		r => [
			expected.toString.assertEquals(getGeneratedCode(name))
		]
	}

	def protected executeGeneratedJavaClassMethodAndAssert(CompilationTestHelper.Result r, String className, String methodName, CharSequence expected) {
		r => [
			var c = getCompiledClass("tests." + className)
			if (c == null)
				c = getCompiledClass(className)
			val obj = c.newInstance
			expected.toString.assertEquals(obj.invoke(methodName).toString)
		]
	}

	def protected assertGeneratedJavaCodeCompiles(CompilationTestHelper.Result r) {
		r.compiledClass // check Java compilation succeeds
	}
}
