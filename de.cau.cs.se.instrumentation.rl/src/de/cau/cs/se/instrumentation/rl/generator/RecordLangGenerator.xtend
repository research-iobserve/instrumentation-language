/***************************************************************************
 * Copyright 2013 Kieker Project (http://kieker-monitoring.net)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ***************************************************************************/
package de.cau.cs.se.instrumentation.rl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.core.resources.ProjectScope
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import de.cau.cs.se.instrumentation.rl.recordLang.RecordType
import de.cau.cs.se.instrumentation.rl.recordLang.PartialRecordType
import org.eclipse.core.runtime.preferences.IEclipsePreferences
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Platform

/**
 * Generates one single files per record for java, c, and perl. 
 */
class RecordLangGenerator implements IGenerator {
				
	private static val className = "de.cau.cs.se.instrumentation.rl.generator.RecordLangGenerator"
	public static val JAVA_DIR_PROPERTY = className + ".JAVA_DIR_PROPERTY"
	public static val JAVA_CHECK_PROPERTY = className + ".JAVA_CHECK_PROPERTY"
	public static val C_DIR_PROPERTY = className + ".C_DIR_PROPERTY"
	public static val C_CHECK_PROPERTY = className + ".C_CHECK_PROPERTY"
	public static val PERL_DIR_PROPERTY = className + ".PERL_DIR_PROPERTY"
	public static val PERL_CHECK_PROPERTY = className + ".PERL_CHECK_PROPERTY"
	public static val AUTHOR_PROPERTY = className + ".AUTHOR_PROPERTY"
	public static val VERSION_PROPERTY = className + ".VERSION_PROPERTY"
	
	@Property var version = "1.9"
	@Property var author = "Generic Kieker"
	
	@Property var String[] selectedLanguageTypes = #[]
	
	@Property var boolean languageSpecificTargetFolder = true
		
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		selectedLanguageTypes = #[ "Java" ]
		if (resource.URI.platformResource) {
			val properties = Platform.getPreferencesService().getRootNode().node("project").node(resource.URI.segments.get(1))
			System.out.println ("node " + properties.get(JAVA_DIR_PROPERTY,""))
			System.out.println ("node " + properties.node(JAVA_DIR_PROPERTY))
			// list all generators to support RecordType
			val Class<?>[] recordTypeGenerators = #[
				typeof(de.cau.cs.se.instrumentation.rl.generator.c.RecordTypeGenerator),
				typeof(de.cau.cs.se.instrumentation.rl.generator.cheader.RecordTypeGenerator),
				typeof(de.cau.cs.se.instrumentation.rl.generator.java.RecordTypeGenerator),
				typeof(de.cau.cs.se.instrumentation.rl.generator.perl.RecordTypeGenerator)
			]
			
			// list all generators to support PartialRecordType
			val Class<?>[] partialRecordTypeGenerators = #[
				typeof(de.cau.cs.se.instrumentation.rl.generator.java.PartialRecordTypeGenerator)
			]
			
							
			for (Class<?> generator : recordTypeGenerators) {
				val cg = generator.getConstructor().newInstance() as AbstractRecordTypeGenerator
				resource.allContents.filter(typeof(RecordType)).forEach[type | 
					if (cg.isActive) fsa.generateFile(cg.fileName(type), cg.createContent(type,author,version,languageSpecificTargetFolder))
				]
			}
			
			for (Class<?> generator : partialRecordTypeGenerators) {
				val cg = generator.getConstructor().newInstance() as AbstractPartialRecordTypeGenerator
				resource.allContents.filter(typeof(PartialRecordType)).forEach[type | 
					if (cg.isActive) fsa.generateFile(cg.fileName(type), cg.createContent(type,author,version,languageSpecificTargetFolder))
				]
			} 
		}
	}
	
	def void show() {
		
	}
	
	def boolean isActive(AbstractRecordTypeGenerator generator) {
		return selectedLanguageTypes.exists[generator.languageType.equals(it)]
	}
	
	def boolean isActive(AbstractPartialRecordTypeGenerator generator) {
		return selectedLanguageTypes.exists[generator.languageType.equals(it)]
	}
}
