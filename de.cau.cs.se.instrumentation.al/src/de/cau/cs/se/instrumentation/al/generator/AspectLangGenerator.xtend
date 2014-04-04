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
package de.cau.cs.se.instrumentation.al.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess



import de.cau.cs.se.instrumentation.al.aspectLang.Aspect
import java.util.Collection
import java.util.Map
import java.util.HashMap
import javax.xml.parsers.DocumentBuilderFactory
import de.cau.cs.se.instrumentation.al.aspectLang.Query
import de.cau.cs.se.instrumantation.model.structure.Method
import de.cau.cs.se.instrumantation.model.structure.MethodModifier
import de.cau.cs.se.instrumentation.al.aspectLang.LocationQuery
import de.cau.cs.se.instrumentation.al.aspectLang.Node
import de.cau.cs.se.instrumentation.al.aspectLang.ContainerNode
import de.cau.cs.se.instrumantation.model.structure.Parameter
import javax.xml.transform.TransformerFactory
import javax.xml.transform.dom.DOMSource
import javax.xml.transform.stream.StreamResult
import java.io.StringWriter
import java.util.ArrayList
import de.cau.cs.se.instrumantation.model.structure.TypeReference
import de.cau.cs.se.instrumentation.al.aspectLang.Collector
import org.w3c.dom.Element
import org.w3c.dom.Document
import de.cau.cs.se.instrumentation.al.aspectLang.InsertionPoint

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class AspectLangGenerator implements IGenerator {
	
	val Map<String,Collection<Aspect>> aspectMap = new HashMap<String,Collection<Aspect>>()
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		resource.allContents.filter(typeof(Aspect)).forEach[aspectMap.addAspect(it)]
		aspectMap.forEach[key, value | switch(key) {
			case 'AspectJ': createAspectJConfiguration(value,fsa)
			case 'J2EE' : createJ2EEConfiguration(value,fsa)
			case 'Spring' : createSpringConfiguration(value,fsa)
		}]
	}
	
	def void addAspect(Map<String, Collection<Aspect>> map, Aspect aspect) {
		var list = map.get(aspect?.annotation?.name)
		if (list == null) {
			list = new ArrayList<Aspect>()
			map.put(aspect?.annotation?.name,list)
		}
		list.add(aspect)
	}
	
	def createAspectJConfiguration(Collection<Aspect> aspects, IFileSystemAccess access) {
		val docFactory = DocumentBuilderFactory.newInstance()
		val docBuilder = docFactory.newDocumentBuilder()
		val doc = docBuilder.newDocument()
		
		val aspectjElement = doc.createElement("aspectj")
		doc.appendChild(aspectjElement)
		
		val weaverElement = doc.createElement("weaver")
		weaverElement.setAttribute("options","")
		aspectjElement.appendChild(weaverElement)
		
		for (Aspect aspect : aspects) {
			val includeElement = doc.createElement("include")
			includeElement.setAttribute("within", aspect.query.computeAspectJQuery)
			weaverElement.appendChild(includeElement)
		} 
		
		val aspectsElement = doc.createElement("aspects")
		aspectjElement.appendChild(aspectsElement)
		for (Aspect aspect : aspects) {
			aspect.collectors.filter[it.insertionPoint == InsertionPoint.^BEFORE].createCollector(doc, aspectsElement)
			aspect.collectors.filter[it.insertionPoint == InsertionPoint.^AFTER].createCollector(doc, aspectsElement)
		}
		
		// writing stuff
		val transformerFactory = TransformerFactory.newInstance()
		val transformer = transformerFactory.newTransformer()
		
		val writer = new StringWriter()
		
		transformer.transform(new DOMSource(doc), new StreamResult(writer))
		
		access.generateFile('aop.xml',writer.toString)
	}
	
	def void createCollector(Iterable<Collector> list, Document doc, Element aspectsElement) {
		val aspectElement = doc.createElement("aspect")
		aspectElement.setAttribute("name","record types are " + list.map[it.type.name].join(', '))
		aspectsElement.appendChild(aspectElement)
	}
	
	def String computeAspectJQuery(Query query) '''«query.location.computeLocation» «query.modifier.computeModifier» «if (query.method != null) query.method.computeMethod else '*'»'''
	
	def CharSequence computeLocation(LocationQuery query) '''«query.node.computeNode»«if (query.specialization != null) '.' + query.specialization.computeLocation»'''
	
	def dispatch computeNode(ContainerNode node) '''«node.container.name»'''
	def dispatch computeNode(Node node) '''#''' // illegal call
	
	// TODO this should produce the correct mapping of modifiers
	def CharSequence computeModifier(MethodModifier modifier) '''«if (modifier != null) modifier.name else '*'»'''
	
	def CharSequence computeMethod(Method method) '''«method.name» («method.parameters.map[it.computeParameter].join(', ')»)'''
	
	// TODO this should produce the correct mapping of types and modifiers
	def CharSequence computeParameter(Parameter parameter) '''«parameter.type.computeType» «parameter.name»'''
	
	def CharSequence computeType(TypeReference reference) '''«reference.type.name»'''
	
	def createSpringConfiguration(Collection<Aspect> aspects, IFileSystemAccess access) {
		"TODO: auto-generated method stub"
	}
	
	def createJ2EEConfiguration(Collection<Aspect> aspects, IFileSystemAccess access) {
		"TODO: auto-generated method stub"
	}

	
}
