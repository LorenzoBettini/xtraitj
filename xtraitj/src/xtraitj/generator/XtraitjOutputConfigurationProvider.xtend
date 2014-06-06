package xtraitj.generator

import org.eclipse.xtext.generator.OutputConfigurationProvider

class XtraitjOutputConfigurationProvider extends OutputConfigurationProvider {

	public static val TRAITJ_GEN = "./xtraitj-gen"

	override getOutputConfigurations() {
		super.getOutputConfigurations() => [
			head.outputDirectory = TRAITJ_GEN
		]
	}	
}