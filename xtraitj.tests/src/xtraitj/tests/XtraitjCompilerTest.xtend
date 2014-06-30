package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.input.tests.XtraitjInputs

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(InjectorProviderCustom))
class XtraitjCompilerTest extends AbstractXtraitjCompilerTest {
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
import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TInterface {
  @XtraitjRequiredField
  public abstract List<Integer> getF();
  
  public abstract void setF(final List<Integer> f);
  
  @XtraitjRequiredField
  public abstract boolean isB();
  
  public abstract void setB(final boolean b);
  
  @XtraitjDefinedMethod
  public abstract Object m(final List<String> l, final String s);
  
  @XtraitjRequiredMethod
  public abstract boolean abM(final String s);
  
  @XtraitjRequiredMethod
  public abstract void abV();
}
''')
assertTraitJavaClass("T",
'''
import java.util.ArrayList;
import java.util.List;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T implements TInterface {
  private TInterface _delegate;
  
  public T(final TInterface delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public List<Integer> getF() {
    return _delegate.getF();
  }
  
  public void setF(final List<Integer> f) {
    _delegate.setF(f);
  }
  
  @XtraitjRequiredField
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setB(final boolean b) {
    _delegate.setB(b);
  }
  
  @XtraitjRequiredMethod
  public boolean abM(final String s) {
    return _delegate.abM(s);
  }
  
  @XtraitjRequiredMethod
  public void abV() {
    _delegate.abV();
  }
  
  @XtraitjDefinedMethod
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

assertTraitJavaInterface("T",
'''
import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TInterface {
  @XtraitjRequiredField
  public abstract List<Integer> getF();
  
  public abstract void setF(final List<Integer> f);
  
  @XtraitjRequiredField
  public abstract boolean isB();
  
  public abstract void setB(final boolean b);
  
  @XtraitjDefinedMethod
  public abstract Object m(final List<String> l, final String s);
  
  @XtraitjDefinedMethod
  public abstract Object n();
}
''')
assertTraitJavaClass("T",
'''
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T implements TInterface {
  private TInterface _delegate;
  
  public T(final TInterface delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public List<Integer> getF() {
    return _delegate.getF();
  }
  
  public void setF(final List<Integer> f) {
    _delegate.setF(f);
  }
  
  @XtraitjRequiredField
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setB(final boolean b) {
    _delegate.setB(b);
  }
  
  @XtraitjDefinedMethod
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
  
  @XtraitjDefinedMethod
  public Object n() {
    return _delegate.n();
  }
  
  public Object _n() {
    LinkedList<String> _newLinkedList = CollectionLiterals.<String>newLinkedList("bar");
    return this.m(_newLinkedList, "foo");
  }
}
''')

assertJavaClass("C",
'''
import java.util.List;

@SuppressWarnings("all")
public class C implements TInterface {
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
  
  private T _T = new T(this);
  
  public Object m(final List<String> l, final String s) {
    return _T._m(l, s);
  }
  
  public Object n() {
    return _T._n();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "n", "1foo[1]false")
		]
	}

	@Test def void testTraitPrivateMethod() {
		traitPrivateMethod.compile [
assertTraitJavaInterface("tests", "T1",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface {
  @XtraitjDefinedMethod
  public abstract String callPriv();
}
''')
assertTraitJavaClass("tests", "T1",
'''
package tests;

import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1 implements T1Interface {
  private T1Interface _delegate;
  
  public T1(final T1Interface delegate) {
    this._delegate = delegate;
  }
  
  public String priv() {
    return "T1.priv;";
  }
  
  @XtraitjDefinedMethod
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






	@Test def void testClassWithTraitSum() {
		classWithTraitSum.compile[
assertTraitJavaInterface("tests", "T1",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface {
  @XtraitjRequiredField
  public abstract int getI();
  
  public abstract void setI(final int i);
  
  @XtraitjDefinedMethod
  public abstract Object m1();
  
  @XtraitjRequiredMethod
  public abstract Object m2();
}
'''
)
assertTraitJavaClass("tests", "T1",
'''
package tests;

import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1 implements T1Interface {
  private T1Interface _delegate;
  
  public T1(final T1Interface delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public int getI() {
    return _delegate.getI();
  }
  
  public void setI(final int i) {
    _delegate.setI(i);
  }
  
  @XtraitjRequiredMethod
  public Object m2() {
    return _delegate.m2();
  }
  
  @XtraitjDefinedMethod
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

import tests.T1;
import tests.T1Interface;
import tests.T2;
import tests.T2Interface;

@SuppressWarnings("all")
public class C implements T1Interface, T2Interface {
  private int i = 0;
  
  public int getI() {
    return this.i;
  }
  
  public void setI(final int i) {
    this.i = i;
  }
  
  private T1 _T1 = new T1(this);
  
  public Object m1() {
    return _T1._m1();
  }
  
  private T2 _T2 = new T2(this);
  
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

	@Test def void testTraitSum() {
		traitSum.compile[
assertTraitJavaInterface("tests", "T",
'''
package tests;

import tests.T1Interface;
import tests.T2Interface;
import tests.T3Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TInterface extends T1Interface, T2Interface, T3Interface {
  @XtraitjDefinedMethod
  public abstract String m();
}
'''
)

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface {
  @XtraitjDefinedMethod
  public abstract Object t1();
  
  /**
   * required method
   */
  @XtraitjRequiredMethod
  public abstract Object t2();
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1 implements T1Interface {
  private T1Interface _delegate;
  
  public T1(final T1Interface delegate) {
    this._delegate = delegate;
  }
  
  /**
   * required method
   */
  @XtraitjRequiredMethod
  public Object t2() {
    return _delegate.t2();
  }
  
  @XtraitjDefinedMethod
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
package tests;

import tests.T1;
import tests.T2;
import tests.T3;
import tests.TInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T implements TInterface {
  private TInterface _delegate;
  
  private T1 _T1;
  
  private T2 _T2;
  
  private T3 _T3;
  
  public T(final TInterface delegate) {
    this._delegate = delegate;
    _T1 = new T1(delegate);
    _T2 = new T2(delegate);
    _T3 = new T3(delegate);
  }
  
  @XtraitjDefinedMethod
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
  
  @XtraitjDefinedMethod
  public Object t1() {
    return _delegate.t1();
  }
  
  public Object _t1() {
    return _T1._t1();
  }
  
  @XtraitjDefinedMethod
  public Object t2() {
    return _delegate.t2();
  }
  
  public Object _t2() {
    return _T2._t2();
  }
  
  @XtraitjDefinedMethod
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

import tests.T;
import tests.TInterface;

@SuppressWarnings("all")
public class C implements TInterface {
  private T _T = new T(this);
  
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
package tests;

import tests.T;
import tests.T4Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T4 implements T4Interface {
  private T4Interface _delegate;
  
  private T _T;
  
  public T4(final T4Interface delegate) {
    this._delegate = delegate;
    _T = new T(delegate);
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T._m();
  }
  
  @XtraitjDefinedMethod
  public Object t1() {
    return _delegate.t1();
  }
  
  public Object _t1() {
    return _T._t1();
  }
  
  @XtraitjDefinedMethod
  public Object t2() {
    return _delegate.t2();
  }
  
  public Object _t2() {
    return _T._t2();
  }
  
  @XtraitjDefinedMethod
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
package tests;

import tests.T;
import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2 implements T2Interface {
  private T2Interface _delegate;
  
  private T _T;
  
  public T2(final T2Interface delegate) {
    this._delegate = delegate;
    _T = new T(delegate);
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T._m();
  }
  
  @XtraitjRequiredField
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

import tests.T2;
import tests.T2Interface;

@SuppressWarnings("all")
public class C implements T2Interface {
  private String s = "test";
  
  public String getS() {
    return this.s;
  }
  
  public void setS(final String s) {
    this.s = s;
  }
  
  private T2 _T2 = new T2(this);
  
  public String m() {
    return _T2._m();
  }
}
''')
			executeGeneratedJavaClassMethodAndAssert("C", "m", "Test")
		]
	}

	@Test def void testTraitWithDoubleApply() {
		traitWithDoubleApply.compile[
assertTraitJavaInterface("tests", "TDouble",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TDoubleInterface {
  @XtraitjDefinedMethod
  public abstract int doubleApply();
  
  @XtraitjRequiredMethod
  public abstract int m();
}
'''
)
assertTraitJavaClass("tests", "TDouble",
'''
package tests;

import tests.TDoubleInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TDouble implements TDoubleInterface {
  private TDoubleInterface _delegate;
  
  public TDouble(final TDoubleInterface delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredMethod
  public int m() {
    return _delegate.m();
  }
  
  @XtraitjDefinedMethod
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
package tests;

import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1 implements T1Interface {
  private T1Interface _delegate;
  
  public T1(final T1Interface delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
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
package tests;

import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2 implements T2Interface {
  private T2Interface _delegate;
  
  public T2(final T2Interface delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
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

import tests.T1;
import tests.T1Interface;
import tests.TDouble;
import tests.TDoubleInterface;

@SuppressWarnings("all")
public class C1 implements T1Interface, TDoubleInterface {
  private T1 _T1 = new T1(this);
  
  public int m() {
    return _T1._m();
  }
  
  private TDouble _TDouble = new TDouble(this);
  
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






	@Test def void testTraitRequiredMethodProvidedWithCovariantReturnType() {
		traitRequiredMethodProvidedWithCovariantReturnType.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.ArrayList;
import tests.T1;
import tests.T1Interface;
import tests.T2;
import tests.T2Interface;

@SuppressWarnings("all")
public class C implements T2Interface, T1Interface {
  private T2 _T2 = new T2(this);
  
  public ArrayList<String> createList() {
    return _T2._createList();
  }
  
  private T1 _T1 = new T1(this);
  
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
import tests.T1;
import tests.T1Interface;
import tests.T2;
import tests.T2Interface;
import xtraitj.input.tests.MyTestInterface;
import xtraitj.input.tests.MyTestInterface2;

@SuppressWarnings("all")
public class C implements MyTestInterface, MyTestInterface2, T1Interface, T2Interface {
  private T1 _T1 = new T1(this);
  
  public int m(final List<String> l) {
    return _T1._m(l);
  }
  
  private T2 _T2 = new T2(this);
  
  public List<Integer> n(final int i) {
    return _T2._n(i);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testGeneratedJavaDocForTraitsAndClasses() {
		elementsWithDocumentation.compile[

assertTraitJavaInterface("tests", "T",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

/**
 * My documented trait
 */
@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TInterface {
}
'''
)

assertTraitJavaClass("tests", "T",
'''
package tests;

import tests.TInterface;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

/**
 * My documented trait
 */
@XtraitjTraitClass
@SuppressWarnings("all")
public class T implements TInterface {
  private TInterface _delegate;
  
  public T(final TInterface delegate) {
    this._delegate = delegate;
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

/**
 * My documented class
 */
@SuppressWarnings("all")
public class C {
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
package tests;

import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T2Interface extends T1Interface {
  @XtraitjDefinedMethod
  public abstract String req();
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests;

import tests.T1;
import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2 implements T2Interface {
  private T2Interface _delegate;
  
  private T1 _T1;
  
  public T2(final T2Interface delegate) {
    this._delegate = delegate;
    _T1 = new T1(delegate);
  }
  
  @XtraitjDefinedMethod
  public String req() {
    return _delegate.req();
  }
  
  public String _req() {
    return "req";
  }
  
  @XtraitjDefinedMethod
  public String useReq() {
    return _delegate.useReq();
  }
  
  public String _useReq() {
    return _T1._useReq();
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import tests.T2;
import tests.T2Interface;

@SuppressWarnings("all")
public class C implements T2Interface {
  private T2 _T2 = new T2(this);
  
  public String req() {
    return _T2._req();
  }
  
  public String useReq() {
    return _T2._useReq();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "useReq", "req")
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

	@Test def void testTraitRenamedRequiredMethodDoesNotConflict() {
		traitRenamedRequiredMethodDoesNotConflict.compile[

			// callM1 which calls m1 which was required and was
			// renamed to provided T2.m
			executeGeneratedJavaClassMethodAndAssert("C", "callM1", "T2.m;")
		]
	}

	@Test def void testTraitRenameRequiredMethodToProvidedAndSum() {
		classUsesTraitRenameRequiredMethodToProvidedAndSum.compile[

			// callM1 which calls m1 which was required and was
			// renamed to provided T2.m
			executeGeneratedJavaClassMethodAndAssert("C", "callM1", "T2.m;")
		]
	}

	@Test def void testTraitRenameRequiredMethods() {
		traitRenameRequiredMethods.compile[
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract String req();
  
  public abstract String n();
  
  public abstract String m();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T3_T2_0_AdapterInterface {
  @XtraitjDefinedMethod
  public abstract String foo();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public String req1() {
    return this.req();
  }
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("req1")
  public String req() {
    return _delegate.req();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    return this.n();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
  }
  
  @XtraitjRequiredMethod
  public String req() {
    return _delegate.req();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameOperations() {
		traitRenameOperations.compile[
assertTraitAdapterJavaInterface("T3_T2_0",
'''
@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract String getS();
  
  public abstract void setS(final String s);
  
  public abstract int n2();
  
  public abstract int m2();
  
  public abstract int t1();
}
'''
)

assertTraitJavaInterface("T3",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T3_T2_0_AdapterInterface {
  @XtraitjDefinedMethod
  public abstract int foo();
}
'''
)

assertTraitAdapterJavaClass("T3_T2_0",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public int m() {
    return this.m2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public int m2() {
    return _delegate.m2();
  }
  
  public int _m2() {
    return _T2_0._m();
  }
  
  public int n() {
    return this.n2();
  }
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("n")
  public int n2() {
    return _delegate.n2();
  }
  
  @XtraitjDefinedMethod
  public int t1() {
    return _delegate.t1();
  }
  
  public int _t1() {
    return _T2_0._t1();
  }
  
  @XtraitjRequiredField
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
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public int foo() {
    return _delegate.foo();
  }
  
  public int _foo() {
    int _n2 = this.n2();
    int _m2 = this.m2();
    return (_n2 + _m2);
  }
  
  @XtraitjDefinedMethod
  public int m2() {
    return _delegate.m2();
  }
  
  public int _m2() {
    return _T2_0._m2();
  }
  
  @XtraitjDefinedMethod
  public int t1() {
    return _delegate.t1();
  }
  
  public int _t1() {
    return _T2_0._t1();
  }
  
  @XtraitjRequiredField
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  @XtraitjRequiredMethod
  public int n2() {
    return _delegate.n2();
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
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract String n2();
  
  public abstract String m2();
  
  public abstract String t1();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public String m() {
    return this.m2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m();
  }
  
  public String n() {
    return this.n2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("n")
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
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
package tests;

import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
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
  
  @XtraitjDefinedMethod
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m2();
  }
  
  @XtraitjDefinedMethod
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n2();
  }
  
  @XtraitjDefinedMethod
  public String t1() {
    return _delegate.t1();
  }
  
  public String _t1() {
    return _T2_0._t1();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "foo", "T2.n;T1.m;T1.t1;")
		]
	}

	@Test def void testTraitDoubleRenaming() {
		traitDoubleRenaming.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract String n2();
  
  public abstract String m2();
}
'''
)

assertTraitAdapterJavaInterface("tests", "T3_T2_1",
'''
package tests;

@SuppressWarnings("all")
public interface T3_T2_1_AdapterInterface {
  public abstract String n3();
  
  public abstract String m3();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_AdapterInterface;
import tests.T3_T2_1_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T3_T2_0_AdapterInterface, T3_T2_1_AdapterInterface {
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract String foo();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public String m() {
    return this.m2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m();
  }
  
  public String n() {
    return this.n2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("n")
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import tests.T3_T2_1_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  private T3_T2_1_Adapter _T2_1;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
    _T2_1 = new T3_T2_1_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    String _m2 = this.m2();
    return ("T3." + _m2);
  }
  
  @XtraitjDefinedMethod
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    String _n3 = this.n3();
    String _m = this.m();
    return (_n3 + _m);
  }
  
  @XtraitjDefinedMethod
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m2();
  }
  
  @XtraitjDefinedMethod
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n2();
  }
  
  @XtraitjDefinedMethod
  public String m3() {
    return _delegate.m3();
  }
  
  public String _m3() {
    return _T2_1._m3();
  }
  
  @XtraitjDefinedMethod
  public String n3() {
    return _delegate.n3();
  }
  
  public String _n3() {
    return _T2_1._n3();
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "foo", "T2.n;T3.T1.m;")
		]
	}

	@Test def void testTraitRedefinitionByRenaming() {
		traitRedefinitionByRenaming.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract String n2();
  
  public abstract String m2();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T3_T2_0_AdapterInterface {
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract String foo();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public String m() {
    return this.m2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m();
  }
  
  public String n() {
    return this.n2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("n")
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    String _m2 = this.m2();
    return ("T3." + _m2);
  }
  
  @XtraitjDefinedMethod
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    String _n2 = this.n2();
    String _m = this.m();
    return (_n2 + _m);
  }
  
  @XtraitjDefinedMethod
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m2();
  }
  
  @XtraitjDefinedMethod
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n2();
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
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract int m1();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T3_T2_0_AdapterInterface, T1Interface {
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public int m() {
    return this.m1();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
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
package tests;

import tests.T1;
import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  private T1 _T1;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
    _T1 = new T1(delegate);
  }
  
  @XtraitjDefinedMethod
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T2_0._m1();
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
package tests;

import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T3_T2_0_AdapterInterface {
  @XtraitjDefinedMethod
  public abstract String req();
  
  @XtraitjDefinedMethod
  public abstract String foo();
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public String req() {
    return _delegate.req();
  }
  
  public String _req() {
    return "T3.req";
  }
  
  @XtraitjDefinedMethod
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    return this.n();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
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
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract int m1();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T1Interface, T3_T2_0_AdapterInterface {
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public int m() {
    return this.m1();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
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
package tests;

import tests.T1;
import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T1 _T1;
  
  private T3_T2_0_Adapter _T2_0;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T1 = new T1(delegate);
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T2_0._m1();
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
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract String callFirstRename();
  
  public abstract String secondRename();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T3_T2_0_AdapterInterface {
  @XtraitjDefinedMethod
  public abstract String callSecondRename();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public String firstRename() {
    return this.secondRename();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod({ "m", "firstRename" })
  public String secondRename() {
    return _delegate.secondRename();
  }
  
  public String _secondRename() {
    return _T2_0._firstRename();
  }
  
  @XtraitjDefinedMethod
  public String callFirstRename() {
    return _delegate.callFirstRename();
  }
  
  public String _callFirstRename() {
    return _T2_0._callFirstRename();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public String callSecondRename() {
    return _delegate.callSecondRename();
  }
  
  public String _callSecondRename() {
    return this.secondRename();
  }
  
  @XtraitjDefinedMethod
  public String secondRename() {
    return _delegate.secondRename();
  }
  
  public String _secondRename() {
    return _T2_0._secondRename();
  }
  
  @XtraitjDefinedMethod
  public String callFirstRename() {
    return _delegate.callFirstRename();
  }
  
  public String _callFirstRename() {
    return _T2_0._callFirstRename();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "callSecondRename", "m")
			executeGeneratedJavaClassMethodAndAssert("C", "callFirstRename", "m")
		]
	}

}
