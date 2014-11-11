package xtrait.example.examples.util;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

/**
 * A simple trait that negates a boolean operation
 */
@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TNegate {
  @XtraitjDefinedMethod
  public abstract boolean notOp();
  
  @XtraitjRequiredMethod
  public abstract boolean op();
}
