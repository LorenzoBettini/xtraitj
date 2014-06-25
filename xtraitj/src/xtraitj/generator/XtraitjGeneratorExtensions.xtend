package xtraitj.generator

import com.google.inject.Inject
import com.google.inject.Singleton
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.common.types.JvmAnnotationTarget
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.jvmmodel.XtraitjJvmModelUtil
import xtraitj.jvmmodel.XtraitjJvmOperation
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod
import xtraitj.runtime.lib.annotation.XtraitjRequiredField
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod
import xtraitj.runtime.lib.annotation.XtraitjTraitClass
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface
import xtraitj.util.XtraitjAnnotatedElementHelper
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.XtraitjModelUtil.*

@Singleton
class XtraitjGeneratorExtensions {
	
	@Inject extension IQualifiedNameProvider
	@Inject extension JvmTypesBuilder
	@Inject extension XtraitjAnnotatedElementHelper
	@Inject extension XtraitjJvmModelUtil

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
   		n.skipLast(1).toString // append("traits").
   			+ t.adapterName + "Interface"
   	}

   	def traitExpressionClassName(TJTraitReference t) {
   		val n = t.containingDeclaration.fullyQualifiedName
   		n.skipLast(1).toString /* append("traits").append("impl").*/
   			+ t.adapterName
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
		t.jvmTypeReferenceString
	}
	
	def void annotateAsTrait(TJTrait element, JvmAnnotationTarget target) {
		target.annotations += element.toAnnotation(XtraitjTraitInterface)
	}

	def void annotateAsTraitClass(TJTrait element, JvmAnnotationTarget target) {
		target.annotations += element.toAnnotation(XtraitjTraitClass)
	}

	def void annotateAsRequiredField(EObject element, JvmMember target) {
		target.annotations += element.toAnnotation(XtraitjRequiredField)
	}

	def void annotateAsRequiredMethod(EObject element, JvmMember target) {
		target.annotations += element.toAnnotation(XtraitjRequiredMethod)
	}

	def void annotateAsDefinedMethod(EObject element, JvmMember target) {
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

	def void copyAnnotationsFrom(JvmOperation target, XtraitjJvmOperation xop) {
		target.annotations += xop.op.annotations.
			filterOutXtraitjAnnotations.map[EcoreUtil2.cloneWithProxies(it)]
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

	def toMethodDelegate(XtraitjJvmOperation op, String delegateFieldName) {
		op.toMethodDelegate(delegateFieldName, op.op.simpleName, "_"+op.op.simpleName)
	}

	def toMethodDelegate(XtraitjJvmOperation op, String delegateFieldName, String methodName, String methodToDelegate) {
		val o = op.op
		val m = o.originalSource ?: o
		if (!o.typeParameters.empty)
			m.toMethod(methodName, op.returnType) [
				documentation = m.documentation
				
				if (m instanceof TJMethodDeclaration) {
					copyTypeParameters(o.typeParameters)
				}
	
				//returnType = returnType.rebindTypeParameters(it)
		
				val paramTypeIt = op.parametersTypes.iterator
				for (p : o.parameters) {
					//parameters += p.toParameter(p.name, paramTypeIt.next.rebindTypeParameters(it))
					parameters += p.toParameter(p.name, paramTypeIt.next)
				}
				val args = o.parameters.map[name].join(", ")
				if (op.returnType?.simpleName != "void")
					body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
				else
					body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
			]
		else // if there's no type params we can make things simpler
			m.toMethod(methodName, op.returnType) [
				documentation = m.documentation
				
				val paramTypeIt = op.parametersTypes.iterator
				for (p : o.parameters) {
					parameters += p.toParameter(p.name, paramTypeIt.next)
				}
				val args = o.parameters.map[name].join(", ")
				if (op.returnType?.simpleName != "void")
					body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
				else
					body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
			] // and we can navigate to the original method
	}

   	def toSetterDelegateFromGetter(XtraitjJvmOperation op) {
   		val fieldName = op.op.simpleName.stripGetter
   		op.op.toSetter(fieldName, op.returnType) => [
   			method |
   			method.body = [append('''«delegateFieldName».«method.simpleName»(«fieldName»);''')]
   		]
   	}

	def toAbstractSetterDelegateFromGetter(XtraitjJvmOperation op) {
   		val fieldName = op.op.simpleName.stripGetter
   		op.op.toSetter(fieldName, op.returnType) => [
   			abstract = true
   		]
   	}

//	def buildTypeRef(TJTraitReference t, Map<String, JvmGenericType> typesMap) {
//		val typeRef = t.trait
//		// here instead proxy resolution seems to be necessary
//		// val type = typeRef.getTypeWithoutProxyResolution
//		val type = typeRef.type
//		if (type.eIsProxy()) {
//			val mapped = typesMap.get(typeRef.getJvmTypeReferenceString)
//			if (mapped !== null)
//				return mapped.newTypeRef(typeRef.arguments.map[cloneWithProxies])
//		}
//		typeRef
//	}

}