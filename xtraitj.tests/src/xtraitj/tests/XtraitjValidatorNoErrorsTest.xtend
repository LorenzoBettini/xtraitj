package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.XtraitjInputs
import xtraitj.xtraitj.TJProgram
import com.google.inject.Provider
import org.eclipse.xtext.resource.XtextResourceSet
import java.util.List

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjValidatorNoErrorsTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	@Inject extension XtraitjInputs
	@Inject
	private Provider<XtextResourceSet> resourceSetProvider;

	@Test def void testDuplicateTraitReferenceWithOperationsOK() {
		'''
		trait T {
			String m();
		}
		
		trait T1 uses T, T[rename m to n] {}
		'''.parseAndAssertNoErrors
	}

	@Test def void testGenericTrait() {
		genericTrait.parseAndAssertNoErrors
	}

	@Test def void testGenericTraitWithRecursiveTypeParameterNotUsed() {
		genericTraitWithRecursiveTypeParameterNotUsed.parseAndAssertNoErrors
	}

	@Test def void testGenericTraitWithRecursiveTypeParameterUsedInMethod() {
		genericTraitWithRecursiveTypeParameterUsedInMethod.parseAndAssertNoErrors
	}

	@Test def void testGenericTraitWithRecursiveTypeParameter() {
		genericTraitWithRecursiveTypeParameter.parseAndAssertNoErrors
	}

	@Test def void testGenericTraitWithRecursiveTypeParameter2() {
		genericTraitWithRecursiveTypeParameter2.parseAndAssertNoErrors
	}

	@Test def void testTraitWithGenericMethodShadowingTraitTypeParameter() {
		traitWithGenericMethodShadowingTraitTypeParameter.parseAndAssertNoErrors
	}

	@Test def void testClassImplementsAllGenericInterfaceMethods() {
		classImplementsAllGenericInterfaceMethods.parseAndAssertNoErrors
	}

	@Test def void testClassImplementsAllGenericInterfaceMethods2() {
		classImplementsAllGenericInterfaceMethods2.parseAndAssertNoErrors
	}

	@Test def void testClassImplementsAllGenericInterfaceMethods3() {
		classImplementsAllGenericInterfaceMethods3.parseAndAssertNoErrors
	}

	@Test def void testClassImplementsAllGenericInterfaceMethodsWithCovariantReturnType() {
		classImplementsAllGenericInterfaceMethodsWithCovariantReturnType.parseAndAssertNoErrors
	}

	@Test def void testClassImplementsAllGenericInterfaceMethodsWithCovariantReturnType2() {
		classImplementsAllGenericInterfaceMethodsWithCovariantReturnType2.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesGenericTrait() {
		traitUsesGenericTrait.parseAndAssertNoErrors
	}

	@Test def void testRequiredMethodsWithGenerics() {
		requiredMethodsWithGenerics.parseAndAssertNoErrors
	}

	@Test def void testCompliantRequiredMethodsWithGenerics() {
		compliantRequiredMethodsWithGenerics.parseAndAssertNoErrors
	}

	@Test def void testCompliantRequiredMethodsWithGenericsAfterTypeParamInstantiation() {
		compliantRequiredMethodsWithGenericsAfterTypeParamInstantiation.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesGenericTraitWithDefinedMethods() {
		traitUsesGenericTraitWithDefinedMethod.parseAndAssertNoErrors
	}

	@Test def void testCompliantRequiredFieldsWithGenericsAfterTypeParamInstantiation() {
		compliantRequiredFieldsWithGenericsAfterTypeParamInstantiation.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesGenericTraitWithFields() {
		traitUsesGenericTraitWithFields.parseAndAssertNoErrors
	}

	@Test def void testCompliantRequiredFieldsWithGenerics() {
		compliantRequiredFieldsWithGenerics.parseAndAssertNoErrors
	}

	@Test def void testGenericFunctionType() {
		genericFunctionType.parseAndAssertNoErrors
	}

	@Test def void testClassUsesTraitWithGenericFunctionType() {
		classUsesTraitWithGenericFunctionType.parseAndAssertNoErrors
	}

	@Test def void testClassUsesTraitWithGenericFunctionTypeInstantiated() {
		classUsesTraitWithGenericFunctionTypeInstantiated.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesGenericTraitWithWildCard() {
		traitUsesGenericTraitWithWildCard.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesGenericTraitWithRequiredMethods() {
		traitUsesGenericTraitWithRequiredMethods.parseAndAssertNoErrors
	}

	@Test def void testTraitUsingGenericMethod() {
		traitUsingGenericMethod.parseAndAssertNoErrors
	}

//	@Test def void testTraitUsingGenericMethodSeparateFiles() {
//		traitUsingGenericMethodSeparateFiles.parseAndAssertNoErrors
//	}
	
	@Test def void testTraitWithGenericMethod() {
		traitWithGenericMethod.parseAndAssertNoErrors
	}

	@Test def void testTraitWithTypeParametersWithDifferentNames() {
		traitWithTypeParametersWithDifferentNames.parseAndAssertNoErrors
	}

//	@Test def void testTraitWithTypeParametersWithDifferentNamesSeparateFiles() {
//		traitWithTypeParametersWithDifferentNamesSeparateFiles.parseAndAssertNoErrors
//	}
	
	@Test def void testTraitUsesGenericTraitClass() {
		traitUsesGenericClass.parseAndAssertNoErrors
	}

//	@Test def void testTraitUsesGenericTraitClassSeparateFiles() {
//		traitUsesGenericClassSeparateFiles.parseAndAssertNoErrors
//	}
	
	@Test def void testAccessToGeneratedJavaCodeWithoutOriginalSource() {
		accessToGeneratedJavaCodeWithoutOriginalSource.parseAndAssertNoErrors
	}

	def private parseAndAssertNoErrors(CharSequence input) {
		input.parse.assertNoErrors
	}

//	def private parseAndAssertNoErrors(List<String> inputs) {
//		val rs = resourceSetProvider.get
//		val eobjects = newArrayList()
//		for (i : inputs) {
//			eobjects += i.parse(rs)
//		}
//		for (o1 : eobjects) {
//			for (o : eobjects) {
//				o.validate
//			}
//		}
//		for (o : eobjects) {
//			o.assertNoErrors
//		}
//	}
}
