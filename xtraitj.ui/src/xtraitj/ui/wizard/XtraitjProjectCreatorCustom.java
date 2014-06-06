package xtraitj.ui.wizard;

import java.util.List;

import xtraitj.generator.XtraitjOutputConfigurationProvider;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;

public class XtraitjProjectCreatorCustom extends XtraitjProjectCreator {

	@Override
	protected List<String> getAllFolders() {
		return ImmutableList.of(SRC_ROOT,
				XtraitjOutputConfigurationProvider.TRAITJ_GEN);
	}
	
	@Override
	protected List<String> getRequiredBundles() {
		return Lists.newArrayList(
				"org.eclipse.core.runtime",
				"org.eclipse.ui",
				"xtraitj.runtime.requirements");
	}
}
