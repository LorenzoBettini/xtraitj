package xtraitj.tests;

import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.xtext.xbase.compiler.OnTheFlyJavaCompiler;
import org.eclipse.xtext.xbase.compiler.OnTheFlyJavaCompiler.EclipseRuntimeDependentJavaCompiler;
import org.eclipse.xtext.xbase.junit.evaluation.AbstractXbaseEvaluationTest;
import org.eclipse.xtext.xbase.lib.Functions;

import xtraitj.XtraitjInjectorProvider;
import xtraitj.XtraitjRuntimeModule;
import xtraitj.XtraitjStandaloneSetup;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

import com.google.common.base.Supplier;
import com.google.inject.Guice;
import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Provider;

public class InjectorProviderCustom extends XtraitjInjectorProvider {

	public Injector internalCreateInjector() {
			return new XtraitjStandaloneSetup() {
				@Override
				public Injector createInjector() {
					return Guice.createInjector(new XtraitjRuntimeModule() {
						@Override
						public ClassLoader bindClassLoaderToInstance() {
							return InjectorProviderCustom.class
									.getClassLoader();
						}

						@SuppressWarnings("unused")
						public Class<? extends OnTheFlyJavaCompiler> bindOnTheFlyJavaCompiler() {
							try {
								if (ResourcesPlugin.getWorkspace() != null)
									return EclipseRuntimeDependentJavaCompiler.class;
							} catch (Exception e) {
								// ignore
							}
							return OnTheFlyJavaCompiler.class;
						}
						
						@SuppressWarnings("unused")
						public Class<? extends OnTheFlyJavaCompiler.ClassPathAssembler> bindClassPathAssembler() {
							return TestClassPathAssembler.class;
						}
					});
				}
			}.createInjectorAndDoEMFRegistration();
	}

	public static class TestClassPathAssembler extends
			OnTheFlyJavaCompiler.ClassPathAssembler {
		@Override
		public void assembleCompilerClassPath(OnTheFlyJavaCompiler compiler) {
			super.assembleCompilerClassPath(compiler);
			if (compiler instanceof EclipseRuntimeDependentJavaCompiler) {
				compiler.addClassPathOfClass(getClass());
				compiler.addClassPathOfClass(AbstractXbaseEvaluationTest.class);
				compiler.addClassPathOfClass(Functions.class);
				compiler.addClassPathOfClass(Provider.class);
				compiler.addClassPathOfClass(Inject.class);
				compiler.addClassPathOfClass(javax.inject.Provider.class);
				compiler.addClassPathOfClass(Supplier.class);
				
				compiler.addClassPathOfClass(XtraitjTraitInterface.class);
				compiler.addClassPathOfClass(XtraitjRequiredField.class);
				compiler.addClassPathOfClass(XtraitjRequiredMethod.class);
				compiler.addClassPathOfClass(XtraitjDefinedMethod.class);
			}
		}
	}
}
