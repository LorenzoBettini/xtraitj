package xtraitj.jvmmodel;

import com.google.common.base.Objects;
import com.google.inject.Singleton;
import java.util.Map;
import java.util.Set;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import xtraitj.xtraitj.TJDeclaration;
import xtraitj.xtraitj.TJTraitReference;

@Singleton
@SuppressWarnings("all")
public class TraitJJvmModelAssociator extends JvmModelAssociator {
  public Set<EObject> getSourceElements(final EObject jvmElement) {
    final Set<EObject> result = super.getSourceElements(jvmElement);
    boolean _isEmpty = result.isEmpty();
    boolean _not = (!_isEmpty);
    if (_not) {
      return result;
    }
    try {
      EObject _eContainer = jvmElement.eContainer();
      Set<EObject> _sourceElements = super.getSourceElements(_eContainer);
      final Function1<EObject,Boolean> _function = new Function1<EObject,Boolean>() {
        public Boolean apply(final EObject it) {
          boolean _or = false;
          if ((it instanceof TJTraitReference)) {
            _or = true;
          } else {
            _or = ((it instanceof TJTraitReference) || (it instanceof TJDeclaration));
          }
          return Boolean.valueOf(_or);
        }
      };
      final Iterable<EObject> decl = IterableExtensions.<EObject>filter(_sourceElements, _function);
      boolean _isEmpty_1 = IterableExtensions.isEmpty(decl);
      boolean _not_1 = (!_isEmpty_1);
      if (_not_1) {
        Resource _eResource = jvmElement.eResource();
        ResourceSet _resourceSet = _eResource.getResourceSet();
        EList<Resource> _resources = _resourceSet.getResources();
        for (final Resource r : _resources) {
          {
            final Map<EObject,Set<EObject>> map = this.targetToSourceMap(r);
            final Set<EObject> sources = map.get(jvmElement);
            boolean _notEquals = (!Objects.equal(sources, null));
            if (_notEquals) {
              return sources;
            }
          }
        }
      }
    } catch (final Throwable _t) {
      if (_t instanceof Throwable) {
        final Throwable t = (Throwable)_t;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return result;
  }
}
