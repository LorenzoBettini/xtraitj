package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("n")
  public abstract int n2();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract int m2();
  
  @XtraitjRequiredField
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("n")
  public abstract int n2();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract int m2();
  
  @XtraitjRequiredField
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
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

	@Test def void testTraitRenameOperationsWithTraitReferenceFullyQualified() {
		traitRenameOperationsWithTraitReferenceFullyQualified.compile[
			expectationsForTraitRenameOperationsWithTraitReferenceFullyQualified(it)
		]
	}

	@Test def void testTraitRenameOperationsWithTraitReferenceFullyQualifiedDifferentFiles() {
		traitRenameOperationsWithTraitReferenceFullyQualifiedDifferentFiles.compile[
			expectationsForTraitRenameOperationsWithTraitReferenceFullyQualified(it)
		]
	}
	
	private def expectationsForTraitRenameOperationsWithTraitReferenceFullyQualified(Result it) {
		assertTraitAdapterJavaInterface("tests", "T2_T1_0",
		'''
		package tests;
		
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
		@SuppressWarnings("all")
		public interface T2_T1_0_Adapter {
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("m")
		  public abstract int m2();
		}
		'''
		)
		
		assertTraitAdapterJavaClass("tests", "T2_T1_0",
		'''
		package tests;
		
		import tests.T1;
		import tests.T1Impl;
		import tests.T2_T1_0_Adapter;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
		@SuppressWarnings("all")
		public class T2_T1_0_AdapterImpl implements T2_T1_0_Adapter, T1 {
		  private T2_T1_0_Adapter _delegate;
		  
		  private T1Impl _T1_0;
		  
		  public T2_T1_0_AdapterImpl(final T2_T1_0_Adapter delegate) {
		    this._delegate = delegate;
		    _T1_0 = new T1Impl(this);
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
		    return _T1_0._m();
		  }
		}
		'''
		)
		
			assertGeneratedJavaCodeCompiles
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
		traitDoubleRenamingSeparateFiles.compile[
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
  @XtraitjRenamedMethod({ "m", "firstRename" })
  public abstract String secondRename();
  
  @XtraitjDefinedMethod
  public abstract String callFirstRename();
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
  public String secondRename() {
    return _delegate.secondRename();
  }
  
  public String _secondRename() {
    return _T2_0._secondRename();
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

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredField
  @XtraitjRenamedMethod("isFieldB")
  public abstract boolean isB();
  
  @XtraitjRequiredFieldSetter
  public abstract void setB(final boolean b);
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldS")
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
  @XtraitjDefinedMethod
  public abstract boolean n();
  
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
  public abstract String meth();
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
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

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
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
  public boolean isB() {
    return _delegate.isB();
  }
  
  public void setB(final boolean b) {
    _delegate.setB(b);
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

	@Test def void testTraitHide() {
		// m will be hidden by T3
		traitHide.compile[
			expectationsForTraitHide(it)
		]
	}

	@Test def void testTraitHideSeparateFiles() {
		// m will be hidden by T3
		traitHideSeparateFiles.compile[
			expectationsForTraitHide(it)
		]
	}
	
	private def expectationsForTraitHide(Result it) {
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredField
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
  @XtraitjDefinedMethod
  public abstract String p();
  
  @XtraitjDefinedMethod
  public abstract String n();
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
  /**
   * independent new version of m
   */
  @XtraitjDefinedMethod
  public abstract int m(final int i);
  
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
  public abstract int callM();
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _T2_0._m();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
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

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
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
  
  /**
   * independent new version of m
   */
  @XtraitjDefinedMethod
  public int m(final int i) {
    return _delegate.m(i);
  }
  
  /**
   * independent new version of m
   */
  public int _m(final int i) {
    return i;
  }
  
  @XtraitjDefinedMethod
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n();
    String _p = this.p();
    return (_n + _p);
  }
  
  @XtraitjDefinedMethod
  public int callM() {
    return _delegate.callM();
  }
  
  public int _callM() {
    return this.m(10);
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
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
			// call the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "10")
			
			// n in T1 will call its own m
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T1.m;T1.m;")
	}

	@Test def void testTraitAlias() {
		traitAlias.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public abstract String oldm();
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjRequiredField
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
  @XtraitjDefinedMethod
  public abstract String p();
  
  @XtraitjDefinedMethod
  public abstract String n();
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
  public abstract String callN();
  
  @XtraitjDefinedMethod
  public abstract String callM();
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
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
  @XtraitjDefinedMethod
  public String _oldm() {
    return _T2_0._m();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  /**
   * original version of m
   */
  public String _m() {
    return _T2_0._m();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
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

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
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
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n();
    String _p = this.p();
    return (_n + _p);
  }
  
  @XtraitjDefinedMethod
  public String callM() {
    return _delegate.callM();
  }
  
  public String _callM() {
    String _m = this.m();
    String _oldm = this.oldm();
    return (_m + _oldm);
  }
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T2_0._oldm();
  }
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  /**
   * original version of m
   */
  public String _m() {
    return _T2_0._m();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
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
			// call the new alias version of m, oldm
			executeGeneratedJavaClassMethodAndAssert("C", "oldm", "T1.m;")
			
			// call callM which calls both m and oldm
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T1.m;T1.m;")
		]
	}

	@Test def void testTraitAliasWithRenameAndHide() {
		traitAliasWithRenameAndHide.compile[
			expectationsForTraitAliasWithRenameAndHide(it)
		]
	}

	@Test def void testTraitAliasWithRenameAndHideSeparateFiles() {
		traitAliasWithRenameAndHideSeparateFiles.compile[
			expectationsForTraitAliasWithRenameAndHide(it)
		]
	}
	
	private def expectationsForTraitAliasWithRenameAndHide(Result it) {
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public abstract String m1();
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public abstract String oldm();
  
  /**
   * original version of n
   */
  @XtraitjDefinedMethod
  public abstract String oldn();
  
  @XtraitjRequiredField
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
  @XtraitjDefinedMethod
  public abstract String p();
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
  /**
   * independent version of n
   */
  @XtraitjDefinedMethod
  public abstract String n(final int i);
  
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
  public abstract String callM();
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
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
  @XtraitjDefinedMethod
  public String _oldm() {
    return _T2_0._m();
  }
  
  /**
   * original version of n
   */
  public String oldn() {
    return _delegate.oldn();
  }
  
  /**
   * original version of n
   */
  @XtraitjDefinedMethod
  public String _oldn() {
    return _T2_0._n();
  }
  
  /**
   * original version of m
   */
  public String m() {
    return this.m1();
  }
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("m")
  public String m1() {
    return _delegate.m1();
  }
  
  /**
   * original version of m
   */
  public String _m1() {
    return _T2_0._m();
  }
  
  /**
   * original version of n
   */
  public String n() {
    return _T2_0._n();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
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

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
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
  
  /**
   * independent version of n
   */
  @XtraitjDefinedMethod
  public String n(final int i) {
    return _delegate.n(i);
  }
  
  /**
   * independent version of n
   */
  public String _n(final int i) {
    String _oldn = this.oldn();
    String _plus = (_oldn + Integer.valueOf(i));
    return (_plus + " - ");
  }
  
  @XtraitjDefinedMethod
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n(10);
    String _p = this.p();
    return (_n + _p);
  }
  
  @XtraitjDefinedMethod
  public String callM() {
    return _delegate.callM();
  }
  
  public String _callM() {
    String _m1 = this.m1();
    String _oldm = this.oldm();
    return (_m1 + _oldm);
  }
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public String m1() {
    return _delegate.m1();
  }
  
  /**
   * original version of m
   */
  public String _m1() {
    return _T2_0._m1();
  }
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T2_0._oldm();
  }
  
  /**
   * original version of n
   */
  @XtraitjDefinedMethod
  public String oldn() {
    return _delegate.oldn();
  }
  
  /**
   * original version of n
   */
  public String _oldn() {
    return _T2_0._oldn();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
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
			// call the new alias version of m, oldm
			executeGeneratedJavaClassMethodAndAssert("C", "oldm", "T1.m;")
			
			// call the renamed version of m, m1
			executeGeneratedJavaClassMethodAndAssert("C", "m1", "T1.m;")
			
			// call callM which calls both m1 and oldm
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T1.m;T1.m;")
			
			// call callN which calls the new version of n and p
			// which in turns calls the original versions of m and n
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T1.n;10 - T1.m;T1.n;")
	}

	@Test def void testTraitRestrict() {
		traitRestrict.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  /**
   * original version of m
   */
  @XtraitjRequiredMethod
  public abstract String m();
  
  @XtraitjRequiredField
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
  @XtraitjDefinedMethod
  public abstract String p();
  
  @XtraitjDefinedMethod
  public abstract String n();
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
  /**
   * new version of m
   */
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
  public abstract String callM();
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _delegate.m();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
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

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
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
  
  /**
   * new version of m
   */
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  /**
   * new version of m
   */
  public String _m() {
    return "T3.m;";
  }
  
  @XtraitjDefinedMethod
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n();
    String _p = this.p();
    return (_n + _p);
  }
  
  @XtraitjDefinedMethod
  public String callM() {
    return _delegate.callM();
  }
  
  public String _callM() {
    return this.m();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
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
			// call callM which calls both the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T3.m;")

			// call callN which calls n and p which will call the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T3.m;T3.m;")
		]
	}

	@Test def void testTraitRestrictAndAlias() {
		traitRestrictAndAlias.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public abstract String oldm();
  
  /**
   * original version of m
   */
  @XtraitjRequiredMethod
  public abstract String m();
  
  @XtraitjRequiredField
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
  
  @XtraitjDefinedMethod
  public abstract String p();
  
  @XtraitjDefinedMethod
  public abstract String n();
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
  /**
   * new version of m
   */
  @XtraitjDefinedMethod
  public abstract String m();
  
  @XtraitjDefinedMethod
  public abstract String callN();
  
  @XtraitjDefinedMethod
  public abstract String callM();
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
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
  @XtraitjDefinedMethod
  public String _oldm() {
    return _T2_0._m();
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _delegate.m();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
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

assertTraitJavaClass("tests", "T3",
'''
package tests;

import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
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
  
  /**
   * new version of m
   */
  @XtraitjDefinedMethod
  public String m() {
    return _delegate.m();
  }
  
  /**
   * new version of m
   */
  public String _m() {
    String _oldm = this.oldm();
    return ("T3.m;" + _oldm);
  }
  
  @XtraitjDefinedMethod
  public String callN() {
    return _delegate.callN();
  }
  
  public String _callN() {
    String _n = this.n();
    String _p = this.p();
    return (_n + _p);
  }
  
  @XtraitjDefinedMethod
  public String callM() {
    return _delegate.callM();
  }
  
  public String _callM() {
    return this.m();
  }
  
  /**
   * original version of m
   */
  @XtraitjDefinedMethod
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T2_0._oldm();
  }
  
  @XtraitjDefinedMethod
  public String p() {
    return _delegate.p();
  }
  
  public String _p() {
    return _T2_0._p();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T2_0._n();
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
			// call callM which calls both the new version of m
			// which in turn calls also the old version
			executeGeneratedJavaClassMethodAndAssert("C", "callM", "T3.m;T1.m;")

			// call callN which calls n and p which will call the new version of m
			executeGeneratedJavaClassMethodAndAssert("C", "callN", "T3.m;T1.m;T3.m;T1.m;")
		]
	}

	@Test def void testTraitRedirect() {
		traitRedirect.compile[

assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredField
  public abstract String getS2();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS2(final String s2);
  
  @XtraitjDefinedMethod
  public abstract String useField();
  
  @XtraitjDefinedMethod
  public abstract String prov();
  
  @XtraitjDefinedMethod
  public abstract String callReq();
}
'''
)

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3 extends T3_T2_0_Adapter {
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2 {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
  }
  
  @XtraitjRequiredField
  public String getS1() {
    return _delegate.getS2();
  }
  
  public void setS1(final String s2) {
    _delegate.setS2(s2);
  }
  
  @XtraitjDefinedMethod
  public String req() {
    return _delegate.prov();
  }
  
  @XtraitjDefinedMethod
  public String useField() {
    return _delegate.useField();
  }
  
  public String _useField() {
    return _T2_0._useField();
  }
  
  @XtraitjDefinedMethod
  public String prov() {
    return _delegate.prov();
  }
  
  public String _prov() {
    return _T2_0._prov();
  }
  
  @XtraitjDefinedMethod
  public String callReq() {
    return _delegate.callReq();
  }
  
  public String _callReq() {
    return _T2_0._callReq();
  }
  
  @XtraitjRequiredField
  public String getS2() {
    return _delegate.getS2();
  }
  
  public void setS2(final String s2) {
    _delegate.setS2(s2);
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
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
  public String useField() {
    return _delegate.useField();
  }
  
  public String _useField() {
    return _T2_0._useField();
  }
  
  @XtraitjDefinedMethod
  public String prov() {
    return _delegate.prov();
  }
  
  public String _prov() {
    return _T2_0._prov();
  }
  
  @XtraitjDefinedMethod
  public String callReq() {
    return _delegate.callReq();
  }
  
  public String _callReq() {
    return _T2_0._callReq();
  }
  
  @XtraitjRequiredField
  public String getS2() {
    return _delegate.getS2();
  }
  
  public void setS2(final String s2) {
    _delegate.setS2(s2);
  }
}
'''
)
			// originally return s1 which is redirected to s2
			executeGeneratedJavaClassMethodAndAssert("C", "useField", "s2")
			
			// callReq calls the required method req, which was
			// redirected to prov
			executeGeneratedJavaClassMethodAndAssert("C", "callReq", "prov")
		]
	}

}
