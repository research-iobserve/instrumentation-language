package de.cau.cs.se.instrumentation.al.generator.spring

import de.cau.cs.se.geco.architecture.framework.IGenerator
import de.cau.cs.se.instrumentation.al.aspectLang.Advice

import static extension de.cau.cs.se.instrumentation.al.generator.CommonJavaTemplates.*

class SpringAdviceGenerator implements IGenerator<Advice, CharSequence> {
	
	override generate(Advice input) {
		'''
			package «input.packageName»
			
			«input.collectors.createRecordInputs»
			
			MISSING
		'''
	}
	
}