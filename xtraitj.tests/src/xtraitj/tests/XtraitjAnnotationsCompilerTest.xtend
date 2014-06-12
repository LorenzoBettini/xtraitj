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
class XtraitjAnnotationsCompilerTest extends AbstractXtraitjCompilerTest {
	@Inject extension CompilationTestHelper
	@Inject extension XtraitjInputs
	
	@Test def void testAnnotatedMethods() {
		annotatedElements.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1 {
  @XtraitjRequiredField
  public abstract String getS();
  
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
package tests.traits.impl;

import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  public String req() {
    return _delegate.req();
  }
  
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
import tests.traits.T1;
import tests.traits.T2;
import tests.traits.impl.T1Impl;
import tests.traits.impl.T2Impl;

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
