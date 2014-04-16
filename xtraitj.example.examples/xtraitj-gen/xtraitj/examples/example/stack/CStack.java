package xtraitj.examples.example.stack;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import xtraitj.example.examples.stack.IStack;
import xtraitj.examples.example.stack.traits.TStack;
import xtraitj.examples.example.stack.traits.impl.TStackImpl;

@SuppressWarnings("all")
public class CStack implements IStack, TStack {
  private List<Object> collection = new ArrayList<Object>();
  
  public List<Object> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<Object> collection) {
    this.collection = collection;
  }
  
  public CStack() {
  }
  
  public CStack(final Collection<Object> c) {
    this.collection.addAll(c);
  }
  
  private TStackImpl _TStack = new TStackImpl(this);
  
  public boolean isEmpty() {
    return _TStack._isEmpty();
  }
  
  public void push(final Object o) {
    _TStack._push(o);
  }
  
  public Object pop() {
    return _TStack._pop();
  }
}
