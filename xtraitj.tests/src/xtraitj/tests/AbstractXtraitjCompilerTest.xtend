package xtraitj.tests

import com.google.inject.Inject
import java.util.List
import org.eclipse.xtext.junit4.TemporaryFolder
import org.eclipse.xtext.resource.FileExtensionProvider
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.eclipse.xtext.xbase.lib.util.ReflectExtensions
import org.junit.Rule

import static extension org.junit.Assert.*

class AbstractXtraitjCompilerTest extends XtraitjAbstractTest {
	@Inject extension ReflectExtensions
	
	@Rule
	@Inject public TemporaryFolder temporaryFolder 
	
	@Inject private FileExtensionProvider extensionProvider
	
	@Inject protected extension CompilationTestHelper
	
	def protected void assertTraitAdapterJavaInterface(CompilationTestHelper.Result r, String name, CharSequence expected) {
		r.assertTraitJavaInterface(name + "_Adapter", expected)
	}

	def protected void assertTraitJavaInterface(CompilationTestHelper.Result r, String name, CharSequence expected) {
//		r.assertJavaCode(name + "Interface", expected)
		r.assertJavaCode(name, expected)
	}

	def protected void assertTraitAdapterJavaClass(CompilationTestHelper.Result r, String name, CharSequence expected) {
		r.assertTraitJavaClass(name + "_Adapter", expected)
	}

	def protected void assertTraitJavaClass(CompilationTestHelper.Result r, String name, CharSequence expected) {
//		r.assertJavaCode(name, expected)
		r.assertJavaCode(name + "Impl", expected)
	}

	def protected void assertTraitAdapterJavaInterface(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
		r.assertTraitJavaInterface(packageName, name + "_Adapter", expected)
	}

	def protected void assertTraitJavaInterface(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
//		r.assertJavaCode(packageName + "." + name + "Interface", expected)
		r.assertJavaCode(packageName + "." + name, expected)
	}

	def protected void assertTraitAdapterJavaClass(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
		r.assertTraitJavaClass(packageName, name + "_Adapter", expected)
	}

	def protected void assertTraitJavaClass(CompilationTestHelper.Result r, String packageName, String name, CharSequence expected) {
//		r.assertJavaCode(packageName + "." + name, expected)
		r.assertJavaCode(packageName + "." + name + "Impl", expected)
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

	def protected createResourceSet(List<? extends CharSequence> inputs) {
		val pairs = newArrayList() => [
			list |
			inputs.forEach[e, i|
				list += "MyFile" + i + "." + 
					extensionProvider.getPrimaryFileExtension() -> e
			]
		] 
		resourceSet(pairs)
	}
	
}
