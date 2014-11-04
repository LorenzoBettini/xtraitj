package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(InjectorProviderCustom))
class XtraitjWithOperationsCompilerTest extends AbstractXtraitjCompilerTest {
	
	@Test def void testTraitRenamedRequiredMethodDoesNotConflict() {
		traitRenamedRequiredMethodDoesNotConflict.compile[

			// callM1 which calls m1 which was required and was
			// renamed to provided T2.m
			executeGeneratedJavaClassMethodAndAssert("C", "callM1", "T2.m;")
		]
	}

	@Test def void testTraitRenameRequiredMethodToProvidedAndSum() {
		classUsesTraitRenameRequiredMethodToProvidedAndSum.compile[

			// callM1 which calls m1 which was required and was
			// renamed to provided T2.m
			executeGeneratedJavaClassMethodAndAssert("C", "callM1", "T2.m;")
		]
	}

	@Test def void testTraitRenameRequiredMethods() {
		traitRenameRequiredMethods.compile[
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("req1")
  public abstract String req();
  
  @XtraitjDefinedMethod
  public abstract String n();
  
  @XtraitjDefinedMethod
  public abstract String m();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  public abstract String foo();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Impl;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String req1() {
    return this.req();
  }
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("req1")
  public String req() {
    return _delegate.req();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    return this.n();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
  }
  
  @XtraitjRequiredMethod
  public String req() {
    return _delegate.req();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameOperationsNotUsed() {
		traitRenameOperationsNotUsed.compile[
assertTraitAdapterJavaInterface("T3_T2_0",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredField
  public abstract String getS();
  
  public abstract void setS(final String s);
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("n")
  public abstract int n2();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract int m2();
  
  @XtraitjDefinedMethod
  public abstract int t1();
}
'''
)

assertTraitAdapterJavaClass("T3_T2_0",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public int m() {
    return this.m2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public int m2() {
    return _delegate.m2();
  }
  
  public int _m2() {
    return _T2_0._m();
  }
  
  public int n() {
    return this.n2();
  }
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("n")
  public int n2() {
    return _delegate.n2();
  }
  
  @XtraitjDefinedMethod
  public int t1() {
    return _delegate.t1();
  }
  
  public int _t1() {
    return _T2_0._t1();
  }
  
  @XtraitjRequiredField
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaInterface("T3",
'''
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
}
'''
)

assertTraitJavaClass("T3",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public int m2() {
    return _delegate.m2();
  }
  
  public int _m2() {
    return _T2_0._m2();
  }
  
  @XtraitjDefinedMethod
  public int t1() {
    return _delegate.t1();
  }
  
  public int _t1() {
    return _T2_0._t1();
  }
  
  @XtraitjRequiredField
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  @XtraitjRequiredMethod
  public int n2() {
    return _delegate.n2();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameOperations() {
		traitRenameOperations.compile[
assertTraitAdapterJavaInterface("T3_T2_0",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredField
  public abstract String getS();
  
  public abstract void setS(final String s);
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("n")
  public abstract int n2();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract int m2();
  
  @XtraitjDefinedMethod
  public abstract int t1();
}
'''
)

assertTraitJavaInterface("T3",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  public abstract int foo();
}
'''
)

assertTraitAdapterJavaClass("T3_T2_0",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public int m() {
    return this.m2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public int m2() {
    return _delegate.m2();
  }
  
  public int _m2() {
    return _T2_0._m();
  }
  
  public int n() {
    return this.n2();
  }
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("n")
  public int n2() {
    return _delegate.n2();
  }
  
  @XtraitjDefinedMethod
  public int t1() {
    return _delegate.t1();
  }
  
  public int _t1() {
    return _T2_0._t1();
  }
  
  @XtraitjRequiredField
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("T3",
'''
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public int foo() {
    return _delegate.foo();
  }
  
  public int _foo() {
    int _n2 = this.n2();
    int _m2 = this.m2();
    return (_n2 + _m2);
  }
  
  @XtraitjDefinedMethod
  public int m2() {
    return _delegate.m2();
  }
  
  public int _m2() {
    return _T2_0._m2();
  }
  
  @XtraitjDefinedMethod
  public int t1() {
    return _delegate.t1();
  }
  
  public int _t1() {
    return _T2_0._t1();
  }
  
  @XtraitjRequiredField
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  @XtraitjRequiredMethod
  public int n2() {
    return _delegate.n2();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameProvidedMethods() {
		traitRenameProvidedMethods.compile[
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("n")
  public abstract String n2();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract String m2();
  
  @XtraitjDefinedMethod
  public abstract String t1();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Impl;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String m() {
    return this.m2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m();
  }
  
  public String n() {
    return this.n2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("n")
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String t1() {
    return _delegate.t1();
  }
  
  public String _t1() {
    return _T2_0._t1();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    String _n2 = this.n2();
    String _m2 = this.m2();
    String _plus = (_n2 + _m2);
    String _t1 = this.t1();
    return (_plus + _t1);
  }
  
  @XtraitjDefinedMethod
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n2();
  }
  
  @XtraitjDefinedMethod
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m2();
  }
  
  @XtraitjDefinedMethod
  public String t1() {
    return _delegate.t1();
  }
  
  public String _t1() {
    return _T2_0._t1();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "foo", "T2.n;T1.m;T1.t1;")
		]
	}

	@Test def void testTraitDoubleRenaming() {
		traitDoubleRenaming.compile[
			expectationsForTraitDoubleRenaming(it)
		]
	}

	@Test def void testTraitDoubleRenamingSeparateFiles() {
		traitDoubleRenamingSeparateFiles.createResourceSet.compile[
			expectationsForTraitDoubleRenaming(it)
		]
	}
	
	private def expectationsForTraitDoubleRenaming(Result it) {
		assertTraitAdapterJavaInterface("tests", "T3_T2_0",
		'''
		package tests;
		
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
		@SuppressWarnings("all")
		public interface T3_T2_0_Adapter {
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("n")
		  public abstract String n2();
		  
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("m")
		  public abstract String m2();
		}
		'''
		)
		
		assertTraitAdapterJavaInterface("tests", "T3_T2_1",
		'''
		package tests;
		
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
		@SuppressWarnings("all")
		public interface T3_T2_1_Adapter {
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("n")
		  public abstract String n3();
		  
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("m")
		  public abstract String m3();
		}
		'''
		)
		
		assertTraitJavaInterface("tests", "T3",
		'''
		package tests;
		
		import tests.T3_T2_0_Adapter;
		import tests.T3_T2_1_Adapter;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;
		
		@XtraitjTraitInterface
		@SuppressWarnings("all")
		public interface T3 extends T3_T2_0_Adapter, T3_T2_1_Adapter {
		  @XtraitjDefinedMethod
		  public abstract String m();
		  
		  @XtraitjDefinedMethod
		  public abstract String foo();
		}
		'''
		)
		
		assertTraitAdapterJavaClass("tests", "T3_T2_0",
		'''
		package tests;
		
		import tests.T2;
		import tests.T2Impl;
		import tests.T3_T2_0_Adapter;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
		@SuppressWarnings("all")
		public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
		  private T3_T2_0_Adapter _delegate;
		  
		  private T2Impl _T2_0;
		  
		  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
		    this._delegate = delegate;
		    _T2_0 = new T2Impl(this);
		  }
		  
		  public String m() {
		    return this.m2();
		  }
		  
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("m")
		  public String m2() {
		    return _delegate.m2();
		  }
		  
		  public String _m2() {
		    return _T2_0._m();
		  }
		  
		  public String n() {
		    return this.n2();
		  }
		  
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("n")
		  public String n2() {
		    return _delegate.n2();
		  }
		  
		  public String _n2() {
		    return _T2_0._n();
		  }
		}
		'''
		)
		
		assertTraitJavaClass("tests", "T3",
		'''
		package tests;
		
		import tests.T3;
		import tests.T3_T2_0_AdapterImpl;
		import tests.T3_T2_1_AdapterImpl;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjTraitClass;
		
		@XtraitjTraitClass
		@SuppressWarnings("all")
		public class T3Impl implements T3 {
		  private T3 _delegate;
		  
		  private T3_T2_0_AdapterImpl _T2_0;
		  
		  private T3_T2_1_AdapterImpl _T2_1;
		  
		  public T3Impl(final T3 delegate) {
		    this._delegate = delegate;
		    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
		    _T2_1 = new T3_T2_1_AdapterImpl(delegate);
		  }
		  
		  @XtraitjDefinedMethod
		  public String m() {
		    return _delegate.m();
		  }
		  
		  public String _m() {
		    String _m2 = this.m2();
		    return ("T3." + _m2);
		  }
		  
		  @XtraitjDefinedMethod
		  public String foo() {
		    return _delegate.foo();
		  }
		  
		  public String _foo() {
		    String _n3 = this.n3();
		    String _m = this.m();
		    return (_n3 + _m);
		  }
		  
		  @XtraitjDefinedMethod
		  public String n2() {
		    return _delegate.n2();
		  }
		  
		  public String _n2() {
		    return _T2_0._n2();
		  }
		  
		  @XtraitjDefinedMethod
		  public String m2() {
		    return _delegate.m2();
		  }
		  
		  public String _m2() {
		    return _T2_0._m2();
		  }
		  
		  @XtraitjDefinedMethod
		  public String n3() {
		    return _delegate.n3();
		  }
		  
		  public String _n3() {
		    return _T2_1._n3();
		  }
		  
		  @XtraitjDefinedMethod
		  public String m3() {
		    return _delegate.m3();
		  }
		  
		  public String _m3() {
		    return _T2_1._m3();
		  }
		}
		'''
		)
					executeGeneratedJavaClassMethodAndAssert("C", "foo", "T2.n;T3.T1.m;")
	}

	@Test def void testTraitRedefinitionByRenaming() {
		traitRedefinitionByRenaming.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("n")
  public abstract String n2();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract String m2();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract String foo();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Impl;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String m() {
    return this.m2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m();
  }
  
  public String n() {
    return this.n2();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("n")
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    String _m2 = this.m2();
    return ("T3." + _m2);
  }
  
  @XtraitjDefinedMethod
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    String _n2 = this.n2();
    String _m = this.m();
    return (_n2 + _m);
  }
  
  @XtraitjDefinedMethod
  public String n2() {
    return _delegate.n2();
  }
  
  public String _n2() {
    return _T2_0._n2();
  }
  
  @XtraitjDefinedMethod
  public String m2() {
    return _delegate.m2();
  }
  
  public String _m2() {
    return _T2_0._m2();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "foo", "T2.n;T3.T1.m;")
		]
	}

	@Test def void testTraitRenameProvidedMethodToRequiredAndSum() {
		traitRenameProvidedMethodToRequiredAndSum.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract int m1();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter, T1 {
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Impl;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public int m() {
    return this.m1();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T2_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T1Impl;
import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  private T1Impl _T1;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
    _T1 = new T1Impl(delegate);
  }
  
  @XtraitjDefinedMethod
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T2_0._m1();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameRequiredMethodProvidedByTrait() {
		traitRenameRequiredMethodProvidedByTrait.compile[

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  public abstract String req();
  
  @XtraitjDefinedMethod
  public abstract String foo();
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public String req() {
    return _delegate.req();
  }
  
  public String _req() {
    return "T3.req";
  }
  
  @XtraitjDefinedMethod
  public String foo() {
    return _delegate.foo();
  }
  
  public String _foo() {
    return this.n();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameProvidedMethodToRequiredAndSum2() {
		traitRenameProvidedMethodToRequiredAndSum2.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract int m1();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T1;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T1, T3_T2_0_Adapter {
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Impl;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public int m() {
    return this.m1();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T2_0._m();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T1Impl;
import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T1Impl _T1;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public int m1() {
    return _delegate.m1();
  }
  
  public int _m1() {
    return _T2_0._m1();
  }
}
'''
)

			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testTraitRenameRenamed() {
		traitRenameRenamed.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  public abstract String callFirstRename();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod({ "m", "firstRename" })
  public abstract String secondRename();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
  @XtraitjDefinedMethod
  public abstract String callSecondRename();
}
'''
)

assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import tests.T2;
import tests.T2Impl;
import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  public String firstRename() {
    return this.secondRename();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod({ "m", "firstRename" })
  public String secondRename() {
    return _delegate.secondRename();
  }
  
  public String _secondRename() {
    return _T2_0._firstRename();
  }
  
  @XtraitjDefinedMethod
  public String callFirstRename() {
    return _delegate.callFirstRename();
  }
  
  public String _callFirstRename() {
    return _T2_0._callFirstRename();
  }
}
'''
)

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl implements T3 {
  private T3 _delegate;
  
  private T3_T2_0_AdapterImpl _T2_0;
  
  public T3Impl(final T3 delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public String callSecondRename() {
    return _delegate.callSecondRename();
  }
  
  public String _callSecondRename() {
    return this.secondRename();
  }
  
  @XtraitjDefinedMethod
  public String callFirstRename() {
    return _delegate.callFirstRename();
  }
  
  public String _callFirstRename() {
    return _T2_0._callFirstRename();
  }
  
  @XtraitjDefinedMethod
  public String secondRename() {
    return _delegate.secondRename();
  }
  
  public String _secondRename() {
    return _T2_0._secondRename();
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "callSecondRename", "m")
			executeGeneratedJavaClassMethodAndAssert("C", "callFirstRename", "m")
		]
	}

	@Test def void testClassRenamesRequiredMethodToProvidedAndSum() {
		classRenamesRequiredMethodToProvidedAndSum.compile[

assertJavaClass("tests", "C",
'''
package tests;

import tests.C_T1_0_Adapter;
import tests.C_T1_0_AdapterImpl;
import tests.T2;
import tests.T2Impl;

@SuppressWarnings("all")
public class C implements T2, C_T1_0_Adapter {
  private T2Impl _T2 = new T2Impl(this);
  
  public String m() {
    return _T2._m();
  }
  
  private C_T1_0_AdapterImpl _T1_0 = new C_T1_0_AdapterImpl(this);
  
  public String callM1() {
    return _T1_0._callM1();
  }
}
'''
)

assertTraitAdapterJavaInterface("tests", "C_T1_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface C_T1_0_Adapter {
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("m1")
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract String callM1();
}
'''
)

assertTraitAdapterJavaClass("tests", "C_T1_0",
'''
package tests;

import tests.C_T1_0_Adapter;
import tests.T1;
import tests.T1Impl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public class C_T1_0_AdapterImpl implements C_T1_0_Adapter, T1 {
  private C_T1_0_Adapter _delegate;
  
  private T1Impl _T1_0;
  
  public C_T1_0_AdapterImpl(final C_T1_0_Adapter delegate) {
    this._delegate = delegate;
    _T1_0 = new T1Impl(this);
  }
  
  public String m1() {
    return this.m();
  }
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("m1")
  public String m() {
    return _delegate.m();
  }
  
  @XtraitjDefinedMethod
  public String callM1() {
    return _delegate.callM1();
  }
  
  public String _callM1() {
    return _T1_0._callM1();
  }
}
'''
)

			// callM1 which calls m1 which was required and was
			// renamed to provided T2.m
			executeGeneratedJavaClassMethodAndAssert("C", "callM1", "T2.m;")
		]
	}

	@Test def void testRenameField() {
		classUsesTraitWithRenamedFields.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

@SuppressWarnings("all")
public interface T3_T2_0_AdapterInterface {
  public abstract boolean isB();
  
  public abstract void setB(final boolean b);
  
  public abstract String getS();
  
  public abstract void setS(final String s);
  
  public abstract boolean n();
  
  public abstract String m();
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
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_Adapter implements T3_T2_0_AdapterInterface, T2Interface {
  private T3_T2_0_AdapterInterface _delegate;
  
  private T2 _T2_0;
  
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
  
  public boolean isFieldB() {
    return this.isB();
  }
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("isFieldB")
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setFieldB(final boolean b) {
    this.setB(b);
  }
  
  public void setB(final boolean b) {
    _delegate.setB(b);
  }
  
  @XtraitjDefinedMethod
  public boolean n() {
    return _delegate.n();
  }
  
  public boolean _n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
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
    this.setB(false);
    String _s = this.getS();
    boolean _isB = this.isB();
    return (_s + Boolean.valueOf(_isB));
  }
  
  @XtraitjDefinedMethod
  public boolean n() {
    return _delegate.n();
  }
  
  public boolean _n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    return _T2_0._m();
  }
  
  @XtraitjRequiredField
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  @XtraitjRequiredField
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setB(final boolean b) {
    _delegate.setB(b);
  }
}
'''
)

			// call the method which uses the renamed field
			executeGeneratedJavaClassMethodAndAssert("C", "meth", "foofalse")
		]
	}

	@Test def void testClassRenameField() {
		classRenameFields.compile[
			// call the method which uses the renamed field
			executeGeneratedJavaClassMethodAndAssert("C", "m", "foo")
			executeGeneratedJavaClassMethodAndAssert("C", "n", "false")
		]
	}

}
