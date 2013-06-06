package xtraitj.generator

import org.eclipse.xtext.generator.OutputConfigurationProvider

class TraitJOutputConfigurationProvider extends OutputConfigurationProvider {

	public static val TRAITJ_GEN = "./xtraitj-gen"

	override getOutputConfigurations() {
		super.getOutputConfigurations() => [
			head.outputDirectory = TRAITJ_GEN
		]
	}	
}