package xtraitj.input.tests

class XtraitjInputs {
	def traitSum() {
		'''
		package tests;
		
		trait T uses T1, T2, T3 {
			String m() {
				return t1().toString + t2().toString() + t3().toString()
			}
		}

		trait T1 {
			/* required method */
			Object t2();
			Object t1() { return "a"; }
		}
		trait T2 {
			Object t1(); // required
			Object t2() { return 1 + " - " + t1().toString() + " - "; }
		}
		trait T3 {
			Object t3() { return false; }
		}
		
		class C uses T { }
		'''
	}

	def traitUsesTraitWithTraitSum() {
		traitSum +
		'''
		trait T4 uses T {}
		
		class C4 uses T4 {}
		'''
	}

	def traitUsesTraitWithFields() {
		'''
		package tests;
		
		trait T {
			String s;
			String m() { 
				s = s.toFirstUpper
				return s;
			}
		}
		
		trait T2 uses T {}
		
		class C uses T2 {
			String s = "test";
		}
		'''
	}

	def traitDependency() {
		'''
		package tests;
		
		trait T uses T1, T2  {
			String f;
			String m() {
				return t1().toString + t2().toString() + t3().toString()
			}
		}

		trait T1 uses T3 {
			Object f1;
			Object t1() { return "a"; }
		}
		trait T2 uses T4, T5 {
			Object f2;
			Object t2() { return 1; }
			Object req2();
		}
		trait T3 {
			Object f3;
			Object t3() { return false; }
		}
		trait T4 {
			Object f4;
			Object t4() { return false; }
		}
		trait T5 {
			Object f5;
			Object t5() { return false; }
		}
		
		//class C uses T { }
		'''
	}

	def classUsesTraitWithDependencies() {
		'''
		«traitDependency»
		
		class C uses T {}
		'''
	}

	def classUsesTraitWithParameterizedFields() {
		'''
import java.util.List

trait T {
	List<Integer> integers;
}

class C uses T {
}
		'''
	}

	def classWithTraitSum() {
		'''
		package tests;
		
		trait T1 {
			int i;
			Object m2();
			Object m1() {
				if (i > 3)
					return i;
				i = i+1
				return m2();
			}
		}
		trait T2 {
			int i;
			Object m1();
			Object m2() {
				if (i > 3)
					return i;
				i = i+1
				return m1();
			}
		}
		
		class C uses T1, T2 {
			int i = 0;
		}
		'''
	}

	def traitWithDoubleApply() {
		'''
		package tests;
		
		trait T1 {
			int m() { return 2; }
		}
		trait T2 {
			int m() { return 3; }
		}
		
		trait TDouble {
			int m();
			int doubleApply() { return m() * m(); }
		}
		
		class C1 uses T1, TDouble {
			
		}
		
		class C2 uses T2, TDouble {
			
		}
		'''
	}

	def traitRenameOperationsNotUsed() {
		'''
		trait T1 {
			String s;
			int m() { return 0; }
			int t1() { return 0; }
		}
		
		trait T2 uses T1 {
			int n();
		}
		
		trait T3 uses T2[ rename m to m2, rename n to n2 ] {
			
		}
		'''
	}

	def traitRenameOperations() {
		'''
		trait T1 {
			String s;
			int m() { return 0; }
			int t1() { return 0; }
		}
		
		trait T2 uses T1 {
			int n();
		}
		
		trait T3 uses T2[ rename m to m2, rename n to n2 ] {
			int foo() { 
				return this.n2() + m2();
			}
		}
		'''
	}

	def traitRenameProvidedMethods() {
		'''
		package tests;
		
		trait T1 {
			String m() { return "T1.m;"; }
			String t1() { return "T1.t1;"; }
		}
		
		trait T2 uses T1 {
			String n() { return "T2.n;"; }
		}
		
		trait T3 uses T2[ rename m to m2, rename n to n2 ] {
			String foo() { 
				return n2() + m2() + t1();
			}
		}
		
		class C uses T3 {
			
		}
		'''
	}

	def traitRenameRequiredMethods() {
		'''
		package tests;
		
		trait T1 {
			String m() { return req1(); }
			String req1(); // required
		}
		
		trait T2 uses T1 {
			String n() { return m(); }
		}
		
		trait T3 uses T2[ rename req1 to req ] {
			String foo() { 
				return n();
			}
		}
		'''
	}

	def traitRenameProvidedMethodToRequiredAndSum() {
		'''
		package tests;
		
		trait T1 {
			int m1();
		}
		
		trait T2 {
			int m() { 0 }
		}
		
		// the provided method is renamed so that
		// it matches the required one
		trait T3 uses T2[rename m to m1], T1 {}
		'''
	}

	def classUsesTraitRenameProvidedMethodToRequiredAndSum() {
		'''
		«traitRenameProvidedMethodToRequiredAndSum»
		
		class C uses T3 {}
		'''
	}

	def traitRenameProvidedMethodToRequiredAndSum2() {
		'''
		package tests;
		
		trait T1 {
			int m1();
		}
		
		trait T2 {
			int m() { 0 }
		}
		
		// the provided method is renamed so that
		// it matches the required one
		trait T3 uses T1, T2[rename m to m1] {}
		'''
	}

	def classUsesTraitRenameProvidedMethodToRequiredAndSum2() {
		'''
		«traitRenameProvidedMethodToRequiredAndSum2»
		
		class C uses T3 {}
		'''
	}

	def traitRenameRequiredMethodToProvidedAndSum() {
		'''
		trait T1 {
			String m1();
			String callM1() { m1() }
		}
		
		trait T2 {
			String m() { "T2.m;" }
		}

		// the required method is renamed so that
		// it matches the provided one
		trait T3 uses T2, T1[rename m1 to m] 
		{}
		'''
	}

	def classUsesTraitRenameRequiredMethodToProvidedAndSum() {
		'''
		«traitRenameRequiredMethodToProvidedAndSum»
		
		class C uses T3 {}
		'''
	}

	def traitRenamedRequiredMethodDoesNotConflict() {
		'''
		trait T1 {
			String m1();
			String callM1() { m1() }
		}
		
		trait T2 {
			String m() { "T2.m;" }
			int m1(int i) { return i; }
		}

		// the required method is renamed so that
		// it matches the provided one
		// T2.m1 will not conflict at all
		trait T3 uses T2, T1[rename m1 to m] 
		{}
		
		class C uses T3 {}
		'''
	}

	def traitRenameRenamed() {
		'''
		package tests;
		
		trait T1 {
			String m() { return "m"; }
		}
		
		trait T2 uses T1[rename m to firstRename] {
			String callFirstRename() {
				return this.firstRename();
			}
		}
		
		trait T3 uses T2[rename firstRename to secondRename] {
			String callSecondRename() {
				return this.secondRename();
			}
		}
		
		class C uses T3 {}
		'''
	}

	def classRenamesRequiredMethodToProvidedAndSum() {
		'''
		package tests;
		
		trait T1 {
			String m1();
			String callM1() { m1() }
		}
		
		trait T2 {
			String m() { "T2.m;" }
		}
		
		// the required method is renamed so that
		// it matches the provided one
		class C uses T2, T1[rename m1 to m] {
			
		}
		'''
	}

	def traitRequiredMethodProvidedBySum() {
		'''
		package tests;
		
		trait T1 {
			int m1();
		}
		
		trait T2 {
			int m1() { 0 }
		}
		
		trait T3 uses T2, T1 {}
		'''
	}

	def traitRequiredMethodProvidedBySum2() {
		'''
		package tests;
		
		trait T1 {
			int m1();
		}
		
		trait T2 {
			int m1() { 0 }
		}
		
		trait T3 uses T1, T2 {}
		'''
	}

	def classUsesTraitWithRenamedRequiredMethods() {
		'''
		«traitRenameRequiredMethods»
		
		trait T4 {
			String req() { "req" }
		}
		
		class C uses T3, T4 {
			
		}
		'''
	}

	def traitRenameRequiredMethodProvidedByTrait() {
		'''
		package tests;
		
		trait T1 {
			String m() { return req1(); }
			String req1(); // required
		}
		
		trait T2 uses T1 {
			String n() { return m(); }
		}
		
		// a required method of the used trait, req1, is renamed
		// so that it matches the method req provided by this trait
		trait T3 uses T2[ rename req1 to req ] {
			String req() {
				return "T3.req"
			}
			String foo() { 
				return n();
			}
		}
		
		class C uses T3 {
			
		}
		'''
	}

	def traitRedefinitionByRenaming() {
		'''
		package tests;
		
		trait T1 {
			String m() { return "T1.m;"; }
		}
		
		trait T2 uses T1 {
			String n() { return "T2.n;"; }
		}
		
		// since m and n are renamed, we can (re)define a new
		// version in this trait
		trait T3 uses T2[ rename m to m2, rename n to n2 ] {
			String m() {
				return "T3." + m2();
			}
			String foo() { 
				return n2() + m();
			}
		}
		
		class C uses T3 {
			
		}
		'''
	}

	def traitDoubleRenaming() {
		'''
		package tests;
		
		trait T1 {
			String m() { return "T1.m;"; }
		}
		
		trait T2 uses T1 {
			String n() { return "T2.n;"; }
		}
		
		trait T3 uses T2[ rename m to m2, rename n to n2 ], 
		              T2[ rename m to m3, rename n to n3 ] {
			String m() {
				return "T3." + m2();
			}
			String foo() { 
				return n3() + m();
			}
		}
		
		class C uses T3 {
			
		}
		'''
	}

	def traitDoubleRenamingSeparateFiles() {
		#[
		'''
		package tests;
		
		class C uses T3 {
			
		}
		''',
		'''
		package tests;
		
		trait T3 uses T2[ rename m to m2, rename n to n2 ], 
		              T2[ rename m to m3, rename n to n3 ] {
			String m() {
				return "T3." + m2();
			}
			String foo() { 
				return n3() + m();
			}
		}
		''',
		'''
		package tests;
		
		trait T2 uses T1 {
			String n() { return "T2.n;"; }
		}
		''',
		'''
		package tests;
		
		trait T1 {
			String m() { return "T1.m;"; }
		}
		'''
		]
	}

	def traitRenameField() {
		'''
		package tests;
		
		trait T1 {
			String fieldS;
			String m() { return fieldS; }
		}
		
		trait T2 uses T1 {
			boolean fieldB;
			boolean n() { return fieldB; }
		}
		
		trait T3 uses T2[ rename field fieldS to s, rename field fieldB to b ] {
			String meth() {
				s = "foo"
				b = false
				return s + b;
			}
		}
		'''
	}

	def classUsesTraitWithRenamedFields() {
		'''
		«traitRenameField»
		
		class C uses T3 {
			boolean b = true;
			String s = "test";
		}
		'''
	}

	def classRenameFields() {
		'''
		package tests;
		
		trait T1 {
			String fieldS;
			String m() { return fieldS; }
		}
		
		trait T2 uses T1 {
			boolean fieldB;
			boolean n() { return fieldB; }
		}
		
		class C uses T2[ rename field fieldS to s, rename field fieldB to b ] {
			String s = "foo";
			boolean b = false;
		}
		'''
	}

	def traitHide() {
		'''
package tests;

trait T1 {
	String s;
	/* original version of m */
	String m() { return "T1.m;"; }
	String n() { return m(); }
}

trait T2 uses T1 {
	String p() { return m(); }
}

trait T3 uses T2[ hide m ] {
	/* independent new version of m */
	int m(int i) {
		return i;
	}
	String callN() { 
		return n() + p();
	}
	int callM() { 
		return m(10);
	}
}

class C uses T3 {
	String s = "";
}
		'''
	}

	def traitHideSeparateFiles() {
		#[
		'''
package tests;

trait T3 uses T2[ hide m ] {
	/* independent new version of m */
	int m(int i) {
		return i;
	}
	String callN() { 
		return n() + p();
	}
	int callM() { 
		return m(10);
	}
}
		''',
		'''
package tests;

class C uses T3 {
	String s = "";
}
		''',
		'''
package tests;

trait T2 uses T1 {
	String p() { return m(); }
}
		''',
		'''
package tests;

trait T1 {
	String s;
	/* original version of m */
	String m() { return "T1.m;"; }
	String n() { return m(); }
}
		'''
		]
	}

	def traitAlias() {
		'''
package tests;

trait T1 {
	String s;
	/* original version of m */
	String m() { return "T1.m;"; }
	String n() { return m(); }
}

trait T2 uses T1 {
	String p() { return m(); }
}

trait T3 uses T2[ alias m as oldm ] {
	String callN() { 
		return n() + p();
	}
	String callM() { 
		return m() + oldm();
	}
}

class C uses T3 {
	String s = "";
}
		'''
	}

	def traitAliasWithRenameAndHide() {
		'''
		package tests;
		
		trait T1 {
			String s;
			/* original version of m */
			String m() { return "T1.m;"; }
			/* original version of n */
			String n() { return "T1.n;"; }
		}
		
		trait T2 uses T1 {
			String p() { return m() + n(); }
		}
		
		trait T3 uses T2[ alias m as oldm, alias n as oldn,
		                  rename m to m1, hide n ] {
			/* independent version of n */
			String n(int i) {
				return oldn() + i + " - ";
			}
			String callN() { 
				return n(10) + p();
			}
			String callM() { 
				return m1() + oldm();
			}
		}
		
		class C uses T3 {
			String s = "";
		}
		'''
	}

	def traitAliasWithRenameAndHideSeparateFiles() {
		#[
		'''
		package tests;
		
		class C uses T3 {
			String s = "";
		}
		''',
		'''
		package tests;
		
		trait T3 uses T2[ alias m as oldm, alias n as oldn,
		                  rename m to m1, hide n ] {
			/* independent version of n */
			String n(int i) {
				return oldn() + i + " - ";
			}
			String callN() { 
				return n(10) + p();
			}
			String callM() { 
				return m1() + oldm();
			}
		}
		''',
		'''
		package tests;
		
		trait T2 uses T1 {
			String p() { return m() + n(); }
		}
		''',
		'''
		package tests;
		
		trait T1 {
			String s;
			/* original version of m */
			String m() { return "T1.m;"; }
			/* original version of n */
			String n() { return "T1.n;"; }
		}
		'''
		]
	}

	def traitRestrict() {
		'''
		package tests;
		
		trait T1 {
			String s;
			/* original version of m */
			String m() { return "T1.m;"; }
			String n() { return m(); }
		}
		
		trait T2 uses T1 {
			String p() { return m(); }
		}
		
		trait T3 uses T2[ restrict m ] {
			/* new version of m */
			String m() {
				return "T3.m;";
			}
			String callN() { 
				return n() + p();
			}
			String callM() { 
				return m();
			}
		}
		
		class C uses T3 {
			String s = "";
		}
		'''
	}

	def traitRestrictAndAlias() {
		'''
		package tests;
		
		trait T1 {
			String s;
			/* original version of m */
			String m() { return "T1.m;"; }
			String n() { return m(); }
		}
		
		trait T2 uses T1 {
			String p() { return m(); }
		}
		
		trait T3 uses T2[ alias m as oldm, restrict m ] {
			/* new version of m */
			String m() {
				return "T3.m;" + oldm();
			}
			String callN() { 
				return n() + p();
			}
			String callM() { 
				return m();
			}
		}
		
		class C uses T3 {
			String s = "";
		}
		'''
	}

	def traitPrivateMethod() {
		'''
		package tests;
		
		trait T1 {
			private String priv() { return "T1.priv;"; }
			String callPriv() { return priv(); }
		}
		
		class C uses T1 {
			String s = "";
		}
		'''
	}

	def traitRedirect() {
		'''
		package tests;
		
		trait T1 {
			String s1;
			String s2;
			String req();
			String prov() { return "prov"; }
			String callReq() { return req(); }
		}
		
		trait T2 uses T1 {
			String useField() { return s1; }
		}
		
		trait T3 uses T2[ redirect s1 to s2, redirect req to prov ] {
		}
		
		class C uses T3 {
			String s2 = "s2";
		}
		'''
	}

	def traitRequiredMethodProvidedWithCovariantReturnType() {
		'''
		package tests;
		
		import java.util.List
		import java.util.ArrayList
		
		trait T1 {
			List<? extends String> createList();
			String listToString() {
				createList().toString();
			}
		}
		
		trait T2 {
			ArrayList<String> createList() {
				newArrayList("1", "2", "3")
			}
		}
		
		class C uses T2, T1 {}
		'''
	}

	def classImplementsSerializableAndClonable() {
		'''
		package tests;
		
		import java.io.Serializable
		
		class C implements Serializable, Cloneable {
			
		}
		'''
	}

	def traitProvidesMethodToUsedTrait() {
		'''
		package tests;
		
		trait T1 {
			String req();
			String useReq() { return req(); }
		}
		
		trait T2 uses T1 {
			String req() { return "req"; }
		}
		
		class C uses T2 {}
		'''
	}

	def compliantRequiredFields() {
		'''
		package tests;
		
		trait T1 {
			String s;
			String m1() { return s; }
		}
		
		trait T2 {
			String s;
			String m2() { return s; }
		}
		
		trait T3 uses T1, T2 {
			String m3() { return s; }
		}
		
		class C uses T3 {
			String s = "s";
		}
		'''
	}

	def compliantRequiredFieldsWithGenerics() {
		'''
package tests;

import java.util.List

trait T1<T> {
	int i;
	List<String> ll;
}

trait T2  {
	int i;
	List<String> ll;
}

trait T3 uses T1<String>, T2 {
	
}
		'''
	}

	def compliantRequiredFieldsWithGenericsAfterTypeParamInstantiation() {
		'''
package tests;

import java.util.List

trait T1<T> {
	int i;
	List<T> ll;
}

trait T2  {
	int i;
	List<String> ll;
}

// the required field now has the same type List<String>
trait T3 uses T1<String>, T2 {
	
}
		'''
	}

	def compliantRequiredMethods() {
		'''
		package tests;
		
		trait T1 {
			String req();
			String m1() { return req(); }
		}
		
		trait T2 {
			String req();
			String m2() { return req(); }
		}
		
		trait T3 uses T1, T2 {
			String req() { return "req"; }
		}
		
		class C uses T3 {
			
		}
		'''
	}

	def compliantRequiredMethodsWithGenerics() {
		'''
package tests;

import java.util.List

trait T1<T> {
	int i();
	List<String> m();
}

trait T2  {
	int i();
	List<String> m();
}

trait T3 uses T1<String>, T2 {
	
}
		'''
	}

	def compliantRequiredMethodsWithGenericsAfterTypeParamInstantiation() {
		'''
package tests;

import java.util.List

trait T1<T> {
	int i();
	List<T> m();
}

trait T2  {
	int i();
	List<String> m();
}

// the required method now has the same type List<String>
trait T3 uses T1<String>, T2 {
	
}
		'''
	}

	def classImplementsAllInterfaceMethodsWithSum() {
		'''
		package tests;
		
		import xtraitj.input.tests.MyTestInterface
		import xtraitj.input.tests.MyTestInterface2
		import java.util.List
		
		trait T1 {
			int m(List<String> l) { return l.size }
		}
		
		trait T2 {
			List<Integer> n(int i) { return null; }
		}
		
		class C implements MyTestInterface, MyTestInterface2 uses T1, T2 {}
		'''
	}

	def classWithDefaultEmptyConstructor() {
		'''
		package tests;
		
		class C {
			String s;
			C() {}
		}
		'''
	}

	def classWithDefaultConstructor() {
		'''
		package tests;
		
		class C {
			String s;
			C() {
				s = "";
			}
		}
		'''
	}

	def classWithConstructors() {
		'''
		package tests;
		
		class C {
			String s;
			int i;
			C() {
				s = "";
				i = 0;
			}
			C(String mys) { s = mys; }
			C(int i, String s) {
				this.i = i;
				this.s = s;
			}
		}
		'''
	}

	def genericClass() {
		'''
		package tests;
		
		import java.util.List
		
		class C <T extends List<String>, U> {
			T t;
			U u;
			
			C(T t1, U u1) {
				t = t1
				u = u1
				val String s = t.head // since t is a List
				val int i = t.size // since t is a List
				println(i) println(s)
			}
		}
		'''
	}

	def genericTrait() {
		'''
		package tests;
		
		import java.util.List
		
		trait T1 <T extends List<String>, U> {
			T t;
			
			String m() {
				val t1 = t
				t = t1
				return t.head
			}
			
			T read_t() {
				val T t1 = t
				return t1
			}
			
			void update_t(T t) {
				this.t = t
			}
		}
		'''
	}

	def genericTraitWithRecursiveTypeParameterNotUsed() {
		'''
		package tests;
		
		trait T1 <T extends Comparable<T>> {
		}
		'''
	}

	def genericTraitWithRecursiveTypeParameterUsedInMethod() {
		'''
		package tests;
		
		trait T1 <T extends Comparable<T>> {
			int compare(T t1, T t2) {
				return t1.compareTo(t2)
			}
		}
		'''
	}

	def genericTraitWithRecursiveTypeParameter() {
		'''
		package tests;
		
		trait T1 <T extends Comparable<T>> {
			T t;
			
			int compare(T t1) {
				return t.compareTo(t1)
			}
		}
		'''
	}

	def genericTraitWithRecursiveTypeParameter2() {
		'''
		package tests;
		
		import java.util.List
		
		trait T1 <T extends Comparable<T>, U extends List<? extends T>> {
			T t;
			
			int compare(U t1) {
				return t.compareTo(t1.get(0))
			}
		}
		'''
	}

	def traitWithGenericMethod() {
		'''
		package tests;
		
		import java.util.List
		
		trait T1 {
			<T extends List<String>> String getFirst(T t) {
				return t.get(0)
			}
			
			<T extends Comparable<T>, U extends List<? extends T>> int compare(T t1, U t2) {
				return t1.compareTo(t2.get(0))
			}
		}
		
		trait T2 uses T1 {}
		
		trait T3 uses T2 {}
		
		class C uses T2 {}
		
		class C2 uses T1 {}
		'''
	}

	def traitUsingGenericMethod() {
'''
package tests;

//import java.util.ArrayList;

trait T1 {
	<T> T identity(T t) {
		return t
	}
	
	String useIdentity() {
		val s = identity("foo")
		val i = identity(0)
		val l = identity(newArrayList(true, false))
		return s + "," + i + "," + l
	}

	<V> V recursive(V v) {
		return recursive(recursive(v))
	}

	/**
	 * IMPORTANT:
	 * The generated Java code in T1Impl._noReturn() must be
	 * InputOutput.<U>println(u);
	 * Otherwise it means type parameter references are not correctly bound!
	 */
	<U> void noReturn(U u) {
		println(u)
	}

	void useRecursive() {
		println(recursive(0) + recursive("foo"))
	}

	String useIdentityNested() {
		val s = identity(identity("foo"))
		val i = identity(identity(0))
		val l = identity(identity(newArrayList(true, false)))
		return s + "," + i + "," + l
	}
	
	void useNoReturn() {
		noReturn("foo")
		noReturn(0)
	}
}

trait T2 uses T1 {
	String useIdentity2() {
		val s = identity("bar")
		return s + "," + useIdentity()
	}
	
	String useIdentityNested2() {
		val s = identity(identity("bar"))
		return s + "," + useIdentityNested()
	}
	
	void useNoReturn2() {
		noReturn("foo")
		noReturn(0)
	}
}

class C uses T1 {}

class C2 uses T2 {}
'''
	}

	def traitUsingGenericMethodSeparateFiles() {
#[
'''
package tests;

trait T1 {
	<T> T identity(T t) {
		return t
	}
	
	String useIdentity() {
		val s = identity("foo")
		val i = identity(0)
		val l = identity(newArrayList(true, false))
		return s + "," + i + "," + l
	}

	<V> V recursive(V v) {
		return recursive(recursive(v))
	}

	/**
	 * IMPORTANT:
	 * The generated Java code in T1Impl._noReturn() must be
	 * InputOutput.<U>println(u);
	 * Otherwise it means type parameter references are not correctly bound!
	 */
	<U> void noReturn(U u) {
		println(u)
	}

	void useRecursive() {
		println(recursive(0) + recursive("foo"))
	}

	String useIdentityNested() {
		val s = identity(identity("foo"))
		val i = identity(identity(0))
		val l = identity(identity(newArrayList(true, false)))
		return s + "," + i + "," + l
	}
	
	void useNoReturn() {
		noReturn("foo")
		noReturn(0)
	}
}
''',
'''
package tests;

trait T2 uses T1 {
	String useIdentity2() {
		val s = identity("bar")
		return s + "," + useIdentity()
	}
	
	String useIdentityNested2() {
		val s = identity(identity("bar"))
		return s + "," + useIdentityNested()
	}
	
	void useNoReturn2() {
		noReturn("foo")
		noReturn(0)
	}
}
''',
'''
package tests;

class C2 uses T2 {}
''',
'''
package tests;

class C uses T1 {}
'''
]
	}

	def traitWithGenericMethodShadowingTraitTypeParameter() {
		'''
		package tests;
		
		import java.util.List
		
		trait T1 <T> {
			<T extends List<String>> String getFirst(T t) {
				return t.get(0)
			}
		}
		'''
	}

	def traitUsesGenericTrait() {
		'''
		package tests;
		
		import java.util.List
		import java.util.Collection
		
		trait TGeneric<T extends Collection<String>> {
			
		}
		
		trait TUsesGeneric uses TGeneric<List<String>> {
			
		}
		
		class CUsesGeneric uses TGeneric<List<String>> {
			
		}
		'''
	}

	def traitUsesGenericTraitWithDefinedMethod() {
		'''
package tests;

import java.util.List

trait TGeneric<T> {
	T searchInList(List<T> l, T arg) {
		return l.findFirst[it === arg]
	}
}

trait TUsesGeneric uses TGeneric<String> {
}

class CUsesGeneric uses TUsesGeneric {
}
		'''
	}

	def traitUsesGenericTraitWithFields() {
		'''
package tests;

import java.util.List
import java.util.Collection
import java.util.Set

trait TGeneric<T extends Collection<String>, U extends Collection<Integer>> {
	T t;
	
	Iterable<T> iterableOfStrings;
	
	Iterable<U> iterableOfIntegers;
}

trait TUsesGeneric uses TGeneric<List<String>, Set<Integer>> {
	
}

trait T2 uses TUsesGeneric {
	
}

class CUsesGeneric uses TGeneric<List<String>, Set<Integer>> {
	List<String> t;
	
	Iterable<List<String>> iterableOfStrings;
	
	Iterable<Set<Integer>> iterableOfIntegers;
}

class CUsesGeneric2 uses T2 {
	List<String> t;
	
	Iterable<List<String>> iterableOfStrings;
	
	Iterable<Set<Integer>> iterableOfIntegers;
}
		'''
	}

	def traitUsesGenericTraitWithRequiredMethods() {
		'''
		package tests;
		
		import java.util.List
		import java.util.Collection
		import java.util.Set
		
		trait TGeneric<T extends String, U extends Collection<Integer>> {
			Iterable<T> iterableOfStrings();
			
			<V extends List<String>> String getFirst(V t);
		}
		
		trait TUsesGeneric uses TGeneric<String, Set<Integer>> {
			Iterable<String> iterableOfStrings() {
				return newArrayList('foo')
			}
			
			<V extends List<String>> String getFirst(V t) {
				return t.get(0);
			}
		}
		
		class CUsesGeneric uses TUsesGeneric {
		}
		'''
	}

	def requiredMethodsWithGenerics() {
		'''
		package tests;
		
		trait TGeneric<T extends String> {
			Iterable<T> iterableOfStrings();
		}
		
		trait TUsesGeneric uses TGeneric<String> {
			
		}
		
		trait T2 {
			Iterable<String> iterableOfStrings() {
				return newArrayList('foo')
			}
		}
		
		class CUsesGeneric uses TUsesGeneric, T2 {
		}
		
		class CUsesGeneric2 uses TGeneric<String>, T2 {
		}
		'''
	}

	def classImplementsAllGenericInterfaceMethods() {
		'''
		package tests;
		
		import xtraitj.input.tests.MyGenericTestInterface
		import xtraitj.input.tests.MyGenericTestInterface2
		import java.util.List
		
		trait T1 {
			int m(List<String> l) { return l.size }
		}
		
		trait T2 {
			List<Integer> n(int i) { return null; }
		}
		
		class C implements MyGenericTestInterface<String>, MyGenericTestInterface2<Integer> uses T1, T2 {}
		'''
	}

	def classImplementsAllGenericInterfaceMethods2() {
		'''
		package tests;
		
		import xtraitj.input.tests.MyGenericTestInterface3
		
		trait T1 {
			Integer n(int i) { return null; }
		}
		
		class C implements MyGenericTestInterface3<Integer> uses T1 {}
		'''
	}

	def classImplementsAllGenericInterfaceMethods3() {
		'''
		package tests;
		
		import xtraitj.input.tests.MyGenericTestInterface3
		
		trait T1<U> {
			U n(int i) { return null; }
		}
		
		class C<U> implements MyGenericTestInterface3<U> uses T1<U> {}
		'''
	}

	def classImplementsAllGenericInterfaceMethodsWithCovariantReturnType() {
		'''
		package tests;
		
		import xtraitj.input.tests.MyGenericTestInterface2
		import java.util.ArrayList
		
		trait T1<U> {
			ArrayList<U> n(int i) { return null; }
		}
		
		class C<U> implements MyGenericTestInterface2<U> uses T1<U> {}
		'''
	}

	def classImplementsAllGenericInterfaceMethodsWithCovariantReturnType2() {
		'''
		package tests;
		
		import xtraitj.input.tests.MyGenericTestInterface2
		import java.util.ArrayList
		
		trait T1<U> {
			ArrayList<U> n(int i) { return null; }
		}
		
		class C implements MyGenericTestInterface2<String> uses T1<String> {}
		'''
	}

	def traitWithTypeParametersWithDifferentNames() {
		'''
		package tests;
		
		trait T1<E1> {
			E1 fieldT1;
			E1 mT1() { return null; }
		}
		
		trait T2<G2> uses T1<G2> {
			G2 fieldT2;
			G2 mT2() { return null; }
		}
		
		trait T3<G3> uses T2<G3> {
			String meth() {
				println(fieldT1)
				val t1 = fieldT1
				fieldT1 = t1
				println(fieldT2)
				val t2 = fieldT2
				fieldT2 = t2
				return "foo" // t1 + t2;
			}
		}
		
		class C3<U> uses T3<U>{
			U fieldT1;
			U fieldT2;
		}
		'''
	}

	def traitWithTypeParametersWithDifferentNamesSeparateFiles() {
		#[
		'''
		package tests;
		
		trait T3<G3> uses T2<G3> {
			String meth() {
				println(fieldT1)
				val t1 = fieldT1
				fieldT1 = t1
				println(fieldT2)
				val t2 = fieldT2
				fieldT2 = t2
				return "foo" // t1 + t2;
			}
		}
		''',
		'''
		package tests;
		
		class C3<U> uses T3<U>{
			U fieldT1;
			U fieldT2;
		}
		''',
		'''
		package tests;
		
		trait T2<G2> uses T1<G2> {
			G2 fieldT2;
			G2 mT2() { return null; }
		}
		''',
		'''
		package tests;
		
		trait T1<E1> {
			E1 fieldT1;
			E1 mT1() { return null; }
		}
		'''
		]
	}

	def traitUsesGenericTraitWithRenameSimpler() {
		'''
package tests;

import java.util.List
import java.util.LinkedList

trait TGeneric<T> {
	List<T> returnList() {
		return new LinkedList<T>
	}
	void printList(List<T> l) {}
}

trait UsesTGeneric uses 
	TGeneric<Integer>[rename returnList to returnListOfInteger, rename printList to printListOfInteger]
{
	String useLists() {
		val intList = returnListOfInteger() => [add(1)]
		printListOfInteger(intList)
		return intList.toString
	}
}

class C uses UsesTGeneric {}
		'''
	}

	def traitUsesGenericTraitWithRenameSimplerSeparateFiles() {
		#[
		'''
package tests;

class C uses UsesTGeneric {}
		''',
		'''
package tests;

trait UsesTGeneric uses 
	TGeneric<Integer>[rename returnList to returnListOfInteger, rename printList to printListOfInteger]
{
	String useLists() {
		val intList = returnListOfInteger() => [add(1)]
		printListOfInteger(intList)
		return intList.toString
	}
}
		''',
		'''
package tests;

import java.util.List
import java.util.LinkedList

trait TGeneric<T> {
	List<T> returnList() {
		return new LinkedList<T>
	}
	void printList(List<T> l) {}
}
		'''
		]
	}

	def traitUsesGenericTraitWithRename() {
		'''
package tests;

import java.util.List
import java.util.LinkedList

trait TGeneric<T> {
	List<T> returnList() {
		return new LinkedList<T>
	}
}

trait UsesTGeneric uses 
	TGeneric<Integer>[rename returnList to returnListOfInteger],
	TGeneric<List<Integer>>[rename returnList to returnListOfListOfInteger],
	TGeneric<String> 
{
	String useLists() {
		val stringList = returnList() => [add("foo")]
		val intList = returnListOfInteger() => [add(1)]
		val intListList = returnListOfListOfInteger() => [
			add(
				returnListOfInteger() => [ add(2) ]
			)
		]
		(stringList.toString + intList.toString + intListList.toString)
	}
}

class C uses UsesTGeneric {}
		'''
	}

	def traitUsesGenericTraitWithRenameSeparateFiles() {
		#[
		'''
package tests;

class C uses UsesTGeneric {}
		''',
		'''
package tests;

import java.util.List

trait UsesTGeneric uses 
	TGeneric<Integer>[rename returnList to returnListOfInteger],
	TGeneric<List<Integer>>[rename returnList to returnListOfListOfInteger],
	TGeneric<String> 
{
	String useLists() {
		val stringList = returnList() => [add("foo")]
		val intList = returnListOfInteger() => [add(1)]
		val intListList = returnListOfListOfInteger() => [
			add(
				returnListOfInteger() => [ add(2) ]
			)
		]
		(stringList.toString + intList.toString + intListList.toString)
	}
}
		''',
		'''
package tests;

import java.util.List
import java.util.LinkedList

trait TGeneric<T> {
	List<T> returnList() {
		return new LinkedList<T>
	}
}
		'''
		]
	}

	def traitRenameGenericFieldInstantiated() {
		'''
		package tests;
		
		trait T1<E1> {
			E1 fieldS;
		}
		
		trait T2<G1,G2> uses T1<G1> {
			G2 fieldB;
		}
		
		trait T3 uses T2<String,Boolean>[ rename field fieldS to s, rename field fieldB to b ] {
			String meth() {
				s = "foo"
				b = false
				return s + b;
			}
		}
		'''
	}

	def classUsesTraitWithGenericRenamedFieldsInstantiated() {
		'''
		«traitRenameGenericFieldInstantiated»
		
		class C uses T3 {
			Boolean b = true;
			String s = "test";
		}
		'''
	}

	def classUsesTraitWithGenericRenamedFieldsInstantiatedSeparateFiles() {
		#[
		'''
		package tests;
		
		class C uses T3 {
			Boolean b = true;
			String s = "test";
		}
		''',
		'''
		package tests;
		
		trait T3 uses T2<String,Boolean>[ rename field fieldS to s, rename field fieldB to b ] {
			String meth() {
				s = "foo"
				b = false
				return s + b;
			}
		}
		''',
		'''
		package tests;
		
		trait T2<G1,G2> uses T1<G1> {
			G2 fieldB;
		}
		''',
		'''
		package tests;
		
		trait T1<E1> {
			E1 fieldS;
		}
		'''
		]
	}

	def traitRenameGenericFieldNotInstantiated() {
		'''
		package tests;
		
		trait T1<E1> {
			E1 fieldS;
		}
		
		trait T2<G1,G2> uses T1<G1> {
			G2 fieldB;
			
			String T2meth() {
				println(fieldS)
				val t = fieldS
				println(t)
				return "foo" // fieldS + fieldB;
			}
		}
		
		trait T3<U extends String,V> uses T2<U,V>[ rename field fieldS to s, rename field fieldB to b ] {
			String meth() {
				println(s)
				val t1 = s
				s = t1
				println(b)
				val t2 = b
				b = t2
				return "foo" // s + b;
			}
		}
		
		class C3<U extends String,V> uses T3<U,V>{
			U s;
			V b;
		}
		'''
	}

	def traitRenameGenericFieldNotInstantiatedSeparateFiles() {
		#[
		'''
		package tests;
		
		class C3<U extends String,V> uses T3<U,V>{
			U s;
			V b;
		}
		''',
		'''
		package tests;
		
		trait T3<U extends String,V> uses T2<U,V>[ rename field fieldS to s, rename field fieldB to b ] {
			String meth() {
				println(s)
				val t1 = s
				s = t1
				println(b)
				val t2 = b
				b = t2
				return "foo" // s + b;
			}
		}
		''',
		'''
		package tests;
		
		trait T2<G1,G2> uses T1<G1> {
			G2 fieldB;
			
			String T2meth() {
				println(fieldS)
				val t = fieldS
				println(t)
				return "foo" // fieldS + fieldB;
			}
		}
		''',
		'''
		package tests;
		
		trait T1<E1> {
			E1 fieldS;
		}
		'''
		]
	}

	def traitUsesGenericClass() {
'''
package tests;

import java.util.List;

trait T1<T> {
	T f;
	
	String m() {
		val c = new C<T>()
		// the class' field will be null
		// so we set it using our field
		// which is initialized by the specific class
		// where type parameters are instantiated
		c.f = f
		return c.n()
	}
	
	String n() {
		return f.toString;
	}
}

class C<U> uses T1<U> {
	U f;
}

class CString uses T1<String> {
	String f = "test";
}

class CInteger uses T1<Integer> {
	Integer f = 10;
}

class CListOfStrings uses T1<List<String>> {
	List<String> f = #["a", "b", "c"];
}
'''
	}

	def traitUsesGenericClassSeparateFiles() {
		#[
'''
package tests;

class C<U> uses T1<U> {
	U f;
}
''',
'''
package tests;

import java.util.List;

class CString uses T1<String> {
	String f = "test";
}

class CInteger uses T1<Integer> {
	Integer f = 10;
}

class CListOfStrings uses T1<List<String>> {
	List<String> f = #["a", "b", "c"];
}
''',
'''
package tests;

trait T1<T> {
	T f;
	
	String m() {
		val c = new C<T>()
		// the class' field will be null
		// so we set it using our field
		// which is initialized by the specific class
		// where type parameters are instantiated
		c.f = f
		return c.n()
	}
	
	String n() {
		return f.toString;
	}
}
'''
		]
	}

	def traitUsesTraitWithRenameGenericMethod() {
		'''
package tests;

import java.util.List

trait T1 {
	<T> List<T> returnList(T t) {
		return newArrayList(t)
	}
}

trait UsesTGeneric uses 
	T1[rename returnList to returnListOfInteger],
	T1 
{
	String useLists() {
		val stringList = returnList("bar") => [add("foo")]
		val intList = returnListOfInteger(0) => [add(1)]
		return stringList.toString + intList.toString
	}
}

class C uses UsesTGeneric {}
		'''
	}


	def traitUsesGenericTraitWithAlias() {
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> l;
	/* original version of m */
	T m() { 
		return l.get(0);
	}
	T n() { 
		return m();
	}
}

/* alias on a directly instantiated type parameter */
trait T2 uses T1<String>[ alias m as oldm ] {
	String p() { 
		return m() + oldm();
	}
}

trait T3 uses T1<String> {
	
}

/* alias on a indirectly instantiated type parameter */
trait T4 uses T3[ alias m as oldm ] {
	String p() { 
		return m() + oldm();
	}
}

class C uses T2 {
	List < String > l = newArrayList("foo", "bar");
}

class C2 uses T4 {
	List < String > l = newArrayList("foo", "bar");
}
'''
	}
	
	def traitUsesGenericTraitWithHide() {
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> l;
	/* original version of m */
	T m() { 
		return l.get(0);
	}
	T n() { 
		return m();
	}
}

trait T2 uses T1<String> {
	String p() { return m(); }
}

trait T3 uses T2[ hide m ] {
	/* independent new version of m */
	int m(int i) {
		return i;
	}
	String callN() { 
		return n() + p();
	}
	int callM() { 
		return m(10);
	}
}

trait T4 uses T1<String>[ hide m ] {
	/* independent new version of m */
	int m(int i) {
		return i;
	}
	String callN() { 
		return n() + m(10);
	}
	int callM() { 
		return m(10);
	}
}

class C uses T3 {
	List < String > l = newArrayList("foo", "bar");
}

class C2 uses T4 {
	List < String > l = newArrayList("foo", "bar");
}
		'''
	}

	def traitUsesGenericTraitWithHideSeparateFiles() {
		#[
		'''
package tests;

import java.util.List

class C uses T3 {
	List < String > l = newArrayList("foo", "bar");
}
		''',
		'''
package tests;

import java.util.List

class C2 uses T4 {
	List < String > l = newArrayList("foo", "bar");
}
		''',
		'''
package tests;

import java.util.List

trait T3 uses T2[ hide m ] {
	/* independent new version of m */
	int m(int i) {
		return i;
	}
	String callN() { 
		return n() + p();
	}
	int callM() { 
		return m(10);
	}
}
		''',
		'''
package tests;

trait T4 uses T1<String>[ hide m ] {
	/* independent new version of m */
	int m(int i) {
		return i;
	}
	String callN() { 
		return n() + m(10);
	}
	int callM() { 
		return m(10);
	}
}
		''',
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> l;
	/* original version of m */
	T m() { 
		return l.get(0);
	}
	T n() { 
		return m();
	}
}
		''',
		'''
package tests;

import java.util.List

trait T2 uses T1<String> {
	String p() { return m(); }
}
		'''
		]
	}

	def traitUsesGenericTraitWithRedirect() {
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> s1;
	List<T> s2;
	T req();
	T prov() { return s2.get(0); }
	T callReq() { return req(); }
}

trait T2 uses T1<String> {
	String useField() { return s1.get(0); }
}

trait T3 uses T2[ redirect s1 to s2, redirect req to prov ] {
}

trait T4 uses T1<String>[ redirect s1 to s2, redirect req to prov ] {
	String useField() { return s2.get(0); }
}

class C uses T3 {
	List < String > s2 = newArrayList("foo", "bar");
}

class C2 uses T4 {
	List < String > s2 = newArrayList("foo", "bar");
}
		'''
	}

	def traitUsesGenericTraitWithRestrict() {
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> s;
	/* original version of m */
	T m() { return s.get(0); }
	T n() { return m(); }
}

trait T2 uses T1<String> {
	String p() { return m(); }
}

trait T3 uses T2[ restrict m ] {
	/* new version of m */
	String m() {
		return "T3.m;";
	}
	String callN() { 
		return n() + p();
	}
	String callM() { 
		return m();
	}
}

trait T4 uses T1<String>[ restrict m ] {
	/* new version of m */
	String m() {
		return "T3.m;";
	}
	String callN() { 
		return n();
	}
	String callM() { 
		return m();
	}
}

class C uses T3 {
	List < String > s = newArrayList("foo", "bar");
}

class C2 uses T4 {
	List < String > s = newArrayList("foo", "bar");
}
		'''
	}

	def traitUsesGenericTraitWithRestrictAndAlias() {
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> s;
	/* original version of m */
	T m() { return s.get(0); }
	T n() { return m(); }
}

trait T2 uses T1<String> {
	String p() { return m(); }
}

trait T3 uses T2[ alias m as oldm, restrict m ] {
	/* new version of m */
	String m() {
		return "T3.m;" + oldm();
	}
	String callN() { 
		return n() + p();
	}
	String callM() { 
		return m();
	}
}

trait T4 uses T1<String>[ alias m as oldm, restrict m ] {
	/* new version of m */
	String m() {
		return "T3.m;" + oldm();
	}
	String callN() { 
		return n();
	}
	String callM() { 
		return m();
	}
}

class C uses T3 {
	List < String > s = newArrayList("foo", "bar");
}

class C2 uses T4 {
	List < String > s = newArrayList("foo", "bar");
}
		'''
	}

	def traitUsesGenericTraitWithRestrictAndAliasSeparateFiles() {
		#[
		'''
package tests;

import java.util.List

class C uses T3 {
	List < String > s = newArrayList("foo", "bar");
}
		''',
		'''
package tests;

import java.util.List

class C2 uses T4 {
	List < String > s = newArrayList("foo", "bar");
}
		''',
		'''
package tests;

trait T4 uses T1<String>[ alias m as oldm, restrict m ] {
	/* new version of m */
	String m() {
		return "T3.m;" + oldm();
	}
	String callN() { 
		return n();
	}
	String callM() { 
		return m();
	}
}
		''',
		'''
package tests;

trait T3 uses T2[ alias m as oldm, restrict m ] {
	/* new version of m */
	String m() {
		return "T3.m;" + oldm();
	}
	String callN() { 
		return n() + p();
	}
	String callM() { 
		return m();
	}
}
		''',
		'''
package tests;

trait T2 uses T1<String> {
	String p() { return m(); }
}
		''',
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> s;
	/* original version of m */
	T m() { return s.get(0); }
	T n() { return m(); }
}

		'''
		]
	}

	def traitUsesGenericTraitWithAliasRenameHide() {
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> s;
	/* original version of m */
	T m() { return s.get(0); }
	T n() { return m(); }
}

trait T2 uses T1<String> {
	String p() { return m() + n(); }
}

trait T3 uses T2[ alias m as oldm, alias n as oldn,
		                  rename m to m1, hide n ] {
	/* independent version of n */
	String n(int i) {
		return oldn() + i + " - ";
	}
	String callN() { 
		return n(10) + p();
	}
	String callM() { 
		return m1() + oldm();
	}
}

trait T4 uses T1<String>[ alias m as oldm, alias n as oldn,
		                  rename m to m1, hide n ] {
	/* independent version of n */
	String n(int i) {
		return oldn() + i + " - ";
	}
	String callN() { 
		return n(10);
	}
	String callM() { 
		return m1() + oldm();
	}
}

class C uses T3 {
	List < String > s = newArrayList("foo", "bar");
}

class C2 uses T4 {
	List < String > s = newArrayList("foo", "bar");
}
'''
	}

	def traitUsesGenericTraitWithAliasRenameHideSeparateFiles() {
		#[
		'''
package tests;

import java.util.List

class C uses T3 {
	List < String > s = newArrayList("foo", "bar");
}

class C2 uses T4 {
	List < String > s = newArrayList("foo", "bar");
}
''',
		'''
package tests;

trait T4 uses T1<String>[ alias m as oldm, alias n as oldn,
		                  rename m to m1, hide n ] {
	/* independent version of n */
	String n(int i) {
		return oldn() + i + " - ";
	}
	String callN() { 
		return n(10);
	}
	String callM() { 
		return m1() + oldm();
	}
}
''',
		'''
package tests;

trait T3 uses T2[ alias m as oldm, alias n as oldn,
		                  rename m to m1, hide n ] {
	/* independent version of n */
	String n(int i) {
		return oldn() + i + " - ";
	}
	String callN() { 
		return n(10) + p();
	}
	String callM() { 
		return m1() + oldm();
	}
}
''',
		'''
package tests;

trait T2 uses T1<String> {
	String p() { return m() + n(); }
}
''',
		'''
package tests;

import java.util.List

trait T1<T> {
	List<T> s;
	/* original version of m */
	T m() { return s.get(0); }
	T n() { return m(); }
}
'''
		]
	}

	def traitUsesGenericTraitWithWildCard() {
		'''
package tests;

import java.util.ArrayList
import java.util.List

trait TGeneric<T> {
	
	List<T> myL;
	
	List<? extends T> returnListOfT() {
		return myL
	}
	
	T searchInList(List<? extends T> l, T arg) {
		return l.findFirst[it === arg]
	}
	
	void addToListOfT(List<? super T> l, T arg) {
		l.add(arg)
	}
	
	void addToListOfTDefault(List<? super T> l) {
		l.add(myL.get(0))
	}
}

trait TUsesGeneric uses TGeneric<String> {
	String updateAndReturn() {
		addToListOfT(myL, "foo")
		addToListOfT(myL, "bar")
		searchInList(myL, "foo")
	}
}

class C uses TUsesGeneric {
	List<String> myL = new ArrayList<String>;
}
		'''
	}

	def traitWithGenericFunctionType() {
		'''
package tests;

import java.util.List
import java.util.ArrayList

trait TGenericExtensions<T> {
	Iterable<T> iterable;
	
	<R> List<R> mapToList((T) => R mapper) {
		val result = new ArrayList<R>()
		for (e : iterable) {
			result += mapper.apply(e)
		}
		return result
	}
	
	List<T> mapToList2((T) => T mapper) {
		val result = new ArrayList<T>()
		for (e : iterable) {
			result += mapper.apply(e)
		}
		return result
	}
}
		'''
	}

	def genericFunctionType() {
		'''
«traitWithGenericFunctionType»

trait TStringExtensions uses TGenericExtensions<String> {
	
}
		'''
	}

	def classUsesTraitWithGenericFunctionType() {
		'''
«traitWithGenericFunctionType»

class StringExtensions<U> uses TGenericExtensions<U> {
	Iterable<U> iterable
}
		'''
	}

	def classUsesTraitWithGenericFunctionTypeInstantiated() {
		'''
«traitWithGenericFunctionType»

class StringExtensions uses TGenericExtensions<String> {
	Iterable<String> iterable
}
		'''
	}

	def genericFunctionAsField() {
		'''
package tests;

import java.util.Iterator

/**
 * Acts as a wrapper for a Java Iterator
 */
trait TIterator<E> {
	Iterator<E> iterator;
	
	boolean hasNext() { return iterator.hasNext(); }
	E next() { return iterator.next(); }
	void remove() { iterator.remove(); }
}

trait TTransformerIterator<T,R> uses TIterator<T>[rename next to origNext] {
	(T) => R function;
	
	R next() {
		val T o = origNext();
		return function.apply(o);
	}
}
		'''
	}

	def passTypeParameterAsTypeArgument() {
'''
package tests;

import java.util.List

trait T1<T> {
	T s;
	T m() { return s }
}

trait TWithOp<Z> uses T1<Z>[hide m] {
	
}

trait T2<W> uses T1<W> {
	
}

trait T3<V> uses T2<List<V>> {
	
}

class C1<U> uses T2<U> {
	U s;
}

class C uses T2<String> {
	String s = "foo";
}

class C3 uses T3<String> {
	List<String> s = newArrayList("foo", "bar");
}

class CWithOp<Z> uses T1<Z>[hide m] {
	Z s;
}
'''
	}

	def passTypeParameterAsTypeArgumentSeparateFiles() {
		#[
'''
package tests;

class CWithOp<Z> uses T1<Z>[hide m] {
	Z s;
}
''',
'''
package tests;

class C uses T2<String> {
	String s = "foo";
}
''',
'''
package tests;

class C1<U> uses T2<U> {
	U s;
}
''',
'''
package tests;

import java.util.List

class C3 uses T3<String> {
	List<String> s = newArrayList("foo", "bar");
}
''',
'''
package tests;

import java.util.List

trait T3<V> uses T2<List<V>> {
	
}
''',
'''
package tests;

trait T2<W> uses T1<W> {
	
}
''',
'''
package tests;

trait TWithOp<Z> uses T1<Z>[hide m] {
	
}

''',
'''
package tests;

trait T1<T> {
	T s;
	T m() { return s }
}
'''
		]
	}

	def annotatedElements() {
'''
package tests;

import com.google.inject.Inject

trait T1 {
	String s;
	
	@SuppressWarnings("all")
	String m() { return s }
	
	String req();
}

trait T2 {
	String req() { return "foo" }
}

class C uses T1, T2 {
	@Inject
	String s = "bar";
}
'''
	}

	def elementsWithDocumentation() {
'''
package tests;

/**
 * My documented trait
 */
trait T {}

/**
 * My documented class
 */
class C {}
'''
	}
}
