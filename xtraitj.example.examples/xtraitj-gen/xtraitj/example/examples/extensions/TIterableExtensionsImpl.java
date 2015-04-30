package xtraitj.example.examples.extensions;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.example.examples.extensions.TIterableExtensions;
import xtraitj.example.examples.extensions.TransformerIterator;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TIterableExtensionsImpl<T extends Object> implements TIterableExtensions<T> {
  private TIterableExtensions<T> _delegate;
  
  public TIterableExtensionsImpl(final TIterableExtensions<T> delegate) {
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
  public T head() {
    return _delegate.head();
  }
  
  public T _head() {
    Iterable<T> _iterable = this.getIterable();
    final Iterator<T> iterator = _iterable.iterator();
    boolean _hasNext = iterator.hasNext();
    if (_hasNext) {
      return iterator.next();
    }
    return null;
  }
  
  @XtraitjDefinedMethod
  public T last() {
    return _delegate.last();
  }
  
  public T _last() {
    Iterable<T> _iterable = this.getIterable();
    if ((_iterable instanceof List<?>)) {
      Iterable<T> _iterable_1 = this.getIterable();
      final List<T> list = ((List<T>) _iterable_1);
      boolean _isEmpty = list.isEmpty();
      if (_isEmpty) {
        return null;
      }
      int _size = list.size();
      int _minus = (_size - 1);
      return list.get(_minus);
    } else {
      Iterable<T> _iterable_2 = this.getIterable();
      if ((_iterable_2 instanceof SortedSet<?>)) {
        Iterable<T> _iterable_3 = this.getIterable();
        final SortedSet<T> sortedSet = ((SortedSet<T>) _iterable_3);
        boolean _isEmpty_1 = sortedSet.isEmpty();
        if (_isEmpty_1) {
          return null;
        }
        return sortedSet.last();
      } else {
        T result = null;
        Iterable<T> _iterable_4 = this.getIterable();
        for (final T t : _iterable_4) {
          result = t;
        }
        return result;
      }
    }
  }
  
  @XtraitjDefinedMethod
  public String join(final CharSequence separator) {
    return _delegate.join(separator);
  }
  
  public String _join(final CharSequence separator) {
    final StringBuilder result = new StringBuilder();
    Iterable<T> _iterable = this.getIterable();
    final Iterator<T> iterator = _iterable.iterator();
    while (iterator.hasNext()) {
      {
        final T next = iterator.next();
        final String elementToString = next.toString();
        result.append(elementToString);
        boolean _hasNext = iterator.hasNext();
        if (_hasNext) {
          result.append(separator);
        }
      }
    }
    return result.toString();
  }
  
  @XtraitjDefinedMethod
  public <R extends Object> List<R> mapToList(final Function1<? super T, ? extends R> mapper) {
    return _delegate.mapToList(mapper);
  }
  
  public <R extends Object> List<R> _mapToList(final Function1<? super T, ? extends R> mapper) {
    final ArrayList<R> result = new ArrayList<R>();
    Iterable<T> _iterable = this.getIterable();
    for (final T e : _iterable) {
      R _apply = mapper.apply(e);
      result.add(_apply);
    }
    return result;
  }
  
  @XtraitjDefinedMethod
  public <R extends Object> Iterable<R> map(final Function1<? super T, ? extends R> mapper) {
    return _delegate.map(mapper);
  }
  
  public <R extends Object> Iterable<R> _map(final Function1<? super T, ? extends R> mapper) {
    final Iterable<R> _function = new Iterable<R>() {
      @Override
      public Iterator<R> iterator() {
        Iterable<T> _iterable = TIterableExtensionsImpl.this.getIterable();
        Iterator<T> _iterator = _iterable.iterator();
        return new TransformerIterator<T, R>(_iterator, mapper);
      }
    };
    return _function;
  }
}
