package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.xtraitj.TJProgram
import static extension xtraitj.util.XtraitjModelUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
abstract class XtraitjAbstractTest {
	
	@Inject extension JvmTypesBuilder
	@Inject extension ParseHelper<TJProgram>
	
	def protected toTypeRef(Class<?> clazz) {
		'''
		trait T {}
		'''.
		parse.newTypeRef(clazz)
	}

	def protected getJavaMethod(Class<?> clazz, String methodName) {
		(clazz.toTypeRef.type as JvmDeclaredType).
			allFeatures.filter(JvmMember).findFirst[simpleName == methodName]
	}

	def protected toResourceTypeRef(Class<?> clazz, Class<?>... typeArgs) {
		var typeArguments = ""
		if (typeArgs.length > 0) {
			typeArguments = "<" +
				typeArgs.map[name].join(", ") +
				">"
		}
		
		'''
		trait T {
			«clazz.name»«typeArguments» testField;
		}
		'''.
		parse.traits.head.fields.head.type
	}
	
}