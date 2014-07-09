package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.xtraitj.TJProgram

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjSmokeTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	
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

	@Test def void testReferenceToNonExistentTrait() {
		'''
		trait T {
			String m
		}
		
		trait T2 uses T1 {
			
		}
		'''.parseAndValidate
	}

	@Test def void testReferenceToNonExistentTraitWithOperations() {
		'''
		trait T {
			String m
		}
		
		trait T2 uses T1[rename m ] {
			
		}
		'''.parseAndValidate
	}

	def private void parseAndValidate(CharSequence input) {
		input.parse.validate
	} 
}