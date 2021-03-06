/*
 * generated by Xtext
 */
package xtraitj

import com.google.inject.Binder
import com.google.inject.name.Names
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import org.eclipse.xtext.service.SingletonBinding
import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer
import org.eclipse.xtext.xbase.typesystem.conformance.TypeConformanceComputer
import org.eclipse.xtext.xbase.typesystem.^override.OverrideHelper
import org.eclipse.xtext.xbase.validation.JvmTypeReferencesValidator
import xtraitj.compiler.XtraitjTypeReferenceSerializer
import xtraitj.generator.XtraitjOutputConfigurationProvider
import xtraitj.scoping.XtraitjImportedNamespaceScopeProvider
import xtraitj.typesystem.conformance.XtraitjTypeConformanceComputer
import xtraitj.typesystem.^override.XtraitjOverrideHelper
import xtraitj.validation.XtraitjJvmTypeReferencesValidator

/** 
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class XtraitjRuntimeModule extends AbstractXtraitjRuntimeModule {
	override void configure(Binder binder) {
		super.configure(binder)
		binder.bind(TypeConformanceComputer).to(XtraitjTypeConformanceComputer)
	}

	def Class<? extends IOutputConfigurationProvider> bindIOutputConfigurationProvider() {
		return XtraitjOutputConfigurationProvider
	}

	def Class<? extends TypeReferenceSerializer> bindTypeReferenceSerializer() {
		return XtraitjTypeReferenceSerializer
	}

	override void configureIScopeProviderDelegate(Binder binder) {
		binder.bind(IScopeProvider).annotatedWith(Names.named(AbstractDeclarativeScopeProvider.NAMED_DELEGATE)).to(
			XtraitjImportedNamespaceScopeProvider)
	}

	def Class<? extends OverrideHelper> bindOverrideHelper() {
		return XtraitjOverrideHelper
	}

	@SingletonBinding(eager=true) override Class<? extends JvmTypeReferencesValidator> bindJvmTypeReferencesValidator() {
		return XtraitjJvmTypeReferencesValidator
	}
}
