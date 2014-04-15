package xtraitj.ui.outline

import org.eclipse.xtext.ui.editor.outline.impl.AbstractOutlineNode
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.swt.graphics.Image

class XtraitjProvidesNode extends AbstractOutlineNode {
	
	protected new(IOutlineNode parent, Image image) {
		super(parent, image, "provides", false)
	}
	
}