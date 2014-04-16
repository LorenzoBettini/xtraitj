package my.traits.traits;

import java.util.List;

@SuppressWarnings("all")
public interface T {
  public abstract String getS();
  
  public abstract void setS(final String s);
  
  public abstract List<? extends String> getStrings();
  
  public abstract void setStrings(final List<? extends String> strings);
  
  public abstract String m();
}
