package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjValidatorNoErrorsTest extends XtraitjAbstractTest {

	@Test def void testDuplicateTraitReferenceWithOperationsOK() {
		'''
		trait T {
			String m();
		}
		
		trait T1 uses T, T[rename m to n] {}
		'''.parseAndAssertNoErrors
	}

	@Test def void testTraitMethods() {
		'''
		import java.util.List
		
		trait T {
			List<Integer> f;
			boolean b;
			boolean abM(String s);
			void abV();
			Object m(List<String> l, String s) {
				f = newArrayList(1)
				return l.size + s + f + abM("foo") + b;
			}
		}
		'''.parseAndAssertNoErrors
	}

	@Test def void testTraitFieldName() {
		'''
		package tests;
		
		trait T1 {
			
		}
		
		trait T2 {
			
		}
		
		trait T3 uses T1, tests.T2 {
			
		}
		'''.parseAndAssertNoErrors
	}

	@Test def void testTraitAndClass() {
		'''
		import java.util.List
		
		trait T {
			List<Integer> f;
			boolean b;
			Object m(List<String> l, String s) {
				f = newArrayList(1)
				return l.size + s + f + b;
			}
			Object n() { m(newLinkedList("bar"), "foo"); }
		}
		
		class C uses T {
			List<Integer> f;
			boolean b=false;
		}
		'''.parseAndAssertNoErrors
	}

//	@Test def void testTraitAndClassSeparateFiles() {
//		#[
//		'''
//		import java.util.List
//		
//		class C uses T {
//			List<Integer> f;
//			boolean b=false;
//		}
//		''',
//		'''
//		import java.util.List
//		
//		trait T {
//			List<Integer> f;
//			boolean b;
//			Object m(List<String> l, String s) {
//				f = newArrayList(1)
//				return l.size + s + f + b;
//			}
//			Object n() { m(newLinkedList("bar"), "foo"); }
//		}
//		'''
//		].createResourceSet.compile [
//			expectationsForTraitAndClass(it)
//		]
//	}

	@Test def void testTraitPrivateMethod() {
		traitPrivateMethod.parseAndAssertNoErrors
	}

	@Test def void testClassWithTraitSum() {
		classWithTraitSum.parseAndAssertNoErrors
	}

	@Test def void testTraitSum() {
		traitSum.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesTraitWithTraitSum() {
		traitUsesTraitWithTraitSum.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesTraitWithFields() {
		traitUsesTraitWithFields.parseAndAssertNoErrors
	}

	@Test def void testTraitWithDoubleApply() {
		traitWithDoubleApply.parseAndAssertNoErrors
	}

	@Test def void testTraitRequiredMethodProvidedWithCovariantReturnType() {
		traitRequiredMethodProvidedWithCovariantReturnType.parseAndAssertNoErrors
	}

	@Test def void testClassWithDefaultEmptyConstructor() {
		classWithDefaultEmptyConstructor.parseAndAssertNoErrors
	}

	@Test def void testClassWithDefaultConstructor() {
		classWithDefaultConstructor.parseAndAssertNoErrors
	}

	@Test def void testClassConstructors() {
		classWithConstructors.parseAndAssertNoErrors
	}

	@Test def void testClassImplementsAllInterfaceMethodsWithSum() {
		classImplementsAllInterfaceMethodsWithSum.parseAndAssertNoErrors
	}

	@Test def void testGeneratedJavaDocForTraitsAndClasses() {
		elementsWithDocumentation.parseAndAssertNoErrors
	}

	@Test def void testTraitProvidesMethodToUsedTrait() {
		traitProvidesMethodToUsedTrait.parseAndAssertNoErrors
	}

	@Test def void testCompliantRequiredFields() {
		compliantRequiredFields.parseAndAssertNoErrors
	}

	@Test def void testCompliantRequiredMethods() {
		compliantRequiredMethods.parseAndAssertNoErrors
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

	@Test def void testClassUsesTraitWithGenericFunctionTypeSimple() {
		'''
package tests;

import java.util.List

trait TWithGenericMethod {
	<T> T m(T t) { return t; }
}

class C uses TWithGenericMethod {
	
}
		'''.parseAndAssertNoErrors
	}

	@Test def void testClassUsesTraitWithGenericFunctionType() {
		classUsesTraitWithGenericFunctionType.parseAndAssertNoErrors
	}

	@Test def void testClassUsesTraitWithGenericFunctionTypeInstantiated() {
		classUsesTraitWithGenericFunctionTypeInstantiated.parseAndAssertNoErrors
	}

	@Test def void testClassGenericFunctionAsField() {
		classGenericFunctionAsField.parseAndAssertNoErrors
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
