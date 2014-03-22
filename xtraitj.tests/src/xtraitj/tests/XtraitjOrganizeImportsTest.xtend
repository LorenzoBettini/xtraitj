package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.ReplaceRegion
import org.eclipse.xtext.xbase.imports.ImportOrganizer
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.xtraitj.TJProgram
import static org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjOrganizeImportsTest {
	@Inject extension ParseHelper<TJProgram> 
	@Inject ImportOrganizer importOrganizer

	def protected assertIsOrganizedTo(CharSequence model, CharSequence expected) {
		val program = parse(model.toString)
		val changes = importOrganizer.getOrganizedImportChanges(program.eResource as XtextResource)
		val builder = new StringBuilder(model)
		val sortedChanges= changes.sortBy[offset]
		var ReplaceRegion lastChange = null
		for(it: sortedChanges) {
			if(lastChange != null && lastChange.endOffset > offset)
				fail("Overlapping text edits: " + lastChange + ' and ' +it)
			lastChange = it
		}
		for(it: sortedChanges.reverse)
			builder.replace(offset, offset + length, text)
		assertEquals(expected.toString, builder.toString)
	}
	
	@Test def void simpleProgram() {
		'''
		trait T {
			java.util.List<String> l;
		}
		'''.assertIsOrganizedTo(
'''
import java.util.List

trait T {
	List<String> l;
}
'''
		)
	}

	@Test def void programWithPackage() {
		'''
		package my.traits;
		
		trait T {
			java.util.List<String> l;
		}
		'''.assertIsOrganizedTo(
'''
package my.traits;

import java.util.List

trait T {
	List<String> l;
}
'''
		)
	}

	@Test def void programWithComments() {
		// see https://github.com/LorenzoBettini/xtraitj/issues/1
		// and https://bugs.eclipse.org/bugs/show_bug.cgi?id=407390
		'''
		/*
		 * This is a comment
		 */
		
		package my.traits;
		
		trait T {
			java.util.List<String> l;
		}
		'''.assertIsOrganizedTo(
'''
/*
 * This is a comment
 */

package my.traits;

import java.util.List

trait T {
	List<String> l;
}
'''
		)
	}
}