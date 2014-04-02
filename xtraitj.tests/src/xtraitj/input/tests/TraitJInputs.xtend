package xtraitj.input.tests

class TraitJInputs {
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
				return n2() + m2();
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
		
		trait T3 uses T2[ rename fieldS to s, rename fieldB to b ] {
			String meth() { return s + b; }
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
		'''
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
		
		class CUsesGeneric uses TGeneric<List<String>, Set<Integer>> {
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
}
