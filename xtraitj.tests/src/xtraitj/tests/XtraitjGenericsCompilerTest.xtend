package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(InjectorProviderCustom))
class XtraitjGenericsCompilerTest extends AbstractXtraitjCompilerTest {
	
	@Test def void testGenericClass() {
		genericClass.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IterableExtensions;

@SuppressWarnings("all")
public class C<T extends List<String>, U extends Object> {
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
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends List<String>, U extends Object> {
  @XtraitjRequiredField
  public abstract T getT();
  
  @XtraitjRequiredFieldSetter
  public abstract void setT(final T t);
  
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract T read_t();
  
  @XtraitjDefinedMethod
  public abstract void update_t(final T t);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl<T extends List<String>, U extends Object> implements T1<T, U> {
  private T1<T, U> _delegate;
  
  public T1Impl(final T1<T, U> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public T getT() {
    return _delegate.getT();
  }
  
  public void setT(final T t) {
    _delegate.setT(t);
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    final T t1 = this.getT();
    this.setT(t1);
    T _t = this.getT();
    return IterableExtensions.<String>head(_t);
  }
  
  @XtraitjDefinedMethod
  public T read_t() {
    return _delegate.read_t();
  }
  
  public T _read_t() {
    final T t1 = this.getT();
    return t1;
  }
  
  @XtraitjDefinedMethod
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

	@Test def void testGenericTraitWithRecursiveTypeParameterNotUsed() {
		genericTraitWithRecursiveTypeParameterNotUsed.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends Comparable<T>> {
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl<T extends Comparable<T>> implements T1<T> {
  private T1<T> _delegate;
  
  public T1Impl(final T1<T> delegate) {
    this._delegate = delegate;
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testGenericTraitWithRecursiveTypeParameterUsedInMethod() {
		genericTraitWithRecursiveTypeParameterUsedInMethod.compile[

assertTraitJavaClass("tests", "T1",
'''
package tests;

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl<T extends Comparable<T>> implements T1<T> {
  private T1<T> _delegate;
  
  public T1Impl(final T1<T> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
  public int compare(final T t1, final T t2) {
    return _delegate.compare(t1, t2);
  }
  
  public int _compare(final T t1, final T t2) {
    return t1.compareTo(t2);
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
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends Comparable<T>> {
  @XtraitjRequiredField
  public abstract T getT();
  
  @XtraitjRequiredFieldSetter
  public abstract void setT(final T t);
  
  @XtraitjDefinedMethod
  public abstract int compare(final T t1);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl<T extends Comparable<T>> implements T1<T> {
  private T1<T> _delegate;
  
  public T1Impl(final T1<T> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public T getT() {
    return _delegate.getT();
  }
  
  public void setT(final T t) {
    _delegate.setT(t);
  }
  
  @XtraitjDefinedMethod
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
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends Comparable<T>, U extends List<? extends T>> {
  @XtraitjRequiredField
  public abstract T getT();
  
  @XtraitjRequiredFieldSetter
  public abstract void setT(final T t);
  
  @XtraitjDefinedMethod
  public abstract int compare(final U t1);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.List;
import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl<T extends Comparable<T>, U extends List<? extends T>> implements T1<T, U> {
  private T1<T, U> _delegate;
  
  public T1Impl(final T1<T, U> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public T getT() {
    return _delegate.getT();
  }
  
  public void setT(final T t) {
    _delegate.setT(t);
  }
  
  @XtraitjDefinedMethod
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





	@Test def void testTraitWithGenericMethodShadowingTraitTypeParameter() {
		traitWithGenericMethodShadowingTraitTypeParameter.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends Object> {
  @XtraitjDefinedMethod
  public abstract <T extends List<String>> String getFirst(final T t);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.List;
import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl<T extends Object> implements T1<T> {
  private T1<T> _delegate;
  
  public T1Impl(final T1<T> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
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

	@Test def void testClassImplementsAllGenericInterfaceMethods() {
		classImplementsAllGenericInterfaceMethods.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import tests.T1;
import tests.T1Impl;
import tests.T2;
import tests.T2Impl;
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

	@Test def void testClassImplementsAllGenericInterfaceMethods2() {
		classImplementsAllGenericInterfaceMethods2.compile[

assertJavaClass("tests", "C",
'''
package tests;

import tests.T1;
import tests.T1Impl;
import xtraitj.input.tests.MyGenericTestInterface3;

@SuppressWarnings("all")
public class C implements MyGenericTestInterface3<Integer>, T1 {
  private T1Impl _T1 = new T1Impl(this);
  
  public Integer n(final int i) {
    return _T1._n(i);
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassImplementsAllGenericInterfaceMethods3() {
		classImplementsAllGenericInterfaceMethods3.compile[

assertJavaClass("tests", "C",
'''
package tests;

import tests.T1;
import tests.T1Impl;
import xtraitj.input.tests.MyGenericTestInterface3;

@SuppressWarnings("all")
public class C<U extends Object> implements MyGenericTestInterface3<U>, T1<U> {
  private T1Impl<U> _T1 = new T1Impl(this);
  
  public U n(final int i) {
    return _T1._n(i);
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassImplementsAllGenericInterfaceMethodsWithCovariantReturnType() {
		classImplementsAllGenericInterfaceMethodsWithCovariantReturnType.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import java.util.ArrayList;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<U extends Object> {
  @XtraitjDefinedMethod
  public abstract ArrayList<U> n(final int i);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.ArrayList;
import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl<U extends Object> implements T1<U> {
  private T1<U> _delegate;
  
  public T1Impl(final T1<U> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
  public ArrayList<U> n(final int i) {
    return _delegate.n(i);
  }
  
  public ArrayList<U> _n(final int i) {
    return null;
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import java.util.ArrayList;
import tests.T1;
import tests.T1Impl;
import xtraitj.input.tests.MyGenericTestInterface2;

@SuppressWarnings("all")
public class C<U extends Object> implements MyGenericTestInterface2<U>, T1<U> {
  private T1Impl<U> _T1 = new T1Impl(this);
  
  public ArrayList<U> n(final int i) {
    return _T1._n(i);
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassImplementsAllGenericInterfaceMethodsWithCovariantReturnType2() {
		classImplementsAllGenericInterfaceMethodsWithCovariantReturnType2.compile[

assertJavaClass("tests", "C",
'''
package tests;

import java.util.ArrayList;
import tests.T1;
import tests.T1Impl;
import xtraitj.input.tests.MyGenericTestInterface2;

@SuppressWarnings("all")
public class C implements MyGenericTestInterface2<String>, T1<String> {
  private T1Impl<String> _T1 = new T1Impl(this);
  
  public ArrayList<String> n(final int i) {
    return _T1._n(i);
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
package tests;

import java.util.List;
import tests.TGeneric;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<List<String>> {
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import tests.TGenericImpl;
import tests.TUsesGeneric;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
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
import tests.TGeneric;
import tests.TGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric implements TGeneric<List<String>> {
  private TGenericImpl<List<String>> _TGeneric = new TGenericImpl(this);
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testRequiredMethodsWithGenerics() {
		requiredMethodsWithGenerics.compile[

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import tests.TGenericImpl;
import tests.TUsesGeneric;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<String> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  @XtraitjRequiredMethod
  public Iterable<String> iterableOfStrings() {
    return _delegate.iterableOfStrings();
  }
}
'''
)

assertJavaClass("tests", "CUsesGeneric",
'''
package tests;

import tests.T2;
import tests.T2Impl;
import tests.TUsesGeneric;
import tests.TUsesGenericImpl;

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

import tests.T2;
import tests.T2Impl;
import tests.TGeneric;
import tests.TGenericImpl;

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

	@Test def void testCompliantRequiredMethodsWithGenerics() {
		compliantRequiredMethodsWithGenerics.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends Object> {
  @XtraitjRequiredMethod
  public abstract int i();
  
  @XtraitjRequiredMethod
  public abstract List<String> m();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T1<String>, T2 {
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testCompliantRequiredMethodsWithGenericsAfterTypeParamInstantiation() {
		compliantRequiredMethodsWithGenericsAfterTypeParamInstantiation.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends Object> {
  @XtraitjRequiredMethod
  public abstract int i();
  
  @XtraitjRequiredMethod
  public abstract List<T> m();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T1<String>, T2 {
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitUsesGenericTraitWithDefinedMethods() {
		traitUsesGenericTraitWithDefinedMethod.compile[

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import tests.TGenericImpl;
import tests.TUsesGeneric;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<String> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  @XtraitjDefinedMethod
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
import tests.TUsesGeneric;
import tests.TUsesGenericImpl;

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

	@Test def void testCompliantRequiredFieldsWithGenericsAfterTypeParamInstantiation() {
		compliantRequiredFieldsWithGenericsAfterTypeParamInstantiation.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends Object> {
  @XtraitjRequiredField
  public abstract int getI();
  
  @XtraitjRequiredFieldSetter
  public abstract void setI(final int i);
  
  @XtraitjRequiredField
  public abstract List<T> getLl();
  
  @XtraitjRequiredFieldSetter
  public abstract void setLl(final List<T> ll);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T1<String>, T2 {
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import java.util.List;
import tests.T1Impl;
import tests.T2Impl;
import tests.T3;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T1Impl<String> _T1;
  
  private T2Impl _T2;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
    _T2 = new T2Impl(delegate);
  }
  
  @XtraitjRequiredField
  public int getI() {
    return _delegate.getI();
  }
  
  public void setI(final int i) {
    _delegate.setI(i);
  }
  
  @XtraitjRequiredField
  public List<String> getLl() {
    return _delegate.getLl();
  }
  
  public void setLl(final List<String> ll) {
    _delegate.setLl(ll);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitUsesGenericTraitWithFields() {
		traitUsesGenericTraitWithFields.compile[

assertTraitJavaInterface("tests", "TGeneric",
'''
package tests;

import java.util.Collection;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TGeneric<T extends Collection<String>, U extends Collection<Integer>> {
  @XtraitjRequiredField
  public abstract T getT();
  
  @XtraitjRequiredFieldSetter
  public abstract void setT(final T t);
  
  @XtraitjRequiredField
  public abstract Iterable<T> getIterableOfStrings();
  
  @XtraitjRequiredFieldSetter
  public abstract void setIterableOfStrings(final Iterable<T> iterableOfStrings);
  
  @XtraitjRequiredField
  public abstract Iterable<U> getIterableOfIntegers();
  
  @XtraitjRequiredFieldSetter
  public abstract void setIterableOfIntegers(final Iterable<U> iterableOfIntegers);
}
'''
)

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import java.util.Set;
import tests.TGeneric;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<List<String>, Set<Integer>> {
}
'''
)


assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import java.util.Set;
import tests.TGenericImpl;
import tests.TUsesGeneric;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<List<String>, Set<Integer>> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  @XtraitjRequiredField
  public List<String> getT() {
    return _delegate.getT();
  }
  
  public void setT(final List<String> t) {
    _delegate.setT(t);
  }
  
  @XtraitjRequiredField
  public Iterable<List<String>> getIterableOfStrings() {
    return _delegate.getIterableOfStrings();
  }
  
  public void setIterableOfStrings(final Iterable<List<String>> iterableOfStrings) {
    _delegate.setIterableOfStrings(iterableOfStrings);
  }
  
  @XtraitjRequiredField
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
package tests;

import java.util.List;
import java.util.Set;
import tests.T2;
import tests.TUsesGenericImpl;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private TUsesGenericImpl _TUsesGeneric;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _TUsesGeneric = new TUsesGenericImpl(delegate);
  }
  
  @XtraitjRequiredField
  public List<String> getT() {
    return _delegate.getT();
  }
  
  public void setT(final List<String> t) {
    _delegate.setT(t);
  }
  
  @XtraitjRequiredField
  public Iterable<List<String>> getIterableOfStrings() {
    return _delegate.getIterableOfStrings();
  }
  
  public void setIterableOfStrings(final Iterable<List<String>> iterableOfStrings) {
    _delegate.setIterableOfStrings(iterableOfStrings);
  }
  
  @XtraitjRequiredField
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
import tests.TGeneric;
import tests.TGenericImpl;

@SuppressWarnings("all")
public class CUsesGeneric implements TGeneric<List<String>, Set<Integer>> {
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
  
  private TGenericImpl<List<String>, Set<Integer>> _TGeneric = new TGenericImpl(this);
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testCompliantRequiredFieldsWithGenerics() {
		compliantRequiredFieldsWithGenerics.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1<T extends Object> {
  @XtraitjRequiredField
  public abstract int getI();
  
  @XtraitjRequiredFieldSetter
  public abstract void setI(final int i);
  
  @XtraitjRequiredField
  public abstract List<String> getLl();
  
  @XtraitjRequiredFieldSetter
  public abstract void setLl(final List<String> ll);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T1<String>, T2 {
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import java.util.List;
import tests.T1Impl;
import tests.T2Impl;
import tests.T3;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T1Impl<String> _T1;
  
  private T2Impl _T2;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
    _T2 = new T2Impl(delegate);
  }
  
  @XtraitjRequiredField
  public int getI() {
    return _delegate.getI();
  }
  
  public void setI(final int i) {
    _delegate.setI(i);
  }
  
  @XtraitjRequiredField
  public List<String> getLl() {
    return _delegate.getLl();
  }
  
  public void setLl(final List<String> ll) {
    _delegate.setLl(ll);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testGenericFunctionType() {
		genericFunctionType.compile[

assertTraitJavaInterface("tests", "TGenericExtensions",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TGenericExtensions<T extends Object> {
  @XtraitjRequiredField
  public abstract Iterable<T> getIterable();
  
  @XtraitjRequiredFieldSetter
  public abstract void setIterable(final Iterable<T> iterable);
  
  @XtraitjDefinedMethod
  public abstract <R extends Object> List<R> mapToList(final Function1<? super T, ? extends R> mapper);
  
  @XtraitjDefinedMethod
  public abstract List<T> mapToList2(final Function1<? super T, ? extends T> mapper);
}
'''
)

assertTraitJavaClass("tests", "TGenericExtensions",
'''
package tests;

import java.util.ArrayList;
import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import tests.TGenericExtensions;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TGenericExtensionsImpl<T extends Object> implements TGenericExtensions<T> {
  private TGenericExtensions<T> _delegate;
  
  public TGenericExtensionsImpl(final TGenericExtensions<T> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public Iterable<T> getIterable() {
    return _delegate.getIterable();
  }
  
  public void setIterable(final Iterable<T> iterable) {
    _delegate.setIterable(iterable);
  }
  
  @XtraitjDefinedMethod
  public <R extends Object> List<R> mapToList(final Function1<? super T, ? extends R> mapper) {
    return _delegate.mapToList(mapper);
  }
  
  public <R extends Object> List<R> _mapToList(final Function1<? super T, ? extends R> mapper) {
    final ArrayList<R> result = new ArrayList<R>();
    Iterable<T> _iterable = this.getIterable();
    for (final T e : _iterable) {
      R _apply = mapper.apply(e);
      result.add(_apply);
    }
    return result;
  }
  
  @XtraitjDefinedMethod
  public List<T> mapToList2(final Function1<? super T, ? extends T> mapper) {
    return _delegate.mapToList2(mapper);
  }
  
  public List<T> _mapToList2(final Function1<? super T, ? extends T> mapper) {
    final ArrayList<T> result = new ArrayList<T>();
    Iterable<T> _iterable = this.getIterable();
    for (final T e : _iterable) {
      T _apply = mapper.apply(e);
      result.add(_apply);
    }
    return result;
  }
}
'''
)

assertTraitJavaInterface("tests", "TStringExtensions",
'''
package tests;

import tests.TGenericExtensions;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TStringExtensions extends TGenericExtensions<String> {
}
'''
)

assertTraitJavaClass("tests", "TStringExtensions",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import tests.TGenericExtensionsImpl;
import tests.TStringExtensions;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TStringExtensionsImpl implements TStringExtensions {
  private TStringExtensions _delegate;
  
  private TGenericExtensionsImpl<String> _TGenericExtensions;
  
  public TStringExtensionsImpl(final TStringExtensions delegate) {
    this._delegate = delegate;
    _TGenericExtensions = new TGenericExtensionsImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public <R extends Object> List<R> mapToList(final Function1<? super String, ? extends R> mapper) {
    return _delegate.mapToList(mapper);
  }
  
  public <R extends Object> List<R> _mapToList(final Function1<? super String, ? extends R> mapper) {
    return _TGenericExtensions._mapToList(mapper);
  }
  
  @XtraitjDefinedMethod
  public List<String> mapToList2(final Function1<? super String, ? extends String> mapper) {
    return _delegate.mapToList2(mapper);
  }
  
  public List<String> _mapToList2(final Function1<? super String, ? extends String> mapper) {
    return _TGenericExtensions._mapToList2(mapper);
  }
  
  @XtraitjRequiredField
  public Iterable<String> getIterable() {
    return _delegate.getIterable();
  }
  
  public void setIterable(final Iterable<String> iterable) {
    _delegate.setIterable(iterable);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassUsesTraitWithGenericFunctionType() {
		classUsesTraitWithGenericFunctionType.compile[

assertJavaClass("tests", "StringExtensions",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import tests.TGenericExtensions;
import tests.TGenericExtensionsImpl;

@SuppressWarnings("all")
public class StringExtensions<U extends Object> implements TGenericExtensions<U> {
  private Iterable<U> iterable;
  
  public Iterable<U> getIterable() {
    return this.iterable;
  }
  
  public void setIterable(final Iterable<U> iterable) {
    this.iterable = iterable;
  }
  
  private TGenericExtensionsImpl<U> _TGenericExtensions = new TGenericExtensionsImpl(this);
  
  public <R extends Object> List<R> mapToList(final Function1<? super U, ? extends R> mapper) {
    return _TGenericExtensions._mapToList(mapper);
  }
  
  public List<U> mapToList2(final Function1<? super U, ? extends U> mapper) {
    return _TGenericExtensions._mapToList2(mapper);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassUsesTraitWithGenericFunctionTypeInstantiated() {
		classUsesTraitWithGenericFunctionTypeInstantiated.compile[

assertJavaClass("tests", "StringExtensions",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import tests.TGenericExtensions;
import tests.TGenericExtensionsImpl;

@SuppressWarnings("all")
public class StringExtensions implements TGenericExtensions<String> {
  private Iterable<String> iterable;
  
  public Iterable<String> getIterable() {
    return this.iterable;
  }
  
  public void setIterable(final Iterable<String> iterable) {
    this.iterable = iterable;
  }
  
  private TGenericExtensionsImpl<String> _TGenericExtensions = new TGenericExtensionsImpl(this);
  
  public <R extends Object> List<R> mapToList(final Function1<? super String, ? extends R> mapper) {
    return _TGenericExtensions._mapToList(mapper);
  }
  
  public List<String> mapToList2(final Function1<? super String, ? extends String> mapper) {
    return _TGenericExtensions._mapToList2(mapper);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testClassGenericFunctionAsField() {
		classGenericFunctionAsField.compile[
			executeGeneratedJavaClassMethodAndAssert("C2", "m", "Test")
		]
	}

	@Test def void testTraitUsesGenericTraitWithWildCard() {
		traitUsesGenericTraitWithWildCard.compile[

assertTraitJavaInterface("tests", "TGeneric",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TGeneric<T extends Object> {
  @XtraitjRequiredField
  public abstract List<T> getMyL();
  
  @XtraitjRequiredFieldSetter
  public abstract void setMyL(final List<T> myL);
  
  @XtraitjDefinedMethod
  public abstract List<? extends T> returnListOfT();
  
  @XtraitjDefinedMethod
  public abstract T searchInList(final List<? extends T> l, final T arg);
  
  @XtraitjDefinedMethod
  public abstract void addToListOfT(final List<? super T> l, final T arg);
  
  @XtraitjDefinedMethod
  public abstract void addToListOfTDefault(final List<? super T> l);
}
'''
)

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests;

import tests.TGeneric;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<String> {
  @XtraitjDefinedMethod
  public abstract String updateAndReturn();
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import tests.TGenericImpl;
import tests.TUsesGeneric;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<String> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  @XtraitjDefinedMethod
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
  
  @XtraitjDefinedMethod
  public List<? extends String> returnListOfT() {
    return _delegate.returnListOfT();
  }
  
  public List<? extends String> _returnListOfT() {
    return _TGeneric._returnListOfT();
  }
  
  @XtraitjDefinedMethod
  public String searchInList(final List<? extends String> l, final String arg) {
    return _delegate.searchInList(l, arg);
  }
  
  public String _searchInList(final List<? extends String> l, final String arg) {
    return _TGeneric._searchInList(l, arg);
  }
  
  @XtraitjDefinedMethod
  public void addToListOfT(final List<? super String> l, final String arg) {
    _delegate.addToListOfT(l, arg);
  }
  
  public void _addToListOfT(final List<? super String> l, final String arg) {
    _TGeneric._addToListOfT(l, arg);
  }
  
  @XtraitjDefinedMethod
  public void addToListOfTDefault(final List<? super String> l) {
    _delegate.addToListOfTDefault(l);
  }
  
  public void _addToListOfTDefault(final List<? super String> l) {
    _TGeneric._addToListOfTDefault(l);
  }
  
  @XtraitjRequiredField
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
import tests.TUsesGeneric;
import tests.TUsesGenericImpl;

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

	@Test def void testTraitUsesGenericTraitWithRequiredMethods() {
		traitUsesGenericTraitWithRequiredMethods.compile[

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import java.util.Set;
import tests.TGeneric;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TUsesGeneric extends TGeneric<String, Set<Integer>> {
  @XtraitjDefinedMethod
  public abstract Iterable<String> iterableOfStrings();
  
  @XtraitjDefinedMethod
  public abstract <V extends List<String>> String getFirst(final V t);
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import java.util.Set;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import tests.TGenericImpl;
import tests.TUsesGeneric;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGenericImpl implements TUsesGeneric {
  private TUsesGeneric _delegate;
  
  private TGenericImpl<String, Set<Integer>> _TGeneric;
  
  public TUsesGenericImpl(final TUsesGeneric delegate) {
    this._delegate = delegate;
    _TGeneric = new TGenericImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public Iterable<String> iterableOfStrings() {
    return _delegate.iterableOfStrings();
  }
  
  public Iterable<String> _iterableOfStrings() {
    return CollectionLiterals.<String>newArrayList("foo");
  }
  
  @XtraitjDefinedMethod
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
import tests.TUsesGeneric;
import tests.TUsesGenericImpl;

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

	@Test def void testTraitUsingGenericMethod() {
		traitUsingGenericMethod.compile[
			expectationsForTraitUsingGenericMethod(it)
		]
	}

	@Test def void testTraitUsingGenericMethodSeparateFiles() {
		traitUsingGenericMethodSeparateFiles.compile[
			expectationsForTraitUsingGenericMethod(it)
		]
	}
	
	private def expectationsForTraitUsingGenericMethod(Result it) {
assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.ArrayList;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.InputOutput;
import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
  public <T extends Object> T identity(final T t) {
    return _delegate.identity(t);
  }
  
  public <T extends Object> T _identity(final T t) {
    return t;
  }
  
  @XtraitjDefinedMethod
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
  
  @XtraitjDefinedMethod
  public <V extends Object> V recursive(final V v) {
    return _delegate.recursive(v);
  }
  
  public <V extends Object> V _recursive(final V v) {
    V _recursive = this.<V>recursive(v);
    return this.<V>recursive(_recursive);
  }
  
  /**
   * IMPORTANT:
   * The generated Java code in T1Impl._noReturn() must be
   * InputOutput.<U>println(u);
   * Otherwise it means type parameter references are not correctly bound!
   */
  @XtraitjDefinedMethod
  public <U extends Object> void noReturn(final U u) {
    _delegate.noReturn(u);
  }
  
  /**
   * IMPORTANT:
   * The generated Java code in T1Impl._noReturn() must be
   * InputOutput.<U>println(u);
   * Otherwise it means type parameter references are not correctly bound!
   */
  public <U extends Object> void _noReturn(final U u) {
    InputOutput.<U>println(u);
  }
  
  @XtraitjDefinedMethod
  public void useRecursive() {
    _delegate.useRecursive();
  }
  
  public void _useRecursive() {
    Integer _recursive = this.<Integer>recursive(Integer.valueOf(0));
    String _recursive_1 = this.<String>recursive("foo");
    String _plus = (_recursive + _recursive_1);
    InputOutput.<String>println(_plus);
  }
  
  @XtraitjDefinedMethod
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
  
  @XtraitjDefinedMethod
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

assertTraitJavaInterface("tests", "T2",
'''
package tests;

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T2 extends T1 {
  @XtraitjDefinedMethod
  public abstract String useIdentity2();
  
  @XtraitjDefinedMethod
  public abstract String useIdentityNested2();
  
  @XtraitjDefinedMethod
  public abstract void useNoReturn2();
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests;

import tests.T1Impl;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private T1Impl _T1;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
  }
  
  @XtraitjDefinedMethod
  public String useIdentity2() {
    return _delegate.useIdentity2();
  }
  
  public String _useIdentity2() {
    final String s = this.<String>identity("bar");
    String _useIdentity = this.useIdentity();
    return ((s + ",") + _useIdentity);
  }
  
  @XtraitjDefinedMethod
  public String useIdentityNested2() {
    return _delegate.useIdentityNested2();
  }
  
  public String _useIdentityNested2() {
    String _identity = this.<String>identity("bar");
    final String s = this.<String>identity(_identity);
    String _useIdentityNested = this.useIdentityNested();
    return ((s + ",") + _useIdentityNested);
  }
  
  @XtraitjDefinedMethod
  public void useNoReturn2() {
    _delegate.useNoReturn2();
  }
  
  public void _useNoReturn2() {
    this.<String>noReturn("foo");
    this.<Integer>noReturn(Integer.valueOf(0));
  }
  
  @XtraitjDefinedMethod
  public <T extends Object> T identity(final T t) {
    return _delegate.identity(t);
  }
  
  public <T extends Object> T _identity(final T t) {
    return _T1._identity(t);
  }
  
  @XtraitjDefinedMethod
  public String useIdentity() {
    return _delegate.useIdentity();
  }
  
  public String _useIdentity() {
    return _T1._useIdentity();
  }
  
  @XtraitjDefinedMethod
  public <V extends Object> V recursive(final V v) {
    return _delegate.recursive(v);
  }
  
  public <V extends Object> V _recursive(final V v) {
    return _T1._recursive(v);
  }
  
  /**
   * IMPORTANT:
   * The generated Java code in T1Impl._noReturn() must be
   * InputOutput.<U>println(u);
   * Otherwise it means type parameter references are not correctly bound!
   */
  @XtraitjDefinedMethod
  public <U extends Object> void noReturn(final U u) {
    _delegate.noReturn(u);
  }
  
  /**
   * IMPORTANT:
   * The generated Java code in T1Impl._noReturn() must be
   * InputOutput.<U>println(u);
   * Otherwise it means type parameter references are not correctly bound!
   */
  public <U extends Object> void _noReturn(final U u) {
    _T1._noReturn(u);
  }
  
  @XtraitjDefinedMethod
  public void useRecursive() {
    _delegate.useRecursive();
  }
  
  public void _useRecursive() {
    _T1._useRecursive();
  }
  
  @XtraitjDefinedMethod
  public String useIdentityNested() {
    return _delegate.useIdentityNested();
  }
  
  public String _useIdentityNested() {
    return _T1._useIdentityNested();
  }
  
  @XtraitjDefinedMethod
  public void useNoReturn() {
    _delegate.useNoReturn();
  }
  
  public void _useNoReturn() {
    _T1._useNoReturn();
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import tests.T1;
import tests.T1Impl;

@SuppressWarnings("all")
public class C implements T1 {
  private T1Impl _T1 = new T1Impl(this);
  
  public <T extends Object> T identity(final T t) {
    return _T1._identity(t);
  }
  
  public String useIdentity() {
    return _T1._useIdentity();
  }
  
  public <V extends Object> V recursive(final V v) {
    return _T1._recursive(v);
  }
  
  /**
   * IMPORTANT:
   * The generated Java code in T1Impl._noReturn() must be
   * InputOutput.<U>println(u);
   * Otherwise it means type parameter references are not correctly bound!
   */
  public <U extends Object> void noReturn(final U u) {
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
	}

	@Test def void testTraitWithGenericMethod() {
		traitWithGenericMethod.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1 {
  @XtraitjDefinedMethod
  public abstract <T extends List<String>> String getFirst(final T t);
  
  @XtraitjDefinedMethod
  public abstract <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.List;
import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1Impl implements T1 {
  private T1 _delegate;
  
  public T1Impl(final T1 delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
  public <T extends List<String>> String getFirst(final T t) {
    return _delegate.getFirst(t);
  }
  
  public <T extends List<String>> String _getFirst(final T t) {
    return t.get(0);
  }
  
  @XtraitjDefinedMethod
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
package tests;

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T2 extends T1 {
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests;

import java.util.List;
import tests.T1Impl;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private T1Impl _T1;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
  }
  
  @XtraitjDefinedMethod
  public <T extends List<String>> String getFirst(final T t) {
    return _delegate.getFirst(t);
  }
  
  public <T extends List<String>> String _getFirst(final T t) {
    return _T1._getFirst(t);
  }
  
  @XtraitjDefinedMethod
  public <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2) {
    return _delegate.compare(t1, t2);
  }
  
  public <T extends Comparable<T>, U extends List<? extends T>> int _compare(final T t1, final U t2) {
    return _T1._compare(t1, t2);
  }
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T2 {
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import java.util.List;
import tests.T2Impl;
import tests.T3;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T2Impl _T2;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2 = new T2Impl(delegate);
  }
  
  @XtraitjDefinedMethod
  public <T extends List<String>> String getFirst(final T t) {
    return _delegate.getFirst(t);
  }
  
  public <T extends List<String>> String _getFirst(final T t) {
    return _T2._getFirst(t);
  }
  
  @XtraitjDefinedMethod
  public <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2) {
    return _delegate.compare(t1, t2);
  }
  
  public <T extends Comparable<T>, U extends List<? extends T>> int _compare(final T t1, final U t2) {
    return _T2._compare(t1, t2);
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import tests.T2;
import tests.T2Impl;

@SuppressWarnings("all")
public class C implements T2 {
  private T2Impl _T2 = new T2Impl(this);
  
  public <T extends List<String>> String getFirst(final T t) {
    return _T2._getFirst(t);
  }
  
  public <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2) {
    return _T2._compare(t1, t2);
  }
}
'''
)

assertJavaClass("tests", "C2",
'''
package tests;

import java.util.List;
import tests.T1;
import tests.T1Impl;

@SuppressWarnings("all")
public class C2 implements T1 {
  private T1Impl _T1 = new T1Impl(this);
  
  public <T extends List<String>> String getFirst(final T t) {
    return _T1._getFirst(t);
  }
  
  public <T extends Comparable<T>, U extends List<? extends T>> int compare(final T t1, final U t2) {
    return _T1._compare(t1, t2);
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitWithTypeParametersWithDifferentNames() {
		traitWithTypeParametersWithDifferentNames.compile[
			expectationsForTraitWithTypeParametersWithDifferentNames(it)
		]
	}

	@Test def void testTraitWithTypeParametersWithDifferentNamesSeparateFiles() {
		traitWithTypeParametersWithDifferentNamesSeparateFiles.compile[
			expectationsForTraitWithTypeParametersWithDifferentNames(it)
		]
	}
	
	private def expectationsForTraitWithTypeParametersWithDifferentNames(Result it) {
assertTraitJavaClass("tests", "T3",
'''
package tests;

import org.eclipse.xtext.xbase.lib.InputOutput;
import tests.T2Impl;
import tests.T3;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl<G3 extends Object> implements T3<G3> {
  private T3<G3> _delegate;
  
  private T2Impl<G3> _T2;
  
  public T3Impl(final T3<G3> delegate) {
    this._delegate = delegate;
    _T2 = new T2Impl(delegate);
  }
  
  @XtraitjDefinedMethod
  public String meth() {
    return _delegate.meth();
  }
  
  public String _meth() {
    G3 _fieldT1 = this.getFieldT1();
    InputOutput.<G3>println(_fieldT1);
    final G3 t1 = this.getFieldT1();
    this.setFieldT1(t1);
    G3 _fieldT2 = this.getFieldT2();
    InputOutput.<G3>println(_fieldT2);
    final G3 t2 = this.getFieldT2();
    this.setFieldT2(t2);
    return "foo";
  }
  
  @XtraitjDefinedMethod
  public G3 mT2() {
    return _delegate.mT2();
  }
  
  public G3 _mT2() {
    return _T2._mT2();
  }
  
  @XtraitjDefinedMethod
  public G3 mT1() {
    return _delegate.mT1();
  }
  
  public G3 _mT1() {
    return _T2._mT1();
  }
  
  @XtraitjRequiredField
  public G3 getFieldT2() {
    return _delegate.getFieldT2();
  }
  
  public void setFieldT2(final G3 fieldT2) {
    _delegate.setFieldT2(fieldT2);
  }
  
  @XtraitjRequiredField
  public G3 getFieldT1() {
    return _delegate.getFieldT1();
  }
  
  public void setFieldT1(final G3 fieldT1) {
    _delegate.setFieldT1(fieldT1);
  }
}
'''
)

assertJavaClass("tests", "C3",
'''
package tests;

import tests.T3;
import tests.T3Impl;

@SuppressWarnings("all")
public class C3<U extends Object> implements T3<U> {
  private U fieldT1;
  
  public U getFieldT1() {
    return this.fieldT1;
  }
  
  public void setFieldT1(final U fieldT1) {
    this.fieldT1 = fieldT1;
  }
  
  private U fieldT2;
  
  public U getFieldT2() {
    return this.fieldT2;
  }
  
  public void setFieldT2(final U fieldT2) {
    this.fieldT2 = fieldT2;
  }
  
  private T3Impl<U> _T3 = new T3Impl(this);
  
  public String meth() {
    return _T3._meth();
  }
  
  public U mT2() {
    return _T3._mT2();
  }
  
  public U mT1() {
    return _T3._mT1();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
	}

	@Test def void testTraitUsesGenericTraitClass() {
		traitUsesGenericClass.compile[
			expectationsForTraitUsesGenericClass(it)
		]
	}

	@Test def void testTraitUsesGenericTraitClassSeparateFiles() {
		traitUsesGenericClassSeparateFiles.compile[
			expectationsForTraitUsesGenericClass(it)
		]
	}
	
	def expectationsForTraitUsesGenericClass(Result it) {
		executeGeneratedJavaClassMethodAndAssert("CString", "m", "test")
		executeGeneratedJavaClassMethodAndAssert("CInteger", "m", "10")
		executeGeneratedJavaClassMethodAndAssert("CListOfStrings", "m", "[a, b, c]")
	}

	@Test def void testAccessToGeneratedJavaCodeWithoutOriginalSource() {
		accessToGeneratedJavaCodeWithoutOriginalSource.compile[
			executeGeneratedJavaClassMethodAndAssert("C", "useProvided", "test")
			executeGeneratedJavaClassMethodAndAssert("C2", "useProvided", "test")
		]
	}
}
