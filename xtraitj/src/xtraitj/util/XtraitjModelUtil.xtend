package xtraitj.util

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.TypesPackage
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJConstructor
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJRequiredMethod
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitExpression
import xtraitj.xtraitj.TJTraitOperation
import xtraitj.xtraitj.TJTraitReference
import xtraitj.xtraitj.XtraitjPackage

import static extension org.eclipse.xtext.EcoreUtil2.*

class XtraitjModelUtil {
	
	protected new() {
		
	}
	
	def static traits(TJProgram p) {
		p.elements.filter(typeof(TJTrait))
	}

	def static classes(TJProgram p) {
		p.elements.filter(typeof(TJClass))
	}

	def static fields(TJTrait t) {
		t.members.filter(typeof(TJField))
	}

	def static methods(TJTrait t) {
		t.members.filter(typeof(TJMethod))
	}

	def static requiredMethods(TJTrait t) {
		t.members.filter(typeof(TJRequiredMethod))
	}

	def static containingDeclaration(EObject e) {
		e.getContainerOfType(typeof(TJDeclaration))
	}

	def static containingTrait(TJMember e) {
		e.getContainerOfType(typeof(TJTrait))
	}

	def static containingTraitOperationExpression(EObject e) {
		e.getContainerOfType(typeof(TJTraitReference))
	}

	def static traitReferences(TJDeclaration t) {
		t.traitExpression.traitReferences
	}

	def static traitReferences(TJTraitExpression e) {
		if (e == null)
			return emptyList
		e.references
	}

	def static traitOperationExpressions(TJDeclaration t) {
		t.traitExpression.traitReferences.
			filter[!operations.empty].toList
	}

	def static representationWithTypes(TJField f) {
		f.type?.simpleName + " " + f.name
	}
	
	def static representationWithTypes(TJMethodDeclaration f) {
		f.type?.simpleName + " " + f.name +
			parameterRepresentation(f)
	}

	def static parameterRepresentation(TJMethodDeclaration f) {
		"(" +
			f.params.map[parameterType?.simpleName].join(", ")
		+ ")"
	}

	def static typeArgumentsRepresentation(List<JvmTypeReference> typeArguments) {
		"<" +
			typeArguments.map[simpleName].join(",")
		+ ">"
	}

	def static constructorRepresentation(TJConstructor c) {
		c.name +
			"(" +
			c.params.map[parameterType?.simpleName].join(", ")
			+ ")"
	}

	def static getJvmTypeReferenceString(JvmTypeReference t) {
		val n = NodeModelUtils.getTokenText(NodeModelUtils.findActualNodeFor(t))
		
		removeTypeArgs(n)
	}
	
	def static removeTypeArgs(String n) {
		var pos = n.indexOf("<")
   		if (pos > 0)
   			return n.substring(0, pos)
   		else
   			return n
	}

	/**
	 * Simply using getType would trigger proxy resolution which we do not want at this
	 * stage.  This method takes the JvmType reflectively without triggering proxy resolution.
	 */
	def static getTypeWithoutProxyResolution(JvmParameterizedTypeReference typeRef) {
		typeRef.eGet(TypesPackage.eINSTANCE.jvmParameterizedTypeReference_Type, false) as JvmType
	}

	/**
	 * Retrieves the name of the member involved in this trait operation
	 * without actually resolving the member
	 */
	def static getOperationMemberName(TJTraitOperation op) {
		val nodes = NodeModelUtils.findNodesForFeature(op, XtraitjPackage.eINSTANCE.TJTraitOperation_Member)
		val head = nodes.head
		if (head == null)
			return null
		NodeModelUtils.getTokenText(head)
	}
}