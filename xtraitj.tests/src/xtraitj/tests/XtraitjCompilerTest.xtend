package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjCompilerTest extends AbstractXtraitjCompilerTest {

	@Test(expected=RuntimeException)
	def void testCompilerErrorsAreDetected() {
		'''
		trait T uses Foo {}
		'''.compile[]
	}

	@Test
	def void testCompilerErrorsIgnored() {
		'''
		trait T uses Foo {}
		'''.compile(false)[
assertTraitJavaInterface("T",
'''
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T extends void {
}
''')
			
		]
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
		'''.compile [
assertTraitJavaInterface("T",
'''
import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T {
  @XtraitjRequiredField
  public abstract List<Integer> getF();
  
  @XtraitjRequiredFieldSetter
  public abstract void setF(final List<Integer> f);
  
  @XtraitjRequiredField
  public abstract boolean isB();
  
  @XtraitjRequiredFieldSetter
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
public class TImpl implements T {
  private T _delegate;
  
  public TImpl(final T delegate) {
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

	@Test def void testTraitFieldName() {
		'''
		package tests;
		
		trait T1 {
			
		}
		
		trait T2 {
			
		}
		
		trait T3 uses T1, tests.T2 {
			
		}
		'''.compile [
assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T1Impl;
import tests.T2Impl;
import tests.T3;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T1Impl _T1;
  
  private T2Impl _T2;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
    _T2 = new T2Impl(delegate);
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
			expectationsForTraitAndClass(it)
		]
	}

	@Test def void testTraitAndClassSeparateFiles() {
		#[
		'''
		import java.util.List
		
		class C uses T {
			List<Integer> f;
			boolean b=false;
		}
		''',
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
		'''
		].compile [
			expectationsForTraitAndClass(it)
		]
	}
	
	private def expectationsForTraitAndClass(Result it) {
		assertTraitJavaInterface("T",
		'''
import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T {
  @XtraitjRequiredField
  public abstract List<Integer> getF();
  
  @XtraitjRequiredFieldSetter
  public abstract void setF(final List<Integer> f);
  
  @XtraitjRequiredField
  public abstract boolean isB();
  
  @XtraitjRequiredFieldSetter
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
		public class TImpl implements T {
		  private T _delegate;
		  
		  public TImpl(final T delegate) {
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
		
					executeGeneratedJavaClassMethodAndAssert("C", "n", "1foo[1]false")
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
public interface T1 {
  @XtraitjDefinedMethod
  public abstract String callPriv();
}
''')
assertTraitJavaClass("tests", "T1",
'''
package tests;

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1 {
  @XtraitjRequiredField
  public abstract int getI();
  
  @XtraitjRequiredFieldSetter
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

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
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
import tests.T1Impl;
import tests.T2;
import tests.T2Impl;

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

	@Test def void testTraitSum() {
		traitSum.compile[
assertTraitJavaInterface("tests", "T",
'''
package tests;

import tests.T1;
import tests.T2;
import tests.T3;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T extends T1, T2, T3 {
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
public interface T1 {
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

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
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

import tests.T;
import tests.T1Impl;
import tests.T2Impl;
import tests.T3Impl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
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
import tests.TImpl;

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
package tests;

import tests.T4;
import tests.TImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T4Impl implements T4 {
  private T4 _delegate;
  
  private TImpl _T;
  
  public T4Impl(final T4 delegate) {
    this._delegate = delegate;
    _T = new TImpl(delegate);
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

import tests.T2;
import tests.TImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private TImpl _T;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T = new TImpl(delegate);
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
import tests.T2Impl;

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
public interface TDouble {
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

import tests.TDouble;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TDoubleImpl implements TDouble {
  private TDouble _delegate;
  
  public TDoubleImpl(final TDouble delegate) {
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

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
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

import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  public T2Impl(final T2 delegate) {
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
import tests.T1Impl;
import tests.TDouble;
import tests.TDoubleImpl;

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






	@Test def void testTraitRequiredMethodProvidedWithCovariantReturnType() {
		traitRequiredMethodProvidedWithCovariantReturnType.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.ArrayList;
import tests.T1;
import tests.T1Impl;
import tests.T2;
import tests.T2Impl;

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
import tests.T1Impl;
import tests.T2;
import tests.T2Impl;
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

	@Test def void testGeneratedJavaDocForTraitsAndClasses() {
		elementsWithDocumentation.compile[

assertTraitJavaInterface("tests", "T",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

/**
 * My documented trait
 */
@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T {
  /**
   * this is a required field
   */
  @XtraitjRequiredField
  public abstract String getF();
  
  /**
   * this is a required field
   */
  @XtraitjRequiredFieldSetter
  public abstract void setF(final String f);
  
  /**
   * this is a defined method
   */
  @XtraitjDefinedMethod
  public abstract String def();
  
  /**
   * this is a required method
   */
  @XtraitjRequiredMethod
  public abstract String req();
}
'''
)

assertTraitJavaClass("tests", "T",
'''
package tests;

import tests.T;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

/**
 * My documented trait
 */
@XtraitjTraitClass
@SuppressWarnings("all")
public class TImpl implements T {
  private T _delegate;
  
  public TImpl(final T delegate) {
    this._delegate = delegate;
  }
  
  /**
   * this is a required field
   */
  @XtraitjRequiredField
  public String getF() {
    return _delegate.getF();
  }
  
  /**
   * this is a required field
   */
  public void setF(final String f) {
    _delegate.setF(f);
  }
  
  /**
   * this is a required method
   */
  @XtraitjRequiredMethod
  public String req() {
    return _delegate.req();
  }
  
  /**
   * this is a defined method
   */
  @XtraitjDefinedMethod
  public String def() {
    return _delegate.def();
  }
  
  /**
   * this is a defined method
   */
  public String _def() {
    return this.req();
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import tests.T;
import tests.T2;
import tests.T2Impl;
import tests.TImpl;

/**
 * My documented class
 */
@SuppressWarnings("all")
public class C implements T, T2 {
  /**
   * this is a declared field
   */
  private String f;
  
  public String getF() {
    return this.f;
  }
  
  public void setF(final String f) {
    this.f = f;
  }
  
  /**
   * this is a constructor
   */
  public C(final String f) {
    this.f = f;
  }
  
  private TImpl _T = new TImpl(this);
  
  /**
   * this is a defined method
   */
  public String def() {
    return _T._def();
  }
  
  private T2Impl _T2 = new T2Impl(this);
  
  /**
   * this is an implemented method
   */
  public String req() {
    return _T2._req();
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
package tests;

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T2 extends T1 {
  @XtraitjDefinedMethod
  public abstract String req();
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests;

import tests.T1Impl;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private T1Impl _T1;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
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
import tests.T2Impl;

@SuppressWarnings("all")
public class C implements T2 {
  private T2Impl _T2 = new T2Impl(this);
  
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

}
