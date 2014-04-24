package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.TraitJInputs

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjAnnotationsCompilerTest extends AbstractXtraitjCompilerTest {
	@Inject extension CompilationTestHelper
	@Inject extension TraitJInputs
	
	@Test def void testAnnotatedMethods() {
		annotatedMethods.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T1 {
  public abstract String getS();
  
  public abstract void setS(final String s);
  
  public abstract String m();
  
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
  
  @SuppressWarnings("checked")
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

			assertGeneratedJavaCodeCompiles
		]
	}

}
