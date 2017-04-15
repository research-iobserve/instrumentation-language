/***************************************************************************
 * Copyright 2017 Kieker Project (http://kieker-monitoring.net)
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
package kieker.develop.al.generator.java.aspectj

import java.io.File
import kieker.develop.al.aspectLang.AspectModel
import kieker.develop.al.generator.java.ConfigurationProperties
import kieker.develop.al.intermediate.IntermediateModel
import kieker.develop.rl.outlet.AbstractOutletConfiguration
import org.w3c.dom.Document

/**
 * AspectJ configuration/aop.xml outlet configuration.
 * 
 * @author Reiner Jung
 */
class AspectJConfigurationOutletConfiguration extends AbstractOutletConfiguration<IntermediateModel, Document> {
			
	new() {
		super(ConfigurationProperties.ASPECT_J_CONFIGURATION_OUTLET_ID, "AspectJ", "./src-gen/java",
			ConfigurationProperties.LANG_JAVA, ConfigurationProperties.TECH_ASPECT_J
		)
		generators += new AspectJConfigurationGenerator()
	}
	
	override outputFilePath(IntermediateModel node) '''«node.outputDirectory»«File::separator»«node.name».java'''
	
	override outputDirectory(IntermediateModel node) '''«(node.eContainer as AspectModel).name.replace('.',File::separator)»'''
	
}