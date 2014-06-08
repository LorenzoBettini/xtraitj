package xtraitj.example.examples.extensions;

import java.util.Iterator;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.example.examples.extensions.traits.TTransformerIterator;
import xtraitj.example.examples.extensions.traits.impl.TTransformerIteratorImpl;

@SuppressWarnings("all")
public class TransformerIterator<T, R> implements Iterator<R>, TTransformerIterator<T, R> {
  private Iterator<T> iterator;
  
  public Iterator<T> getIterator() {
    return this.iterator;
  }
  
  public void setIterator(final Iterator<T> iterator) {
    this.iterator = iterator;
  }
  
  private Function1<? super T, ? extends R> function;
  
  public Function1<? super T, ? extends R> getFunction() {
    return this.function;
  }
  
  public void setFunction(final Function1<? super T, ? extends R> function) {
    this.function = function;
  }
  
  public TransformerIterator(final Iterator<T> iterator, final Function1<? super T, ? extends R> function) {
    this.iterator = iterator;
    this.function = function;
  }
  
  private TTransformerIteratorImpl<T, R> _TTransformerIterator = new TTransformerIteratorImpl(this);
  
  public R next() {
    return _TTransformerIterator._next();
  }
  
  public boolean hasNext() {
    return _TTransformerIterator._hasNext();
  }
  
  public T origNext() {
    return _TTransformerIterator._origNext();
  }
  
  public void remove() {
    _TTransformerIterator._remove();
  }
}
