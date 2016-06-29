package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.formatter.FormatterTester
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjFormatterTest {
	@Inject extension FormatterTester

	@Test def void testFormatter() {
		assertFormatted[
			toBeFormatted = '''
				package tests;
				import java.util.List
				
				trait T  {  int  m ( List < String >  l1 ,  int  p )  {  return  0  ;  }}
				
				class C {
				String s; 		C() {}
				}
			'''
			expectation = '''
				package tests;
				import java.util.List
				
				trait T {
					int  m ( List<String> l1 ,  int p )  {
						return 0;
					}
				}
				
				class C {
					String s;
					C() {}
				}
			'''
		]
	}

}
