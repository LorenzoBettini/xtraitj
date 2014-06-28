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

	@Test def void testTraitUsesGenericTraitWithAlias() {
		traitUsesGenericTraitWithAlias.compile[

assertTraitJavaInterface("tests", "T2",
'''
package tests.traits;

import java.util.List;
import tests.traits.T2_T1_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

/**
 * alias on a directly instantiated type parameter
 */
@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T2 extends T2_T1_0_Adapter {
  @XtraitjDefinedMethod
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
  
  public abstract List<String> getL();
  
  public abstract void setL(final List<String> l);
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.T2;
import tests.traits.impl.T2_T1_0_AdapterImpl;

/**
 * alias on a directly instantiated type parameter
 */
@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private T2_T1_0_AdapterImpl _T2_T1_0;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T2_T1_0 = new T2_T1_0_AdapterImpl(delegate);
  }
  
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    String _m = this.m();
    String _oldm = this.oldm();
    return (_m + _oldm);
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
    return _T2_T1_0._oldm();
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
    return _T2_T1_0._m();
  }
  
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_T1_0._n();
  }
  
  public List<String> getL() {
    return _delegate.getL();
  }
  
  public void setL(final List<String> l) {
    _delegate.setL(l);
  }
}
'''
)

assertTraitAdapterJavaInterface("tests", "T2_T1_0",
'''
package tests.traits;

import java.util.List;

@SuppressWarnings("all")
public interface T2_T1_0_Adapter {
  public abstract List<String> getL();
  
  public abstract void setL(final List<String> l);
  
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

			executeGeneratedJavaClassMethodAndAssert("C", "p", "foofoo")
			executeGeneratedJavaClassMethodAndAssert("C2", "p", "foofoo")
		]
	}

	@Test def void testTraitUsesGenericTraitWithHide() {
		traitUsesGenericTraitWithHide.compile[

			executeGeneratedJavaClassMethodAndAssert("C", "callN", "foofoo")
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "10")
			
			// in this case we call the new m(10)
			executeGeneratedJavaClassMethodAndAssert("C2", "callN", "foo10")
			executeGeneratedJavaClassMethodAndAssert("C2", "callM", "10")
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





	@Test def void testTraitUsesGenericTraitWithRename() {
		traitUsesGenericTraitWithRename.compile[

assertTraitJavaInterface("tests", "UsesTGeneric",
'''
package tests.traits;

import java.util.List;
import tests.traits.TGeneric;
import tests.traits.UsesTGeneric_TGeneric_0_Adapter;
import tests.traits.UsesTGeneric_TGeneric_1_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface UsesTGeneric extends UsesTGeneric_TGeneric_0_Adapter, UsesTGeneric_TGeneric_1_Adapter, TGeneric<String> {
  @XtraitjDefinedMethod
  public abstract String useLists();
  
  public abstract List<Integer> returnListOfInteger();
  
  public abstract List<List<Integer>> returnListOfListOfInteger();
  
  public abstract List<String> returnList();
}
'''
)

assertTraitJavaClass("tests", "UsesTGeneric",
'''
package tests.traits.impl;

import java.util.List;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import tests.traits.UsesTGeneric;
import tests.traits.impl.TGenericImpl;
import tests.traits.impl.UsesTGeneric_TGeneric_0_AdapterImpl;
import tests.traits.impl.UsesTGeneric_TGeneric_1_AdapterImpl;

@SuppressWarnings("all")
public class UsesTGenericImpl implements UsesTGeneric {
  private UsesTGeneric _delegate;
  
  private UsesTGeneric_TGeneric_0_AdapterImpl _UsesTGeneric_TGeneric_0;
  
  private UsesTGeneric_TGeneric_1_AdapterImpl _UsesTGeneric_TGeneric_1;
  
  private TGenericImpl<String> _TGeneric;
  
  public UsesTGenericImpl(final UsesTGeneric delegate) {
    this._delegate = delegate;
    _UsesTGeneric_TGeneric_0 = new UsesTGeneric_TGeneric_0_AdapterImpl(delegate);
    _UsesTGeneric_TGeneric_1 = new UsesTGeneric_TGeneric_1_AdapterImpl(delegate);
    _TGeneric = new TGenericImpl(delegate);
  }
  
  public String useLists() {
    return _delegate.useLists();
  }
  
  public String _useLists() {
    String _xblockexpression = null;
    {
      List<String> _returnList = this.returnList();
      final Procedure1<List<String>> _function = new Procedure1<List<String>>() {
        public void apply(final List<String> it) {
          it.add("foo");
        }
      };
      final List<String> stringList = ObjectExtensions.<List<String>>operator_doubleArrow(_returnList, _function);
      List<Integer> _returnListOfInteger = this.returnListOfInteger();
      final Procedure1<List<Integer>> _function_1 = new Procedure1<List<Integer>>() {
        public void apply(final List<Integer> it) {
          it.add(Integer.valueOf(1));
        }
      };
      final List<Integer> intList = ObjectExtensions.<List<Integer>>operator_doubleArrow(_returnListOfInteger, _function_1);
      List<List<Integer>> _returnListOfListOfInteger = this.returnListOfListOfInteger();
      final Procedure1<List<List<Integer>>> _function_2 = new Procedure1<List<List<Integer>>>() {
        public void apply(final List<List<Integer>> it) {
          List<Integer> _returnListOfInteger = UsesTGenericImpl.this.returnListOfInteger();
          final Procedure1<List<Integer>> _function = new Procedure1<List<Integer>>() {
            public void apply(final List<Integer> it) {
              it.add(Integer.valueOf(2));
            }
          };
          List<Integer> _doubleArrow = ObjectExtensions.<List<Integer>>operator_doubleArrow(_returnListOfInteger, _function);
          it.add(_doubleArrow);
        }
      };
      final List<List<Integer>> intListList = ObjectExtensions.<List<List<Integer>>>operator_doubleArrow(_returnListOfListOfInteger, _function_2);
      String _string = stringList.toString();
      String _string_1 = intList.toString();
      String _plus = (_string + _string_1);
      String _string_2 = intListList.toString();
      _xblockexpression = (_plus + _string_2);
    }
    return _xblockexpression;
  }
  
  public List<Integer> returnListOfInteger() {
    return _delegate.returnListOfInteger();
  }
  
  public List<Integer> _returnListOfInteger() {
    return _UsesTGeneric_TGeneric_0._returnListOfInteger();
  }
  
  public List<List<Integer>> returnListOfListOfInteger() {
    return _delegate.returnListOfListOfInteger();
  }
  
  public List<List<Integer>> _returnListOfListOfInteger() {
    return _UsesTGeneric_TGeneric_1._returnListOfListOfInteger();
  }
  
  public List<String> returnList() {
    return _delegate.returnList();
  }
  
  public List<String> _returnList() {
    return _TGeneric._returnList();
  }
}
'''
)

assertTraitAdapterJavaInterface("tests", "UsesTGeneric_TGeneric_0",
'''
package tests.traits;

import java.util.List;

@SuppressWarnings("all")
public interface UsesTGeneric_TGeneric_0_Adapter {
  public abstract List<Integer> returnListOfInteger();
}
'''
)

assertTraitAdapterJavaClass("tests", "UsesTGeneric_TGeneric_0",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.TGeneric;
import tests.traits.UsesTGeneric_TGeneric_0_Adapter;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class UsesTGeneric_TGeneric_0_AdapterImpl implements UsesTGeneric_TGeneric_0_Adapter, TGeneric<Integer> {
  private UsesTGeneric_TGeneric_0_Adapter _delegate;
  
  private TGenericImpl<Integer> _TGeneric_0;
  
  public UsesTGeneric_TGeneric_0_AdapterImpl(final UsesTGeneric_TGeneric_0_Adapter delegate) {
    this._delegate = delegate;
    _TGeneric_0 = new TGenericImpl(this);
  }
  
  public List<Integer> returnList() {
    return this.returnListOfInteger();
  }
  
  public List<Integer> returnListOfInteger() {
    return _delegate.returnListOfInteger();
  }
  
  public List<Integer> _returnListOfInteger() {
    return _TGeneric_0._returnList();
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import tests.traits.UsesTGeneric;
import tests.traits.impl.UsesTGenericImpl;

@SuppressWarnings("all")
public class C implements UsesTGeneric {
  private UsesTGenericImpl _UsesTGeneric = new UsesTGenericImpl(this);
  
  public String useLists() {
    return _UsesTGeneric._useLists();
  }
  
  public List<Integer> returnListOfInteger() {
    return _UsesTGeneric._returnListOfInteger();
  }
  
  public List<List<Integer>> returnListOfListOfInteger() {
    return _UsesTGeneric._returnListOfListOfInteger();
  }
  
  public List<String> returnList() {
    return _UsesTGeneric._returnList();
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "useLists", "[foo][1][[2]]")
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
