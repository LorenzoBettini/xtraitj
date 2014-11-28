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

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjValidatorWithOperationsNoErrorsTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	@Inject extension XtraitjInputs
	@Inject
//	private Provider<XtextResourceSet> resourceSetProvider;

	@Test def void testTraitRenamedRequiredMethodDoesNotConflict() {
		traitRenamedRequiredMethodDoesNotConflict.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameRequiredMethodToProvidedAndSum() {
		classUsesTraitRenameRequiredMethodToProvidedAndSum.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameRequiredMethods() {
		traitRenameRequiredMethods.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameRequiredMethodToProvided() {
		traitRenameProvidedMethodToRequired.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameOperationsNotUsed() {
		traitRenameOperationsNotUsed.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameOperations() {
		traitRenameOperations.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameProvidedMethods() {
		traitRenameProvidedMethods.parseAndAssertNoErrors
	}

	@Test def void testTraitDoubleRenaming() {
		traitDoubleRenaming.parseAndAssertNoErrors
	}

//	@Test def void testTraitDoubleRenamingSeparateFiles() {
//		traitDoubleRenamingSeparateFiles.createResourceSet.compile[
//			expectationsForTraitDoubleRenaming(it)
//		]
//	}

	@Test def void testTraitRedefinitionByRenaming() {
		traitRedefinitionByRenaming.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameProvidedMethodToRequiredAndSum() {
		traitRenameProvidedMethodToRequiredAndSum.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameRequiredMethodProvidedByTrait() {
		traitRenameRequiredMethodProvidedByTrait.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameProvidedMethodToRequiredAndSum2() {
		traitRenameProvidedMethodToRequiredAndSum2.parseAndAssertNoErrors
	}

	@Test def void testTraitRenameRenamed() {
		traitRenameRenamed.parseAndAssertNoErrors
	}

	@Test def void testClassRenamesRequiredMethodToProvidedAndSum() {
		classRenamesRequiredMethodToProvidedAndSum.parseAndAssertNoErrors
	}

	@Test def void testRenameField() {
		classUsesTraitWithRenamedFields.parseAndAssertNoErrors
	}

	@Test def void testClassRenameField() {
		classRenameFields.parseAndAssertNoErrors
	}

	@Test def void testTraitHide() {
		// m will be hidden by T3
		traitHide.parseAndAssertNoErrors
	}

//	@Test def void testTraitHideSeparateFiles() {
//		// m will be hidden by T3
//		traitHideSeparateFiles.createResourceSet.compile[
//			expectationsForTraitHide(it)
//		]
//	}
	
	@Test def void testTraitAlias() {
		traitAlias.parseAndAssertNoErrors
	}

	@Test def void testTraitAliasWithRenameAndHide() {
		traitAliasWithRenameAndHide.parseAndAssertNoErrors
	}

//	@Test def void testTraitAliasWithRenameAndHideSeparateFiles() {
//		traitAliasWithRenameAndHideSeparateFiles.createResourceSet.compile[
//			expectationsForTraitAliasWithRenameAndHide(it)
//		]
//	}
	
	@Test def void testTraitRestrict() {
		traitRestrict.parseAndAssertNoErrors
	}

	@Test def void testTraitRestrictAndAlias() {
		traitRestrictAndAlias.parseAndAssertNoErrors
	}

	@Test def void testTraitRedirect() {
		traitRedirect.parseAndAssertNoErrors
	}
	
	@Test def void testTraitUsesGenericTraitWithRenameSimpler() {
		traitUsesGenericTraitWithRenameSimpler.parseAndAssertNoErrors
	}

//	@Test def void testTraitUsesGenericTraitWithRenameSimplerSeparateFiles() {
//		traitUsesGenericTraitWithRenameSimplerSeparateFiles.createResourceSet.compile[
//			expectationsForTraitUsesGenericTraitWithRenameSimpler(it)
//		]
//	}

	@Test def void testTraitUsesGenericTraitWithRename() {
		traitUsesGenericTraitWithRename.parseAndAssertNoErrors
	}

//	@Test def void testTraitUsesGenericTraitWithRenameSeparateFiles() {
//		traitUsesGenericTraitWithRenameSeparateFiles.createResourceSet.compile[
//			expectationsForTraitUsesGenericTraitWithRename(it)
//		]
//	}

	@Test def void traitRenameGenericFieldInstantiated() {
		classUsesTraitWithGenericRenamedFieldsInstantiated.parseAndAssertNoErrors
	}

//	@Test def void traitRenameGenericFieldInstantiatedSeparateFiles() {
//		classUsesTraitWithGenericRenamedFieldsInstantiatedSeparateFiles.createResourceSet.compile[
//			expectationsForTraitRenameGenericFieldInstantiated(it)
//		]
//	}

	@Test def void testRenameGenericFieldNotInstantiated() {
		traitRenameGenericFieldNotInstantiated.parseAndAssertNoErrors
	}

//	@Test def void testRenameGenericFieldNotInstantiatedSeparateFiles() {
//		traitRenameGenericFieldNotInstantiatedSeparateFiles.createResourceSet.compile[
//			expectationsForRenameGenericFieldNotInstantiated(it)
//		]
//	}

	@Test def void testUsesTraitWithRenameGenericMethod() {
		traitUsesTraitWithRenameGenericMethod.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesGenericTraitWithHide() {
		traitUsesGenericTraitWithHide.parseAndAssertNoErrors
	}

//	@Test def void testTraitUsesGenericTraitWithHideSeparateFiles() {
//		traitUsesGenericTraitWithHideSeparateFiles.createResourceSet.compile[
//			expectationsForTraitUsesGenericTraitWithHide(it)
//		]
//	}

	@Test def void testTraitUsesGenericTraitWithAlias() {
		traitUsesGenericTraitWithAlias.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesGenericTraitWithAliasRenameHide() {
		traitUsesGenericTraitWithAliasRenameHide.parseAndAssertNoErrors
	}

//	@Test def void testTraitUsesGenericTraitWithAliasRenameHideSeparateFiles() {
//		traitUsesGenericTraitWithAliasRenameHideSeparateFiles.createResourceSet.compile[
//			expectationsForTraitUsesGenericTraitWithAliasRenameHide(it)
//		]
//	}

	@Test def void testTraitUsesGenericTraitWithRestrict() {
		traitUsesGenericTraitWithRestrict.parseAndAssertNoErrors
	}

	@Test def void testTraitUsesGenericTraitWithRestrictAndAlias() {
		traitUsesGenericTraitWithRestrictAndAlias.parseAndAssertNoErrors
	}

//	@Test def void testTraitUsesGenericTraitWithRestrictAndAliasSeparateFiles() {
//		traitUsesGenericTraitWithRestrictAndAliasSeparateFiles.createResourceSet.compile[
//			expectationsForTraitUsesGenericTraitWithRestrictAndAlias(it)
//		]
//	}

	@Test def void testGenericFunctionAsField() {
		genericFunctionAsField.parseAndAssertNoErrors
	}

	@Test def void testPassTypeParameterAsTypeArgument() {
		passTypeParameterAsTypeArgument.parseAndAssertNoErrors
	}

//	@Test def void testPassTypeParameterAsTypeArgumentSeparateFiles() {
//		passTypeParameterAsTypeArgumentSeparateFiles.createResourceSet.compile[
//			expectationsForPassTypeParameterAsTypeArgument(it)
//		]
//	}
	
	@Test def void testTraitUsesGenericTraitWithRedirect() {
		traitUsesGenericTraitWithRedirect.parseAndAssertNoErrors
	}

//	@Test def void testTraitUsesGenericTraitWithRedirectSeparateFiles() {
//		traitUsesGenericTraitWithRedirectSeparateFiles.createResourceSet.compile[
//			expectationsForTraitUsesGenericTraitWithRedirect(it)
//		]
//	}

	@Test def void testAccessRenameGeneratedJavaCodeWithoutOriginalSource() {
		accessRenameGeneratedJavaCodeWithoutOriginalSource.parseAndAssertNoErrors
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
