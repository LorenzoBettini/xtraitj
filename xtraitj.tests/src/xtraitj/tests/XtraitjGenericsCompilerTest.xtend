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

import tests.traits.TGeneric;

@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<String> {
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests.traits.impl;

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
}
'''
)

assertJavaClass("tests", "CUsesGeneric",
'''
package tests;

import tests.traits.TGeneric;
import tests.traits.impl.TGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric implements TGeneric<String> {
  private TGenericImpl<String> _TGeneric = new TGenericImpl(this);
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}
}
