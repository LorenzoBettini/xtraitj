package xtraitj.tests

import org.apache.log4j.Logger
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.tests.utils.XtraitjLogListener

import static org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjSmokeTest extends XtraitjAbstractTest {
	private final static Logger LOG = Logger.getLogger(JvmModelAssociator);

	var XtraitjLogListener logListener

	@Before
	def void createAppender() {
		logListener = new XtraitjLogListener => [
			LOG.addAppender(it)
		]
	}

	@After
	def void removeAppender() {
		LOG.removeAppender(logListener)
	}

	@Test def void testIncompleteMethod() {
		'''
		trait T {
			String
		}
		'''.parseAndValidate
	}

	@Test def void testIncompleteFieldInClass() {
		'''
		class C {
			String
		}
		'''.parseAndValidate
	}
	
	@Test def void testEmptyOperations() {
		'''
		trait T {
			
		}
		
		class C uses T[] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testNoMemberInRenameYet() {
		'''
		trait T {
			
		}
		
		class C uses T[rename ] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testNoMemberInRenameYet2() {
		'''
		trait T {
			String s;
		}
		
		class C uses T[rename ] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testNoMemberInRenameFieldYet() {
		'''
		trait T {
			
		}
		
		class C uses T[rename field ] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testRenameIncompleteMethod() {
		'''
		trait T {
			String m
		}
		
		class C uses T[rename m ] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testRenameNonExistantMethod() {
		'''
		trait T {
			void m() {}
		}
		
		class C uses T[rename foo to bar] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testRenameReferenceToNonExistentTraitWithOperations() {
		'''
		trait T {
			String m
		}
		
		trait T2 uses T1[rename m ] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testNoMemberInHideYet() {
		'''
		trait T {
			
		}
		
		class C uses T[hide ] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testHideNonExistantMethod() {
		'''
		trait T {
			void m() {}
		}
		
		class C uses T[hide foo] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testAliasNonExistantMethod() {
		'''
		trait T {
			void m() {}
		}
		
		class C uses T[alias foo] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testAliasAsNotYetSpecified() {
		'''
		trait T {
			void m() {}
		}
		
		class C uses T[alias m as ] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testRestrictNonExistantMethod() {
		'''
		trait T {
			void m() {}
		}
		
		class C uses T[restrict foo] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testRedirectNonExistantMethod() {
		'''
		trait T {
			void m() {}
		}
		
		class C uses T[redirect foo] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testRedirectNonExistantMethod2() {
		'''
		trait T {
			void m() {}
			void n() {}
		}
		
		class C uses T[redirect foo to n] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testRedirectNonExistantMethod3() {
		'''
		trait T {
			void m() {}
			void n() {}
		}
		
		class C uses T[redirect m to foo] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testRedirectToNotYetSpecified() {
		'''
		trait T {
			void m() {}
		}
		
		class C uses T[redirect m to ] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testReferenceToNonExistentTrait() {
		'''
		trait T {
			String m
		}
		
		trait T2 uses T1 {
			
		}
		'''.parseAndValidate
	}

	@Test def void testReferenceToNonExistentTraitFromClass() {
		'''
		class C uses T1 {
			
		}
		'''.parseAndValidate
	}

	@Test def void testReferenceToNonExistentGenericTraitFromClass() {
		'''
		class C<T> uses T1<T> {
			
		}
		'''.parseAndValidate
	}

	@Test def void testReferenceWithWrongTypeArgs() {
		'''
		trait T1<T> {
			
		}
		
		trait T2<U,V> uses T1<U,V> {
			
		}
		'''.parseAndValidate
	}

	@Test def void testReferenceToNonExistentInterface() {
		'''
		class C implements T {
			
		}
		'''.parseAndValidate
	}

	@Test def void testClassTraitReferenceWithWrongTypeArgs() {
		'''
		trait T1<T> {
			
		}
		
		class C<U,V> uses T1<U,V> {
			
		}
		'''.parseAndValidate
	}

	@Test def void testClassTraitReferenceWithOperationsWithWrongTypeArgs() {
		'''
		trait T1<T> {
			String m();
		}
		
		class C<U,V> uses T1<U,V>[rename m to n] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testClassTraitReferenceWithOperationsWithRawType() {
		'''
		trait T1<T> {
			String m();
		}
		
		class C<U,V> uses T1[rename m to n] {
			
		}
		'''.parseAndValidate
	}

	@Test def void testClassUsesWithoutTraitReference() {
		'''
		class C uses {
			
		}
		'''.parseAndValidate
	}

	@Test def void testTraitUsesWithoutTraitReference() {
		'''
		trait T uses {
			
		}
		'''.parseAndValidate
	}

	def private void parseAndValidate(CharSequence input) {
		input.parse.validate
		//	.map[message].forEach[println(it)] // useful for debugging
		// there must be no error in the log either
		assertTrue("Some error was reported in the LOG", logListener.events.empty)
	} 
}