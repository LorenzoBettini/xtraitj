package xtraitj.ui.outline;

import org.eclipse.swt.graphics.Image;
import org.eclipse.xtext.ui.editor.outline.IOutlineNode;
import org.eclipse.xtext.ui.editor.outline.impl.AbstractOutlineNode;

@SuppressWarnings("all")
public class TraitJRequirementsNode extends AbstractOutlineNode {
  protected TraitJRequirementsNode(final IOutlineNode parent, final Image image) {
    super(parent, image, "requirements", false);
  }
}
