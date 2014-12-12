package xtraitj.generator

import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.naming.IQualifiedNameProvider
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference

import static extension xtraitj.util.XtraitjModelUtil.*

@Singleton
class XtraitjGeneratorExtensions {
	
	@Inject extension IQualifiedNameProvider

	def traitInterfaceName(String n) {
   		n //+ "Interface"
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
   			toString.traitClassName
   	}

	def traitClassName(String n) {
   		n // skipLast(1). /* append("traits").append("impl"). */ 
   			/* append(n.lastSegment). */ 
   			+ "Impl"
   	}

   	def traitExpressionInterfaceName(TJTraitReference t) {
   		val n = t.containingDeclaration.fullyQualifiedName
   		n //.skipLast(1).toString // append("traits").
   			+ t.adapterName // + "Interface"
   	}

   	def traitExpressionClassName(TJTraitReference t) {
   		val n = t.containingDeclaration.fullyQualifiedName
   		n // .skipLast(1).toString /* append("traits").append("impl").*/
   			+ t.adapterName + "Impl"
   	}

	def adapterName(TJTraitReference t) {
		t.syntheticName + "_Adapter"
	}

	def syntheticName(TJTraitReference t) {
		//t.containingDeclaration.name + 
		"_" +
		t.trait.typeNameWithoutTypeArgs /* .simpleName */ + "_" +
		t.containingDeclaration.traitOperationExpressions.indexOf(t)
	}

	def delegateFieldName() {
		"_delegate"
	}

	def traitFieldName(TJTraitReference e) {
		if (e.operations.empty)
			return "_" + e.trait.traitFieldName
		return e.traitFieldNameForOperations
	}

	def traitFieldNameForOperations(TJTraitReference e) {
		return "_" + e.trait.traitFieldName + "_" +
				e.containingDeclaration.traitOperationExpressions.indexOf(e)
	}

	def traitFieldName(JvmParameterizedTypeReference t) {
		val n = t.typeNameWithoutTypeArgs
		
   		return n
	}

	def traitClassName(JvmTypeReference t) {
   		val name = reconstructIdentifier(t)
   		
   		if (name == "void") {
   			return name
   		}
   		return name + "Impl"
   	}

	def traitInterfaceName(JvmTypeReference t) {
   		reconstructIdentifier(t)
   	}

	def reconstructIdentifier(JvmTypeReference t) {
   		var n = t.identifier
   		
   		if (n == null) {
   			return "void"
   		}
   		
   		var pos = n.indexOf("<")
   		if (pos > 0)
   			n = n.substring(0, pos)
   		
   		pos = n.lastIndexOf(".")
   		var name = ""
   		if (pos > 0)
   			name = n.substring(0, pos) + "."
   		
   		return name + n.substring(pos+1)
   	}

	def typeNameWithoutTypeArgs(JvmTypeReference t) {
		val n = t.jvmTypeReferenceString
		
		val pos = n.lastIndexOf(".")
   		if (pos > 0) {
   			return n.substring(pos+1)
   		}
   		
   		return n
	}
	


//	def toMethodDelegate(XtraitjJvmOperation op, String delegateFieldName) {
//		op.toMethodDelegate(delegateFieldName, op.op.simpleName, "_"+op.op.simpleName)
//	}
//
//	def toMethodDelegate(XtraitjJvmOperation op, String delegateFieldName, String methodName, String methodToDelegate) {
//		val o = op.op
//		val m = o.originalSource ?: o
////		if (!o.typeParameters.empty)
//			m.toMethod(methodName, op.returnType) [
//				documentation = m.documentation
//				
////				if (m instanceof TJMethodDeclaration) {
//					copyTypeParameters(o.typeParameters)
////				}
//	
//				//returnType = returnType.rebindTypeParameters(it)
//		
//				val paramTypeIt = op.parametersTypes.iterator
//				for (p : o.parameters) {
//					//parameters += p.toParameter(p.name, paramTypeIt.next.rebindTypeParameters(it))
//					// don't associate the parameter to p, since p is not part of the source tree
//					// java.lang.IllegalArgumentException: The source element must be part of the source tree.
//					parameters += m.toParameter(p.name, paramTypeIt.next)
//				}
//				val args = o.parameters.map[name].join(", ")
//				if (op.returnType?.simpleName != "void")
//					body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
//				else
//					body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
//			]
////		else // if there's no type params we can make things simpler
////			m.toMethod(methodName, op.returnType) [
////				documentation = m.documentation
////				
////				val paramTypeIt = op.parametersTypes.iterator
////				for (p : o.parameters) {
////					parameters += p.toParameter(p.name, paramTypeIt.next)
////				}
////				val args = o.parameters.map[name].join(", ")
////				if (op.returnType?.simpleName != "void")
////					body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
////				else
////					body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
////			] // and we can navigate to the original method
//	}

//	def toMethodDelegate(XtraitjTraitOperationWrapper op, String delegateFieldName, String methodName, String methodToDelegate) {
//		//val o = op.jvmOperation
//		val m = op.operation
//		m.toMethod(methodName, op.returnType) [
//			documentation = m.documentation
//			
//			copyTypeParameters(op.typeParameters)
//			
//			for (p : op.parameters) {
//				parameters += p.toParameter(p.name, p.parameterType)
//			}
//			val args = op.parameters.map[name].join(", ")
//			if (op.returnType?.simpleName != "void")
//				body = [append('''return «delegateFieldName».«methodToDelegate»(«args»);''')]
//			else
//				body = [append('''«delegateFieldName».«methodToDelegate»(«args»);''')]
//		]
//	}

//   	def toSetterDelegateFromGetter(XtraitjJvmOperation op) {
//   		val fieldName = op.op.simpleName.stripGetter
//   		op.op.toSetter(fieldName, op.returnType) => [
//   			method |
//   			method.body = [append('''«delegateFieldName».«method.simpleName»(«fieldName»);''')]
//   		]
//   	}
//
//	def toAbstractSetterDelegateFromGetter(XtraitjJvmOperation op) {
//   		val fieldName = op.op.simpleName.stripGetter
//   		op.op.toSetter(fieldName, op.returnType) => [
//   			abstract = true
//   		]
//   	}

//	def toAbstractSetterDelegateFromGetter(XtraitjJvmOperation op, String newName) {
//   		op.op.toSetter(newName, op.returnType) => [
//   			abstract = true
//   		]
//   	}

//	def typeParametersOfReferredType(JvmParameterizedTypeReference typeRef) {
//		(typeRef.type as JvmGenericType).typeParameters.map[cloneWithProxies]
//	}

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