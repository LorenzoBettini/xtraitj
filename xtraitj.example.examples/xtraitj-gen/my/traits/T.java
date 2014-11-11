package my.traits;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T {
  @XtraitjRequiredField
  public abstract String getS();
  
  public abstract void setS(final String s);
  
  @XtraitjRequiredField
  public abstract List<? extends String> getStrings();
  
  public abstract void setStrings(final List<? extends String> strings);
  
  @XtraitjDefinedMethod
  public abstract String m();
}
