package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.MyGenericAnnotatedJavaInterface
import xtraitj.input.tests.MyGenericAnnotatedJavaInterfaceDerived
import xtraitj.input.tests.MyGenericTestInterface
import xtraitj.input.tests.MyGenericTestInterfaceWithTwoTypeParameters
import xtraitj.input.tests.MyGenericThirdTestInterface
import xtraitj.jvmmodel.XtraitjJvmModelHelper
import xtraitj.jvmmodel.XtraitjResolvedOperations
import xtraitj.xtraitj.TJTrait

import static extension xtraitj.tests.utils.XtraitjTestsUtils.*
import static extension xtraitj.util.XtraitjModelUtil.*
import xtraitj.xtraitj.TJTraitReference
import xtraitj.jvmmodel.XtraitjJvmModelUtil

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjJvmModelHelperTest extends XtraitjAbstractTest {
	
	@Inject extension XtraitjJvmModelHelper
	@Inject extension XtraitjJvmModelUtil
	
	@Test def void testResolvedOperationsWithoutTypeArgument() {
		MyGenericTestInterface.assertResolvedOperations("m(List<Object>) : int")
	}
	
	@Test def void testResolvedOperationsWithTypeArgument() {
		MyGenericTestInterface.assertResolvedOperations("m(List<String>) : int",
			String
		)
	}

	@Test def void testResolvedOperationsWithTwoTypeArguments() {
		MyGenericTestInterfaceWithTwoTypeParameters.assertResolvedOperations(
			"m1(List<Integer>) : String; m2(List<String>, String) : Integer",
			String, Integer
		)
	}

	@Test def void testResolvedOperationsWithDifferentTypeArgumentNames() {
		MyGenericThirdTestInterface.assertResolvedOperations(
			"m3(List<Integer>) : Integer; m2(List<Integer>) : Integer; m1(List<Integer>) : Integer",
			Integer
		)
	}

	@Test def void testXtraitjResolvedOperations() {
		MyGenericAnnotatedJavaInterface.assertXtraitjResolvedOperations(
'''
requiredFields: getField() : Object
requiredMethods: getRequired(List<Object>) : Object
definedMethods: getDefined(List<Object>) : Object
'''
		)
	}

	@Test def void testXtraitjResolvedOperationsWithTypeArgument() {
		MyGenericAnnotatedJavaInterface.assertXtraitjResolvedOperations(
'''
requiredFields: getField() : String
requiredMethods: getRequired(List<String>) : String
definedMethods: getDefined(List<String>) : String
'''
		,
		String
		)
	}

	@Test def void testXtraitjResolvedOperationsWithTypeArgumentDerived() {
		MyGenericAnnotatedJavaInterfaceDerived.assertXtraitjResolvedOperations(
'''
requiredFields: getField2() : String; getField() : String
requiredMethods: getRequired2(List<String>) : String; getRequired(List<String>) : String
definedMethods: getDefined2(List<String>) : String; getDefined(List<String>) : String
'''
		,
		String
		)
	}

	@Test def void testDeclaredMethods() {
		// included both required and defined methods
		MyGenericAnnotatedJavaInterfaceDerived.assertDeclaredMethods(
'''
getRequired2(List<String>) : String
getRequired(List<String>) : String
getDefined2(List<String>) : String
getDefined(List<String>) : String'''
		,
		String
		)
	}

	@Test def void testAllDeclarations() {
		// included both required and defined methods
		MyGenericAnnotatedJavaInterfaceDerived.assertAllDeclarations(
'''
getField2() : String
getField() : String
getRequired2(List<String>) : String
getRequired(List<String>) : String
getDefined2(List<String>) : String
getDefined(List<String>) : String'''
		,
		String
		)
	}

	@Test def void testAllRequirements() {
		// included both required and defined methods
		MyGenericAnnotatedJavaInterfaceDerived.assertAllRequirements(
'''
getField2() : String
getField() : String
getRequired2(List<String>) : String
getRequired(List<String>) : String'''
		,
		String
		)
	}

	@Test def void testGetResolvedOperation() {
		// included both required and defined methods
		MyGenericAnnotatedJavaInterfaceDerived.assertResolvedOperation("getRequired2",
'''getRequired2(List<String>) : String'''
		,
		String
		)
	}

	@Test def void testGetXtraitjResolvedOperationsUsingJvmTypeReference() {
		'''
		trait T1 uses T2 {
			
		}
		
		trait T2 {
			String f;
			String m(int i);
			String n(int i) { return null; }
		}
		'''.firstTraitReference => [
			traitRef |
			traitRef.trait.getXtraitjResolvedOperations(traitRef).
			assertAllDeclarations(
'''
getF() : String
m(int) : String
n(int) : String'''
			)
		]
	}

	@Test def void testGetXtraitjResolvedOperationsAfterRenamingUsingJvmTypeReference() {
		// since we take the JvmTypeReference, alteration operations are not considered
		// i.e., we still see the original method
		'''
		trait T1 uses T2[rename field f to g, rename m to o] {
			
		}
		
		trait T2 {
			String f;
			String m(int i);
			String n(int i) { return null; }
		}
		'''.firstTraitReference => [
			traitRef |
			traitRef.trait.getXtraitjResolvedOperations(traitRef).
			assertAllDeclarations(
'''
getF() : String
m(int) : String
n(int) : String'''
			)
		]
	}

	@Test def void testGetTraitReferenceXtraitjResolvedOperations() {
		'''
		trait T1 uses T2 {
			
		}
		
		trait T2 {
			String f;
			String m(int i);
			String n(int i) { return null; }
		}
		'''.firstTraitReference => [
			traitRef |
			traitRef.getTraitReferenceXtraitjResolvedOperations(traitRef.containingDeclarationInferredType).
			assertAllDeclarations(
'''
getF() : String
m(int) : String
n(int) : String'''
			)
		]
	}

	@Test def void testGetTraitReferenceXtraitjResolvedOperationsAfterRenaming() {
		// renamed methods are considered instead of the original one
		'''
		trait T1 uses T2[rename field f to g, rename m to o] {
			
		}
		
		trait T2 {
			String f;
			String m(int i);
			String n(int i) { return null; }
		}
		'''.firstTraitReference => [
			traitRef |
			traitRef.getTraitReferenceXtraitjResolvedOperations(traitRef.containingDeclarationInferredType).
			assertAllDeclarations(
'''
getG() : String
o(int) : String
n(int) : String'''
			)
		]
	}

	/**
	 * Retrieves the first trait in the program
	 */
	private def firstTraitReference(CharSequence input) {
		input.firstTrait.traitExpression.references.head
	}

	/**
	 * Retrieves the first trait in the program
	 */
	private def firstTrait(CharSequence input) {
		input.parse.elements.head as TJTrait
	}

	def private assertResolvedOperations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		val operations = clazz.toResourceTypeRef(typeArguments).getOperations
		assertResolvedOperations(operations, expected)
	}
	
	private def assertResolvedOperations(Iterable<IResolvedOperation> operations, CharSequence expected) {
		expected.assertEqualsStrings(operations.map[
			simpleSignature + " : " + resolvedReturnType
		].join("; "))
	}

	def private assertXtraitjResolvedOperations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		var repr = ""
		val resolved = clazz.toResourceTypeRef(typeArguments).xtraitjResolvedOperations
		repr += "requiredFields: " +
			resolved.requiredFields.map[resolvedOperation.simpleSignature + " : " + resolvedOperation.resolvedReturnType].join("; ") + "\n"
		repr += "requiredMethods: " +
			resolved.requiredMethods.map[resolvedOperation.simpleSignature + " : " + resolvedOperation.resolvedReturnType].join("; ") + "\n"
		repr += "definedMethods: " +
			resolved.definedMethods.map[resolvedOperation.simpleSignature + " : " + resolvedOperation.resolvedReturnType].join("; ") + "\n"
		expected.assertEqualsStrings(repr)
	}

	def private assertResolvedOperation(Class<?> clazz, String methodName, CharSequence expected, Class<?>... typeArguments) {
		val typeRef = clazz.toResourceTypeRef(typeArguments)
		val op = typeRef.getJavaMethod(methodName)
		val resolved = typeRef.getResolvedOperation(typeRef, op)
		
		expected.assertEqualsStrings(resolved.simpleSignature + " : " + resolved.resolvedReturnType)
	}

	def private assertDeclaredMethods(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		val resolved = clazz.toResourceTypeRef(typeArguments).xtraitjResolvedOperations
		expected.assertEqualsStrings(
			resolved.declaredMethods.map[resolvedOperation.simpleSignature + " : " + resolvedOperation.resolvedReturnType].join("\n")
		)
	}

	def private assertAllDeclarations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		val resolved = clazz.toResourceTypeRef(typeArguments).xtraitjResolvedOperations
		assertAllDeclarations(resolved, expected)
	}
	
	private def assertAllDeclarations(XtraitjResolvedOperations resolved, CharSequence expected) {
		expected.assertEqualsStrings(
			resolved.allDeclarations.map[resolvedOperation.simpleSignature + " : " + resolvedOperation.resolvedReturnType].join("\n")
		)
	}

	def private assertAllRequirements(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		val resolved = clazz.toResourceTypeRef(typeArguments).xtraitjResolvedOperations
		expected.assertEqualsStrings(
			resolved.allRequirements.map[resolvedOperation.simpleSignature + " : " + resolvedOperation.resolvedReturnType].join("\n")
		)
	}

	def private containingDeclarationInferredType(TJTraitReference traitRef) {
		traitRef.containingDeclaration.associatedJavaType
	}
}