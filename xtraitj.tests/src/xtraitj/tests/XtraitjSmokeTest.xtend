package xtraitj.tests

import com.google.inject.Inject
import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.spi.LoggingEvent
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.xtraitj.TJProgram

import static org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjSmokeTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	
	private final static Logger LOG = Logger.getLogger(JvmModelAssociator);

	/**
	 * JvmModelAssociator does not throw exceptions but logs possible
	 * errors; we use this class to record possible error events
	 */
	static class LogListener extends ConsoleAppender {
		
		val public events = newArrayList()
		
		override doAppend(LoggingEvent event) {
			if (event.getLevel == Level.ERROR) {
				events += event
			}
		}
		
	}
	
	var LogListener logListener

	@Before
	def void createAppender() {
		logListener = new LogListener => [
			LOG.addAppender(it)
		]
	}

	@After
	def void removeAppender() {
		LOG.removeAppender(logListener)
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

	def private void parseAndValidate(CharSequence input) {
		input.parse.validate
		//	.map[message].forEach[println(it)] // useful for debugging
		// there must be no error in the log either
		assertTrue("Some error was reported in the LOG", logListener.events.empty)
	} 
}