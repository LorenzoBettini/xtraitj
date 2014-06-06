package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.xtraitj.TJProgram
import xtraitj.input.tests.XtraitjInputs

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(InjectorProviderCustom))
class XtraitjCompilerTest extends AbstractXtraitjCompilerTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension CompilationTestHelper
	@Inject extension XtraitjInputs
	
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
		'''.compile [
assertTraitJavaInterface("T",
'''
package traits;

import java.util.List;

@SuppressWarnings("all")
public interface T {
  public abstract List<Integer> getF();
  
  public abstract void setF(final List<Integer> f);
  
  public abstract boolean isB();
  
  public abstract void setB(final boolean b);
  
  public abstract Object m(final List<String> l, final String s);
  
  public abstract boolean abM(final String s);
  
  public abstract void abV();
}
''')
assertTraitJavaClass("T",
'''
package traits.impl;

import java.util.ArrayList;
import java.util.List;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import traits.T;

@SuppressWarnings("all")
public class TImpl implements T {
  private T _delegate;
  
  public TImpl(final T delegate) {
    this._delegate = delegate;
  }
  
  public List<Integer> getF() {
    return _delegate.getF();
  }
  
  public void setF(final List<Integer> f) {
    _delegate.setF(f);
  }
  
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setB(final boolean b) {
    _delegate.setB(b);
  }
  
  public boolean abM(final String s) {
    return _delegate.abM(s);
  }
  
  public void abV() {
    _delegate.abV();
  }
  
  public Object m(final List<String> l, final String s) {
    return _delegate.m(l, s);
  }
  
  public Object _m(final List<String> l, final String s) {
    ArrayList<Integer> _newArrayList = CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1));
    this.setF(_newArrayList);
    int _size = l.size();
    String _plus = (Integer.valueOf(_size) + s);
    List<Integer> _f = this.getF();
    String _plus_1 = (_plus + _f);
    boolean _abM = this.abM("foo");
    String _plus_2 = (_plus_1 + Boolean.valueOf(_abM));
    boolean _isB = this.isB();
    return (_plus_2 + Boolean.valueOf(_isB));
  }
}
''')
			assertGeneratedJavaCodeCompiles
		]
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
		'''.compile [
assertJavaClass("C",
'''
import java.util.List;
import traits.T;
import traits.impl.TImpl;

@SuppressWarnings("all")
public class C implements T {
  private List<Integer> f;
  
  public List<Integer> getF() {
    return this.f;
  }
  
  public void setF(final List<Integer> f) {
    this.f = f;
  }
  
  private boolean b = false;
  
  public boolean isB() {
    return this.b;
  }
  
  public void setB(final boolean b) {
    this.b = b;
  }
  
  private TImpl _T = new TImpl(this);
  
  public Object m(final List<String> l, final String s) {
    return _T._m(l, s);
  }
  
  public Object n() {
    return _T._n();
  }
}
'''
)
assertTraitJavaInterface("T",
'''
package traits;

import java.util.List;

@SuppressWarnings("all")
public interface T {
  public abstract List<Integer> getF();
  
  public abstract void setF(final List<Integer> f);
  
  public abstract boolean isB();
  
  public abstract void setB(final boolean b);
  
  public abstract Object m(final List<String> l, final String s);
  
  public abstract Object n();
}
''')
assertTraitJavaClass("T",
'''
package traits.impl;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import traits.T;

@SuppressWarnings("all")
public class TImpl implements T {
  private T _delegate;
  
  public TImpl(final T delegate) {
    this._delegate = delegate;
  }
  
  public List<Integer> getF() {
    return _delegate.getF();
  }
  
  public void setF(final List<Integer> f) {
    _delegate.setF(f);
  }
  
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setB(final boolean b) {
    _delegate.setB(b);
  }
  
  public Object m(final List<String> l, final String s) {
    return _delegate.m(l, s);
  }
  
  public Object _m(final List<String> l, final String s) {
    ArrayList<Integer> _newArrayList = CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1));
    this.setF(_newArrayList);
    int _size = l.size();
    String _plus = (Integer.valueOf(_size) + s);
    List<Integer> _f = this.getF();
    String _plus_1 = (_plus + _f);
    boolean _isB = this.isB();
    return (_plus_1 + Boolean.valueOf(_isB));
  }
  
  public Object n() {
    return _delegate.n();
  }
  
  public Object _n() {
    LinkedList<String> _newLinkedList = CollectionLiterals.<String>newLinkedList("bar");
    return this.m(_newLinkedList, "foo");
  }
}
''')
			executeGeneratedJavaClassMethodAndAssert("C", "n", "1foo[1]false")
		]
	}

	@Test def void testTraitPrivateMethod() {
		traitPrivateMethod.compile [
assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T1 {
  public abstract String callPriv();
}
''')
assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  public String priv() {
    return "T1.priv;";
  }
  
  public String callPriv() {
    return _delegate.callPriv();
  }
  
  public String _callPriv() {
    return this.priv();
  }
}
''')
			executeGeneratedJavaClassMethodAndAssert("C", "callPriv", "T1.priv;")
		]
	}

	@Test def void testTraitSum() {
		traitSum.compile[
assertTraitJavaInterface("tests", "T",
'''
package tests.traits;

import tests.traits.T1;
import tests.traits.T2;
import tests.traits.T3;

@SuppressWarnings("all")
public interface T extends T1, T2, T3 {
  public abstract String m();
  
  public abstract Object t1();
  
  public abstract Object t2();
  
  public abstract Object t3();
}
'''
)

assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T1 {
  public abstract Object t1();
  
  /**
   * required method
   */
  public abstract Object t2();
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  /**
   * required method
   */
  public Object t2() {
    return _delegate.t2();
  }
  
  public Object t1() {
    return _delegate.t1();
  }
  
  public Object _t1() {
    return "a";
  }
}
''')

assertTraitJavaClass("tests", "T",
'''
package tests.traits.impl;

import tests.traits.T;
import tests.traits.impl.T1Impl;
import tests.traits.impl.T2Impl;
import tests.traits.impl.T3Impl;

@SuppressWarnings("all")
public class TImpl implements T {
  private T _delegate;
  
  private T1Impl _T1;
  
  private T2Impl _T2;
  
  private T3Impl _T3;
  
  public TImpl(final T delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
    _T2 = new T2Impl(delegate);
    _T3 = new T3Impl(delegate);
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    Object _t1 = this.t1();
    String _string = _t1.toString();
    Object _t2 = this.t2();
    String _string_1 = _t2.toString();
    String _plus = (_string + _string_1);
    Object _t3 = this.t3();
    String _string_2 = _t3.toString();
    return (_plus + _string_2);
  }
  
  public Object t1() {
    return _delegate.t1();
  }
  
  public Object _t1() {
    return _T1._t1();
  }
  
  public Object t2() {
    return _delegate.t2();
  }
  
  public Object _t2() {
    return _T2._t2();
  }
  
  public Object t3() {
    return _delegate.t3();
  }
  
  public Object _t3() {
    return _T3._t3();
  }
}
''')

assertJavaClass("tests", "C",
'''
package tests;

import tests.traits.T;
import tests.traits.impl.TImpl;

@SuppressWarnings("all")
public class C implements T {
  private TImpl _T = new TImpl(this);
  
  public String m() {
    return _T._m();
  }
  
  public Object t1() {
    return _T._t1();
  }
  
  public Object t2() {
    return _T._t2();
  }
  
  public Object t3() {
    return _T._t3();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "m", "a1 - a - false")
		]
	}

	@Test def void testTraitUsesTraitWithTraitSum() {
		traitUsesTraitWithTraitSum.compile[
assertTraitJavaClass("tests", "T4",
'''
package tests.traits.impl;

import tests.traits.T4;
import tests.traits.impl.TImpl;

@SuppressWarnings("all")
public class T4Impl implements T4 {
  private T4 _delegate;
  
  private TImpl _T;
  
  public T4Impl(final T4 delegate) {
    this._delegate = delegate;
    _T = new TImpl(delegate);
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T._m();
  }
  
  public Object t1() {
    return _delegate.t1();
  }
  
  public Object _t1() {
    return _T._t1();
  }
  
  public Object t2() {
    return _delegate.t2();
  }
  
  public Object _t2() {
    return _T._t2();
  }
  
  public Object t3() {
    return _delegate.t3();
  }
  
  public Object _t3() {
    return _T._t3();
  }
}
''')
			executeGeneratedJavaClassMethodAndAssert("C4", "m", "a1 - a - false")
		]
	}

	@Test def void testTraitUsesTraitWithFields() {
		traitUsesTraitWithFields.compile[
assertTraitJavaClass("tests", "T2",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.impl.TImpl;

@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private TImpl _T;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T = new TImpl(delegate);
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T._m();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
''')

assertJavaClass("tests", "C",
'''
package tests;

import tests.traits.T2;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class C implements T2 {
  private String s = "test";
  
  public String getS() {
    return this.s;
  }
  
  public void setS(final String s) {
    this.s = s;
  }
  
  private T2Impl _T2 = new T2Impl(this);
  
  public String m() {
    return _T2._m();
  }
}
''')
			executeGeneratedJavaClassMethodAndAssert("C", "m", "Test")
		]
	}

	@Test def void testClassWithTraitSum() {
		classWithTraitSum.compile[
assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T1 {
  public abstract int getI();
  
  public abstract void setI(final int i);
  
  public abstract Object m1();
  
  public abstract Object m2();
}
'''
)
assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  public int getI() {
    return _delegate.getI();
  }
  
  public void setI(final int i) {
    _delegate.setI(i);
  }
  
  public Object m2() {
    return _delegate.m2();
  }
  
  public Object m1() {
    return _delegate.m1();
  }
  
  public Object _m1() {
    int _i = this.getI();
    boolean _greaterThan = (_i > 3);
    if (_greaterThan) {
      return Integer.valueOf(this.getI());
    }
    int _i_1 = this.getI();
    int _plus = (_i_1 + 1);
    this.setI(_plus);
    return this.m2();
  }
}
'''
)
assertJavaClass("tests", "C",
'''
package tests;

import tests.traits.T1;
import tests.traits.T2;
import tests.traits.impl.T1Impl;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class C implements T1, T2 {
  private int i = 0;
  
  public int getI() {
    return this.i;
  }
  
  public void setI(final int i) {
    this.i = i;
  }
  
  private T1Impl _T1 = new T1Impl(this);
  
  public Object m1() {
    return _T1._m1();
  }
  
  private T2Impl _T2 = new T2Impl(this);
  
  public Object m2() {
    return _T2._m2();
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "m1", "4")
			executeGeneratedJavaClassMethodAndAssert("C", "m2", "4")
		]
	}

	@Test def void testTraitWithDoubleApply() {
		traitWithDoubleApply.compile[
assertTraitJavaInterface("tests", "TDouble",
'''
package tests.traits;

@SuppressWarnings("all")
public interface TDouble {
  public abstract int doubleApply();
  
  public abstract int m();
}
'''
)
assertTraitJavaClass("tests", "TDouble",
'''
package tests.traits.impl;

import tests.traits.TDouble;

@SuppressWarnings("all")
public class TDoubleImpl implements TDouble {
  private TDouble _delegate;
  
  public TDoubleImpl(final TDouble delegate) {
    this._delegate = delegate;
  }
  
  public int m() {
    return _delegate.m();
  }
  
  public int doubleApply() {
    return _delegate.doubleApply();
  }
  
  public int _doubleApply() {
    int _m = this.m();
    int _m_1 = this.m();
    return (_m * _m_1);
  }
}
'''
)
assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  public int m() {
    return _delegate.m();
  }
  
  public int _m() {
    return 2;
  }
}
'''
)
assertTraitJavaClass("tests", "T2",
'''
package tests.traits.impl;

import tests.traits.T2;

@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
  }
  
  public int m() {
    return _delegate.m();
  }
  
  public int _m() {
    return 3;
  }
}
'''
)
assertJavaClass("tests", "C1",
'''
package tests;

import tests.traits.T1;
import tests.traits.TDouble;
import tests.traits.impl.T1Impl;
import tests.traits.impl.TDoubleImpl;

@SuppressWarnings("all")
public class C1 implements T1, TDouble {
  private T1Impl _T1 = new T1Impl(this);
  
  public int m() {
    return _T1._m();
  }
  
  private TDoubleImpl _TDouble = new TDoubleImpl(this);
  
  public int doubleApply() {
    return _TDouble._doubleApply();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C1", "doubleApply", "4")
			executeGeneratedJavaClassMethodAndAssert("C2", "doubleApply", "9")
		]
	}

	@Test def void testTraitRenameOperations() {
		traitRenameOperations.compile[
assertTraitAdapterJavaInterface("T3_T2_0",
'''
package traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract int n2();
  
  public abstract int m2();
  
  public abstract int t1();
  
  public abstract String getS();
  
  public abstract void setS(final String s);
}
'''
)

assertTraitJavaInterface("T3",
'''
package traits;

import traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  public abstract int foo();
  
  public abstract int m2();
  
  public abstract int t1();
}
'''
)

assertTraitAdapterJavaClass("T3_T2_0",
'''
package traits.impl;

import traits.T2;
import traits.T3_T2_0_Adapter;
import traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public int n() {
    return this.n2();
  }
  
  public int n2() {
    return _delegate.n2();
  }
  
  public int m() {
    return this.m2();
  }
  
  public int m2() {
    return _delegate.m2();
  }
  
  public int _m2() {
    return _T2_0._m();
  }
  
  public int t1() {
    return _delegate.t1();
  }
  
  public int _t1() {
    return _T2_0._t1();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("T3",
'''
package traits.impl;

import traits.T3;
import traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public int foo() {
    return _delegate.foo();
  }
  
  public int _foo() {
    int _n2 = this.n2();
    int _m2 = this.m2();
    return (_n2 + _m2);
  }
  
  public int m2() {
    return _delegate.m2();
  }
  
  public int _m2() {
    return _T3_T2_0._m2();
  }
  
  public int t1() {
    return _delegate.t1();
  }
  
  public int _t1() {
    return _T3_T2_0._t1();
  }
  
  public int n2() {
    return _delegate.n2();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameProvidedMethods() {
		traitRenameProvidedMethods.compile[
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String n2();
  
  public abstract String m2();
  
  public abstract String t1();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String n() {
    return this.n2();
  }
  
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n();
  }
  
  public String m() {
    return this.m2();
  }
  
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m();
  }
  
  public String t1() {
    return _delegate.t1();
  }
  
  public String _t1() {
    return _T2_0._t1();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    String _n2 = this.n2();
    String _m2 = this.m2();
    String _plus = (_n2 + _m2);
    String _t1 = this.t1();
    return (_plus + _t1);
  }
  
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T3_T2_0._n2();
  }
  
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T3_T2_0._m2();
  }
  
  public String t1() {
    return _delegate.t1();
  }
  
  public String _t1() {
    return _T3_T2_0._t1();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "foo", "T2.n;T1.m;T1.t1;")
		]
	}

	@Test def void testTraitRenameRequiredMethods() {
		traitRenameRequiredMethods.compile[
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String n();
  
  public abstract String m();
  
  public abstract String req();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  public abstract String foo();
  
  public abstract String n();
  
  public abstract String m();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
  }
  
  public String req1() {
    return this.req();
  }
  
  public String req() {
    return _delegate.req();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    return this.n();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T3_T2_0._n();
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T3_T2_0._m();
  }
  
  public String req() {
    return _delegate.req();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameRequiredMethodProvidedByTrait() {
		traitRenameRequiredMethodProvidedByTrait.compile[

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  public abstract String req();
  
  public abstract String foo();
  
  public abstract String n();
  
  public abstract String m();
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public String req() {
    return _delegate.req();
  }
  
  public String _req() {
    return "T3.req";
  }
  
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    return this.n();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T3_T2_0._n();
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T3_T2_0._m();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRedefinitionByRenaming() {
		traitRedefinitionByRenaming.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String n2();
  
  public abstract String m2();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  public abstract String m();
  
  public abstract String foo();
  
  public abstract String n2();
  
  public abstract String m2();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String n() {
    return this.n2();
  }
  
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n();
  }
  
  public String m() {
    return this.m2();
  }
  
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    String _m2 = this.m2();
    return ("T3." + _m2);
  }
  
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    String _n2 = this.n2();
    String _m = this.m();
    return (_n2 + _m);
  }
  
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T3_T2_0._n2();
  }
  
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T3_T2_0._m2();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "foo", "T2.n;T3.T1.m;")
		]
	}

	@Test def void testTraitDoubleRenaming() {
		traitDoubleRenaming.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String n2();
  
  public abstract String m2();
}
'''
)

assertTraitAdapterJavaInterface("tests", "T3_T2_1",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_1_Adapter {
  public abstract String n3();
  
  public abstract String m3();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;
import tests.traits.T3_T2_1_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter, T3_T2_1_Adapter {
  public abstract String m();
  
  public abstract String foo();
  
  public abstract String n2();
  
  public abstract String m2();
  
  public abstract String n3();
  
  public abstract String m3();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String n() {
    return this.n2();
  }
  
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n();
  }
  
  public String m() {
    return this.m2();
  }
  
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;
import tests.traits.impl.T3_T2_1_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  private T3_T2_1_AdapterImpl _T3_T2_1;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
    _T3_T2_1 = new T3_T2_1_AdapterImpl(delegate);
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    String _m2 = this.m2();
    return ("T3." + _m2);
  }
  
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    String _n3 = this.n3();
    String _m = this.m();
    return (_n3 + _m);
  }
  
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T3_T2_0._n2();
  }
  
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T3_T2_0._m2();
  }
  
  public String n3() {
    return _delegate.n3();
  }
  
  public String _n3() {
    return _T3_T2_1._n3();
  }
  
  public String m3() {
    return _delegate.m3();
  }
  
  public String _m3() {
    return _T3_T2_1._m3();
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "foo", "T2.n;T3.T1.m;")
		]
	}

	@Test def void testTraitRenameProvidedMethodToRequiredAndSum() {
		traitRenameProvidedMethodToRequiredAndSum.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract int m1();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T1;
import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter, T1 {
  public abstract int m1();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public int m() {
    return this.m1();
  }
  
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T2_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T1Impl;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  private T1Impl _T1;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
    _T1 = new T1Impl(delegate);
  }
  
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T3_T2_0._m1();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameProvidedMethodToRequiredAndSum2() {
		traitRenameProvidedMethodToRequiredAndSum2.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract int m1();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T1;
import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T1, T3_T2_0_Adapter {
  public abstract int m1();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_1;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_1 = new T2Impl(this);
  }
  
  public int m() {
    return this.m1();
  }
  
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T2_1._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T1Impl;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T1Impl _T1;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T3_T2_0._m1();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameRenamed() {
		traitRenameRenamed.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String callFirstRename();
  
  public abstract String secondRename();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  public abstract String callSecondRename();
  
  public abstract String callFirstRename();
  
  public abstract String secondRename();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String callFirstRename() {
    return _delegate.callFirstRename();
  }
  
  public String _callFirstRename() {
    return _T2_0._callFirstRename();
  }
  
  public String firstRename() {
    return this.secondRename();
  }
  
  public String secondRename() {
    return _delegate.secondRename();
  }
  
  public String _secondRename() {
    return _T2_0._firstRename();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public String callSecondRename() {
    return _delegate.callSecondRename();
  }
  
  public String _callSecondRename() {
    return this.secondRename();
  }
  
  public String callFirstRename() {
    return _delegate.callFirstRename();
  }
  
  public String _callFirstRename() {
    return _T3_T2_0._callFirstRename();
  }
  
  public String secondRename() {
    return _delegate.secondRename();
  }
  
  public String _secondRename() {
    return _T3_T2_0._secondRename();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "callSecondRename", "m")
			executeGeneratedJavaClassMethodAndAssert("C", "callFirstRename", "m")
		]
	}

	@Test def void testTraitRenameRequiredMethodToProvidedAndSum() {
		classUsesTraitRenameRequiredMethodToProvidedAndSum.compile[

			// callM1 which calls m1 which was required and was
			// renamed to provided T2.m
			executeGeneratedJavaClassMethodAndAssert("C", "callM1", "T2.m;")
		]
	}

	@Test def void testTraitRenamedRequiredMethodDoesNotConflict() {
		traitRenamedRequiredMethodDoesNotConflict.compile[

			// callM1 which calls m1 which was required and was
			// renamed to provided T2.m
			executeGeneratedJavaClassMethodAndAssert("C", "callM1", "T2.m;")
		]
	}

	@Test def void testClassRenamesRequiredMethodToProvidedAndSum() {
		classRenamesRequiredMethodToProvidedAndSum.compile[

assertJavaClass("tests", "C",
'''
package tests;

import tests.traits.C_T1_0_Adapter;
import tests.traits.T2;
import tests.traits.impl.C_T1_0_AdapterImpl;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class C implements T2, C_T1_0_Adapter {
  private T2Impl _T2 = new T2Impl(this);
  
  public String m() {
    return _T2._m();
  }
  
  private C_T1_0_AdapterImpl _C_T1_0 = new C_T1_0_AdapterImpl(this);
  
  public String callM1() {
    return _C_T1_0._callM1();
  }
}
'''
)

assertTraitAdapterJavaInterface("tests", "C_T1_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface C_T1_0_Adapter {
  public abstract String callM1();
  
  public abstract String m();
}
'''
)

assertTraitAdapterJavaClass("tests", "C_T1_0",
'''
package tests.traits.impl;

import tests.traits.C_T1_0_Adapter;
import tests.traits.T1;
import tests.traits.impl.T1Impl;

@SuppressWarnings("all")
public class C_T1_0_AdapterImpl implements C_T1_0_Adapter, T1 {
  private C_T1_0_Adapter _delegate;
  
  private T1Impl _T1_1;
  
  public C_T1_0_AdapterImpl(final C_T1_0_Adapter delegate) {
    this._delegate = delegate;
    _T1_1 = new T1Impl(this);
  }
  
  public String callM1() {
    return _delegate.callM1();
  }
  
  public String _callM1() {
    return _T1_1._callM1();
  }
  
  public String m1() {
    return this.m();
  }
  
  public String m() {
    return _delegate.m();
  }
}
'''
)

			// callM1 which calls m1 which was required and was
			// renamed to provided T2.m
			executeGeneratedJavaClassMethodAndAssert("C", "callM1", "T2.m;")
		]
	}

	@Test def void testRenameField() {
		classUsesTraitWithRenamedFields.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract boolean isB();
  
  public abstract void setB(final boolean fieldB);
  
  public abstract boolean n();
  
  public abstract String m();
  
  public abstract String getS();
  
  public abstract void setS(final String fieldS);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  public abstract String meth();
  
  public abstract boolean n();
  
  public abstract String m();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public boolean isFieldB() {
    return this.isB();
  }
  
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setFieldB(final boolean fieldB) {
    this.setB(fieldB);
  }
  
  public void setB(final boolean fieldB) {
    _delegate.setB(fieldB);
  }
  
  public boolean n() {
    return _delegate.n();
  }
  
  public boolean _n() {
    return _T2_0._n();
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
  }
  
  public String getFieldS() {
    return this.getS();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setFieldS(final String fieldS) {
    this.setS(fieldS);
  }
  
  public void setS(final String fieldS) {
    _delegate.setS(fieldS);
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public String meth() {
    return _delegate.meth();
  }
  
  public String _meth() {
    String _s = this.getS();
    boolean _isB = this.isB();
    return (_s + Boolean.valueOf(_isB));
  }
  
  public boolean n() {
    return _delegate.n();
  }
  
  public boolean _n() {
    return _T3_T2_0._n();
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T3_T2_0._m();
  }
  
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setB(final boolean fieldB) {
    _delegate.setB(fieldB);
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String fieldS) {
    _delegate.setS(fieldS);
  }
}
'''
)

			// call the method which uses the renamed field
			executeGeneratedJavaClassMethodAndAssert("C", "meth", "testtrue")
		]
	}

	@Test def void testTraitHide() {
		traitHide.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String p();
  
  public abstract String n();
  
  public abstract String getS();
  
  public abstract void setS(final String s);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  /**
   * independent new version of m
   */
  public abstract int m(final int i);
  
  public abstract String callN();
  
  public abstract int callM();
  
  public abstract String p();
  
  public abstract String n();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _T2_0._m();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  /**
   * independent new version of m
   */
  public int m(final int i) {
    return _delegate.m(i);
  }
  
  /**
   * independent new version of m
   */
  public int _m(final int i) {
    return i;
  }
  
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n();
    String _p = this.p();
    return (_n + _p);
  }
  
  public int callM() {
    return _delegate.callM();
  }
  
  public int _callM() {
    return this.m(10);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T3_T2_0._p();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T3_T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)
			// call the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "10")
			
			// n in T1 will call its own m
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T1.m;T1.m;")
		]
	}

	@Test def void testTraitAlias() {
		traitAlias.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String p();
  
  /**
   * original version of m
   */
  public abstract String oldm();
  
  /**
   * original version of m
   */
  public abstract String m();
  
  public abstract String n();
  
  public abstract String getS();
  
  public abstract void setS(final String s);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  public abstract String callN();
  
  public abstract String callM();
  
  public abstract String p();
  
  /**
   * original version of m
   */
  public abstract String oldm();
  
  /**
   * original version of m
   */
  public abstract String m();
  
  public abstract String n();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _delegate.m();
  }
  
  /**
   * original version of m
   */
  public String _m() {
    return _T2_0._m();
  }
  
  /**
   * original version of m
   */
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T2_0._m();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n();
    String _p = this.p();
    return (_n + _p);
  }
  
  public String callM() {
    return _delegate.callM();
  }
  
  public String _callM() {
    String _m = this.m();
    String _oldm = this.oldm();
    return (_m + _oldm);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T3_T2_0._p();
  }
  
  /**
   * original version of m
   */
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T3_T2_0._oldm();
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _delegate.m();
  }
  
  /**
   * original version of m
   */
  public String _m() {
    return _T3_T2_0._m();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T3_T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)
			// call the new alias version of m, oldm
			executeGeneratedJavaClassMethodAndAssert("C", "oldm", "T1.m;")
			
			// call callM which calls both m and oldm
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T1.m;T1.m;")
		]
	}

	@Test def void testTraitAliasWithRenameAndHide() {
		traitAliasWithRenameAndHide.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String p();
  
  /**
   * original version of m
   */
  public abstract String m1();
  
  /**
   * original version of m
   */
  public abstract String oldm();
  
  /**
   * original version of n
   */
  public abstract String oldn();
  
  public abstract String getS();
  
  public abstract void setS(final String s);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  /**
   * independent version of n
   */
  public abstract String n(final int i);
  
  public abstract String callN();
  
  public abstract String callM();
  
  public abstract String p();
  
  /**
   * original version of m
   */
  public abstract String m1();
  
  /**
   * original version of m
   */
  public abstract String oldm();
  
  /**
   * original version of n
   */
  public abstract String oldn();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  /**
   * original version of m
   */
  public String m() {
    return this.m1();
  }
  
  /**
   * original version of m
   */
  public String m1() {
    return _delegate.m1();
  }
  
  /**
   * original version of m
   */
  public String _m1() {
    return _T2_0._m();
  }
  
  /**
   * original version of m
   */
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T2_0._m();
  }
  
  /**
   * original version of n
   */
  public String n() {
    return _T2_0._n();
  }
  
  /**
   * original version of n
   */
  public String oldn() {
    return _delegate.oldn();
  }
  
  /**
   * original version of n
   */
  public String _oldn() {
    return _T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  /**
   * independent version of n
   */
  public String n(final int i) {
    return _delegate.n(i);
  }
  
  /**
   * independent version of n
   */
  public String _n(final int i) {
    String _oldn = this.oldn();
    String _plus = (_oldn + Integer.valueOf(i));
    return (_plus + " - ");
  }
  
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n(10);
    String _p = this.p();
    return (_n + _p);
  }
  
  public String callM() {
    return _delegate.callM();
  }
  
  public String _callM() {
    String _m1 = this.m1();
    String _oldm = this.oldm();
    return (_m1 + _oldm);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T3_T2_0._p();
  }
  
  /**
   * original version of m
   */
  public String m1() {
    return _delegate.m1();
  }
  
  /**
   * original version of m
   */
  public String _m1() {
    return _T3_T2_0._m1();
  }
  
  /**
   * original version of m
   */
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T3_T2_0._oldm();
  }
  
  /**
   * original version of n
   */
  public String oldn() {
    return _delegate.oldn();
  }
  
  /**
   * original version of n
   */
  public String _oldn() {
    return _T3_T2_0._oldn();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)
			// call the new alias version of m, oldm
			executeGeneratedJavaClassMethodAndAssert("C", "oldm", "T1.m;")
			
			// call the renamed version of m, m1
			executeGeneratedJavaClassMethodAndAssert("C", "m1", "T1.m;")
			
			// call callM which calls both m1 and oldm
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T1.m;T1.m;")
			
			// call callN which calls the new version of n and p
			// which in turns calls the original versions of m and n
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T1.n;10 - T1.m;T1.n;")
		]
	}

	@Test def void testTraitRestrict() {
		traitRestrict.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String p();
  
  /**
   * original version of m
   */
  public abstract String m();
  
  public abstract String n();
  
  public abstract String getS();
  
  public abstract void setS(final String s);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  /**
   * new version of m
   */
  public abstract String m();
  
  public abstract String callN();
  
  public abstract String callM();
  
  public abstract String p();
  
  public abstract String n();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _delegate.m();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  /**
   * new version of m
   */
  public String m() {
    return _delegate.m();
  }
  
  /**
   * new version of m
   */
  public String _m() {
    return "T3.m;";
  }
  
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n();
    String _p = this.p();
    return (_n + _p);
  }
  
  public String callM() {
    return _delegate.callM();
  }
  
  public String _callM() {
    return this.m();
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T3_T2_0._p();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T3_T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)
			// call callM which calls both the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T3.m;")

			// call callN which calls n and p which will call the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T3.m;T3.m;")
		]
	}

	@Test def void testTraitRestrictAndAlias() {
		traitRestrictAndAlias.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String p();
  
  /**
   * original version of m
   */
  public abstract String oldm();
  
  /**
   * original version of m
   */
  public abstract String m();
  
  public abstract String n();
  
  public abstract String getS();
  
  public abstract void setS(final String s);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  /**
   * new version of m
   */
  public abstract String m();
  
  public abstract String callN();
  
  public abstract String callM();
  
  public abstract String p();
  
  /**
   * original version of m
   */
  public abstract String oldm();
  
  public abstract String n();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _delegate.m();
  }
  
  /**
   * original version of m
   */
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T2_0._m();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  /**
   * new version of m
   */
  public String m() {
    return _delegate.m();
  }
  
  /**
   * new version of m
   */
  public String _m() {
    String _oldm = this.oldm();
    return ("T3.m;" + _oldm);
  }
  
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n();
    String _p = this.p();
    return (_n + _p);
  }
  
  public String callM() {
    return _delegate.callM();
  }
  
  public String _callM() {
    return this.m();
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T3_T2_0._p();
  }
  
  /**
   * original version of m
   */
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T3_T2_0._oldm();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T3_T2_0._n();
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)
			// call callM which calls both the new version of m
			// which in turn calls also the old version
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T3.m;T1.m;")

			// call callN which calls n and p which will call the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T3.m;T1.m;T3.m;T1.m;")
		]
	}

	@Test def void testTraitRedirect() {
		traitRedirect.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  public abstract String useField();
  
  public abstract String prov();
  
  public abstract String callReq();
  
  public abstract String getS2();
  
  public abstract void setS2(final String s2);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import tests.traits.T3_T2_0_Adapter;

@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  public abstract String useField();
  
  public abstract String prov();
  
  public abstract String callReq();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.T3_T2_0_Adapter;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String useField() {
    return _delegate.useField();
  }
  
  public String _useField() {
    return _T2_0._useField();
  }
  
  public String prov() {
    return _delegate.prov();
  }
  
  public String _prov() {
    return _T2_0._prov();
  }
  
  public String callReq() {
    return _delegate.callReq();
  }
  
  public String _callReq() {
    return _T2_0._callReq();
  }
  
  public String getS1() {
    return _delegate.getS2();
  }
  
  public void setS1(final String s1) {
    _delegate.setS2(s1);
  }
  
  public String getS2() {
    return _delegate.getS2();
  }
  
  public void setS2(final String s2) {
    _delegate.setS2(s2);
  }
  
  public String req() {
    return _delegate.prov();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import tests.traits.T3;
import tests.traits.impl.T3_T2_0_AdapterImpl;

@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T3_T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T3_T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  public String useField() {
    return _delegate.useField();
  }
  
  public String _useField() {
    return _T3_T2_0._useField();
  }
  
  public String prov() {
    return _delegate.prov();
  }
  
  public String _prov() {
    return _T3_T2_0._prov();
  }
  
  public String callReq() {
    return _delegate.callReq();
  }
  
  public String _callReq() {
    return _T3_T2_0._callReq();
  }
  
  public String getS2() {
    return _delegate.getS2();
  }
  
  public void setS2(final String s2) {
    _delegate.setS2(s2);
  }
}
'''
)
			// originally return s1 which is redirected to s2
			executeGeneratedJavaClassMethodAndAssert("C", "useField", "s2")
			
			// callReq calls the required method req, which was
			// redirected to prov
			executeGeneratedJavaClassMethodAndAssert("C", "callReq", "prov")
		]
	}

	@Test def void testTraitRequiredMethodProvidedWithCovariantReturnType() {
		traitRequiredMethodProvidedWithCovariantReturnType.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.ArrayList;
import tests.traits.T1;
import tests.traits.T2;
import tests.traits.impl.T1Impl;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class C implements T2, T1 {
  private T2Impl _T2 = new T2Impl(this);
  
  public ArrayList<String> createList() {
    return _T2._createList();
  }
  
  private T1Impl _T1 = new T1Impl(this);
  
  public String listToString() {
    return _T1._listToString();
  }
}
'''
)
			// T1 expects List<? extends String> createList() and
			// T2 provides ArrayList<String> createList()
			executeGeneratedJavaClassMethodAndAssert("C", "listToString", "[1, 2, 3]")
		]
	}

	@Test def void testTraitAliasWhenSplitInTwoFiles() {
		val rs = '''
		package tests;
		
		trait T1 {
			String m() { return null; }
		}
		'''.parse.eResource.resourceSet
		
		'''
		package tests;
		
		trait T2 uses tests.T1[alias m as newM] {
			
		}
		'''.parse(rs)
		
		rs.compile[

assertTraitAdapterJavaInterface("tests", "T2_T1_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T2_T1_0_Adapter {
  public abstract String newM();
  
  public abstract String m();
}
'''
)

assertTraitAdapterJavaClass("tests", "T2_T1_0",
'''
package tests.traits.impl;

import tests.traits.T1;
import tests.traits.T2_T1_0_Adapter;
import tests.traits.impl.T1Impl;

@SuppressWarnings("all")
public class T2_T1_0_AdapterImpl implements T2_T1_0_Adapter, T1 {
  private T2_T1_0_Adapter _delegate;
  
  private T1Impl _T1_0;
  
  public T2_T1_0_AdapterImpl(final T2_T1_0_Adapter delegate) {
    this._delegate = delegate;
    _T1_0 = new T1Impl(this);
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T1_0._m();
  }
  
  public String newM() {
    return _delegate.newM();
  }
  
  public String _newM() {
    return _T1_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.impl.T2_T1_0_AdapterImpl;

@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private T2_T1_0_AdapterImpl _T2_T1_0;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T2_T1_0 = new T2_T1_0_AdapterImpl(delegate);
  }
  
  public String newM() {
    return _delegate.newM();
  }
  
  public String _newM() {
    return _T2_T1_0._newM();
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_T1_0._m();
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitProvidesMethodToUsedTrait() {
		traitProvidesMethodToUsedTrait.compile[

assertTraitJavaInterface("tests", "T2",
'''
package tests.traits;

import tests.traits.T1;

@SuppressWarnings("all")
public interface T2 extends T1 {
  public abstract String req();
  
  public abstract String useReq();
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.impl.T1Impl;

@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private T1Impl _T1;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
  }
  
  public String req() {
    return _delegate.req();
  }
  
  public String _req() {
    return "req";
  }
  
  public String useReq() {
    return _delegate.useReq();
  }
  
  public String _useReq() {
    return _T1._useReq();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "useReq", "req")
		]
	}

	@Test def void testClassWithDefaultEmptyConstructor() {
		classWithDefaultEmptyConstructor.compile[

assertJavaClass("tests", "C",
'''
package tests;

@SuppressWarnings("all")
public class C {
  private String s;
  
  public String getS() {
    return this.s;
  }
  
  public void setS(final String s) {
    this.s = s;
  }
  
  public C() {
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassWithDefaultConstructor() {
		classWithDefaultConstructor.compile[

assertJavaClass("tests", "C",
'''
package tests;

@SuppressWarnings("all")
public class C {
  private String s;
  
  public String getS() {
    return this.s;
  }
  
  public void setS(final String s) {
    this.s = s;
  }
  
  public C() {
    this.s = "";
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassConstructors() {
		classWithConstructors.compile[

assertJavaClass("tests", "C",
'''
package tests;

@SuppressWarnings("all")
public class C {
  private String s;
  
  public String getS() {
    return this.s;
  }
  
  public void setS(final String s) {
    this.s = s;
  }
  
  private int i;
  
  public int getI() {
    return this.i;
  }
  
  public void setI(final int i) {
    this.i = i;
  }
  
  public C() {
    this.s = "";
    this.i = 0;
  }
  
  public C(final String mys) {
    this.s = mys;
  }
  
  public C(final int i, final String s) {
    this.i = i;
    this.s = s;
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassImplementsAllInterfaceMethodsWithSum() {
		classImplementsAllInterfaceMethodsWithSum.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import tests.traits.T1;
import tests.traits.T2;
import tests.traits.impl.T1Impl;
import tests.traits.impl.T2Impl;
import xtraitj.input.tests.MyTestInterface;
import xtraitj.input.tests.MyTestInterface2;

@SuppressWarnings("all")
public class C implements MyTestInterface, MyTestInterface2, T1, T2 {
  private T1Impl _T1 = new T1Impl(this);
  
  public int m(final List<String> l) {
    return _T1._m(l);
  }
  
  private T2Impl _T2 = new T2Impl(this);
  
  public List<Integer> n(final int i) {
    return _T2._n(i);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testCompliantRequiredFields() {
		compliantRequiredFields.compile[
			executeGeneratedJavaClassMethodAndAssert("C", "m1", "s")
			executeGeneratedJavaClassMethodAndAssert("C", "m2", "s")
			executeGeneratedJavaClassMethodAndAssert("C", "m3", "s")
		]
	}

	@Test def void testCompliantRequiredMethods() {
		compliantRequiredMethods.compile[
			executeGeneratedJavaClassMethodAndAssert("C", "m1", "req")
			executeGeneratedJavaClassMethodAndAssert("C", "m2", "req")
			executeGeneratedJavaClassMethodAndAssert("C", "req", "req")
		]
	}

}
