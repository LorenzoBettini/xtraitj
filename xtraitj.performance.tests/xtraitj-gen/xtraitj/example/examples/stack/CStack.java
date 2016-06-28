package xtraitj.example.examples.stack;

import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.TStack;
import xtraitj.example.examples.stack.TStackImpl;

@SuppressWarnings("all")
public class CStack<T extends Object> implements IStack<T>, TStack<T> {
  private List<T> collection = new LinkedList<T>();
  
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
