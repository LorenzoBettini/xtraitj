package xtraitj.example.examples.extensions.traits;

import java.util.Iterator;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.example.examples.extensions.traits.TTransformerIterator_TIterator_0_Adapter;

@SuppressWarnings("all")
public interface TTransformerIterator<T, R> extends TTransformerIterator_TIterator_0_Adapter<T,R> {
  public abstract Function1<? super T,? extends R> getFunction();
  
  public abstract void setFunction(final Function1<? super T,? extends R> function);
  
  public abstract R next();
  
  public abstract boolean hasNext();
  
  public abstract T origNext();
  
  public abstract void remove();
  
  public abstract Iterator<T> getIterator();
  
  public abstract void setIterator(final Iterator<T> iterator);
}
