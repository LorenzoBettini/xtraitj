/**
 * 
 */
package xtraitj.runtime.lib.annotation;

import static java.lang.annotation.ElementType.METHOD;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author Lorenzo Bettini
 * 
 * Annotates a Java setter method that corresponds to an Xtraitj required field
 *
 */
@Target({METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface XtraitjRequiredFieldSetter {

}
