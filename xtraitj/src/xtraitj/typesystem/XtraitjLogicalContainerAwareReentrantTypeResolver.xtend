/**
 * 
 */
package xtraitj.typesystem;

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmAnnotationTarget
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.xbase.typesystem.internal.LogicalContainerAwareReentrantTypeResolver
import xtraitj.util.XtraitjAnnotatedElementHelper

/**
 * Customized to avoid a problem with Xtext 2.7.3, see below.
 * 
 * @author Lorenzo Bettini
 *
 */
public class XtraitjLogicalContainerAwareReentrantTypeResolver extends
		LogicalContainerAwareReentrantTypeResolver {

	@Inject extension XtraitjAnnotatedElementHelper
	
	override protected void recordAnnotationExpressions(JvmAnnotationTarget annotable) {
		/*
		 * In Xtext 2.7.3 we get
		 * 
		 * IllegalStateException("Cannot root object twice: " + e);
		 * 
		 * because the same XAnnotation is associated with the inferred trait interface
		 * and the inferred trait class.
		 * 
		 * Failing test:
		 * 
		 * xtraitj.tests.XtraitjAnnotationsCompilerTest.testAnnotatedMethods()
		 * 
		 * Forum reference: https://www.eclipse.org/forums/index.php/t/864890/
		 */
		if (annotable instanceof JvmOperation) {
			val containerType = annotable.declaringType
			if (containerType.annotatedTraitClass) {
				return
			}
		}
		
		super.recordAnnotationExpressions(annotable)
	}
}
