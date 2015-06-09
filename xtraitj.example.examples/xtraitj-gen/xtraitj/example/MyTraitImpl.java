package xtraitj.example;

import xtraitj.example.MyTrait;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class MyTraitImpl implements MyTrait {
  private MyTrait _delegate;
  
  public MyTraitImpl(final MyTrait delegate) {
    this._delegate = delegate;
  }
}
