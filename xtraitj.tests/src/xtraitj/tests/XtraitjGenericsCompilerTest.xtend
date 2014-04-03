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
class XtraitjGenericsCompilerTest extends AbstractXtraitjCompilerTest {
	@Inject extension CompilationTestHelper
	@Inject extension TraitJInputs
	
	@Test def void testGenericClass() {
		genericClass.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IterableExtensions;

@SuppressWarnings("all")
public class C<T extends List<String>, U> {
  private T t;
  
  public T getT() {
    return this.t;
  }
  
  public void setT(final T t) {
    this.t = t;
  }
  
  private U u;
  
  public U getU() {
    return this.u;
  }
  
  public void setU(final U u) {
    this.u = u;
  }
  
  public C(final T t1, final U u1) {
    this.t = t1;
    this.u = u1;
    final String s = IterableExtensions.<String>head(this.t);
    final int i = this.t.size();
    InputOutput.<Integer>println(Integer.valueOf(i));
    InputOutput.<String>println(s);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testGenericTrait() {
		genericTrait.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

import java.util.List;

@SuppressWarnings("all")
public interface T1<T extends List<String>, U> {
  public abstract T getT();
  
  public abstract void setT(final T t);
  
  public abstract String m();
  
  public abstract T read_t();
  
  public abstract void update_t(final T t);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import java.util.List;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl<T extends List<String>, U> implements T1<T,U> {
  private T1<T,U> _delegate;
  
  public T1Impl(final T1<T,U> delegate) {
    this._delegate = delegate;
  }
  
  public T getT() {
    return _delegate.getT();
  }
  
  public void setT(final T t) {
    _delegate.setT(t);
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    final T t1 = this.getT();
    this.setT(t1);
    T _t = this.getT();
    return IterableExtensions.<String>head(_t);
  }
  
  public T read_t() {
    return _delegate.read_t();
  }
  
  public T _read_t() {
    final T t1 = this.getT();
    return t1;
  }
  
  public void update_t(final T t) {
    _delegate.update_t(t);
  }
  
  public void _update_t(final T t) {
    this.setT(t);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testGenericTraitWithRecursiveTypeParameter() {
		genericTraitWithRecursiveTypeParameter.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

@SuppressWarnings("all")
public interface T1<T extends Comparable<T>> {
  public abstract T getT();
  
  public abstract void setT(final T t);
  
  public abstract int compare(final T t1);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl<T extends Comparable<T>> implements T1<T> {
  private T1<T> _delegate;
  
  public T1Impl(final T1<T> delegate) {
    this._delegate = delegate;
  }
  
  public T getT() {
    return _delegate.getT();
  }
  
  public void setT(final T t) {
    _delegate.setT(t);
  }
  
  public int compare(final T t1) {
    return _delegate.compare(t1);
  }
  
  public int _compare(final T t1) {
    T _t = this.getT();
    return _t.compareTo(t1);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testGenericTraitWithRecursiveTypeParameter2() {
		genericTraitWithRecursiveTypeParameter2.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

import java.util.List;

@SuppressWarnings("all")
public interface T1<T extends Comparable<T>, U extends List<? extends T>> {
  public abstract T getT();
  
  public abstract void setT(final T t);
  
  public abstract int compare(final U t1);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl<T extends Comparable<T>, U extends List<? extends T>> implements T1<T,U> {
  private T1<T,U> _delegate;
  
  public T1Impl(final T1<T,U> delegate) {
    this._delegate = delegate;
  }
  
  public T getT() {
    return _delegate.getT();
  }
  
  public void setT(final T t) {
    _delegate.setT(t);
  }
  
  public int compare(final U t1) {
    return _delegate.compare(t1);
  }
  
  public int _compare(final U t1) {
    T _t = this.getT();
    T _get = t1.get(0);
    return _t.compareTo(_get);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitWithGenericMethod() {
		traitWithGenericMethod.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

import java.util.List;

@SuppressWarnings("all")
public interface T1 {
  public abstract <T extends List<String>> String getFirst(final T t);
  
  public abstract <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  public <T extends List<String>> String getFirst(final T t) {
    return _delegate.getFirst(t);
  }
  
  public <T extends List<String>> String _getFirst(final T t) {
    return t.get(0);
  }
  
  public <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2) {
    return _delegate.compare(t1, t2);
  }
  
  public <T extends Comparable<T>, U extends List<? extends T>> int _compare(final T t1, final U t2) {
    T _get = t2.get(0);
    return t1.compareTo(_get);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitWithGenericMethodShadowingTraitTypeParameter() {
		traitWithGenericMethodShadowingTraitTypeParameter.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests.traits;

import java.util.List;

@SuppressWarnings("all")
public interface T1<T> {
  public abstract <T extends List<String>> String getFirst(final T t);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl<T> implements T1<T> {
  private T1<T> _delegate;
  
  public T1Impl(final T1<T> delegate) {
    this._delegate = delegate;
  }
  
  public <T extends List<String>> String getFirst(final T t) {
    return _delegate.getFirst(t);
  }
  
  public <T extends List<String>> String _getFirst(final T t) {
    return t.get(0);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitUsesGenericTrait() {
		traitUsesGenericTrait.compile[

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests.traits;

import java.util.List;
import tests.traits.TGeneric;

@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<List<String>> {
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.TUsesGeneric;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<List<String>> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
}
'''
)

assertJavaClass("tests", "CUsesGeneric",
'''
package tests;

import java.util.List;
import tests.traits.TGeneric;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric implements TGeneric<List<String>> {
  private TGenericImpl<List<String>> _TGeneric = new TGenericImpl(this);
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitUsesGenericTraitWithFields() {
		traitUsesGenericTraitWithFields.compile[

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests.traits;

import java.util.List;
import java.util.Set;
import tests.traits.TGeneric;

@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<List<String>,Set<Integer>> {
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests.traits.impl;

import java.util.List;
import java.util.Set;
import tests.traits.TUsesGeneric;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<List<String>,Set<Integer>> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  public List<String> getT() {
    return _delegate.getT();
  }
  
  public void setT(final List<String> t) {
    _delegate.setT(t);
  }
  
  public Iterable<List<String>> getIterableOfStrings() {
    return _delegate.getIterableOfStrings();
  }
  
  public void setIterableOfStrings(final Iterable<List<String>> iterableOfStrings) {
    _delegate.setIterableOfStrings(iterableOfStrings);
  }
  
  public Iterable<Set<Integer>> getIterableOfIntegers() {
    return _delegate.getIterableOfIntegers();
  }
  
  public void setIterableOfIntegers(final Iterable<Set<Integer>> iterableOfIntegers) {
    _delegate.setIterableOfIntegers(iterableOfIntegers);
  }
}
'''
)

assertJavaClass("tests", "CUsesGeneric",
'''
package tests;

import java.util.List;
import java.util.Set;
import tests.traits.TGeneric;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric implements TGeneric<List<String>,Set<Integer>> {
  private List<String> t;
  
  public List<String> getT() {
    return this.t;
  }
  
  public void setT(final List<String> t) {
    this.t = t;
  }
  
  private Iterable<List<String>> iterableOfStrings;
  
  public Iterable<List<String>> getIterableOfStrings() {
    return this.iterableOfStrings;
  }
  
  public void setIterableOfStrings(final Iterable<List<String>> iterableOfStrings) {
    this.iterableOfStrings = iterableOfStrings;
  }
  
  private Iterable<Set<Integer>> iterableOfIntegers;
  
  public Iterable<Set<Integer>> getIterableOfIntegers() {
    return this.iterableOfIntegers;
  }
  
  public void setIterableOfIntegers(final Iterable<Set<Integer>> iterableOfIntegers) {
    this.iterableOfIntegers = iterableOfIntegers;
  }
  
  private TGenericImpl<List<String>,Set<Integer>> _TGeneric = new TGenericImpl(this);
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitUsesGenericTraitWithDefinedMethods() {
		traitUsesGenericTraitWithDefinedMethod.compile[

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests.traits;

import java.util.List;
import tests.traits.TGeneric;

@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<String> {
  public abstract String searchInList(final List<String> l, final String arg);
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.TUsesGeneric;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<String> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  public String searchInList(final List<String> l, final String arg) {
    return _delegate.searchInList(l, arg);
  }
  
  public String _searchInList(final List<String> l, final String arg) {
    return _TGeneric._searchInList(l, arg);
  }
}
'''
)

assertJavaClass("tests", "CUsesGeneric",
'''
package tests;

import java.util.List;
import tests.traits.TUsesGeneric;
import tests.traits.impl.TUsesGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric implements TUsesGeneric {
  private TUsesGenericImpl _TUsesGeneric = new TUsesGenericImpl(this);
  
  public String searchInList(final List<String> l, final String arg) {
    return _TUsesGeneric._searchInList(l, arg);
  }
  
  public T searchInList(final List<T> l, final T arg) {
    return _TUsesGeneric._searchInList(l, arg);
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitUsesGenericTraitWithRequiredMethods() {
		traitUsesGenericTraitWithRequiredMethods.compile[

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests.traits;

import java.util.List;
import java.util.Set;
import tests.traits.TGeneric;

@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<String,Set<Integer>> {
  public abstract Iterable<String> iterableOfStrings();
  
  public abstract <V extends List<String>> String getFirst(final V t);
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests.traits.impl;

import java.util.List;
import java.util.Set;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import tests.traits.TUsesGeneric;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<String,Set<Integer>> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  public Iterable<String> iterableOfStrings() {
    return _delegate.iterableOfStrings();
  }
  
  public Iterable<String> _iterableOfStrings() {
    return CollectionLiterals.<String>newArrayList("foo");
  }
  
  public <V extends List<String>> String getFirst(final V t) {
    return _delegate.getFirst(t);
  }
  
  public <V extends List<String>> String _getFirst(final V t) {
    return t.get(0);
  }
}
'''
)

assertJavaClass("tests", "CUsesGeneric",
'''
package tests;

import java.util.List;
import tests.traits.TUsesGeneric;
import tests.traits.impl.TUsesGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric implements TUsesGeneric {
  private TUsesGenericImpl _TUsesGeneric = new TUsesGenericImpl(this);
  
  public Iterable<String> iterableOfStrings() {
    return _TUsesGeneric._iterableOfStrings();
  }
  
  public <V extends List<String>> String getFirst(final V t) {
    return _TUsesGeneric._getFirst(t);
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testRequiredMethodsWithGenerics() {
		requiredMethodsWithGenerics.compile[

assertJavaClass("tests", "CUsesGeneric",
'''
package tests;

import tests.traits.T2;
import tests.traits.TUsesGeneric;
import tests.traits.impl.T2Impl;
import tests.traits.impl.TUsesGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric implements TUsesGeneric, T2 {
  private TUsesGenericImpl _TUsesGeneric = new TUsesGenericImpl(this);
  
  private T2Impl _T2 = new T2Impl(this);
  
  public Iterable<String> iterableOfStrings() {
    return _T2._iterableOfStrings();
  }
}
'''
)

assertJavaClass("tests", "CUsesGeneric2",
'''
package tests;

import tests.traits.T2;
import tests.traits.TGeneric;
import tests.traits.impl.T2Impl;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric2 implements TGeneric<String>, T2 {
  private TGenericImpl<String> _TGeneric = new TGenericImpl(this);
  
  private T2Impl _T2 = new T2Impl(this);
  
  public Iterable<String> iterableOfStrings() {
    return _T2._iterableOfStrings();
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassImplementsAllGenericInterfaceMethods() {
		classImplementsAllGenericInterfaceMethods.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import tests.traits.T1;
import tests.traits.T2;
import tests.traits.impl.T1Impl;
import tests.traits.impl.T2Impl;
import xtraitj.input.tests.MyGenericTestInterface;
import xtraitj.input.tests.MyGenericTestInterface2;

@SuppressWarnings("all")
public class C implements MyGenericTestInterface<String>, MyGenericTestInterface2<Integer>, T1, T2 {
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

	@Test def void testTraitUsesGenericTraitWithRename() {
		traitUsesGenericTraitWithRename.compile[

assertTraitJavaInterface("tests", "UsesTGeneric",
'''
package tests.traits;

import java.util.List;
import tests.traits.TGeneric;
import tests.traits.UsesTGeneric_TGeneric_0_Adapter;
import tests.traits.UsesTGeneric_TGeneric_1_Adapter;

@SuppressWarnings("all")
public interface UsesTGeneric extends UsesTGeneric_TGeneric_0_Adapter, UsesTGeneric_TGeneric_1_Adapter, TGeneric<String> {
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

	@Test def void testTraitUsesGenericTraitWithWildCard() {
		traitUsesGenericTraitWithWildCard.compile[

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests.traits;

import java.util.List;
import tests.traits.TGeneric;

@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<String> {
  public abstract String updatedAndReturn();
  
  public abstract List<? extends String> returnListOfT();
  
  public abstract String searchInList(final List<? extends String> l, final String arg);
  
  public abstract void addToListOfT(final List<? super String> l, final String arg);
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.TUsesGeneric;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<String> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  public String updatedAndReturn() {
    return _delegate.updatedAndReturn();
  }
  
  public String _updatedAndReturn() {
    String _xblockexpression = null;
    {
      List<String> _myL = this.getMyL();
      this.addToListOfT(_myL, "foo");
      List<String> _myL_1 = this.getMyL();
      this.addToListOfT(_myL_1, "bar");
      List<String> _myL_2 = this.getMyL();
      _xblockexpression = this.searchInList(_myL_2, "foo");
    }
    return _xblockexpression;
  }
  
  public List<? extends String> returnListOfT() {
    return _delegate.returnListOfT();
  }
  
  public List<? extends String> _returnListOfT() {
    return _TGeneric._returnListOfT();
  }
  
  public String searchInList(final List<? extends String> l, final String arg) {
    return _delegate.searchInList(l, arg);
  }
  
  public String _searchInList(final List<? extends String> l, final String arg) {
    return _TGeneric._searchInList(l, arg);
  }
  
  public void addToListOfT(final List<? super String> l, final String arg) {
    _delegate.addToListOfT(l, arg);
  }
  
  public void _addToListOfT(final List<? super String> l, final String arg) {
    _TGeneric._addToListOfT(l, arg);
  }
  
  public List<String> getMyL() {
    return _delegate.getMyL();
  }
  
  public void setMyL(final List<String> myL) {
    _delegate.setMyL(myL);
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import java.util.ArrayList;
import java.util.List;
import tests.traits.TUsesGeneric;
import tests.traits.impl.TUsesGenericImpl;

@SuppressWarnings("all")
public class C implements TUsesGeneric {
  private List<String> myL = new ArrayList<String>();
  
  public List<String> getMyL() {
    return this.myL;
  }
  
  public void setMyL(final List<String> myL) {
    this.myL = myL;
  }
  
  private TUsesGenericImpl _TUsesGeneric = new TUsesGenericImpl(this);
  
  public String updatedAndReturn() {
    return _TUsesGeneric._updatedAndReturn();
  }
  
  public List<? extends String> returnListOfT() {
    return _TUsesGeneric._returnListOfT();
  }
  
  public String searchInList(final List<? extends String> l, final String arg) {
    return _TUsesGeneric._searchInList(l, arg);
  }
  
  public T searchInList(final List<? extends T> l, final T arg) {
    return _TUsesGeneric._searchInList(l, arg);
  }
  
  public void addToListOfT(final List<? super String> l, final String arg) {
    _TUsesGeneric._addToListOfT(l, arg);
  }
  
  public void addToListOfT(final List<? super T> l, final T arg) {
    _TUsesGeneric._addToListOfT(l, arg);
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}
}
