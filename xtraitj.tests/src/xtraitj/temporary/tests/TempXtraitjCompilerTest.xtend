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
