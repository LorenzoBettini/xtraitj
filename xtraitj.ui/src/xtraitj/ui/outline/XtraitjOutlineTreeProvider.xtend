/*
* generated by Xtext
*/
package xtraitj.ui.outline

import com.google.inject.Inject
import org.eclipse.jface.viewers.StyledString
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.ui.IImageHelper
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode
import org.eclipse.xtext.ui.editor.outline.impl.EObjectNode
import org.eclipse.xtext.xbase.validation.UIStrings
import org.eclipse.xtext.xtype.XtypePackage
import xtraitj.jvmmodel.TraitJJvmModelUtil
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJConstructor
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJRequiredMethod
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitReference
import xtraitj.xtraitj.XtraitjPackage
import xtraitj.jvmmodel.XtraitjJvmOperation

/**
 * Customization of the default outline structure.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#outline
 */
class XtraitjOutlineTreeProvider extends DefaultOutlineTreeProvider {
	
	@Inject IImageHelper images
	
	@Inject UIStrings uiStrings
	
	@Inject extension TraitJJvmModelUtil
	
	def _createChildren(DocumentRootNode parentNode, TJProgram p) {
		if (p.name != null) {
			// corresponds to package
			createEStructuralFeatureNode(
				parentNode,
				p,
				XtraitjPackage::eINSTANCE.TJProgram_Name, 
				images.getImage("package_obj.gif"),
				p.name, 
				true)
		}
		
		if (p.importSection != null && 
				!p.importSection.importDeclarations.empty) {
			createEStructuralFeatureNode(
				parentNode, 
				p.importSection,
				XtypePackage::eINSTANCE.XImportSection_ImportDeclarations,
				images.getImage("impc_obj.gif"),
				"import declarations",
				true)
		}
		
		for (content : p.elements) {
			createNode(parentNode, content);
		}
	}

	def _createChildren(EObjectNode parentNode, TJClass c) {
		nodesForTraitReferences(parentNode, c)
		nodesForRequirements(parentNode, c, c.jvmAllInterfaceMethods)
		nodesForProvides(parentNode, c)
		
		for (f : c.fields) {
			createNode(parentNode, f)
		}
		
		for (cons : c.constructors) {
			createNode(parentNode, cons)
		}
	}

	def _createChildren(EObjectNode parentNode, TJTrait t) {
		nodesForTraitReferences(parentNode, t)
		nodesForRequirements(parentNode, t)
		nodesForProvides(parentNode, t)
		
		for (m : t.members.filter(typeof(TJField))) {
			createNode(parentNode, m)
		}
		
		for (m : t.members.filter(typeof(TJRequiredMethod))) {
			createNode(parentNode, m)
		}
		
		for (m : t.members.filter(typeof(TJMethod))) {
			createNode(parentNode, m)
		}
	}

	def nodesForTraitReferences(EObjectNode parentNode, TJDeclaration d) {
		if (d.traitExpression != null) {
			for (ref : d.traitExpression.references) {
				createNode(parentNode, ref)	
			}
		}
	}

	def nodesForRequirements(EObjectNode parentNode, TJDeclaration d) {
		nodesForRequirements(parentNode, d, emptyList)
	}

	def nodesForRequirements(EObjectNode parentNode, TJDeclaration d, Iterable<JvmOperation> interfaceMethods) {
		val fieldRequirements = d.xtraitjJvmAllRequiredFieldOperations
		val methodRequirements = d.jvmAllRequiredMethodOperationsFromReferences
		
		if (!fieldRequirements.empty || !methodRequirements.empty || !interfaceMethods.empty) {
			val reqNode = new TraitJRequirementsNode(parentNode, images.getImage("externalize.gif"))
			nodesForRequirements(reqNode, interfaceMethods)
			nodesForRequirements2(reqNode, fieldRequirements)
			nodesForRequirements(reqNode, methodRequirements)
		}
	}

	def nodesForProvides(EObjectNode parentNode, TJDeclaration d) {
		nodesForProvides(parentNode, d, emptyList)
	}

	def nodesForProvides(EObjectNode parentNode, TJDeclaration d, Iterable<JvmOperation> interfaceMethods) {
		val provides = d.jvmAllMethodOperations
		
		if (!provides.empty) {
			val reqNode = new TraitJProvidesNode(parentNode, images.getImage("externalize.gif"))
			nodesForProvides(reqNode, provides)
		}
	}

	def nodesForRequirements(TraitJRequirementsNode reqNode, Iterable<JvmOperation> requirements) {
		for (req : requirements) {
			val source = req.originalSource
			if (source != null) {
				// use the name from req so that
				// possible renames are applied
				// but use the original source as the element
				// so that we can jump to it
				if (source instanceof TJField)
					reqNode.createEObjectNode(
						source,
						_image(source),
						req.simpleName.stripGetter +
						" : " + source.getType().getSimpleName(),
						true
					)
				else
					reqNode.createEObjectNode(
						source,
						_image(source),
						new StyledString(
							req.simpleName 
							+ uiStrings.parameters(req)
						).append(
							new StyledString(" : " + 
								source.type.simpleName,
								StyledString::DECORATIONS_STYLER
							)
						),
						true
					)
			}
			else
				reqNode.createNode(req)
		}
	}

	def nodesForRequirements2(TraitJRequirementsNode reqNode, Iterable<XtraitjJvmOperation> requirements) {
		for (req : requirements) {
			val source = req.op.originalSource
			if (source != null) {
				// use the name from req so that
				// possible renames are applied
				// but use the original source as the element
				// so that we can jump to it
				if (source instanceof TJField)
					reqNode.createEObjectNode(
						source,
						_image(source),
						req.op.simpleName.stripGetter +
						" : " + source.getType().getSimpleName(),
						true
					)
				else
					reqNode.createEObjectNode(
						source,
						_image(source),
						new StyledString(
							req.op.simpleName 
							+ uiStrings.parameters(req.op)
						).append(
							new StyledString(" : " + 
								source.type.simpleName,
								StyledString::DECORATIONS_STYLER
							)
						),
						true
					)
			}
			else
				reqNode.createNode(req.op)
		}
	}

	def nodesForProvides(TraitJProvidesNode provNode, Iterable<JvmOperation> provides) {
		for (req : provides) {
			val source = req.originalSource
			if (source != null) {
				provNode.createEObjectNode(
						source,
						_image(source),
						new StyledString(
							req.simpleName 
							+ uiStrings.parameters(req)
						).append(
							new StyledString(" : " + 
								source.type.simpleName,
								StyledString::DECORATIONS_STYLER
							)
						),
						true
					)
			}
		}
	}
	
//	def _text(JvmOperation op) {
//		val source = op.originalSource
//		
//		if (source == null) {
//			super._text(op)
//		}
//		
//		if (source instanceof TJField) {
//			op.simpleName.stripGetter + " : " + 
//			op.returnType.getSimpleName()
//		} else {
//			super._text(op)
//		}
//	}

	def _isLeaf(TJMember m) {
		return true;
	}

	def _isLeaf(TJConstructor m) {
		return true;
	}

	def _isLeaf(TJTraitReference r) {
		return true;
	}

	def _isLeaf(JvmOperation o) {
		return true;
	}
}
