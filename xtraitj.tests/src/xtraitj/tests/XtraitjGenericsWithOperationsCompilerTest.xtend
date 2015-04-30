package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(InjectorProviderCustom))
class XtraitjGenericsWithOperationsCompilerTest extends AbstractXtraitjCompilerTest {

	@Test def void testTraitUsesGenericTraitWithRenameSimpler() {
		traitUsesGenericTraitWithRenameSimpler.compile[
			expectationsForTraitUsesGenericTraitWithRenameSimpler(it)
		]
	}

	@Test def void testTraitUsesGenericTraitWithRenameSimplerSeparateFiles() {
		traitUsesGenericTraitWithRenameSimplerSeparateFiles.compile[
			expectationsForTraitUsesGenericTraitWithRenameSimpler(it)
		]
	}
	
	private def expectationsForTraitUsesGenericTraitWithRenameSimpler(Result it) {
		assertTraitJavaInterface("tests", "UsesTGeneric",
		'''
		package tests;
		
		import tests.UsesTGeneric_TGeneric_0_Adapter;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;
		
		@XtraitjTraitInterface
		@SuppressWarnings("all")
		public interface UsesTGeneric extends UsesTGeneric_TGeneric_0_Adapter {
		  @XtraitjDefinedMethod
		  public abstract String useLists();
		}
		'''
		)
		
		assertTraitAdapterJavaInterface("tests", "UsesTGeneric_TGeneric_0",
		'''
		package tests;
		
		import java.util.List;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
		@SuppressWarnings("all")
		public interface UsesTGeneric_TGeneric_0_Adapter {
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("returnList")
		  public abstract List<Integer> returnListOfInteger();
		  
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("printList")
		  public abstract void printListOfInteger(final List<Integer> l);
		}
		'''
		)
		
		assertTraitAdapterJavaClass("tests", "UsesTGeneric_TGeneric_0",
		'''
		package tests;
		
		import java.util.List;
		import tests.TGeneric;
		import tests.TGenericImpl;
		import tests.UsesTGeneric_TGeneric_0_Adapter;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
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
		import tests.UsesTGeneric;
		import tests.UsesTGeneric_TGeneric_0_AdapterImpl;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjTraitClass;
		
		@XtraitjTraitClass
		@SuppressWarnings("all")
		public class UsesTGenericImpl implements UsesTGeneric {
		  private UsesTGeneric _delegate;
		  
		  private UsesTGeneric_TGeneric_0_AdapterImpl _TGeneric_0;
		  
		  public UsesTGenericImpl(final UsesTGeneric delegate) {
		    this._delegate = delegate;
		    _TGeneric_0 = new UsesTGeneric_TGeneric_0_AdapterImpl(delegate);
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
		import tests.UsesTGenericImpl;
		
		@SuppressWarnings("all")
		public class C implements UsesTGeneric {
		  private UsesTGenericImpl _UsesTGeneric = new UsesTGenericImpl(this);
		  
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
	}

	@Test def void testTraitUsesGenericTraitWithRename() {
		traitUsesGenericTraitWithRename.compile[
			expectationsForTraitUsesGenericTraitWithRename(it)
		]
	}

	@Test def void testTraitUsesGenericTraitWithRenameSeparateFiles() {
		traitUsesGenericTraitWithRenameSeparateFiles.compile[
			expectationsForTraitUsesGenericTraitWithRename(it)
		]
	}
	
	private def expectationsForTraitUsesGenericTraitWithRename(Result it) {
		assertTraitAdapterJavaInterface("tests", "UsesTGeneric_TGeneric_0",
		'''
		package tests;
		
		import java.util.List;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
		@SuppressWarnings("all")
		public interface UsesTGeneric_TGeneric_0_Adapter {
		  @XtraitjDefinedMethod
		  @XtraitjRenamedMethod("returnList")
		  public abstract List<Integer> returnListOfInteger();
		}
		'''
		)
		
		assertTraitAdapterJavaClass("tests", "UsesTGeneric_TGeneric_0",
		'''
		package tests;
		
		import java.util.List;
		import tests.TGeneric;
		import tests.TGenericImpl;
		import tests.UsesTGeneric_TGeneric_0_Adapter;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
		
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

		assertTraitJavaInterface("tests", "UsesTGeneric",
		'''
		package tests;
		
		import tests.TGeneric;
		import tests.UsesTGeneric_TGeneric_0_Adapter;
		import tests.UsesTGeneric_TGeneric_1_Adapter;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;
		
		@XtraitjTraitInterface
		@SuppressWarnings("all")
		public interface UsesTGeneric extends UsesTGeneric_TGeneric_0_Adapter, UsesTGeneric_TGeneric_1_Adapter, TGeneric<String> {
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
		import tests.TGenericImpl;
		import tests.UsesTGeneric;
		import tests.UsesTGeneric_TGeneric_0_AdapterImpl;
		import tests.UsesTGeneric_TGeneric_1_AdapterImpl;
		import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
		import xtraitj.runtime.lib.annotation.XtraitjTraitClass;
		
		@XtraitjTraitClass
		@SuppressWarnings("all")
		public class UsesTGenericImpl implements UsesTGeneric {
		  private UsesTGeneric _delegate;
		  
		  private UsesTGeneric_TGeneric_0_AdapterImpl _TGeneric_0;
		  
		  private UsesTGeneric_TGeneric_1_AdapterImpl _TGeneric_1;
		  
		  private TGenericImpl<String> _TGeneric;
		  
		  public UsesTGenericImpl(final UsesTGeneric delegate) {
		    this._delegate = delegate;
		    _TGeneric_0 = new UsesTGeneric_TGeneric_0_AdapterImpl(delegate);
		    _TGeneric_1 = new UsesTGeneric_TGeneric_1_AdapterImpl(delegate);
		    _TGeneric = new TGenericImpl(delegate);
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
				
		assertJavaClass("tests", "C",
		'''
		package tests;
		
		import java.util.List;
		import tests.UsesTGeneric;
		import tests.UsesTGenericImpl;
		
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
	}

	@Test def void traitRenameGenericFieldInstantiated() {
		classUsesTraitWithGenericRenamedFieldsInstantiated.compile[
			expectationsForTraitRenameGenericFieldInstantiated(it)
		]
	}

	@Test def void traitRenameGenericFieldInstantiatedSeparateFiles() {
		classUsesTraitWithGenericRenamedFieldsInstantiatedSeparateFiles.compile[
			expectationsForTraitRenameGenericFieldInstantiated(it)
		]
	}
	
	private def expectationsForTraitRenameGenericFieldInstantiated(Result it) {
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldB")
  public abstract Boolean getB();
  
  @XtraitjRequiredFieldSetter
  public abstract void setB(final Boolean b);
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldS")
  public abstract String getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final String s);
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
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T3_T2_0_AdapterImpl implements T3_T2_0_Adapter, T2<String, Boolean> {
  private T3_T2_0_Adapter _delegate;
  
  private T2Impl<String, Boolean> _T2_0;
  
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
    this.setB(Boolean.valueOf(false));
    String _s = this.getS();
    Boolean _b = this.getB();
    return (_s + _b);
  }
  
  @XtraitjRequiredField
  public Boolean getB() {
    return _delegate.getB();
  }
  
  public void setB(final Boolean b) {
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
	}

	@Test def void testRenameGenericFieldNotInstantiated() {
		traitRenameGenericFieldNotInstantiated.compile[
			expectationsForRenameGenericFieldNotInstantiated(it)
		]
	}

	@Test def void testRenameGenericFieldNotInstantiatedSeparateFiles() {
		traitRenameGenericFieldNotInstantiatedSeparateFiles.compile[
			expectationsForRenameGenericFieldNotInstantiated(it)
		]
	}
	
	private def expectationsForRenameGenericFieldNotInstantiated(Result it) {
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter<U extends String, V extends Object> {
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldB")
  public abstract V getB();
  
  @XtraitjRequiredFieldSetter
  public abstract void setB(final V b);
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldS")
  public abstract U getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final U s);
  
  @XtraitjDefinedMethod
  public abstract String T2meth();
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
public class T3_T2_0_AdapterImpl<U extends String, V extends Object> implements T3_T2_0_Adapter<U, V>, T2<U, V> {
  private T3_T2_0_Adapter<U, V> _delegate;
  
  private T2Impl<U, V> _T2_0;
  
  public T3_T2_0_AdapterImpl(final T3_T2_0_Adapter<U, V> delegate) {
    this._delegate = delegate;
    _T2_0 = new T2Impl(this);
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

assertTraitJavaInterface("tests", "T3",
'''
package tests;

import tests.T3_T2_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3<U extends String, V extends Object> extends T3_T2_0_Adapter<U, V> {
  @XtraitjDefinedMethod
  public abstract String meth();
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests;

import org.eclipse.xtext.xbase.lib.InputOutput;
import tests.T1Impl;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl<G1 extends Object, G2 extends Object> implements T2<G1, G2> {
  private T2<G1, G2> _delegate;
  
  private T1Impl<G1> _T1;
  
  public T2Impl(final T2<G1, G2> delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
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
import tests.T3;
import tests.T3_T2_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl<U extends String, V extends Object> implements T3<U, V> {
  private T3<U, V> _delegate;
  
  private T3_T2_0_AdapterImpl<U, V> _T2_0;
  
  public T3Impl(final T3<U, V> delegate) {
    this._delegate = delegate;
    _T2_0 = new T3_T2_0_AdapterImpl(delegate);
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
  public V getB() {
    return _delegate.getB();
  }
  
  public void setB(final V b) {
    _delegate.setB(b);
  }
  
  @XtraitjRequiredField
  public U getS() {
    return _delegate.getS();
  }
  
  public void setS(final U s) {
    _delegate.setS(s);
  }
}
'''
)
		assertGeneratedJavaCodeCompiles
	}

	@Test def void testUsesTraitWithRenameGenericMethod() {
		traitUsesTraitWithRenameGenericMethod.compile[

assertTraitAdapterJavaInterface("tests", "UsesTGeneric_T1_0",
'''
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public interface UsesTGeneric_T1_0_Adapter {
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("returnList")
  public abstract <T extends Object> List<T> returnListOfInteger(final T t);
}
'''
)


assertTraitAdapterJavaClass("tests", "UsesTGeneric_T1_0",
'''
package tests;

import java.util.List;
import tests.T1;
import tests.T1Impl;
import tests.UsesTGeneric_T1_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;

@SuppressWarnings("all")
public class UsesTGeneric_T1_0_AdapterImpl implements UsesTGeneric_T1_0_Adapter, T1 {
  private UsesTGeneric_T1_0_Adapter _delegate;
  
  private T1Impl _T1_0;
  
  public UsesTGeneric_T1_0_AdapterImpl(final UsesTGeneric_T1_0_Adapter delegate) {
    this._delegate = delegate;
    _T1_0 = new T1Impl(this);
  }
  
  public <T extends Object> List<T> returnList(final T t) {
    return this.returnListOfInteger(t);
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("returnList")
  public <T extends Object> List<T> returnListOfInteger(final T t) {
    return _delegate.returnListOfInteger(t);
  }
  
  public <T extends Object> List<T> _returnListOfInteger(final T t) {
    return _T1_0._returnList(t);
  }
}
'''
)

assertTraitJavaInterface("tests", "UsesTGeneric",
'''
package tests;

import tests.T1;
import tests.UsesTGeneric_T1_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface UsesTGeneric extends UsesTGeneric_T1_0_Adapter, T1 {
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
import tests.T1Impl;
import tests.UsesTGeneric;
import tests.UsesTGeneric_T1_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class UsesTGenericImpl implements UsesTGeneric {
  private UsesTGeneric _delegate;
  
  private UsesTGeneric_T1_0_AdapterImpl _T1_0;
  
  private T1Impl _T1;
  
  public UsesTGenericImpl(final UsesTGeneric delegate) {
    this._delegate = delegate;
    _T1_0 = new UsesTGeneric_T1_0_AdapterImpl(delegate);
    _T1 = new T1Impl(delegate);
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
  public <T extends Object> List<T> returnListOfInteger(final T t) {
    return _delegate.returnListOfInteger(t);
  }
  
  public <T extends Object> List<T> _returnListOfInteger(final T t) {
    return _T1_0._returnListOfInteger(t);
  }
  
  @XtraitjDefinedMethod
  public <T extends Object> List<T> returnList(final T t) {
    return _delegate.returnList(t);
  }
  
  public <T extends Object> List<T> _returnList(final T t) {
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
import tests.UsesTGenericImpl;

@SuppressWarnings("all")
public class C implements UsesTGeneric {
  private UsesTGenericImpl _UsesTGeneric = new UsesTGenericImpl(this);
  
  public String useLists() {
    return _UsesTGeneric._useLists();
  }
  
  public <T extends Object> List<T> returnListOfInteger(final T t) {
    return _UsesTGeneric._returnListOfInteger(t);
  }
  
  public <T extends Object> List<T> returnList(final T t) {
    return _UsesTGeneric._returnList(t);
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "useLists", "[bar, foo][0, 1]")
		]
	}

	@Test def void testTraitUsesGenericTraitWithHide() {
		traitUsesGenericTraitWithHide.compile[
			expectationsForTraitUsesGenericTraitWithHide(it)
		]
	}

	@Test def void testTraitUsesGenericTraitWithHideSeparateFiles() {
		traitUsesGenericTraitWithHideSeparateFiles.compile[
			expectationsForTraitUsesGenericTraitWithHide(it)
		]
	}
	
	def expectationsForTraitUsesGenericTraitWithHide(Result it) {
assertTraitAdapterJavaClass("tests", "T3_T2_0",
'''
package tests;

import java.util.List;
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
  public List<String> getL() {
    return _delegate.getL();
  }
  
  public void setL(final List<String> l) {
    _delegate.setL(l);
  }
}
'''
)

assertTraitAdapterJavaClass("tests", "T4_T1_0",
'''
package tests;

import java.util.List;
import tests.T1;
import tests.T1Impl;
import tests.T4_T1_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class T4_T1_0_AdapterImpl implements T4_T1_0_Adapter, T1<String> {
  private T4_T1_0_Adapter _delegate;
  
  private T1Impl<String> _T1_0;
  
  public T4_T1_0_AdapterImpl(final T4_T1_0_Adapter delegate) {
    this._delegate = delegate;
    _T1_0 = new T1Impl(this);
  }
  
  /**
   * original version of m
   */
  public String m() {
    return _T1_0._m();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T1_0._n();
  }
  
  @XtraitjRequiredField
  public List<String> getL() {
    return _delegate.getL();
  }
  
  public void setL(final List<String> l) {
    _delegate.setL(l);
  }
}
'''
)
		
		executeGeneratedJavaClassMethodAndAssert("C", "callN", "foofoo")
		executeGeneratedJavaClassMethodAndAssert("C", "callM", "10")
		
		// in this case we call the new m(10)
		executeGeneratedJavaClassMethodAndAssert("C2", "callN", "foo10")
		executeGeneratedJavaClassMethodAndAssert("C2", "callM", "10")
	}

	@Test def void testTraitUsesGenericTraitWithAlias() {
		traitUsesGenericTraitWithAlias.compile[

assertTraitJavaInterface("tests", "T2",
'''
package tests;

import tests.T2_T1_0_Adapter;
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
}
'''
)

assertTraitJavaClass("tests", "T2",
'''
package tests;

import java.util.List;
import tests.T2;
import tests.T2_T1_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

/**
 * alias on a directly instantiated type parameter
 */
@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl implements T2 {
  private T2 _delegate;
  
  private T2_T1_0_AdapterImpl _T1_0;
  
  public T2Impl(final T2 delegate) {
    this._delegate = delegate;
    _T1_0 = new T2_T1_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
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
  @XtraitjDefinedMethod
  public String oldm() {
    return _delegate.oldm();
  }
  
  /**
   * original version of m
   */
  public String _oldm() {
    return _T1_0._oldm();
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
    return _T1_0._m();
  }
  
  @XtraitjDefinedMethod
  public String n() {
    return _delegate.n();
  }
  
  public String _n() {
    return _T1_0._n();
  }
  
  @XtraitjRequiredField
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
package tests;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface T2_T1_0_Adapter {
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
  public abstract List<String> getL();
  
  @XtraitjRequiredFieldSetter
  public abstract void setL(final List<String> l);
  
  @XtraitjDefinedMethod
  public abstract String n();
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "p", "foofoo")
			executeGeneratedJavaClassMethodAndAssert("C2", "p", "foofoo")
		]
	}

	@Test def void testTraitUsesGenericTraitWithAliasRenameHide() {
		traitUsesGenericTraitWithAliasRenameHide.compile[
			expectationsForTraitUsesGenericTraitWithAliasRenameHide(it)
		]
	}

	@Test def void testTraitUsesGenericTraitWithAliasRenameHideSeparateFiles() {
		traitUsesGenericTraitWithAliasRenameHideSeparateFiles.compile[
			expectationsForTraitUsesGenericTraitWithAliasRenameHide(it)
		]
	}
	
	private def expectationsForTraitUsesGenericTraitWithAliasRenameHide(Result it) {
		// call the new alias version of m, oldm
		executeGeneratedJavaClassMethodAndAssert("C", "oldm", "foo")
		
		// call the renamed version of m, m1
		executeGeneratedJavaClassMethodAndAssert("C", "m1", "foo")
		
		// call callM which calls both m1 and oldm
		executeGeneratedJavaClassMethodAndAssert("C", "callM", "foofoo")
		
		// call callN which calls the new version of n and p
		// which in turns calls the original versions of m and n
		executeGeneratedJavaClassMethodAndAssert("C", "callN", "foo10 - foofoo")
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
			expectationsForTraitUsesGenericTraitWithRestrictAndAlias(it)
		]
	}

	@Test def void testTraitUsesGenericTraitWithRestrictAndAliasSeparateFiles() {
		traitUsesGenericTraitWithRestrictAndAliasSeparateFiles.compile[
			expectationsForTraitUsesGenericTraitWithRestrictAndAlias(it)
		]
	}
	
	private def expectationsForTraitUsesGenericTraitWithRestrictAndAlias(Result it) {
		// call callM which calls both the new version of m and the old one
		executeGeneratedJavaClassMethodAndAssert("C", "callM", "T3.m;foo")
		
		// call callN which calls n and p which will call the new version of m and the old one
		executeGeneratedJavaClassMethodAndAssert("C", "callN", "T3.m;fooT3.m;foo")
		
		executeGeneratedJavaClassMethodAndAssert("C2", "callM", "T3.m;foo")
		
		// call callN which calls n (no p in this case) which will call the new version of m and the old one
		executeGeneratedJavaClassMethodAndAssert("C2", "callN", "T3.m;foo")
	}

	@Test def void testGenericFunctionAsField() {
		genericFunctionAsField.compile[

assertTraitJavaInterface("tests", "TTransformerIterator",
'''
package tests;

import org.eclipse.xtext.xbase.lib.Functions.Function1;
import tests.TTransformerIterator_TIterator_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TTransformerIterator<T extends Object, R extends Object> extends TTransformerIterator_TIterator_0_Adapter<T, R> {
  @XtraitjRequiredField
  public abstract Function1<? super T, ? extends R> getFunction();
  
  @XtraitjRequiredFieldSetter
  public abstract void setFunction(final Function1<? super T, ? extends R> function);
  
  @XtraitjDefinedMethod
  public abstract R next();
}
'''
)

assertTraitJavaClass("tests", "TTransformerIterator",
'''
package tests;

import java.util.Iterator;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import tests.TTransformerIterator;
import tests.TTransformerIterator_TIterator_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TTransformerIteratorImpl<T extends Object, R extends Object> implements TTransformerIterator<T, R> {
  private TTransformerIterator<T, R> _delegate;
  
  private TTransformerIterator_TIterator_0_AdapterImpl<T, R> _TIterator_0;
  
  public TTransformerIteratorImpl(final TTransformerIterator<T, R> delegate) {
    this._delegate = delegate;
    _TIterator_0 = new TTransformerIterator_TIterator_0_AdapterImpl(delegate);
  }
  
  @XtraitjRequiredField
  public Function1<? super T, ? extends R> getFunction() {
    return _delegate.getFunction();
  }
  
  public void setFunction(final Function1<? super T, ? extends R> function) {
    _delegate.setFunction(function);
  }
  
  @XtraitjDefinedMethod
  public R next() {
    return _delegate.next();
  }
  
  public R _next() {
    final T o = this.origNext();
    Function1<? super T, ? extends R> _function = this.getFunction();
    return _function.apply(o);
  }
  
  @XtraitjDefinedMethod
  public T origNext() {
    return _delegate.origNext();
  }
  
  public T _origNext() {
    return _TIterator_0._origNext();
  }
  
  @XtraitjDefinedMethod
  public boolean hasNext() {
    return _delegate.hasNext();
  }
  
  public boolean _hasNext() {
    return _TIterator_0._hasNext();
  }
  
  @XtraitjDefinedMethod
  public void remove() {
    _delegate.remove();
  }
  
  public void _remove() {
    _TIterator_0._remove();
  }
  
  @XtraitjRequiredField
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

	@Test def void testPassTypeParameterAsTypeArgument() {
		passTypeParameterAsTypeArgument.compile[
			expectationsForPassTypeParameterAsTypeArgument(it)
		]
	}

	@Test def void testPassTypeParameterAsTypeArgumentSeparateFiles() {
		passTypeParameterAsTypeArgumentSeparateFiles.compile[
			expectationsForPassTypeParameterAsTypeArgument(it)
		]
	}
	
	private def expectationsForPassTypeParameterAsTypeArgument(Result it) {
assertTraitJavaInterface("tests", "T2",
'''
package tests;

import tests.T1;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T2<W extends Object> extends T1<W> {
}
'''
)

assertTraitAdapterJavaInterface("tests", "TWithOp_T1_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface TWithOp_T1_0_Adapter<Z extends Object> {
  @XtraitjRequiredField
  public abstract Z getS();
  
  @XtraitjRequiredFieldSetter
  public abstract void setS(final Z s);
}
'''
)

assertTraitAdapterJavaClass("tests", "TWithOp_T1_0",
'''
package tests;

import tests.T1;
import tests.T1Impl;
import tests.TWithOp_T1_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class TWithOp_T1_0_AdapterImpl<Z extends Object> implements TWithOp_T1_0_Adapter<Z>, T1<Z> {
  private TWithOp_T1_0_Adapter<Z> _delegate;
  
  private T1Impl<Z> _T1_0;
  
  public TWithOp_T1_0_AdapterImpl(final TWithOp_T1_0_Adapter<Z> delegate) {
    this._delegate = delegate;
    _T1_0 = new T1Impl(this);
  }
  
  public Z m() {
    return _T1_0._m();
  }
  
  @XtraitjRequiredField
  public Z getS() {
    return _delegate.getS();
  }
  
  public void setS(final Z s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitJavaClass("tests", "TWithOp",
'''
package tests;

import tests.TWithOp;
import tests.TWithOp_T1_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TWithOpImpl<Z extends Object> implements TWithOp<Z> {
  private TWithOp<Z> _delegate;
  
  private TWithOp_T1_0_AdapterImpl<Z> _T1_0;
  
  public TWithOpImpl(final TWithOp<Z> delegate) {
    this._delegate = delegate;
    _T1_0 = new TWithOp_T1_0_AdapterImpl(delegate);
  }
  
  @XtraitjRequiredField
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
package tests;

import tests.T1Impl;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T2Impl<W extends Object> implements T2<W> {
  private T2<W> _delegate;
  
  private T1Impl<W> _T1;
  
  public T2Impl(final T2<W> delegate) {
    this._delegate = delegate;
    _T1 = new T1Impl(delegate);
  }
  
  @XtraitjDefinedMethod
  public W m() {
    return _delegate.m();
  }
  
  public W _m() {
    return _T1._m();
  }
  
  @XtraitjRequiredField
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
package tests;

import java.util.List;
import tests.T2;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T3<V extends Object> extends T2<List<V>> {
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
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T3Impl<V extends Object> implements T3<V> {
  private T3<V> _delegate;
  
  private T2Impl<List<V>> _T2;
  
  public T3Impl(final T3<V> delegate) {
    this._delegate = delegate;
    _T2 = new T2Impl(delegate);
  }
  
  @XtraitjDefinedMethod
  public List<V> m() {
    return _delegate.m();
  }
  
  public List<V> _m() {
    return _T2._m();
  }
  
  @XtraitjRequiredField
  public List<V> getS() {
    return _delegate.getS();
  }
  
  public void setS(final List<V> s) {
    _delegate.setS(s);
  }
}
'''
)

assertTraitAdapterJavaClass("tests", "CWithOp_T1_0",
'''
package tests;

import tests.CWithOp_T1_0_Adapter;
import tests.T1;
import tests.T1Impl;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class CWithOp_T1_0_AdapterImpl<Z extends Object> implements CWithOp_T1_0_Adapter<Z>, T1<Z> {
  private CWithOp_T1_0_Adapter<Z> _delegate;
  
  private T1Impl<Z> _T1_0;
  
  public CWithOp_T1_0_AdapterImpl(final CWithOp_T1_0_Adapter<Z> delegate) {
    this._delegate = delegate;
    _T1_0 = new T1Impl(this);
  }
  
  public Z m() {
    return _T1_0._m();
  }
  
  @XtraitjRequiredField
  public Z getS() {
    return _delegate.getS();
  }
  
  public void setS(final Z s) {
    _delegate.setS(s);
  }
}
'''
)

			executeGeneratedJavaClassMethodAndAssert("C", "m", "foo")
			executeGeneratedJavaClassMethodAndAssert("C3", "m", "[foo, bar]")
	}

	@Test def void testTraitUsesGenericTraitWithRedirect() {
		traitUsesGenericTraitWithRedirect.compile[
			expectationsForTraitUsesGenericTraitWithRedirect(it)
		]
	}

	@Test def void testTraitUsesGenericTraitWithRedirectSeparateFiles() {
		traitUsesGenericTraitWithRedirectSeparateFiles.compile[
			expectationsForTraitUsesGenericTraitWithRedirect(it)
		]
	}
	
	private def expectationsForTraitUsesGenericTraitWithRedirect(Result it) {
		// originally return s1 which is redirected to s2
		executeGeneratedJavaClassMethodAndAssert("C", "useField", "foo")
		
		// callReq calls the required method req, which was
		// redirected to prov
		executeGeneratedJavaClassMethodAndAssert("C", "callReq", "foo")
		
		executeGeneratedJavaClassMethodAndAssert("C2", "useField", "foo")
		executeGeneratedJavaClassMethodAndAssert("C2", "callReq", "foo")
	}

	@Test def void testTraitUsesGenericTraitWithRedirectCompliant() {
		traitUsesGenericTraitWithRedirectCompliant.compile[
			expectationsForTraitUsesGenericTraitWithRedirectCompliant(it)
		]
	}

	@Test def void testTraitUsesGenericTraitWithRedirectCompliantSeparateFiles() {
		traitUsesGenericTraitWithRedirectCompliantSeparateFiles.compile[
			expectationsForTraitUsesGenericTraitWithRedirectCompliant(it)
		]
	}
	
	private def expectationsForTraitUsesGenericTraitWithRedirectCompliant(Result it) {
		// callReq calls the required method req, which was
		// redirected to prov
		executeGeneratedJavaClassMethodAndAssert("C", "callReq", "[foo, bar]")
		
		executeGeneratedJavaClassMethodAndAssert("C2", "callReq", "[foo, bar]")
	}

	@Test def void testAccessRenameGeneratedJavaCodeWithoutOriginalSource() {
		accessRenameGeneratedJavaCodeWithoutOriginalSource.compile[
			executeGeneratedJavaClassMethodAndAssert("C1", "useProvided", "test")
			executeGeneratedJavaClassMethodAndAssert("C2", "useProvided", "test")
		]
	}
}
