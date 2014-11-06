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
		traitUsesGenericTraitWithRenameSimplerSeparateFiles.createResourceSet.compile[
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
		traitUsesGenericTraitWithRenameSeparateFiles.createResourceSet.compile[
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
		classUsesTraitWithGenericRenamedFieldsInstantiatedSeparateFiles.createResourceSet.compile[
			expectationsForTraitRenameGenericFieldInstantiated(it)
		]
	}
	
	private def expectationsForTraitRenameGenericFieldInstantiated(Result it) {
assertTraitAdapterJavaInterface("tests", "T3_T2_0",
'''
package tests;

import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public interface T3_T2_0_Adapter {
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldB")
  public abstract Boolean getB();
  
  public abstract void setB(final Boolean b);
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldS")
  public abstract String getS();
  
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
		traitRenameGenericFieldNotInstantiatedSeparateFiles.createResourceSet.compile[
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

@SuppressWarnings("all")
public interface T3_T2_0_Adapter<U extends String, V> {
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldB")
  public abstract V getB();
  
  public abstract void setB(final V b);
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getFieldS")
  public abstract U getS();
  
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
public class T3_T2_0_AdapterImpl<U extends String, V> implements T3_T2_0_Adapter<U, V>, T2<U, V> {
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
public interface T3<U extends String, V> extends T3_T2_0_Adapter<U, V> {
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
public class T2Impl<G1, G2> implements T2<G1, G2> {
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
public class T3Impl<U extends String, V> implements T3<U, V> {
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
  public abstract <T> List<T> returnListOfInteger(final T t);
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
import tests.UsesTGenericImpl;

@SuppressWarnings("all")
public class C implements UsesTGeneric {
  private UsesTGenericImpl _UsesTGeneric = new UsesTGenericImpl(this);
  
  public String useLists() {
    return _UsesTGeneric._useLists();
  }
  
  public <T> List<T> returnListOfInteger(final T t) {
    return _UsesTGeneric._returnListOfInteger(t);
  }
  
  public <T> List<T> returnList(final T t) {
    return _UsesTGeneric._returnList(t);
  }
}
'''
)
			executeGeneratedJavaClassMethodAndAssert("C", "useLists", "[bar, foo][0, 1]")
		]
	}
}
