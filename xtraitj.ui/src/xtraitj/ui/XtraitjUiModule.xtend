/*
 * generated by Xtext
 */
package xtraitj.ui

import org.eclipse.jface.viewers.ILabelProvider
import org.eclipse.ui.plugin.AbstractUIPlugin
import org.eclipse.xtext.common.types.xtext.ui.TypeAwareHyperlinkHelper
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkHelper
import org.eclipse.xtext.ui.wizard.IProjectCreator
import xtraitj.ui.labeling.XtraitjLabelProvider
import xtraitj.ui.wizard.XtraitjProjectCreatorCustom

/** 
 * Use this class to register components to be used within the IDE.
 */
class XtraitjUiModule extends AbstractXtraitjUiModule {
	new(AbstractUIPlugin plugin) {
		super(plugin)
	}

	override Class<? extends IProjectCreator> bindIProjectCreator() {
		return XtraitjProjectCreatorCustom
	}

	override Class<? extends ILabelProvider> bindILabelProvider() {
		return XtraitjLabelProvider
	}

	override Class<? extends IHyperlinkHelper> bindIHyperlinkHelper() {
		return TypeAwareHyperlinkHelper
	}
}