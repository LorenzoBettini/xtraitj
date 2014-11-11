package xtraitj.example.examples.extensions;

import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TIterableExtensions<T extends Object> {
  @XtraitjRequiredField
  public abstract Iterable<T> getIterable();
  
  public abstract void setIterable(final Iterable<T> iterable);
  
  @XtraitjDefinedMethod
  public abstract T head();
  
  @XtraitjDefinedMethod
  public abstract T last();
  
  @XtraitjDefinedMethod
  public abstract String join(final CharSequence separator);
  
  @XtraitjDefinedMethod
  public abstract <R extends Object> List<R> mapToList(final Function1<? super T, ? extends R> mapper);
  
  @XtraitjDefinedMethod
  public abstract <R extends Object> Iterable<R> map(final Function1<? super T, ? extends R> mapper);
}
