package xtraitj.performance.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.FixMethodOrder
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.MethodSorters
import xtraitj.XtraitjInjectorProvider
import xtraitj.tests.AbstractXtraitjCompilerTest

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
class XtraitjCompilerPerformanceTest extends AbstractXtraitjCompilerTest {

	@Test def void aWarmUp() {
		compile(
			#['''
				package tests;
				
				trait T1 {
					String m() { return null; }
				}
			''', '''
				package tests;
				
				trait T2 uses tests.T1 {
					
				}
			''']
		) [
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void test010() {
		performanceOfCompiler(10)
	}

	@Test def void test020() {
		performanceOfCompiler(20)
	}

	@Test def void test030() {
		performanceOfCompiler(30)
	}

	@Test def void test040() {
		performanceOfCompiler(40)
	}

	@Test def void test050() {
		performanceOfCompiler(50)
	}

	@Test def void test060() {
		performanceOfCompiler(60)
	}

	@Test def void test100() {
		performanceOfCompiler(100)
	}

	def private performanceOfCompiler(int num) {
		val inputs = newLinkedList(
			'''
				package tests;
				
				trait T1 {
					String m1() { return null; }
				}
			'''
		)
		for (var i = 1; i < num; i++) {
			inputs += '''
				package tests;
				
				trait T«i+1» uses T«i»[rename m«i» to m«i+1»]  {
					
				}
			'''
		}
		compile(inputs) [
			assertGeneratedJavaCodeCompiles
		]
	}
}
