/*
 * generated by Xtext
 */
package xtraitj;

import org.eclipse.xtext.generator.IOutputConfigurationProvider;
import org.eclipse.xtext.scoping.IScopeProvider;
import org.eclipse.xtext.xbase.imports.IImportsConfiguration;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociator;
import org.eclipse.xtext.xbase.scoping.batch.XbaseBatchScopeProvider;

import xtraitj.generator.TraitJOutputConfigurationProvider;
import xtraitj.imports.XtraitjImportsConfiguration;
import xtraitj.jvmmodel.TraitJJvmModelAssociator;
import xtraitj.scoping.TraitJXbaseBatchScopeProvider;
import xtraitj.scoping.TraitJXbaseScopeProvider;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class XtraitjRuntimeModule extends xtraitj.AbstractXtraitjRuntimeModule {

	@Override
	public Class<? extends XbaseBatchScopeProvider> bindXbaseBatchScopeProvider() {
		return TraitJXbaseBatchScopeProvider.class;
	}
	
	@Override
	public Class<? extends IScopeProvider> bindIScopeProvider() {
		return TraitJXbaseScopeProvider.class;
	}

	public Class<? extends IOutputConfigurationProvider> bindIOutputConfigurationProvider() {
        return TraitJOutputConfigurationProvider.class;
    }
	
	public Class<? extends IJvmModelAssociator> bindIJvmModelAssociator() {
		return TraitJJvmModelAssociator.class;
	}

	public Class<? extends IJvmModelAssociations> bindIJvmModelAssociations() {
		return TraitJJvmModelAssociator.class;
	}

	public Class<? extends IImportsConfiguration> bindIImportsConfiguration() {
		return XtraitjImportsConfiguration.class;
	}
}
