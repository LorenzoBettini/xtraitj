package my.traits;

import java.util.List;
import main.CInterface;
import my.traits.traits.T;
import my.traits.traits.impl.TImpl;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.StringExtensions;

@SuppressWarnings("all")
public class C implements CInterface, T {
  private String s = "aString";
  
  public String getS() {
    return this.s;
  }
  
  public void setS(final String s) {
    this.s = s;
  }
  
  private List<? extends String> strings = null;
  
  public List<? extends String> getStrings() {
    return this.strings;
  }
  
  public void setStrings(final List<? extends String> strings) {
    this.strings = strings;
  }
  
  public C() {
  }
  
  public C(final Iterable<String> iterable) {
    final Function1<String, String> _function = new Function1<String, String>() {
      public String apply(final String it) {
        return StringExtensions.toFirstUpper(it);
      }
    };
    Iterable<String> _map = IterableExtensions.<String, String>map(iterable, _function);
    List<String> _list = IterableExtensions.<String>toList(_map);
    this.strings = _list;
  }
  
  private TImpl _T = new TImpl(this);
  
  public String m() {
    return _T._m();
  }
}
