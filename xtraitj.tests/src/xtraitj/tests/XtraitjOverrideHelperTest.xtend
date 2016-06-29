package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.input.tests.^override.renamed.MyAnnotatedJavaInterfaceWithDefined
import xtraitj.input.tests.^override.renamed.MyAnnotatedJavaInterfaceWithRenamed
import xtraitj.input.tests.^override.renamed.MyAnnotatedJavaInterfaceWithRenamedField
import xtraitj.input.tests.^override.required.UsesProvidesRequires
import xtraitj.input.tests.^override.required.UsesRequiresProvides
import xtraitj.typesystem.^override.XtraitjOverrideHelper
import xtraitj.typing.XtraitjTypingUtil

import static extension xtraitj.tests.utils.XtraitjTestsUtils.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjOverrideHelperTest extends XtraitjAbstractTest {
	
	@Inject extension XtraitjOverrideHelper
	@Inject extension XtraitjTypingUtil
	
	@Test def void testResolvedOperationsWithDefinedOverRequired() {
		MyAnnotatedJavaInterfaceWithDefined.assertAllOperations(
'''
getRequired() : String - [XtraitjDefinedMethod] - MyAnnotatedJavaInterfaceWithDefined
getDefined() : String - [XtraitjDefinedMethod] - MyAnnotatedJavaInterfaceWithDefined
getField() : String - [XtraitjRequiredField] - MyAnnotatedJavaInterfaceWithRequirements'''
		)
	}

	@Test def void testResolvedOperationsWithRenamed() {
		MyAnnotatedJavaInterfaceWithRenamed.assertAllOperations(
'''
getRequired() : String - [XtraitjDefinedMethod] - MyAnnotatedJavaInterfaceWithRenamed
getRenamed() : String - [XtraitjRenamedMethod] - MyAnnotatedJavaInterfaceWithRenamed
getDefined() : String - [XtraitjDefinedMethod] - MyAnnotatedJavaInterfaceWithDefined
getField() : String - [XtraitjRequiredField] - MyAnnotatedJavaInterfaceWithRequirements'''
		)
	}

	@Test def void testResolvedOperationsWithRenamedField() {
		MyAnnotatedJavaInterfaceWithRenamedField.assertAllOperations(
'''
getRequired() : String - [XtraitjDefinedMethod] - MyAnnotatedJavaInterfaceWithRenamedField
getRenamedField() : String - [XtraitjRenamedMethod, XtraitjRequiredField] - MyAnnotatedJavaInterfaceWithRenamedField
getDefined() : String - [XtraitjDefinedMethod] - MyAnnotatedJavaInterfaceWithDefined
getField() : String - [XtraitjRequiredField] - MyAnnotatedJavaInterfaceWithRequirements'''
		)
	}

	@Test def void testUsesRequiresProvides() {
		UsesRequiresProvides.assertAllOperations(
'''m() : void - [XtraitjDefinedMethod] - ProvidesMethod'''
		)
	}

	@Test def void testUsesProvidesRequires() {
		UsesProvidesRequires.assertAllOperations(
'''m() : void - [XtraitjDefinedMethod] - ProvidesMethod'''
		)
	}
	
	def private assertAllOperations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		val typeRef = clazz.toResourceTypeRef(typeArguments)
		val lightweightTypeRef = typeRef.toLightweightTypeReference(typeRef)
		expected.assertEqualsStrings(
			lightweightTypeRef.resolvedFeatures.allOperations.filter[
				declaration.declaringType.notJavaLangObject
			].map[
				simpleSignature + " : " + resolvedReturnType + " - " +
				declaration.annotations.map[annotation.simpleName] + " - " +
				declaration.declaringType.simpleName
			].join("\n"))
	}

}