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
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface {
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
import tests.T1Interface;
import tests.T2;
import tests.T2Interface;

@SuppressWarnings("all")
public class C implements T1Interface, T2Interface {
  @Inject
  private String s = "bar";
  
  public String getS() {
    return this.s;
  }
  
  public void setS(final String s) {
    this.s = s;
  }
  
  private T1 _T1 = new T1(this);
  
  @SuppressWarnings("all")
  public String m() {
    return _T1._m();
  }
  
  private T2 _T2 = new T2(this);
  
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
