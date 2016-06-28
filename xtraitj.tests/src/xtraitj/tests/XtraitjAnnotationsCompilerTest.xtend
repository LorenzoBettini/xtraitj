package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjAnnotationsCompilerTest extends AbstractXtraitjCompilerTest {
	
	@Test def void testAnnotatedMethods() {
		annotatedElements.compile[

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
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
  @SuppressWarnings("all")
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjRequiredMethod
  public abstract String req();
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
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  @XtraitjRequiredMethod
  public String req() {
    return _delegate.req();
  }
  
  @XtraitjDefinedMethod
  @SuppressWarnings("all")
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return this.getS();
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import com.google.inject.Inject;
import tests.T1;
import tests.T1Impl;
import tests.T2;
import tests.T2Impl;

@SuppressWarnings("all")
public class C implements T1, T2 {
  @Inject
  private String s = "bar";
  
  public String getS() {
    return this.s;
  }
  
  public void setS(final String s) {
    this.s = s;
  }
  
  private T1Impl _T1 = new T1Impl(this);
  
  @SuppressWarnings("all")
  public String m() {
    return _T1._m();
  }
  
  private T2Impl _T2 = new T2Impl(this);
  
  public String req() {
    return _T2._req();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

}
