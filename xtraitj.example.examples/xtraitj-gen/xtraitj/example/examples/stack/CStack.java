package xtraitj.example.examples.stack;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.traits.TStack;
import xtraitj.example.examples.stack.traits.impl.TStackImpl;

@SuppressWarnings("all")
public class CStack<T> implements IStack<T>, TStack<T> {
  private List<T> collection = new ArrayList<T>();
  
  public List<T> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<T> collection) {
    this.collection = collection;
  }
  
  public CStack() {
  }
  
  public CStack(final Collection<T> c) {
    this.collection.addAll(c);
  }
  
  private TStackImpl<T> _TStack = new TStackImpl(this);
  
  public boolean isEmpty() {
    return _TStack._isEmpty();
  }
  
  public void push(final T o) {
    _TStack._push(o);
  }
  
  public T pop() {
    return _TStack._pop();
  }
}
