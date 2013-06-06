package xtraitj.typing;

import com.google.common.base.Objects;
import com.google.inject.Inject;
import org.eclipse.xtext.common.types.JvmType;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.common.types.util.Primitives;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.typesystem.legacy.StandardTypeReferenceOwner;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;
import org.eclipse.xtext.xbase.typesystem.references.OwnedConverter;
import org.eclipse.xtext.xbase.typesystem.util.CommonTypeComputationServices;

@SuppressWarnings("all")
public class TraitJTypingUtil {
  @Inject
  private CommonTypeComputationServices services;
  
  @Inject
  @Extension
  private Primitives _primitives;
  
  public boolean sameType(final JvmTypeReference t1, final JvmTypeReference t2) {
    boolean _or = false;
    boolean _equals = Objects.equal(t1, null);
    if (_equals) {
      _or = true;
    } else {
      boolean _equals_1 = Objects.equal(t2, null);
      _or = (_equals || _equals_1);
    }
    if (_or) {
      return false;
    }
    boolean _or_1 = false;
    boolean _isPrimitive = this._primitives.isPrimitive(t1);
    if (_isPrimitive) {
      _or_1 = true;
    } else {
      boolean _isPrimitive_1 = this._primitives.isPrimitive(t2);
      _or_1 = (_isPrimitive || _isPrimitive_1);
    }
    if (_or_1) {
      JvmType _type = t1.getType();
      JvmType _type_1 = t2.getType();
      return Objects.equal(_type, _type_1);
    }
    final LightweightTypeReference type1 = this.toLightweightTypeReference(t1);
    final LightweightTypeReference type2 = this.toLightweightTypeReference(t2);
    boolean _and = false;
    boolean _isAssignableFrom = type1.isAssignableFrom(type2);
    if (!_isAssignableFrom) {
      _and = false;
    } else {
      boolean _isAssignableFrom_1 = type2.isAssignableFrom(type1);
      _and = (_isAssignableFrom && _isAssignableFrom_1);
    }
    return _and;
  }
  
  public boolean isSubtype(final JvmTypeReference t1, final JvmTypeReference t2) {
    boolean _xblockexpression = false;
    {
      boolean _or = false;
      boolean _equals = Objects.equal(t1, null);
      if (_equals) {
        _or = true;
      } else {
        boolean _equals_1 = Objects.equal(t2, null);
        _or = (_equals || _equals_1);
      }
      if (_or) {
        return false;
      }
      boolean _or_1 = false;
      boolean _isPrimitive = this._primitives.isPrimitive(t1);
      if (_isPrimitive) {
        _or_1 = true;
      } else {
        boolean _isPrimitive_1 = this._primitives.isPrimitive(t2);
        _or_1 = (_isPrimitive || _isPrimitive_1);
      }
      if (_or_1) {
        JvmType _type = t1.getType();
        JvmType _type_1 = t2.getType();
        return Objects.equal(_type, _type_1);
      }
      final LightweightTypeReference type1 = this.toLightweightTypeReference(t1);
      final LightweightTypeReference type2 = this.toLightweightTypeReference(t2);
      boolean _isAssignableFrom = type2.isAssignableFrom(type1);
      _xblockexpression = (_isAssignableFrom);
    }
    return _xblockexpression;
  }
  
  public LightweightTypeReference toLightweightTypeReference(final JvmTypeReference typeRef) {
    LightweightTypeReference _xblockexpression = null;
    {
      StandardTypeReferenceOwner _standardTypeReferenceOwner = new StandardTypeReferenceOwner(this.services, typeRef);
      OwnedConverter _ownedConverter = new OwnedConverter(_standardTypeReferenceOwner);
      final OwnedConverter converter = _ownedConverter;
      LightweightTypeReference _lightweightReference = converter.toLightweightReference(typeRef);
      _xblockexpression = (_lightweightReference);
    }
    return _xblockexpression;
  }
}
