/*
* generated by Xtext
*/
package xtraitj;

import xtraitj.XtraitjStandaloneSetupGenerated;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class XtraitjStandaloneSetup extends XtraitjStandaloneSetupGenerated{

	public static void doSetup() {
		new XtraitjStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

