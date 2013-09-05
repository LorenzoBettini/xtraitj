/**
 * generated by Xtext
 */
package xtraitj.formatting;

import com.google.inject.Inject;
import java.util.List;
import org.eclipse.xtext.Keyword;
import org.eclipse.xtext.ParserRule;
import org.eclipse.xtext.TerminalRule;
import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter;
import org.eclipse.xtext.formatting.impl.FormattingConfig;
import org.eclipse.xtext.formatting.impl.FormattingConfig.LinewrapLocator;
import org.eclipse.xtext.util.Pair;
import org.eclipse.xtext.xbase.lib.Extension;
import xtraitj.services.XtraitjGrammarAccess;

/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation/latest/xtext.html#formatting
 * on how and when to use it
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
@SuppressWarnings("all")
public class XtraitjFormatter extends AbstractDeclarativeFormatter {
  @Inject
  @Extension
  private XtraitjGrammarAccess f;
  
  protected void configureFormatting(final FormattingConfig c) {
    c.setAutoLinewrap(120);
    LinewrapLocator _setLinewrap = c.setLinewrap(1, 2, 3);
    ParserRule _tJDeclarationRule = this.f.getTJDeclarationRule();
    _setLinewrap.around(_tJDeclarationRule);
    LinewrapLocator _setLinewrap_1 = c.setLinewrap(1, 1, 2);
    ParserRule _tJFieldRule = this.f.getTJFieldRule();
    _setLinewrap_1.around(_tJFieldRule);
    LinewrapLocator _setLinewrap_2 = c.setLinewrap(1, 1, 2);
    ParserRule _tJMemberRule = this.f.getTJMemberRule();
    _setLinewrap_2.around(_tJMemberRule);
    final List<Pair<Keyword,Keyword>> pairs = this.f.findKeywordPairs("{", "}");
    for (final Pair<Keyword,Keyword> pair : pairs) {
      Keyword _first = pair.getFirst();
      Keyword _second = pair.getSecond();
      c.setIndentation(_first, _second);
    }
    LinewrapLocator _setLinewrap_3 = c.setLinewrap(0, 1, 2);
    TerminalRule _sL_COMMENTRule = this.f.getSL_COMMENTRule();
    _setLinewrap_3.before(_sL_COMMENTRule);
    LinewrapLocator _setLinewrap_4 = c.setLinewrap(0, 1, 2);
    TerminalRule _mL_COMMENTRule = this.f.getML_COMMENTRule();
    _setLinewrap_4.before(_mL_COMMENTRule);
    LinewrapLocator _setLinewrap_5 = c.setLinewrap(0, 1, 1);
    TerminalRule _mL_COMMENTRule_1 = this.f.getML_COMMENTRule();
    _setLinewrap_5.after(_mL_COMMENTRule_1);
  }
}
