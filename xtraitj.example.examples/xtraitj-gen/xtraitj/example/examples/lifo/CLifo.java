package xtraitj.example.examples.lifo;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import xtraitj.example.examples.lifo.ILifo;
import xtraitj.example.examples.lifo.traits.TLifo;
import xtraitj.example.examples.lifo.traits.impl.TLifoImpl;

@SuppressWarnings("all")
public class CLifo implements ILifo, TLifo {
  private List<Object> collection = new ArrayList<Object>();
  
  public List<Object> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<Object> collection) {
    this.collection = collection;
  }
  
  public CLifo() {
  }
  
  public CLifo(final Collection<Object> c) {
    this.collection.addAll(c);
  }
  
  private TLifoImpl _TLifo = new TLifoImpl(this);
  
  public void pop() {
    _TLifo._pop();
  }
  
  public Object top() {
    return _TLifo._top();
  }
  
  public boolean isEmpty() {
    return _TLifo._isEmpty();
  }
  
  public void push(final Object o) {
    _TLifo._push(o);
  }
}
