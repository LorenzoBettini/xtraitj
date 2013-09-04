package xtraitj.generator;

import java.util.Set;
import org.eclipse.xtext.generator.OutputConfiguration;
import org.eclipse.xtext.generator.OutputConfigurationProvider;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;

@SuppressWarnings("all")
public class TraitJOutputConfigurationProvider extends OutputConfigurationProvider {
  public final static String TRAITJ_GEN = "./xtraitj-gen";
  
  public Set<OutputConfiguration> getOutputConfigurations() {
    Set<OutputConfiguration> _outputConfigurations = super.getOutputConfigurations();
    final Procedure1<Set<OutputConfiguration>> _function = new Procedure1<Set<OutputConfiguration>>() {
      public void apply(final Set<OutputConfiguration> it) {
        OutputConfiguration _head = IterableExtensions.<OutputConfiguration>head(it);
        _head.setOutputDirectory(TraitJOutputConfigurationProvider.TRAITJ_GEN);
      }
    };
    Set<OutputConfiguration> _doubleArrow = ObjectExtensions.<Set<OutputConfiguration>>operator_doubleArrow(_outputConfigurations, _function);
    return _doubleArrow;
  }
}
