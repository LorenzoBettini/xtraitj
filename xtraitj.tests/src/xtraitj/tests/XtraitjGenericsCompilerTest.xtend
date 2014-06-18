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
import tests.TGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TUsesGenericInterface extends TGenericInterface<List<String>> {
}
'''
)

assertTraitJavaClass("tests", "TUsesGeneric",
'''
package tests;

import java.util.List;
import tests.TGeneric;
import tests.TUsesGenericInterface;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TUsesGeneric implements TUsesGenericInterface {
  private TUsesGenericInterface _delegate;
  
  private TGeneric<List<String>> _TGeneric;
  
  public TUsesGeneric(final TUsesGenericInterface delegate) {
    this._delegate = delegate;
    _TGeneric = new TGeneric(delegate);
  }
}
'''
)

assertJavaClass("tests", "CUsesGeneric",
'''
package tests;

import java.util.List;
import tests.TGeneric;
import tests.TGenericInterface;

@SuppressWarnings("all")
public class CUsesGeneric implements TGenericInterface<List<String>> {
  private TGeneric<List<String>> _TGeneric = new TGeneric(this);
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



}
