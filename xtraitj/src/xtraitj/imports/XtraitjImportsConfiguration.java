package xtraitj.imports;

import java.util.Iterator;
import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.AbstractRule;
import org.eclipse.xtext.GrammarUtil;
import org.eclipse.xtext.nodemodel.ICompositeNode;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.xbase.imports.DefaultImportsConfiguration;

public class XtraitjImportsConfiguration extends DefaultImportsConfiguration {

	@Override
	protected INode findPreviousNode(ICompositeNode node, List<EObject> pathToImportSection) {
		if(pathToImportSection.isEmpty() || node.getGrammarElement() != pathToImportSection.get(0)) 
			return null;
		INode currentNode = null;
		ICompositeNode currentParentNode = node;
		int currentDepth = 0;
		OUTER: while(currentDepth < pathToImportSection.size() - 1) {
			++currentDepth;
			EObject expectedRuleCall = pathToImportSection.get(currentDepth);
			AbstractRule ruleInGrammar = GrammarUtil.containingRule(expectedRuleCall);
			for(INode childNode: currentParentNode.getChildren()) {
				EObject elementInNode = childNode.getGrammarElement();
				if(elementInNode != null) {
					for(Iterator<EObject> i = ruleInGrammar.eAllContents(); i.hasNext();) {
						EObject nextInGrammar = i.next();
						// check for type of childNode, otherwise we get a ClassCastException
						// see https://bugs.eclipse.org/bugs/show_bug.cgi?id=407390
						if(nextInGrammar == expectedRuleCall && childNode instanceof ICompositeNode) {
							currentParentNode = (ICompositeNode) childNode;
							continue OUTER;
						}
						if(nextInGrammar == elementInNode) {
							break;
						}
					}
				}
				currentNode = childNode;
			}
		}
		return currentNode;
	}
}
