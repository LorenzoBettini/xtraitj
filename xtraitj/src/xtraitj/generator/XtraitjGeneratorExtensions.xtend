package xtraitj.generator

import com.google.inject.Inject
import com.google.inject.Singleton
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmAnnotationTarget
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xtype.XFunctionTypeRef
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod
import xtraitj.runtime.lib.annotation.XtraitjRequiredField
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod
import xtraitj.runtime.lib.annotation.XtraitjTraitClass
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.XtraitjModelUtil.*
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJRequiredMethod
import xtraitj.xtraitj.TJMethod

@Singleton
class XtraitjGeneratorExtensions {
	
	@Inject extension IQualifiedNameProvider
	@Inject extension JvmTypesBuilder

	def traitInterfaceName(String n) {
   		n + "Interface"
//   		n.skipLast(1).append("traits").
//   			append(n.lastSegment).toString// + "Interface"
   	}

	def traitInterfaceName(TJTrait t) {
   		t.fullyQualifiedName.toString.traitInterfaceName
//   		n.skipLast(1).append("traits").
//   			append(n.lastSegment).toString// + "Interface"
   	}

	def traitClassName(TJTrait t) {
   		val n = t.fullyQualifiedName
   		n. // skipLast(1). /* append("traits").append("impl"). */ 
   			/* append(n.lastSegment). */ 
   			toString // + "Impl"
   	}

   	def traitExpressionInterfaceName(TJTraitReference t) {
   		val n = t.containingDeclaration.fullyQualifiedName
   		n. // skipLast(1). append("traits").
   			append(t.adapterName).toString + "Interface"
   	}

   	def traitExpressionClassName(TJTraitReference t) {
   		val n = t.containingDeclaration.fullyQualifiedName
   		n. // skipLast(1). /* append("traits").append("impl").*/
   			append(t.adapterName).toString
   	}

	def adapterName(TJTraitReference t) {
		t.syntheticName + "_Adapter"
	}

	def syntheticName(TJTraitReference t) {
		t.containingDeclaration.name + "_" +
		t.trait.simpleName + "_" +
		t.containingDeclaration.traitOperationExpressions.indexOf(t)
	}

	def delegateFieldName() {
		"_delegate"
	}

	def traitFieldName(TJTraitReference e) {
		if (e.operations.empty)
			return "_" + e.trait.traitFieldName
		return "_" + e.syntheticName
	}

	def traitFieldNameForOperations(TJTraitReference e) {
		return e.trait.traitFieldName + "_" +
				e.containingDeclaration.traitReferences.indexOf(e)
	}

	def traitFieldName(TJTrait t) {
		"_" + t.name
	}

	def traitFieldName(JvmParameterizedTypeReference t) {
		t.typeNameWithoutTypeArgs
	}

//	def traitClassName(JvmTypeReference t) {
//   		var n = t.identifier
//   		
//   		var pos = n.indexOf("<")
//   		if (pos > 0)
//   			n = n.substring(0, pos)
//   		
//   		pos = n.lastIndexOf(".")
//   		var name = ""
//   		if (pos > 0)
//   			name = n.substring(0, pos) + "."
//   		
//   		name + n.substring(pos+1) + "Impl"
//   	}

	def typeNameWithoutTypeArgs(JvmTypeReference t) {
		var n = t.simpleName
   		
   		var pos = n.indexOf("<")
   		if (pos > 0)
   			return n.substring(0, pos)
   		else
   			return n
	}
	
	def getJvmTypeReferenceString(JvmTypeReference t) {
		NodeModelUtils.getTokenText(NodeModelUtils.findActualNodeFor(t))
	}

	def void annotateAsTrait(TJTrait element, JvmAnnotationTarget target) {
		target.annotations += element.toAnnotation(XtraitjTraitInterface)
	}

	def void annotateAsTraitClass(TJTrait element, JvmAnnotationTarget target) {
		target.annotations += element.toAnnotation(XtraitjTraitClass)
	}

	def void annotateAsRequiredField(TJField element, JvmMember target) {
		target.annotations += element.toAnnotation(XtraitjRequiredField)
	}

	def void annotateAsRequiredMethod(TJRequiredMethod element, JvmMember target) {
		target.annotations += element.toAnnotation(XtraitjRequiredMethod)
	}

	def void annotateAsDefinedMethod(TJMethod element, JvmMember target) {
		target.annotations += element.toAnnotation(XtraitjDefinedMethod)
	}

	def void copyTypeParameters(JvmTypeParameterDeclarator target, List<JvmTypeParameter> typeParameters) {
		for (typeParameter : typeParameters) {
			val clonedTypeParameter = typeParameter.cloneWithProxies();
			if (clonedTypeParameter != null) {
				target.typeParameters += clonedTypeParameter
			}
		}
	}

	def void translateAnnotations(JvmAnnotationTarget target, List<XAnnotation> annotations) {
		annotations.filterNull.filter[annotationType != null].translateAnnotationsTo(target);
	}

	def transformTypeParametersIntoTypeArguments(JvmParameterizedTypeReference typeRef, EObject ctx) {
		val newRef = typeRef.cloneWithProxies 
		if (newRef instanceof JvmParameterizedTypeReference) {
			newRef.arguments.clear
		
			for (typePar : typeRef.arguments) {
//				val type = typesFactory.createJvmGenericType
//				type.setSimpleName(typePar.simpleName)
				newRef.arguments += newTypeRef(typePar.type)
			}
		
		}
		
		newRef
	}

}