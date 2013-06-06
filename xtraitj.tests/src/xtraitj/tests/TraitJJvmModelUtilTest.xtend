package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.input.tests.TraitJInputs
import xtraitj.jvmmodel.TraitJJvmModelUtil
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitExpression
import xtraitj.xtraitj.TJTraitReference

import static extension org.junit.Assert.*
import static extension xtraitj.util.TraitJModelUtil.*
import xtraitj.XtraitjInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class TraitJJvmModelUtilTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	@Inject extension TraitJInputs
	@Inject extension TraitJJvmModelUtil

	@Test def void testAssociations() {
		'''
		trait T uses T1 {}
		trait T1 {
			Object m() { return null; }
		}
		'''.parse => [
			assertNoErrors
			traits.get(0).assertAssociatedInterface("T")
			traits.get(0).assertAssociatedClass("TImpl")
			traits.get(0).traitExpression.
				assertAssociatedInterface("T1")
		]
	}

	@Test def void testTraitJvmAllFeatures() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).assertJvmFeatures("getF, setF, m, t1, t2, getF1, setF1, t3, getF3, setF3, getF2, setF2, req2, t4, t5, getF4, setF4, getF5, setF5")
		]
	}

	@Test def void testTraitJvmAllOperations() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).assertJvmOperations("getF, setF, m, t1, t2, getF1, setF1, t3, getF3, setF3, getF2, setF2, req2, t4, t5, getF4, setF4, getF5, setF5")
		]
	}

	@Test def void testTraitExpressionAllJvmFeatures() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).traitExpression.traitReferences => [
				get(0).assertJvmFeatures("getF1, setF1, t1, t3, getF3, setF3")
				get(1).assertJvmFeatures("getF2, setF2, t2, req2, t4, t5, getF4, setF4, getF5, setF5")
			]
		]
	}

	@Test def void testTraitExpressionAllJvmOperations() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).traitExpression.traitReferences => [
				get(0).assertJvmOperations("getF1, setF1, t1, t3, getF3, setF3")
				get(1).assertJvmOperations("getF2, setF2, t2, req2, t4, t5, getF4, setF4, getF5, setF5")
			]
		]
	}

	@Test def void testTraitExpressionAllJvmMethodOperations() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).traitExpression.traitReferences => [
				get(0).assertJvmMethodOperations("t1, t3")
				get(1).assertJvmMethodOperations("t2, t4, t5")
			]
		]
	}

	@Test def void testAllJvmMethodOperationsWithPrivate() {
		traitPrivateMethod.parse => [
			assertNoErrors
			classes.head.traitExpression.traitReferences => [
				get(0).assertJvmMethodOperations("callPriv")
			]
		]
	}

	@Test def void testClassAllJvmMethodOperations() {
		classUsesTraitWithDependencies.parse.classes.head.
			assertJvmMethodOperations("m, t1, t2, t3, t4, t5")
	}

	@Test def void testAllJvmFieldsOperations() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).traitExpression.traitReferences => [
				get(0).assertJvmFieldsOperations("getF1, setF1, getF3, setF3")
				get(1).assertJvmFieldsOperations("getF2, setF2, getF4, setF4, getF5, setF5")
			]
		]
	}

	@Test def void testAllJvmRequiredFieldOperations() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).traitExpression.traitReferences => [
				get(0).assertJvmRequiredFieldOperations("getF1, getF3")
				get(1).assertJvmRequiredFieldOperations("getF2, getF4, getF5")
			]
		]
	}

	@Test def void testDefines() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0) => [
				assertTrue(defines(jvmAllOperations.findFirst[simpleName == "m"]))
				assertFalse(defines(jvmAllOperations.findFirst[simpleName == "t1"]))
			]
		]
	}

	@Test def void testIsRequiredMethod() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).jvmAllOperations => [
				memberByName("t1").assertRequired(false)
				memberByName("req2").assertRequired(true)
			]
		]
	}

	@Test def void testIsRequiredMethodFromSum() {
		traitSum.parse => [
			assertNoErrors
			traits.get(0).jvmAllOperations => [
				memberByName("t1").assertRequired(false)
				memberByName("t2").assertRequired(false)
			]
			traits.get(1).jvmAllOperations => [
				memberByName("t1").assertRequired(false)
				memberByName("t2").assertRequired(true)
			]
		]
	}

	@Test def void testIsRequiredField() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).jvmAllOperations => [
				memberByName("getF2").assertRequired(true)
				memberByName("getF3").assertRequired(true)
			]
		]
	}

	@Test def void testFieldRepresentation() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0).traitExpression.traitReferences => [
				get(0).jvmAllFieldOperations => [
					get(0).assertFieldRepresentation("Object f1")
					get(2).assertFieldRepresentation("Object f3")
				]
			]
		]
		
		traitRenameField.parse => [
			assertNoErrors
			traits.get(2).traitExpression.traitReferences => [
				get(0).jvmAllFieldOperations => [
					get(0).assertFieldRepresentation("boolean b")
				]
			]
		]
	}

	@Test def void testMethodRepresentation() {
		'''
		import java.util.List
		import java.util.Set
		
		trait T {
			int m(List<String> l, Object o);
			Set<? extends String> n() { return null; }
		}
		'''.parse.traits.head.jvmAllOperations => [
			get(0).assertMethodRepresentation("Set<? extends String> n()")
			get(1).assertMethodRepresentation("int m(List<String>, Object)")
		]
	}

	@Test def void testMemberRepresentation() {
		'''
		import java.util.List
		import java.util.Set
		
		trait T {
			int m(List<String> l, Object o);
			Set<? extends String> f;
		}
		'''.parse.traits.head => [
			jvmAllRequiredMethodOperations.get(0).
				assertMemberRepresentation("int m(List<String>, Object)")
			jvmAllFieldOperations.get(0).
				assertMemberRepresentation("Set<? extends String> f")
		]
	}

	@Test def void testClassRequiredFields() {
		classUsesTraitWithDependencies.parse.classes.head.
			assertAllRequiredFieldOperations
			("String f, Object f1, Object f3, Object f2, Object f4, Object f5")
		
		classUsesTraitWithRenamedFields.parse.classes.head.
			assertAllRequiredFieldOperations
			("boolean b, String s")
	}

	@Test def void testTraitAllJvmRequiredMethods() {
		'''
		trait T uses T1 {}
		
		trait T1 uses T2 {
			Object req1();
		}
		
		trait T2 {
			Object req2();
		}
		'''.parse => [
			traits.get(0).traitExpression.assertJvmRequiredMethodOperations
				("req1, req2")
		]
	}

	@Test def void testTraitAllJvmRequiredMethodsWhenRenamed() {
		'''
		«traitRenameRequiredMethods»
		
		trait T4 uses T3 {}
		'''.parse => [
			traits.last.traitExpression.assertJvmRequiredMethodOperations
				("req")
			traits.get(1).traitExpression.assertJvmRequiredMethodOperations
				("req1")
		]
	}

	@Test def void testClassAllJvmRequiredMethodsWhenRenamed() {
		'''
		«traitRenameRequiredMethods»
		
		class C uses T3 {}
		'''.parse.classes.head.assertJvmRequiredMethodOperations
				("req")
	}

	@Test def void testFindMatchingField() {
		'''
		trait T1 {
			String o;
			int j;
		}
		class C1 uses T1 {
			int i;
			String o;
		}
		'''.parse => [
			classes.head => [
				fields.assertFoundField
					(jvmAllRequiredFieldOperations.get(0), fields.get(1))
				fields.assertFoundField
					(jvmAllRequiredFieldOperations.get(1), null)
			]
		]
	}

	@Test def void testFindMatchingFieldWithRenamedField() {
		classUsesTraitWithRenamedFields.parse => [
			classes.head => [
				fields.assertFoundField
					(jvmAllRequiredFieldOperations.get(0), fields.get(0))
				fields.assertFoundField
					(jvmAllRequiredFieldOperations.get(1), fields.get(1))
			]
		]
	}

	@Test def void testFindMatchingMethod() {
		'''
		trait T1 {
			int m();
			String n();
		}
		
		trait T2 {
			int m() { 0 }
		}
		
		class C1 uses T1, T2 {
		}
		'''.parse => [
			val traits = traits
			classes.head => [
				jvmAllMethodOperations.assertFoundMethod
					(jvmAllRequiredMethodOperations.get(0), 
						traits.get(1).methods.head)
				jvmAllMethodOperations.assertFoundMethod
					(jvmAllRequiredMethodOperations.get(1), null)
			]
		]
	}

	@Test def void testFindMatchingMethodWithSubtypeReturn() {
		'''
		import java.util.List
		import java.util.ArrayList
		
		trait T1 {
			List<? extends String> m();
			List<String> n();
		}
		
		trait T2 {
			// this fulfills T1's m requirement
			// since ArrayList<String> <: List<? extends String>
			ArrayList<String> m() { return null; }
			
			// this won't fulfill T1's n requirement
			// since List<? extends String> is NOT <: List<String>
			List<? extends String> n() { return null; }
		}
		
		class C1 uses T1, T2 {
		}
		'''.parse => [
			val traits = traits
			classes.head => [
				jvmAllMethodOperations.assertFoundMethod
					(jvmAllRequiredMethodOperations.get(0), 
						traits.get(1).methods.head)
				jvmAllMethodOperations.assertFoundMethod
					(jvmAllRequiredMethodOperations.get(1), null)
			]
		]
	}

	@Test def void testFindMatchingMethodWhenRenamed() {
		'''
		trait T1 {
			int m1();
			String n();
		}
		
		trait T2 {
			int m() { 0 }
		}
		
		trait T3 uses T2[rename m to m1], T1 {}
		
		class C1 uses T3 {
		}
		'''.parse => [
			val traits = traits
			//assertNoErrors
			classes.head => [
				val ops = jvmAllMethodOperations
				// T1.m1 required is found (corresponds to T2.m renamed)
				ops.assertFoundMethod
					(traits.get(0).jvmAllRequiredMethodOperations.get(0), 
						traits.get(1).methods.head)
				// T1.n is not found
				jvmAllMethodOperations.assertFoundMethod
					(traits.get(0).jvmAllRequiredMethodOperations.get(1), null)
			]
		]
	}

	@Test def void testFindMatchingMethodWhenRenamed2() {
		'''
		trait T1 {
			int m1();
			String n();
		}
		
		trait T2 {
			int m() { 0 }
		}
		
		trait T3 uses T1, T2[rename m to m1] {}
		
		class C1 uses T3 {
		}
		'''.parse => [
			val traits = traits
			//assertNoErrors
			classes.head => [
				val ops = jvmAllMethodOperations
				// T1.m1 required is found (corresponds to T2.m renamed)
				ops.assertFoundMethod
					(traits.get(0).jvmAllRequiredMethodOperations.get(0), 
						traits.get(1).methods.head)
				// T1.n is not found
				jvmAllMethodOperations.assertFoundMethod
					(traits.get(0).jvmAllRequiredMethodOperations.get(1), null)
			]
		]
	}

	@Test def void testSourceMethod() {
		traitDependency.parse => [
			assertNoErrors
			traits.get(0) => [
				assertSourceMethod("m", "String m()")
				assertSourceMethod("t1", "Object t1()")
			]
		]
	}

	@Test def void testSourceRenamedMethod() {
		'''
		«traitRenameOperations»
		
		trait T4 uses T3 {}
		'''.parse => [
			assertNoErrors
			traits.get(2) => [
				assertSourceMethod("m2", "int m()")
				assertSourceRequiredMethod("n2", "int n()")
			]
			traits.get(3) => [
				assertSourceMethod("m2", "int m()")
				assertSourceRequiredMethod("n2", "int n()")
			]
		]
	}

	@Test def void testSourceRenameRenamedMethod() {
		traitRenameRenamed.parse => [
			assertNoErrors
			traits.get(1) => [
				assertSourceMethod("firstRename", "String m()")
			]
			traits.get(2) => [
				assertSourceMethod("secondRename", "String m()")
			]
		]
	}

	@Test def void testSourceMethodWhenSplitInTwoFiles() {
		val rs = '''
		trait T1 {
			String m() { return null; }
		}
		'''.parse.eResource.resourceSet
		
		'''
		trait T2 uses T1[alias m as newM] {
			
		}
		'''.parse(rs) => [
			assertNoErrors
			traits.get(0) => [
				assertSourceMethod("newM", "String m()")
			]
		]
	}

	@Test def void testSourceRequiredMethodProvidedBySum() {
		traitRequiredMethodProvidedBySum.parse => [
			assertNoErrors
			traits.get(2) => [
				assertSourceMethod("m1", "int m1()")
			]
		]
	}

	@Test def void testSourceRequiredMethodProvidedBySum2() {
		traitRequiredMethodProvidedBySum2.parse => [
			assertNoErrors
			traits.get(2) => [
				assertSourceMethod("m1", "int m1()")
			]
		]
	}

	@Test def void testSourceRenamedMethodAndSum() {
		traitRenameProvidedMethodToRequiredAndSum.parse => [
			assertNoErrors
			traits.get(2) => [
				assertSourceMethod("m1", "int m()")
			]
		]
	}

	@Test def void testSourceRenamedMethodAndSum2() {
		traitRenameProvidedMethodToRequiredAndSum2.parse => [
			assertNoErrors
			traits.get(2) => [
				assertSourceMethod("m1", "int m()")
			]
		]
	}

	@Test def void testRestrictedConsideredRequired() {
		traitRestrict.parse => [
			assertNoErrors
			traits.last.traitExpression.
				references.head.jvmAllOperations => [
				memberByName("m").assertRequired(true)
			]
		]
	}

	@Test def void testSourceRestricted() {
		'''
		trait T uses T1 {}
		
		trait T1 uses T2[ restrict m ] {
		}
		
		trait T2 {
			Object m() { null }
		}
		'''.parse.traits.head.assertSourceRestricted("m")
	}

	@Test def void testTraitAllJvmRequiredMethodsWithRestricted() {
		'''
		trait T uses T1 {}
		
		trait T1 uses T2[ restrict m ] {
		}
		
		trait T2 {
			Object m() { null }
		}
		'''.parse.traits.head.assertJvmRequiredMethodOperations
				("m")
	}
	
	@Test def void testClassJvmAllMethods() {
		classUsesTraitWithDependencies.parse.classes.head.
			jvmAllMethods.map[simpleName].toList => [
				contains("m").assertTrue
				contains("t1").assertTrue
				// and the ones from Object 
				contains("notify").assertTrue
				contains("wait").assertTrue
			]
	}

	@Test def void testClassJvmAllInterfaceMethods() {
		'''
		class C implements java.util.List {}
		'''.parse.classes.head.
			jvmAllInterfaceMethods.map[simpleName].toList => [
				contains("listIterator").assertTrue
				contains("add").assertTrue
				contains("removeAll").assertTrue
				// methods from java.lang.Object should not be considered
				contains("notify").assertFalse
			]
	}
	
	@Test def void testCompliant() {
		'''
		import java.util.List
		
		trait T {
			int m(List<String> l) { return 0; }
			int n(List<String> l) { return 0; }
			int o(List<String> l, int j) { return 0; }
			boolean p(List<String> l) { return false; }
			int q(List<Integer> l) { return 0; }
			int r(List<? extends String> l) { return 0; }
		}
		'''.parse.traits.head.jvmAllOperations => [
			get(0).assertCompliant(get(0), true)
			get(1).assertCompliant(get(0), true)
			get(2).assertCompliant(get(0), false)
			get(3).assertCompliant(get(0), false)
			get(4).assertCompliant(get(0), false)
			get(5).assertCompliant(get(0), false)
		]
	}

	def private assertAssociatedInterface(TJTrait o, String expectedName) {
		expectedName.assertEquals(o.associatedInterface.simpleName)
	}

	def private assertAssociatedClass(TJTrait o, String expectedName) {
		expectedName.assertEquals(o.associatedClass.simpleName)
	}

	def private assertAssociatedInterface(TJTraitExpression o, String expectedName) {
		o.references.head.assertAssociatedInterface(expectedName)
	}

	def private assertAssociatedInterface(TJTraitReference o, String expectedName) {
		expectedName.assertEquals(o.associatedInterface.simpleName)
	}

	def private assertJvmFeatures(TJTrait o, String expected) {
		expected.assertEquals(
			o.jvmAllFeatures.map[simpleName].join(", ")
		)
	}

	def private assertJvmOperations(TJTrait o, String expected) {
		expected.assertEquals(
			o.jvmAllOperations.map[simpleName].join(", ")
		)
	}

	def private assertJvmOperations(TJTraitReference o, String expected) {
		expected.assertEquals(
			o.jvmAllOperations.map[simpleName].join(", ")
		)
	}

	def private assertJvmFeatures(TJTraitReference o, String expected) {
		expected.assertEquals(
			o.jvmAllFeatures.map[simpleName].join(", ")
		)
	}

	def private assertJvmMethodOperations(TJTraitReference o, String expected) {
		expected.assertEquals(
			o.jvmAllMethodOperations.map[simpleName].join(", ")
		)
	}

	def private assertJvmMethodOperations(TJClass o, String expected) {
		expected.assertEquals(
			o.jvmAllMethodOperations.map[simpleName].join(", ")
		)
	}

	def private assertJvmFieldsOperations(TJTraitReference o, String expected) {
		expected.assertEquals(
			o.jvmAllFieldOperations.map[simpleName].join(", ")
		)
	}

	def private assertJvmRequiredFieldOperations(TJTraitReference o, String expected) {
		expected.assertEquals(
			o.jvmAllRequiredFieldOperations.map[simpleName].join(", ")
		)
	}

	def private assertJvmRequiredMethodOperations(TJTraitExpression o, String expected) {
		o.references.head.assertJvmRequiredMethodOperations(expected)
	}

	def private assertJvmRequiredMethodOperations(TJTraitReference o, String expected) {
		expected.assertEquals(
			o.jvmAllRequiredMethodOperations.map[simpleName].join(", ")
		)
	}

	def private assertJvmRequiredMethodOperations(TJTrait o, String expected) {
		expected.assertEquals(
			o.jvmAllRequiredMethodOperations.map[simpleName].join(", ")
		)
	}

	def private assertJvmRequiredMethodOperations(TJClass o, String expected) {
		expected.assertEquals(
			o.jvmAllRequiredMethodOperations.map[simpleName].join(", ")
		)
	}

	def private assertRequired(JvmMember m, boolean expected) {
		assertNotNull("member is null", m)
		expected.assertEquals(m.required)
	}

	def private assertMemberRepresentation(JvmMember o, String expected) {
		expected.assertEquals(o.memberRepresentation)
	}

	def private assertFieldRepresentation(JvmOperation o, String expected) {
		expected.assertEquals(o.fieldRepresentation)
	}

	def private assertMethodRepresentation(JvmOperation o, String expected) {
		expected.assertEquals(o.methodRepresentation)
	}

	def private assertAllRequiredFieldOperations(TJClass c, String expected) {
		expected.assertEquals
			(c.jvmAllRequiredFieldOperations.map[fieldRepresentation].join(", "))
	}

	def private assertFoundField(Iterable<? extends TJField> fields, JvmOperation member, TJField expected) {
		expected.assertSame(fields.findMatchingField(member))
	}

	def private assertFoundMethod(Iterable<? extends JvmOperation> operations, JvmOperation member, TJMethod expected) {
		expected.assertSame(operations.findMatchingMethod(member).sourceMethod)
	}
	
	def private assertSourceMethod(TJTrait e, String name, String expected) {
		expected.assertEquals(
			e._jvmAllFeatures.findFirst[simpleName == name].
				sourceMethod.representationWithTypes
		)
	}

	def private assertSourceRequiredMethod(TJTrait e, String name, String expected) {
		expected.assertEquals(
			e._jvmAllFeatures.findFirst[simpleName == name].
				sourceRequiredMethod.representationWithTypes
		)
	}

	def private assertSourceRestricted(TJTrait e, String name) {
		name.assertEquals(
			e._jvmAllFeatures.findFirst[simpleName == name].
				sourceRestricted.member.simpleName
		)
	}
	
	def private assertCompliant(JvmOperation o1, JvmOperation o2, boolean expectedTrue) {
		assertEquals(
			o1.memberRepresentation + " compliant to " + o2.memberRepresentation +
			" expected " + expectedTrue,
			expectedTrue,
			o1.compliant(o2) 
		)
	}

}