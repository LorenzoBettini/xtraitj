package xtraitj.example.examples.extensions;

import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.example.examples.extensions.TTransformerIterator_TIterator_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TTransformerIterator<T extends Object, R extends Object> extends TTransformerIterator_TIterator_0_Adapter<T, R> {
  @XtraitjRequiredField
  public abstract Function1<? super T, ? extends R> getFunction();
  
  public abstract void setFunction(final Function1<? super T, ? extends R> function);
  
  @XtraitjDefinedMethod
  public abstract R next();
}
