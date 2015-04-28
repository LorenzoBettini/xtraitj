/**
 * 
 */
package xtraitj.runtime.lib.annotation;

import static java.lang.annotation.ElementType.TYPE;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author Lorenzo Bettini
 * 
 * Annotates a Java interface that corresponds to an Xtraitj trait
 *
 */
@Target({TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface XtraitjTraitInterface {

}
