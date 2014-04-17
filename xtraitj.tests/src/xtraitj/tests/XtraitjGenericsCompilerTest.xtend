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

assertTraitJavaInterface("tests", "T2",
'''
package tests.traits;

import java.util.List;
import tests.traits.T1;

@SuppressWarnings("all")
public interface T2 extends T1 {
  public abstract <T extends List<String>> String getFirst(final T t);
  
  public abstract <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2);
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests.traits.impl;

import java.util.List;
import tests.traits.T2;
import tests.traits.impl.T1Impl;

@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private T1Impl _T1;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
  }
  
  public <T extends List<String>> String getFirst(final T t) {
    return _delegate.getFirst(t);
  }
  
  public <T extends List<String>> String _getFirst(final T t) {
    return _T1._getFirst(t);
  }
  
  public <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2) {
    return _delegate.compare(t1, t2);
  }
  
  public <T extends Comparable<T>, U extends List<? extends T>> int _compare(final T t1, final U t2) {
    return _T1._compare(t1, t2);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitUsingGenericMethod() {
		traitUsingGenericMethod.compile[

assertTraitJavaClass("tests", "T1",
'''
package tests.traits.impl;

import java.util.ArrayList;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.InputOutput;
import tests.traits.T1;

@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  public <T> T identity(final T t) {
    return _delegate.identity(t);
  }
  
  public <T> T _identity(final T t) {
    return t;
  }
  
  public String useIdentity() {
    return _delegate.useIdentity();
  }
  
  public String _useIdentity() {
    final String s = this.<String>identity("foo");
    final Integer i = this.<Integer>identity(Integer.valueOf(0));
    ArrayList<Boolean> _newArrayList = CollectionLiterals.<Boolean>newArrayList(Boolean.valueOf(true), Boolean.valueOf(false));
    final ArrayList<Boolean> l = this.<ArrayList<Boolean>>identity(_newArrayList);
    return ((((s + ",") + i) + ",") + l);
  }
  
  public <V> V recursive(final V v) {
    return _delegate.recursive(v);
  }
  
  public <V> V _recursive(final V v) {
    V _recursive = this.<V>recursive(v);
    return this.<V>recursive(_recursive);
  }
  
  public <U> void noReturn(final U u) {
    _delegate.noReturn(u);
  }
  
  public <U> void _noReturn(final U u) {
    InputOutput.<Object>println(u);
  }
  
  public void useRecursive() {
    _delegate.useRecursive();
  }
  
  public void _useRecursive() {
    Integer _recursive = this.<Integer>recursive(Integer.valueOf(0));
    String _recursive_1 = this.<String>recursive("foo");
    String _plus = (_recursive + _recursive_1);
    InputOutput.<String>println(_plus);
  }
  
  public String useIdentityNested() {
    return _delegate.useIdentityNested();
  }
  
  public String _useIdentityNested() {
    String _identity = this.<String>identity("foo");
    final String s = this.<String>identity(_identity);
    Integer _identity_1 = this.<Integer>identity(Integer.valueOf(0));
    final Integer i = this.<Integer>identity(_identity_1);
    ArrayList<Boolean> _newArrayList = CollectionLiterals.<Boolean>newArrayList(Boolean.valueOf(true), Boolean.valueOf(false));
    ArrayList<Boolean> _identity_2 = this.<ArrayList<Boolean>>identity(_newArrayList);
    final ArrayList<Boolean> l = this.<ArrayList<Boolean>>identity(_identity_2);
    return ((((s + ",") + i) + ",") + l);
  }
  
  public void useNoReturn() {
    _delegate.useNoReturn();
  }
  
  public void _useNoReturn() {
    this.<String>noReturn("foo");
    this.<Integer>noReturn(Integer.valueOf(0));
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import tests.traits.T1;
import tests.traits.impl.T1Impl;

@SuppressWarnings("all")
public class C implements T1 {
  private T1Impl _T1 = new T1Impl(this);
  
  public <T> T identity(final T t) {
    return _T1._identity(t);
  }
  
  public String useIdentity() {
    return _T1._useIdentity();
  }
  
  public <V> V recursive(final V v) {
    return _T1._recursive(v);
  }
  
  public <U> void noReturn(final U u) {
    _T1._noReturn(u);
  }
  
  public void useRecursive() {
    _T1._useRecursive();
  }
  
  public String useIdentityNested() {
    return _T1._useIdentityNested();
  }
  
  public void useNoReturn() {
    _T1._useNoReturn();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "useIdentity", "foo,0,[true, false]")
			executeGeneratedJavaClassMethodAndAssert("C2", "useIdentity2", "bar,foo,0,[true, false]")
			executeGeneratedJavaClassMethodAndAssert("C", "useIdentityNested", "foo,0,[true, false]")
			executeGeneratedJavaClassMethodAndAssert("C2", "useIdentityNested", "foo,0,[true, false]")
			executeGeneratedJavaClassMethodAndAssert("C2", "useIdentityNested2", "bar,foo,0,[true, false]")
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
  public abstract List<String> getT();
  
  public abstract void setT(final List<String> t);
  
  public abstract Iterable<List<String>> getIterableOfStrings();
  
  public abstract void setIterableOfStrings(final Iterable<List<String>> iterableOfStrings);
  
  public abstract Iterable<Set<Integer>> getIterableOfIntegers();
  
  public abstract void setIterableOfIntegers(final Iterable<Set<Integer>> iterableOfIntegers);
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

assertTraitJavaClass("tests", "T2",
'''
package tests.traits.impl;

import java.util.List;
import java.util.Set;
import tests.traits.T2;
import tests.traits.impl.TUsesGenericImpl;

@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private TUsesGenericImpl _TUsesGeneric;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _TUsesGeneric = new TUsesGenericImpl(delegate);
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

	@Test def void testTraitUsesGenericTraitWithAlias() {
		traitUsesGenericTraitWithAlias.compile[

assertTraitJavaInterface("tests", "T2",
'''
package tests.traits;

import java.util.List;
import tests.traits.T2_T1_0_Adapter;

@SuppressWarnings("all")
public interface T2 extends T2_T1_0_Adapter {
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

	@Test def void testTraitUsesGenericTraitWithWildCard() {
		traitUsesGenericTraitWithWildCard.compile[

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests.traits;

import java.util.List;
import tests.traits.TGeneric;

@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<String> {
  public abstract String updateAndReturn();
  
  public abstract List<? extends String> returnListOfT();
  
  public abstract String searchInList(final List<? extends String> l, final String arg);
  
  public abstract void addToListOfT(final List<? super String> l, final String arg);
  
  public abstract void addToListOfTDefault(final List<? super String> l);
  
  public abstract List<String> getMyL();
  
  public abstract void setMyL(final List<String> myL);
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
  
  public String updateAndReturn() {
    return _delegate.updateAndReturn();
  }
  
  public String _updateAndReturn() {
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
  
  public void addToListOfTDefault(final List<? super String> l) {
    _delegate.addToListOfTDefault(l);
  }
  
  public void _addToListOfTDefault(final List<? super String> l) {
    _TGeneric._addToListOfTDefault(l);
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
  
  public String updateAndReturn() {
    return _TUsesGeneric._updateAndReturn();
  }
  
  public List<? extends String> returnListOfT() {
    return _TUsesGeneric._returnListOfT();
  }
  
  public String searchInList(final List<? extends String> l, final String arg) {
    return _TUsesGeneric._searchInList(l, arg);
  }
  
  public void addToListOfT(final List<? super String> l, final String arg) {
    _TUsesGeneric._addToListOfT(l, arg);
  }
  
  public void addToListOfTDefault(final List<? super String> l) {
    _TUsesGeneric._addToListOfTDefault(l);
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "updateAndReturn", "foo")
		]
	}

	@Test def void testPassTypeParameterAsTypeArgument() {
		passTypeParameterAsTypeArgument.compile[

assertTraitJavaInterface("tests", "T2",
'''
package tests.traits;

import tests.traits.T1;

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
