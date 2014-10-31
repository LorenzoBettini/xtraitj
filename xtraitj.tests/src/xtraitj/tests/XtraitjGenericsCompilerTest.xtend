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
class XtraitjGenericsCompilerTest extends AbstractXtraitjCompilerTest {
	@Inject extension CompilationTestHelper
	@Inject extension XtraitjInputs
	
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
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface<T extends List<String>, U> {
  @XtraitjRequiredField
  public abstract T getT();
  
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
import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1<T extends List<String>, U> implements T1Interface<T, U> {
  private T1Interface<T, U> _delegate;
  
  public T1(final T1Interface<T, U> delegate) {
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

	@Test def void testGenericTraitWithRecursiveTypeParameter() {
		genericTraitWithRecursiveTypeParameter.compile[

assertTraitJavaInterface("tests", "T1",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface<T extends Comparable<T>> {
  @XtraitjRequiredField
  public abstract T getT();
  
  public abstract void setT(final T t);
  
  @XtraitjDefinedMethod
  public abstract int compare(final T t1);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1<T extends Comparable<T>> implements T1Interface<T> {
  private T1Interface<T> _delegate;
  
  public T1(final T1Interface<T> delegate) {
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
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface<T extends Comparable<T>, U extends List<? extends T>> {
  @XtraitjRequiredField
  public abstract T getT();
  
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
import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1<T extends Comparable<T>, U extends List<? extends T>> implements T1Interface<T, U> {
  private T1Interface<T, U> _delegate;
  
  public T1(final T1Interface<T, U> delegate) {
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
public interface T1Interface<T> {
  @XtraitjDefinedMethod
  public abstract <T extends List<String>> String getFirst(final T t);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.List;
import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1<T> implements T1Interface<T> {
  private T1Interface<T> _delegate;
  
  public T1(final T1Interface<T> delegate) {
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
import tests.T1Interface;
import tests.T2;
import tests.T2Interface;
import xtraitj.input.tests.MyGenericTestInterface;
import xtraitj.input.tests.MyGenericTestInterface2;

@SuppressWarnings("all")
public class C implements MyGenericTestInterface<String>, MyGenericTestInterface2<Integer>, T1Interface, T2Interface {
  private T1 _T1 = new T1(this);
  
  public int m(final List<String> l) {
    return _T1._m(l);
  }
  
  private T2 _T2 = new T2(this);
  
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
import tests.T1Interface;
import xtraitj.input.tests.MyGenericTestInterface3;

@SuppressWarnings("all")
public class C implements MyGenericTestInterface3<Integer>, T1Interface {
  private T1 _T1 = new T1(this);
  
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
import tests.T1Interface;
import xtraitj.input.tests.MyGenericTestInterface3;

@SuppressWarnings("all")
public class C<U> implements MyGenericTestInterface3<U>, T1Interface<U> {
  private T1<U> _T1 = new T1(this);
  
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
public interface T1Interface<U> {
  @XtraitjDefinedMethod
  public abstract ArrayList<U> n(final int i);
}
'''
)

assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.ArrayList;
import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1<U> implements T1Interface<U> {
  private T1Interface<U> _delegate;
  
  public T1(final T1Interface<U> delegate) {
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
import tests.T1Interface;
import xtraitj.input.tests.MyGenericTestInterface2;

@SuppressWarnings("all")
public class C<U> implements MyGenericTestInterface2<U>, T1Interface<U> {
  private T1<U> _T1 = new T1(this);
  
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
import tests.T1Interface;
import xtraitj.input.tests.MyGenericTestInterface2;

@SuppressWarnings("all")
public class C implements MyGenericTestInterface2<String>, T1Interface<String> {
  private T1<String> _T1 = new T1(this);
  
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

import tests.TGeneric;
import tests.TUsesGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGeneric implements TUsesGenericInterface {
  private TUsesGenericInterface _delegate;
  
  private TGeneric<String> _TGeneric;
  
  public TUsesGeneric(final TUsesGenericInterface delegate) {
    this._delegate = delegate;
    _TGeneric = new TGeneric(delegate);
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
import tests.T2Interface;
import tests.TUsesGeneric;
import tests.TUsesGenericInterface;

@SuppressWarnings("all")
public class CUsesGeneric implements TUsesGenericInterface, T2Interface {
  private TUsesGeneric _TUsesGeneric = new TUsesGeneric(this);
  
  private T2 _T2 = new T2(this);
  
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
import tests.T2Interface;
import tests.TGeneric;
import tests.TGenericInterface;

@SuppressWarnings("all")
public class CUsesGeneric2 implements TGenericInterface<String>, T2Interface {
  private TGeneric<String> _TGeneric = new TGeneric(this);
  
  private T2 _T2 = new T2(this);
  
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
public interface T1Interface<T> {
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

import tests.T1Interface;
import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T1Interface<String>, T2Interface {
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
public interface T1Interface<T> {
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

import tests.T1Interface;
import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T1Interface<String>, T2Interface {
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
import tests.TGeneric;
import tests.TUsesGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGeneric implements TUsesGenericInterface {
  private TUsesGenericInterface _delegate;
  
  private TGeneric<String> _TGeneric;
  
  public TUsesGeneric(final TUsesGenericInterface delegate) {
    this._delegate = delegate;
    _TGeneric = new TGeneric(delegate);
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
import tests.TUsesGenericInterface;

@SuppressWarnings("all")
public class CUsesGeneric implements TUsesGenericInterface {
  private TUsesGeneric _TUsesGeneric = new TUsesGeneric(this);
  
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
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface<T> {
  @XtraitjRequiredField
  public abstract int getI();
  
  public abstract void setI(final int i);
  
  @XtraitjRequiredField
  public abstract List<T> getLl();
  
  public abstract void setLl(final List<T> ll);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1Interface;
import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T1Interface<String>, T2Interface {
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import java.util.List;
import tests.T1;
import tests.T2;
import tests.T3Interface;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T1<String> _T1;
  
  private T2 _T2;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T1 = new T1(delegate);
    _T2 = new T2(delegate);
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
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TGenericInterface<T extends Collection<String>, U extends Collection<Integer>> {
  @XtraitjRequiredField
  public abstract T getT();
  
  public abstract void setT(final T t);
  
  @XtraitjRequiredField
  public abstract Iterable<T> getIterableOfStrings();
  
  public abstract void setIterableOfStrings(final Iterable<T> iterableOfStrings);
  
  @XtraitjRequiredField
  public abstract Iterable<U> getIterableOfIntegers();
  
  public abstract void setIterableOfIntegers(final Iterable<U> iterableOfIntegers);
}
'''
)

assertTraitJavaInterface("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import java.util.Set;
import tests.TGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TUsesGenericInterface extends TGenericInterface<List<String>, Set<Integer>> {
}
'''
)


assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import java.util.Set;
import tests.TGeneric;
import tests.TUsesGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGeneric implements TUsesGenericInterface {
  private TUsesGenericInterface _delegate;
  
  private TGeneric<List<String>, Set<Integer>> _TGeneric;
  
  public TUsesGeneric(final TUsesGenericInterface delegate) {
    this._delegate = delegate;
    _TGeneric = new TGeneric(delegate);
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
import tests.T2Interface;
import tests.TUsesGeneric;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2 implements T2Interface {
  private T2Interface _delegate;
  
  private TUsesGeneric _TUsesGeneric;
  
  public T2(final T2Interface delegate) {
    this._delegate = delegate;
    _TUsesGeneric = new TUsesGeneric(delegate);
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
import tests.TGenericInterface;

@SuppressWarnings("all")
public class CUsesGeneric implements TGenericInterface<List<String>, Set<Integer>> {
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
  
  private TGeneric<List<String>, Set<Integer>> _TGeneric = new TGeneric(this);
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
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Interface<T> {
  @XtraitjRequiredField
  public abstract int getI();
  
  public abstract void setI(final int i);
  
  @XtraitjRequiredField
  public abstract List<String> getLl();
  
  public abstract void setLl(final List<String> ll);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1Interface;
import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T1Interface<String>, T2Interface {
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import java.util.List;
import tests.T1;
import tests.T2;
import tests.T3Interface;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T1<String> _T1;
  
  private T2 _T2;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T1 = new T1(delegate);
    _T2 = new T2(delegate);
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
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TGenericExtensions<T> {
  @XtraitjRequiredField
  public abstract Iterable<T> getIterable();
  
  public abstract void setIterable(final Iterable<T> iterable);
  
  @XtraitjDefinedMethod
  public abstract <R> List<R> mapToList(final Function1<? super T, ? extends R> mapper);
  
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
public class TGenericExtensionsImpl<T> implements TGenericExtensions<T> {
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
  public <R> List<R> mapToList(final Function1<? super T, ? extends R> mapper) {
    return _delegate.mapToList(mapper);
  }
  
  public <R> List<R> _mapToList(final Function1<? super T, ? extends R> mapper) {
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
import tests.TGenericExtensions;
import tests.TStringExtensionsInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TStringExtensions implements TStringExtensionsInterface {
  private TStringExtensionsInterface _delegate;
  
  private TGenericExtensions<String> _TGenericExtensions;
  
  public TStringExtensions(final TStringExtensionsInterface delegate) {
    this._delegate = delegate;
    _TGenericExtensions = new TGenericExtensions(delegate);
  }
  
  @XtraitjDefinedMethod
  public <R> List<R> mapToList(final Function1<? super String, ? extends R> mapper) {
    return _delegate.mapToList(mapper);
  }
  
  public <R> List<R> _mapToList(final Function1<? super String, ? extends R> mapper) {
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

	@Test def void testTraitUsesGenericTraitWithWildCard() {
		traitUsesGenericTraitWithWildCard.compile[

assertTraitJavaInterface("tests", "TGeneric",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TGenericInterface<T> {
  @XtraitjRequiredField
  public abstract List<T> getMyL();
  
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

import tests.TGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TUsesGenericInterface extends TGenericInterface<String> {
  @XtraitjDefinedMethod
  public abstract String updateAndReturn();
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import tests.TGeneric;
import tests.TUsesGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGeneric implements TUsesGenericInterface {
  private TUsesGenericInterface _delegate;
  
  private TGeneric<String> _TGeneric;
  
  public TUsesGeneric(final TUsesGenericInterface delegate) {
    this._delegate = delegate;
    _TGeneric = new TGeneric(delegate);
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
import tests.TUsesGenericInterface;

@SuppressWarnings("all")
public class C implements TUsesGenericInterface {
  private List<String> myL = new ArrayList<String>();
  
  public List<String> getMyL() {
    return this.myL;
  }
  
  public void setMyL(final List<String> myL) {
    this.myL = myL;
  }
  
  private TUsesGeneric _TUsesGeneric = new TUsesGeneric(this);
  
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
import tests.TGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TUsesGenericInterface extends TGenericInterface<String, Set<Integer>> {
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
import tests.TGeneric;
import tests.TUsesGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGeneric implements TUsesGenericInterface {
  private TUsesGenericInterface _delegate;
  
  private TGeneric<String, Set<Integer>> _TGeneric;
  
  public TUsesGeneric(final TUsesGenericInterface delegate) {
    this._delegate = delegate;
    _TGeneric = new TGeneric(delegate);
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
import tests.TUsesGenericInterface;

@SuppressWarnings("all")
public class CUsesGeneric implements TUsesGenericInterface {
  private TUsesGeneric _TUsesGeneric = new TUsesGeneric(this);
  
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

assertTraitJavaClass("tests", "T1",
'''
package tests;

import java.util.ArrayList;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.InputOutput;
import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1 implements T1Interface {
  private T1Interface _delegate;
  
  public T1(final T1Interface delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
  public <T> T identity(final T t) {
    return _delegate.identity(t);
  }
  
  public <T> T _identity(final T t) {
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
  public <V> V recursive(final V v) {
    return _delegate.recursive(v);
  }
  
  public <V> V _recursive(final V v) {
    V _recursive = this.<V>recursive(v);
    return this.<V>recursive(_recursive);
  }
  
  @XtraitjDefinedMethod
  public <U> void noReturn(final U u) {
    _delegate.noReturn(u);
  }
  
  public <U> void _noReturn(final U u) {
    InputOutput.<Object>println(u);
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

assertJavaClass("tests", "C",
'''
package tests;

import tests.T1;
import tests.T1Interface;

@SuppressWarnings("all")
public class C implements T1Interface {
  private T1 _T1 = new T1(this);
  
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
public interface T1Interface {
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
import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1 implements T1Interface {
  private T1Interface _delegate;
  
  public T1(final T1Interface delegate) {
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

import tests.T1Interface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T2Interface extends T1Interface {
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests;

import java.util.List;
import tests.T1;
import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2 implements T2Interface {
  private T2Interface _delegate;
  
  private T1 _T1;
  
  public T2(final T2Interface delegate) {
    this._delegate = delegate;
    _T1 = new T1(delegate);
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

import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T2Interface {
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import java.util.List;
import tests.T2;
import tests.T3Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T2 _T2;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2 = new T2(delegate);
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
import tests.T2Interface;

@SuppressWarnings("all")
public class C implements T2Interface {
  private T2 _T2 = new T2(this);
  
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
import tests.T1Interface;

@SuppressWarnings("all")
public class C2 implements T1Interface {
  private T1 _T1 = new T1(this);
  
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

	@Test def void testTraitUsesGenericTraitWithRenameSimpler() {
		traitUsesGenericTraitWithRenameSimpler.compile[

assertTraitJavaInterface("tests", "UsesTGeneric",
'''
package tests;

import tests.UsesTGeneric_TGeneric_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface UsesTGenericInterface extends UsesTGeneric_TGeneric_0_AdapterInterface {
  @XtraitjDefinedMethod
  public abstract String useLists();
}
'''
)

assertTraitAdapterJavaInterface("tests", "UsesTGeneric_TGeneric_0",
'''
package tests;

import java.util.List;

@SuppressWarnings("all")
public interface UsesTGeneric_TGeneric_0_AdapterInterface {
  public abstract List<Integer> returnListOfInteger();
  
  public abstract void printListOfInteger(final List<Integer> l);
}
'''
)

assertTraitAdapterJavaClass("tests", "UsesTGeneric_TGeneric_0",
'''
package tests;

import java.util.List;
import tests.TGeneric;
import tests.TGenericInterface;
import tests.UsesTGeneric_TGeneric_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class UsesTGeneric_TGeneric_0_Adapter implements UsesTGeneric_TGeneric_0_AdapterInterface, TGenericInterface<Integer> {
  private UsesTGeneric_TGeneric_0_AdapterInterface _delegate;
  
  private TGeneric<Integer> _TGeneric_0;
  
  public UsesTGeneric_TGeneric_0_Adapter(final UsesTGeneric_TGeneric_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _TGeneric_0 = new TGeneric(this);
  }
  
  public List<Integer> returnList() {
    return this.returnListOfInteger();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("returnList")
  public List<Integer> returnListOfInteger() {
    return _delegate.returnListOfInteger();
  }
  
  public List<Integer> _returnListOfInteger() {
    return _TGeneric_0._returnList();
  }
  
  public void printList(final List<Integer> l) {
    this.printListOfInteger(l);
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("printList")
  public void printListOfInteger(final List<Integer> l) {
    _delegate.printListOfInteger(l);
  }
  
  public void _printListOfInteger(final List<Integer> l) {
    _TGeneric_0._printList(l);
  }
}
'''
)

assertTraitJavaClass("tests", "UsesTGeneric",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import tests.UsesTGenericInterface;
import tests.UsesTGeneric_TGeneric_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class UsesTGeneric implements UsesTGenericInterface {
  private UsesTGenericInterface _delegate;
  
  private UsesTGeneric_TGeneric_0_Adapter _TGeneric_0;
  
  public UsesTGeneric(final UsesTGenericInterface delegate) {
    this._delegate = delegate;
    _TGeneric_0 = new UsesTGeneric_TGeneric_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public String useLists() {
    return _delegate.useLists();
  }
  
  public String _useLists() {
    List<Integer> _returnListOfInteger = this.returnListOfInteger();
    final Procedure1<List<Integer>> _function = new Procedure1<List<Integer>>() {
      public void apply(final List<Integer> it) {
        it.add(Integer.valueOf(1));
      }
    };
    final List<Integer> intList = ObjectExtensions.<List<Integer>>operator_doubleArrow(_returnListOfInteger, _function);
    this.printListOfInteger(intList);
    return intList.toString();
  }
  
  @XtraitjDefinedMethod
  public List<Integer> returnListOfInteger() {
    return _delegate.returnListOfInteger();
  }
  
  public List<Integer> _returnListOfInteger() {
    return _TGeneric_0._returnListOfInteger();
  }
  
  @XtraitjDefinedMethod
  public void printListOfInteger(final List<Integer> l) {
    _delegate.printListOfInteger(l);
  }
  
  public void _printListOfInteger(final List<Integer> l) {
    _TGeneric_0._printListOfInteger(l);
  }
}
'''
)

assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import tests.UsesTGeneric;
import tests.UsesTGenericInterface;

@SuppressWarnings("all")
public class C implements UsesTGenericInterface {
  private UsesTGeneric _UsesTGeneric = new UsesTGeneric(this);
  
  public String useLists() {
    return _UsesTGeneric._useLists();
  }
  
  public List<Integer> returnListOfInteger() {
    return _UsesTGeneric._returnListOfInteger();
  }
  
  public void printListOfInteger(final List<Integer> l) {
    _UsesTGeneric._printListOfInteger(l);
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "useLists", "[1]")
		]
	}

	@Test def void testTraitUsesGenericTraitWithRename() {
		traitUsesGenericTraitWithRename.compile[

assertTraitJavaInterface("tests", "UsesTGeneric",
'''
package tests;

import tests.TGenericInterface;
import tests.UsesTGeneric_TGeneric_0_AdapterInterface;
import tests.UsesTGeneric_TGeneric_1_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface UsesTGenericInterface extends UsesTGeneric_TGeneric_0_AdapterInterface, UsesTGeneric_TGeneric_1_AdapterInterface, TGenericInterface<String> {
  @XtraitjDefinedMethod
  public abstract String useLists();
}
'''
)

assertTraitJavaClass("tests", "UsesTGeneric",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import tests.TGeneric;
import tests.UsesTGenericInterface;
import tests.UsesTGeneric_TGeneric_0_Adapter;
import tests.UsesTGeneric_TGeneric_1_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class UsesTGeneric implements UsesTGenericInterface {
  private UsesTGenericInterface _delegate;
  
  private UsesTGeneric_TGeneric_0_Adapter _TGeneric_0;
  
  private UsesTGeneric_TGeneric_1_Adapter _TGeneric_1;
  
  private TGeneric<String> _TGeneric;
  
  public UsesTGeneric(final UsesTGenericInterface delegate) {
    this._delegate = delegate;
    _TGeneric_0 = new UsesTGeneric_TGeneric_0_Adapter(delegate);
    _TGeneric_1 = new UsesTGeneric_TGeneric_1_Adapter(delegate);
    _TGeneric = new TGeneric(delegate);
  }
  
  @XtraitjDefinedMethod
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
          List<Integer> _returnListOfInteger = UsesTGeneric.this.returnListOfInteger();
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
  
  @XtraitjDefinedMethod
  public List<Integer> returnListOfInteger() {
    return _delegate.returnListOfInteger();
  }
  
  public List<Integer> _returnListOfInteger() {
    return _TGeneric_0._returnListOfInteger();
  }
  
  @XtraitjDefinedMethod
  public List<List<Integer>> returnListOfListOfInteger() {
    return _delegate.returnListOfListOfInteger();
  }
  
  public List<List<Integer>> _returnListOfListOfInteger() {
    return _TGeneric_1._returnListOfListOfInteger();
  }
  
  @XtraitjDefinedMethod
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
package tests;

import java.util.List;

@SuppressWarnings("all")
public interface UsesTGeneric_TGeneric_0_AdapterInterface {
  public abstract List<Integer> returnListOfInteger();
}
'''
)

assertTraitAdapterJavaClass("tests", "UsesTGeneric_TGeneric_0",
'''
package tests;

import java.util.List;
import tests.TGeneric;
import tests.TGenericInterface;
import tests.UsesTGeneric_TGeneric_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class UsesTGeneric_TGeneric_0_Adapter implements UsesTGeneric_TGeneric_0_AdapterInterface, TGenericInterface<Integer> {
  private UsesTGeneric_TGeneric_0_AdapterInterface _delegate;
  
  private TGeneric<Integer> _TGeneric_0;
  
  public UsesTGeneric_TGeneric_0_Adapter(final UsesTGeneric_TGeneric_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _TGeneric_0 = new TGeneric(this);
  }
  
  public List<Integer> returnList() {
    return this.returnListOfInteger();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("returnList")
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
import tests.UsesTGeneric;
import tests.UsesTGenericInterface;

@SuppressWarnings("all")
public class C implements UsesTGenericInterface {
  private UsesTGeneric _UsesTGeneric = new UsesTGeneric(this);
  
  public String useLists() {
    return _UsesTGeneric._useLists();
  }
  
  public List<String> returnList() {
    return _UsesTGeneric._returnList();
  }
  
  public List<Integer> returnListOfInteger() {
    return _UsesTGeneric._returnListOfInteger();
  }
  
  public List<List<Integer>> returnListOfListOfInteger() {
    return _UsesTGeneric._returnListOfListOfInteger();
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "useLists", "[foo][1][[2]]")
		]
	}

	@Test def void traitRenameGenericFieldInstantiated() {
		classUsesTraitWithGenericRenamedFieldsInstantiated.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract Boolean getB();
  
  public abstract void setB(final Boolean b);
  
  public abstract String getS();
  
  public abstract void setS(final String s);
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface extends T3_T2_0_AdapterInterface {
  @XtraitjDefinedMethod
  public abstract String meth();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface<String, Boolean> {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2<String, Boolean> _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public String getFieldS() {
    return this.getS();
  }
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldS")
  public String getS() {
    return _delegate.getS();
  }
  
  public void setFieldS(final String s) {
    this.setS(s);
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  public Boolean getFieldB() {
    return this.getB();
  }
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldB")
  public Boolean getB() {
    return _delegate.getB();
  }
  
  public void setFieldB(final Boolean b) {
    this.setB(b);
  }
  
  public void setB(final Boolean b) {
    _delegate.setB(b);
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3 implements T3Interface {
  private T3Interface _delegate;
  
  private T3_T2_0_Adapter _T2_0;
  
  public T3(final T3Interface delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public String meth() {
    return _delegate.meth();
  }
  
  public String _meth() {
    this.setS("foo");
    this.setB(Boolean.valueOf(false));
    String _s = this.getS();
    Boolean _b = this.getB();
    return (_s + _b);
  }
  
  @XtraitjRequiredField
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  @XtraitjRequiredField
  public Boolean getB() {
    return _delegate.getB();
  }
  
  public void setB(final Boolean b) {
    _delegate.setB(b);
  }
}
'''
)

			// call the method which uses the renamed field
			executeGeneratedJavaClassMethodAndAssert("C", "meth", "foofalse")
		]
	}

	@Test def void testRenameGenericFieldNotInstantiated() {
		traitRenameGenericFieldNotInstantiated.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface<U extends String, V> {
  public abstract V getB();
  
  public abstract void setB(final V b);
  
  public abstract U getS();
  
  public abstract void setS(final U s);
  
  public abstract String T2meth();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3Interface<U extends String, V> extends T3_T2_0_AdapterInterface<U, V> {
  @XtraitjDefinedMethod
  public abstract String meth();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Interface;
import tests.T3_T2_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_Adapter<U extends String, V> implements T3_T2_0_AdapterInterface<U, V>, T2Interface<U, V> {
  private T3_T2_0_AdapterInterface<U, V> _delegate;
  
  private T2<U, V> _T2_0;
  
  public T3_T2_0_Adapter(final T3_T2_0_AdapterInterface<U, V> delegate) {
    this._delegate = delegate;
    _T2_0 = new T2(this);
  }
  
  public U getFieldS() {
    return this.getS();
  }
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldS")
  public U getS() {
    return _delegate.getS();
  }
  
  public void setFieldS(final U s) {
    this.setS(s);
  }
  
  public void setS(final U s) {
    _delegate.setS(s);
  }
  
  public V getFieldB() {
    return this.getB();
  }
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldB")
  public V getB() {
    return _delegate.getB();
  }
  
  public void setFieldB(final V b) {
    this.setB(b);
  }
  
  public void setB(final V b) {
    _delegate.setB(b);
  }
  
  @XtraitjDefinedMethod
  public String T2meth() {
    return _delegate.T2meth();
  }
  
  public String _T2meth() {
    return _T2_0._T2meth();
  }
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests;

import org.eclipse.xtext.xbase.lib.InputOutput;
import tests.T1;
import tests.T2Interface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2<G1, G2> implements T2Interface<G1, G2> {
  private T2Interface<G1, G2> _delegate;
  
  private T1<G1> _T1;
  
  public T2(final T2Interface<G1, G2> delegate) {
    this._delegate = delegate;
    _T1 = new T1(delegate);
  }
  
  @XtraitjRequiredField
  public G2 getFieldB() {
    return _delegate.getFieldB();
  }
  
  public void setFieldB(final G2 fieldB) {
    _delegate.setFieldB(fieldB);
  }
  
  @XtraitjDefinedMethod
  public String T2meth() {
    return _delegate.T2meth();
  }
  
  public String _T2meth() {
    G1 _fieldS = this.getFieldS();
    InputOutput.<G1>println(_fieldS);
    final G1 t = this.getFieldS();
    InputOutput.<G1>println(t);
    return "foo";
  }
  
  @XtraitjRequiredField
  public G1 getFieldS() {
    return _delegate.getFieldS();
  }
  
  public void setFieldS(final G1 fieldS) {
    _delegate.setFieldS(fieldS);
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import org.eclipse.xtext.xbase.lib.InputOutput;
import tests.T3Interface;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3<U extends String, V> implements T3Interface<U, V> {
  private T3Interface<U, V> _delegate;
  
  private T3_T2_0_Adapter<U, V> _T2_0;
  
  public T3(final T3Interface<U, V> delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_Adapter(delegate);
  }
  
  @XtraitjDefinedMethod
  public String meth() {
    return _delegate.meth();
  }
  
  public String _meth() {
    U _s = this.getS();
    InputOutput.<U>println(_s);
    final U t1 = this.getS();
    this.setS(t1);
    V _b = this.getB();
    InputOutput.<V>println(_b);
    final V t2 = this.getB();
    this.setB(t2);
    return "foo";
  }
  
  @XtraitjDefinedMethod
  public String T2meth() {
    return _delegate.T2meth();
  }
  
  public String _T2meth() {
    return _T2_0._T2meth();
  }
  
  @XtraitjRequiredField
  public U getS() {
    return _delegate.getS();
  }
  
  public void setS(final U s) {
    _delegate.setS(s);
  }
  
  @XtraitjRequiredField
  public V getB() {
    return _delegate.getB();
  }
  
  public void setB(final V b) {
    _delegate.setB(b);
  }
}
'''
)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testUsesTraitWithRenameGenericMethod() {
		traitUsesTraitWithRenameGenericMethod.compile[

assertTraitAdapterJavaInterface("tests", "UsesTGeneric_T1_0",
'''
package tests;

import java.util.List;

@SuppressWarnings("all")
public interface UsesTGeneric_T1_0_AdapterInterface {
  public abstract <T> List<T> returnListOfInteger(final T t);
}
'''
)


assertTraitAdapterJavaClass("tests", "UsesTGeneric_T1_0",
'''
package tests;

import java.util.List;
import tests.T1;
import tests.T1Interface;
import tests.UsesTGeneric_T1_0_AdapterInterface;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class UsesTGeneric_T1_0_Adapter implements UsesTGeneric_T1_0_AdapterInterface, T1Interface {
  private UsesTGeneric_T1_0_AdapterInterface _delegate;
  
  private T1 _T1_0;
  
  public UsesTGeneric_T1_0_Adapter(final UsesTGeneric_T1_0_AdapterInterface delegate) {
    this._delegate = delegate;
    _T1_0 = new T1(this);
  }
  
  public <T> List<T> returnList(final T t) {
    return this.returnListOfInteger(t);
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("returnList")
  public <T> List<T> returnListOfInteger(final T t) {
    return _delegate.returnListOfInteger(t);
  }
  
  public <T> List<T> _returnListOfInteger(final T t) {
    return _T1_0._returnList(t);
  }
}
'''
)

assertTraitJavaClass("tests", "UsesTGeneric",
'''
package tests;

import java.util.List;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import tests.T1;
import tests.UsesTGenericInterface;
import tests.UsesTGeneric_T1_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class UsesTGeneric implements UsesTGenericInterface {
  private UsesTGenericInterface _delegate;
  
  private UsesTGeneric_T1_0_Adapter _T1_0;
  
  private T1 _T1;
  
  public UsesTGeneric(final UsesTGenericInterface delegate) {
    this._delegate = delegate;
    _T1_0 = new UsesTGeneric_T1_0_Adapter(delegate);
    _T1 = new T1(delegate);
  }
  
  @XtraitjDefinedMethod
  public String useLists() {
    return _delegate.useLists();
  }
  
  public String _useLists() {
    List<String> _returnList = this.<String>returnList("bar");
    final Procedure1<List<String>> _function = new Procedure1<List<String>>() {
      public void apply(final List<String> it) {
        it.add("foo");
      }
    };
    final List<String> stringList = ObjectExtensions.<List<String>>operator_doubleArrow(_returnList, _function);
    List<Integer> _returnListOfInteger = this.<Integer>returnListOfInteger(Integer.valueOf(0));
    final Procedure1<List<Integer>> _function_1 = new Procedure1<List<Integer>>() {
      public void apply(final List<Integer> it) {
        it.add(Integer.valueOf(1));
      }
    };
    final List<Integer> intList = ObjectExtensions.<List<Integer>>operator_doubleArrow(_returnListOfInteger, _function_1);
    String _string = stringList.toString();
    String _string_1 = intList.toString();
    return (_string + _string_1);
  }
  
  @XtraitjDefinedMethod
  public <T> List<T> returnListOfInteger(final T t) {
    return _delegate.returnListOfInteger(t);
  }
  
  public <T> List<T> _returnListOfInteger(final T t) {
    return _T1_0._returnListOfInteger(t);
  }
  
  @XtraitjDefinedMethod
  public <T> List<T> returnList(final T t) {
    return _delegate.returnList(t);
  }
  
  public <T> List<T> _returnList(final T t) {
    return _T1._returnList(t);
  }
}
'''
)



assertJavaClass("tests", "C",
'''
package tests;

import java.util.List;
import tests.UsesTGeneric;
import tests.UsesTGenericInterface;

@SuppressWarnings("all")
public class C implements UsesTGenericInterface {
  private UsesTGeneric _UsesTGeneric = new UsesTGeneric(this);
  
  public String useLists() {
    return _UsesTGeneric._useLists();
  }
  
  public <T> List<T> returnList(final T t) {
    return _UsesTGeneric._returnList(t);
  }
  
  public <T> List<T> returnListOfInteger(final T t) {
    return _UsesTGeneric._returnListOfInteger(t);
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "useLists", "[bar, foo][0, 1]")
		]
	}
}
