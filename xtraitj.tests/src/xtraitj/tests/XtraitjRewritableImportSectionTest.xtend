package xtraitj.tests

import com.google.inject.Inject
import java.util.List
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.xbase.imports.RewritableImportSection
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.xtraitj.TJProgram
import static org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjRewritableImportSectionTest {
	@Inject ParseHelper<TJProgram> parser
	@Inject extension RewritableImportSection.Factory
	@Inject extension TypeReferences
	
	var TJProgram program
	
	@Test
	def void importSectionOfSimpleProgram() {
		val section = '''
		trait T {
			
		}
		'''.section
		section.addImport(List.jvmType)
	}

	@Test
	def void importSectionOfProgramWithPackage() {
		val section = '''
		package my.traits;
		
		trait T {
			
		}
		'''.section
		section.addImport(List.jvmType)
	}

	@Test
	def void importSectionOfProgramWithPackageAndComments() {
		// see https://github.com/LorenzoBettini/xtraitj/issues/1
		// and https://bugs.eclipse.org/bugs/show_bug.cgi?id=407390
		
		val section = '''
		/*
		 * This is a comment
		 */
		
		package my.traits;
		
		trait T {
			
		}
		'''.section
		section.addImport(List.jvmType)
	}

	def private getSection(CharSequence p) {
		program = parser.parse(p)
		(program.eResource as XtextResource).
			parse
	}

	def private jvmType(Class<? extends Object> javaClass) {
		val type = findDeclaredType(javaClass, program)
		assertTrue(type instanceof JvmDeclaredType)
		type as JvmDeclaredType
	} 
}
