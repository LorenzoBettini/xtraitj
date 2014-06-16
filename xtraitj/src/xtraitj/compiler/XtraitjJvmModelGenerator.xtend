package xtraitj.compiler

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.xbase.compiler.DisableCodeGenerationAdapter
import org.eclipse.xtext.xbase.compiler.GeneratorConfig
import org.eclipse.xtext.xbase.compiler.IGeneratorConfigProvider
import org.eclipse.xtext.xbase.compiler.JvmModelGenerator
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.jvmmodel.XtraitjJvmModelUtil

import static extension xtraitj.util.XtraitjModelUtil.*
import xtraitj.xtraitj.TJTrait

class XtraitjJvmModelGenerator extends JvmModelGenerator {
	
	@Inject extension XtraitjGeneratorExtensions
	@Inject extension JvmTypesBuilder
	@Inject extension XtraitjJvmModelUtil
	
	@Inject IGeneratorConfigProvider generatorConfigProvider
	
	override dispatch void internalDoGenerate(JvmDeclaredType type, IFileSystemAccess fsa) {
		if (DisableCodeGenerationAdapter.isDisabled(type))
			return;
		if(type.qualifiedName != null) {
			val genericType = type as JvmGenericType
			val t = genericType.associatedTrait
			if (t !== null)
				fsa.generateFile(t.traitInterfaceName.replace('.', '/') + '.java', t.generateTraitInterfaceType(generatorConfigProvider.get(type)))
			fsa.generateFile(type.qualifiedName.replace('.', '/') + '.java', type.generateType(generatorConfigProvider.get(type)))
		}
	}
	
	def CharSequence generateTraitInterfaceType(TJTrait t, GeneratorConfig config) {
		val traitInterface = t.toInterface(t.traitInterfaceName) [
			documentation = t.documentation
			
			t.annotateAsTrait(it)

   			copyTypeParameters(t.traitTypeParameters)
   			
   			// it is crucial to insert, at this stage, into the inferred interface all
   			// members which are specified in the trait, so that, later
   			// we also add the members we "inherit" from used traits 
			for (field : t.fields) {
				members += field.toGetterAbstract => [
					field.annotateAsRequiredField(it)
				]
				members += field.toSetterAbstract
			}
			
			for (method : t.methods) {
				if (!method.isPrivate)
					members += method.toAbstractMethod => [
	   					translateAnnotations(method.annotations)
	   					method.annotateAsDefinedMethod(it)
	   				]
			}
			
			for (method : t.requiredMethods) {
				members += method.toAbstractMethod => [
					method.annotateAsRequiredMethod(it)
				]
			}
		]
	
		return super.generateType(traitInterface, config)
		
	}
	
}