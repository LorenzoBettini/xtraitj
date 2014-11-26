/*
 * generated by Xtext
 */
package xtraitj;

import org.eclipse.xtext.generator.IOutputConfigurationProvider;
import org.eclipse.xtext.scoping.IScopeProvider;
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider;
import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociator;
import org.eclipse.xtext.xbase.scoping.batch.XbaseBatchScopeProvider;
import org.eclipse.xtext.xbase.typesystem.conformance.TypeConformanceComputer;
import org.eclipse.xtext.xbase.typesystem.internal.DefaultReentrantTypeResolver;
import org.eclipse.xtext.xbase.typesystem.override.OverrideHelper;

import xtraitj.compiler.XtraitjTypeReferenceSerializer;
import xtraitj.generator.XtraitjOutputConfigurationProvider;
import xtraitj.jvmmodel.XtraitjJvmModelAssociator;
import xtraitj.scoping.XtraitjImportedNamespaceScopeProvider;
import xtraitj.scoping.XtraitjXbaseBatchScopeProvider;
import xtraitj.typesystem.XtraitjLogicalContainerAwareReentrantTypeResolver;
import xtraitj.typesystem.conformance.XtraitjTypeConformanceComputer;
import xtraitj.typesystem.override.XtraitjOverrideHelper;
import xtraitj.validation.XtraitjJvmTypeReferencesValidator;

import com.google.inject.Binder;
import com.google.inject.name.Names;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class XtraitjRuntimeModule extends xtraitj.AbstractXtraitjRuntimeModule {

	@Override
	public void configure(Binder binder) {
		super.configure(binder);
		binder.bind(TypeConformanceComputer.class).to(
				XtraitjTypeConformanceComputer.class);
	}
	
	@Override
	public Class<? extends XbaseBatchScopeProvider> bindXbaseBatchScopeProvider() {
		return XtraitjXbaseBatchScopeProvider.class;
	}
	
	public Class<? extends IOutputConfigurationProvider> bindIOutputConfigurationProvider() {
        return XtraitjOutputConfigurationProvider.class;
    }
	
	public Class<? extends IJvmModelAssociator> bindIJvmModelAssociator() {
		return XtraitjJvmModelAssociator.class;
	}

	public Class<? extends IJvmModelAssociations> bindIJvmModelAssociations() {
		return XtraitjJvmModelAssociator.class;
	}

	public Class<? extends TypeReferenceSerializer> bindTypeReferenceSerializer() {
		return XtraitjTypeReferenceSerializer.class;
	}

	@Override
	public void configureIScopeProviderDelegate(Binder binder) {
		binder.bind(IScopeProvider.class).annotatedWith(Names.named(AbstractDeclarativeScopeProvider.NAMED_DELEGATE))
				.to(XtraitjImportedNamespaceScopeProvider.class);
	}
	
//	@Override
//	public Class<? extends IGenerator> bindIGenerator() {
//		return XtraitjJvmModelGenerator.class;
//	}
	
//	public Class<? extends ErrorSafeExtensions> bindErrorSafeExtensions() {
//		return XtraitjErrorSafeExtensions.class;
//	}
	
	public Class<? extends OverrideHelper> bindOverrideHelper() {
		return XtraitjOverrideHelper.class;
	}

	@Override
	public Class<? extends DefaultReentrantTypeResolver> bindDefaultReentrantTypeResolver() {
		return XtraitjLogicalContainerAwareReentrantTypeResolver.class;
	}

	@Override
	@org.eclipse.xtext.service.SingletonBinding(eager=true)	public Class<? extends org.eclipse.xtext.xbase.validation.JvmTypeReferencesValidator> bindJvmTypeReferencesValidator() {
		return XtraitjJvmTypeReferencesValidator.class;
	}
}
