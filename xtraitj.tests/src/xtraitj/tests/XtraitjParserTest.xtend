package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.junit.Test
import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import xtraitj.xtraitj.TJProgram
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.XtraitjInputs

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjParserTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	@Inject extension XtraitjInputs
	
	@Test def void simpleProgram() {
		'''
		trait T {
			
		}
		
		class C uses T {
			
		}
		'''.parse.assertNoErrors
	}

	@Test def void testFields() {
		'''
		package my.pack;
		
		import java.util.List
		
		trait T {
			Object o;
		}
		
		class C uses T {
			Object o;
			List<String> l;
		}
		'''.parse.assertNoErrors
	}

	@Test def void testMethods() {
		'''
		import java.util.List
		
		trait T {
			Object a(String s);
			
			Object m(List<String> l, String s) {
				return null;
			}
		}
		'''.parse.assertNoErrors
	}

	@Test def void testTraitSum() {
		traitSum.parse.assertNoErrors
	}

	@Test def void testTraitUsesTraitWithFields() {
		traitUsesTraitWithFields.parse.assertNoErrors
	}

	@Test def void testTraitRenameOperations() {
		traitRenameOperations.parse.assertNoErrors
	}

	@Test def void testTraitRenameField() {
		classUsesTraitWithRenamedFields.parse.assertNoErrors
	}

	@Test def void testClassUsesTraitWithRenamedRequiredMethods() {
		classUsesTraitWithRenamedRequiredMethods.parse.assertNoErrors
	}

	@Test def void testClassUsesTraitRenameProvidedMethodToRequiredAndSum() {
		classUsesTraitRenameProvidedMethodToRequiredAndSum.parse.assertNoErrors
	}

	@Test def void testUsesTraitRenameProvidedMethodToRequiredAndSum2() {
		classUsesTraitRenameProvidedMethodToRequiredAndSum2.parse.assertNoErrors
	}

	@Test def void testClassRenamesRequiredMethodToProvidedAndSum() {
		classRenamesRequiredMethodToProvidedAndSum.parse.assertNoErrors
	}

	@Test def void testTraitHide() {
		traitHide.parse.assertNoErrors
	}

	@Test def void testTraitAlias() {
		traitAlias.parse.assertNoErrors
	}

	@Test def void testTraitAliasWithRenameAndHide() {
		traitAliasWithRenameAndHide.parse.assertNoErrors
	}

	@Test def void testTraitRestrict() {
		traitRestrict.parse.assertNoErrors
	}

	@Test def void testPrivateMethod() {
		traitPrivateMethod.parse.assertNoErrors
	}

	@Test def void testTraitRedirect() {
		traitRedirect.parse.assertNoErrors
	}

	@Test def void testTraitRequiredMethodProvidedWithCovariantReturnType() {
		traitRequiredMethodProvidedWithCovariantReturnType.parse.assertNoErrors
	}

	@Test def void testClassImplementsSerializableAndClonable() {
		classImplementsSerializableAndClonable.parse.assertNoErrors
	}

	@Test def void testClassImplementsAllInterfaceMethodsWithSum() {
		classImplementsAllInterfaceMethodsWithSum.parse.assertNoErrors
	}

	@Test def void testClassWithDefaultConstructor() {
		classWithDefaultConstructor.parse.assertNoErrors
	}

	@Test def void testClassWithDefaultEmptyConstructor() {
		classWithDefaultEmptyConstructor.parse.assertNoErrors
	}

	@Test def void testClassWithConstructors() {
		classWithConstructors.parse.assertNoErrors
	}
}