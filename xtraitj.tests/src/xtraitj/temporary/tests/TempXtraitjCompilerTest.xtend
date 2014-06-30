package xtraitj.temporary.tests

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
@InjectWith(typeof(xtraitj.tests.InjectorProviderCustom))
class TempXtraitjCompilerTest extends xtraitj.tests.AbstractXtraitjCompilerTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension CompilationTestHelper
	@Inject extension XtraitjInputs
	
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
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  /**
   * independent version of n
   */
  @XtraitjDefinedMethod
  public abstract String n(final int i);
  
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
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
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  /**
   * new version of m
   */
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
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
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  /**
   * new version of m
   */
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
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
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
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
  @XtraitjRenamedMethod("m")
  @XtraitjRenamedMethod("firstRename")
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
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  @XtraitjDefinedMethod
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
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  /**
   * independent new version of m
   */
  @XtraitjDefinedMethod
  public abstract int m(final int i);
  
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
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
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
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


}
