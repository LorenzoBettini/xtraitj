package xtraitj.util

import java.util.List
import java.util.Set
import org.eclipse.emf.ecore.EObject
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJMethod
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJRequiredMethod
import xtraitj.xtraitj.TJTrait
import xtraitj.xtraitj.TJTraitExpression
import xtraitj.xtraitj.TJTraitReference

import static extension org.eclipse.xtext.EcoreUtil2.*
import xtraitj.xtraitj.TJConstructor

class TraitJModelUtil {
	
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

	def static methods(TJTraitReference e) {
		e.trait?.methods
	}
	
	def static members(TJDeclaration d) {
		switch (d) {
			TJTrait : d.members
			TJClass : d.fields
		}
	}

	def static typeParameters(TJDeclaration d) {
		if (d instanceof TJTrait) {
			return d.traitTypeParameters
		} else {
			(d as TJClass).classTypeParameters
		}
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

	def static containingClass(TJConstructor e) {
		e.getContainerOfType(typeof(TJClass))
	}

	def static containingProgram(TJDeclaration e) {
		e.getContainerOfType(typeof(TJProgram))
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

	/**
	 * Recursively collects all TJTrait occurrences in the TJTraitExpression
	 * of the passed trait,
	 * avoiding possible cycles
	 */
	def static allTraitsDependency(TJTrait t) {
		if (t.traitExpression == null)
			return emptyList
		
		t.traitExpression.allTraitReferences.filter(typeof(TJTraitReference)).
			map[trait]
	}

	def static allTraitReferences(TJTraitExpression e) {
		<TJTraitReference>newArrayList() => [
			e.allTraitReferences(it, newHashSet)
		]
	}

	def private static void allTraitReferences(TJTraitExpression e, 
			List<TJTraitReference> traitExpressions,
			Set<TJTrait> visited) {
		for (t : e.traitReferences) {
			// avoid possible cycles
			if (!visited.contains(t.trait)) {
				visited += t.trait
				traitExpressions += t
				t.trait.traitExpression?.
					allTraitReferences(traitExpressions, visited)
			}
		}
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

	def static constructorRepresentation(TJConstructor c) {
		c.name +
			"(" +
			c.params.map[parameterType?.simpleName].join(", ")
			+ ")"
	}

}