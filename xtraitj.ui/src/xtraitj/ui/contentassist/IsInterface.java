package xtraitj.ui.contentassist;

import org.eclipse.jdt.core.Flags;
import org.eclipse.xtext.common.types.xtext.ui.TypeMatchFilters.IsPublic;

public class IsInterface extends IsPublic {
	@Override
	public boolean accept(int modifiers, char[] packageName, char[] simpleTypeName, char[][] enclosingTypeNames,
			String path) {
		return 
				super.accept(modifiers, packageName, simpleTypeName, enclosingTypeNames, path) &&
				Flags.isInterface(modifiers);
	}
}
