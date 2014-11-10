package xtraitj.temporary.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.input.tests.XtraitjInputs

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(xtraitj.tests.InjectorProviderCustom))
class TempXtraitjGenericsCompilerTest extends xtraitj.tests.AbstractXtraitjCompilerTest {
	@Inject extension CompilationTestHelper
	@Inject extension XtraitjInputs
	
	@Test def void testTraitUsesGenericTraitWithAliasRenameHide() {
		traitUsesGenericTraitWithAliasRenameHide.compile[

			// call the new alias version of m, oldm
			executeGeneratedJavaClassMethodAndAssert("C", "oldm", "foo")
			
			// call the renamed version of m, m1
			executeGeneratedJavaClassMethodAndAssert("C", "m1", "foo")
			
			// call callM which calls both m1 and oldm
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "foofoo")
			
			// call callN which calls the new version of n and p
			// which in turns calls the original versions of m and n
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "foo10 - foofoo")
		]
	}

	@Test def void testGenericFunctionAsField() {
		genericFunctionAsField.compile[

assertTraitJavaInterface("tests", "TTransformerIterator",
'''
package tests.traits;

import java.util.Iterator;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import tests.traits.TTransformerIterator_TIterator_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TTransformerIterator<T, R> extends TTransformerIterator_TIterator_0_Adapter<T, R> {
  @XtraitjRequiredField
  public abstract Function1<? super T, ? extends R> getFunction();
  
  public abstract void setFunction(final Function1<? super T, ? extends R> function);
  
  @XtraitjDefinedMethod
  public abstract R next();
  
  public abstract boolean hasNext();
  
  public abstract T origNext();
  
  public abstract void remove();
  
  public abstract Iterator<T> getIterator();
  
  public abstract void setIterator(final Iterator<T> iterator);
}
'''
)

assertTraitJavaClass("tests", "TTransformerIterator",
'''
package tests.traits.impl;

import java.util.Iterator;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import tests.traits.TTransformerIterator;
import tests.traits.impl.TTransformerIterator_TIterator_0_AdapterImpl;

@SuppressWarnings("all")
public class TTransformerIteratorImpl<T, R> implements TTransformerIterator<T, R> {
  private TTransformerIterator<T, R> _delegate;
  
  private TTransformerIterator_TIterator_0_AdapterImpl<T, R> _TTransformerIterator_TIterator_0;
  
  public TTransformerIteratorImpl(final TTransformerIterator<T, R> delegate) {
    this._delegate = delegate;
    _TTransformerIterator_TIterator_0 = new TTransformerIterator_TIterator_0_AdapterImpl(delegate);
  }
  
  public Function1<? super T, ? extends R> getFunction() {
    return _delegate.getFunction();
  }
  
  public void setFunction(final Function1<? super T, ? extends R> function) {
    _delegate.setFunction(function);
  }
  
  public R next() {
    return _delegate.next();
  }
  
  public R _next() {
    final T o = this.origNext();
    Function1<? super T, ? extends R> _function = this.getFunction();
    return _function.apply(o);
  }
  
  public boolean hasNext() {
    return _delegate.hasNext();
  }
  
  public boolean _hasNext() {
    return _TTransformerIterator_TIterator_0._hasNext();
  }
  
  public T origNext() {
    return _delegate.origNext();
  }
  
  public T _origNext() {
    return _TTransformerIterator_TIterator_0._origNext();
  }
  
  public void remove() {
    _delegate.remove();
  }
  
  public void _remove() {
    _TTransformerIterator_TIterator_0._remove();
  }
  
  public Iterator<T> getIterator() {
    return _delegate.getIterator();
  }
  
  public void setIterator(final Iterator<T> iterator) {
    _delegate.setIterator(iterator);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}


	@Test def void testTraitUsesGenericTraitWithRedirect() {
		traitUsesGenericTraitWithRedirect.compile[

			// originally return s1 which is redirected to s2
			executeGeneratedJavaClassMethodAndAssert("C", "useField", "foo")
			
			// callReq calls the required method req, which was
			// redirected to prov
			executeGeneratedJavaClassMethodAndAssert("C", "callReq", "foo")
			
			executeGeneratedJavaClassMethodAndAssert("C2", "useField", "foo")
			executeGeneratedJavaClassMethodAndAssert("C2", "callReq", "foo")
		]
	}

	@Test def void testTraitUsesGenericTraitWithRestrict() {
		traitUsesGenericTraitWithRestrict.compile[

			// call callM which calls both the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T3.m;")

			// call callN which calls n and p which will call the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T3.m;T3.m;")
			
			executeGeneratedJavaClassMethodAndAssert("C2", "callM", "T3.m;")

			// call callN which calls n (no p in this case) which will call the new version of m
			executeGeneratedJavaClassMethodAndAssert("C2", "callN", "T3.m;")
		]
	}

	@Test def void testTraitUsesGenericTraitWithRestrictAndAlias() {
		traitUsesGenericTraitWithRestrictAndAlias.compile[

			// call callM which calls both the new version of m and the old one
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T3.m;foo")

			// call callN which calls n and p which will call the new version of m and the old one
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T3.m;fooT3.m;foo")
			
			executeGeneratedJavaClassMethodAndAssert("C2", "callM", "T3.m;foo")

			// call callN which calls n (no p in this case) which will call the new version of m and the old one
			executeGeneratedJavaClassMethodAndAssert("C2", "callN", "T3.m;foo")
		]
	}











	@Test def void testPassTypeParameterAsTypeArgument() {
		passTypeParameterAsTypeArgument.compile[

assertTraitJavaInterface("tests", "T2",
'''
package tests.traits;

import tests.traits.T1;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T2<W> extends T1<W> {
  public abstract W m();
  
  public abstract W getS();
  
  public abstract void setS(final W s);
}
'''
)

assertTraitAdapterJavaInterface("tests", "TWithOp_T1_0",
'''
package tests.traits;

@SuppressWarnings("all")
public interface TWithOp_T1_0_Adapter<Z> {
  public abstract Z getS();
  
  public abstract void setS(final Z s);
}
'''
)

assertTraitAdapterJavaClass("tests", "TWithOp_T1_0",
'''
package tests.traits.impl;

import tests.traits.T1;
import tests.traits.TWithOp_T1_0_Adapter;
import tests.traits.impl.T1Impl;

@SuppressWarnings("all")
public class TWithOp_T1_0_AdapterImpl<Z> implements TWithOp_T1_0_Adapter<Z>, T1<Z> {
  private TWithOp_T1_0_Adapter<Z> _delegate;
  
  private T1Impl<Z> _T1_0;
  
  public TWithOp_T1_0_AdapterImpl(final TWithOp_T1_0_Adapter<Z> delegate) {
    this._delegate = delegate;
    _T1_0 = new T1Impl(this);
  }
  
  public Z getS() {
    return _delegate.getS();
  }
  
  public void setS(final Z s) {
    _delegate.setS(s);
  }
  
  public Z m() {
    return _T1_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "TWithOp",
'''
package tests.traits.impl;

import tests.traits.TWithOp;
import tests.traits.impl.TWithOp_T1_0_AdapterImpl;

@SuppressWarnings("all")
public class TWithOpImpl<Z> implements TWithOp<Z> {
  private TWithOp<Z> _delegate;
  
  private TWithOp_T1_0_AdapterImpl<Z> _TWithOp_T1_0;
  
  public TWithOpImpl(final TWithOp<Z> delegate) {
    this._delegate = delegate;
    _TWithOp_T1_0 = new TWithOp_T1_0_AdapterImpl(delegate);
  }
  
  public Z getS() {
    return _delegate.getS();
  }
  
  public void setS(final Z s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests.traits.impl;

import tests.traits.T2;
import tests.traits.impl.T1Impl;

@SuppressWarnings("all")
public class T2Impl<W> implements T2<W> {
  private T2<W> _delegate;
  
  private T1Impl<W> _T1;
  
  public T2Impl(final T2<W> delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
  }
  
  public W m() {
    return _delegate.m();
  }
  
  public W _m() {
    return _T1._m();
  }
  
  public W getS() {
    return _delegate.getS();
  }
  
  public void setS(final W s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests.traits;

import java.util.List;
import tests.traits.T2;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3<V> extends T2<List<V>> {
  public abstract List<V> m();
  
  public abstract List<V> getS();
  
  public abstract void setS(final List<V> s);
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.T3;
import tests.traits.impl.T2Impl;

@SuppressWarnings("all")
public class T3Impl<V> implements T3<V> {
  private T3<V> _delegate;
  
  private T2Impl<List<V>> _T2;
  
  public T3Impl(final T3<V> delegate) {
    this._delegate = delegate;
    _T2 = new T2Impl(delegate);
  }
  
  public List<V> m() {
    return _delegate.m();
  }
  
  public List<V> _m() {
    return _T2._m();
  }
  
  public List<V> getS() {
    return _delegate.getS();
  }
  
  public void setS(final List<V> s) {
    _delegate.setS(s);
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "m", "foo")
			executeGeneratedJavaClassMethodAndAssert("C3", "m", "[foo, bar]")
		]
	}










}
