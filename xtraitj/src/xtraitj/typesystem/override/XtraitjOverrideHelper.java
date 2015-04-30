/**
 * 
 */
package xtraitj.typesystem.override;

import org.eclipse.xtext.xbase.typesystem.override.OverrideHelper;
import org.eclipse.xtext.xbase.typesystem.override.OverrideTester;
import org.eclipse.xtext.xbase.typesystem.override.ResolvedFeatures;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;

import xtraitj.util.XtraitjAnnotatedElementHelper;

import com.google.inject.Inject;
import com.google.inject.Singleton;

/**
 * Uses a custom {@link ResolvedOperations} implementation, {@link DefinedMethodAwareResolvedOperations}
 * that gives precedence to defined methods over required methods. 
 * 
 * @author Lorenzo Bettini
 *
 */
@Singleton
public class XtraitjOverrideHelper extends OverrideHelper {

	@Inject
	private OverrideTester overrideTester;
	
	@Inject
	private XtraitjAnnotatedElementHelper annotatedElementHelper;
	
	@Override
	public ResolvedFeatures getResolvedFeatures(
			LightweightTypeReference contextType) {
		return new DefinedMethodAwareResolvedOperations(contextType, overrideTester, annotatedElementHelper);
	}
}
