package xtraitj.example.examples.stack;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.TStack;
import xtraitj.example.examples.stack.TStackImpl;

@SuppressWarnings("all")
public class CStackOfSetsOfComparable<T extends Comparable<T>> implements IStack<Set<T>>, TStack<Set<T>> {
  private List<Set<T>> collection = new ArrayList<Set<T>>();
  
  public List<Set<T>> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<Set<T>> collection) {
    this.collection = collection;
  }
  
  private TStackImpl<Set<T>> _TStack = new TStackImpl(this);
  
  public boolean isEmpty() {
    return _TStack._isEmpty();
  }
  
  public void push(final Set<T> o) {
    _TStack._push(o);
  }
  
  public Set<T> pop() {
    return _TStack._pop();
  }
}
