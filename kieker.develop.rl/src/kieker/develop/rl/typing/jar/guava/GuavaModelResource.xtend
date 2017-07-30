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
package kieker.develop.rl.typing.jar.guava

import kieker.develop.rl.recordLang.Classifier
import kieker.develop.rl.recordLang.Literal
import kieker.develop.rl.recordLang.Model
import kieker.develop.rl.recordLang.RecordLangFactory
import kieker.develop.rl.recordLang.EventType
import kieker.develop.rl.recordLang.TemplateType
import kieker.develop.rl.recordLang.Type
import java.io.IOException
import java.io.InputStream
import java.util.ArrayList
import java.util.Collection
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.impl.ResourceImpl
import kieker.develop.rl.typing.base.BaseTypes
import kieker.develop.rl.recordLang.ComplexType
import java.io.File
import com.google.common.reflect.ClassPath
import java.lang.reflect.Modifier
import java.net.URL
import java.net.URLClassLoader

/**
 * The resource collects record information from JAR files.
 * 
 * @author Reiner Jung
 * 
 * @since 1.3
 */
public class GuavaModelResource extends ResourceImpl {
	
	val EXCLUDE_CLASSES = #[
		"java.io.Serializable",
		"java.lang.Comparable", "java.lang.Object", 
		"kieker.common.record.AbstractMonitoringRecord",
		"kieker.common.record.IMonitoringRecord"
	]
	
	val rlFactory = RecordLangFactory.eINSTANCE
	val Collection<File> jars
	val Collection<Type> modelTypes = new ArrayList<Type>
	
	var int i=0
	
	/**
	 * Integrate a foreign model.
	 * 
	 * @param uri of the foreign model
	 * @param applicationModel the application model
	 */
	public new(URI uri, Collection<File> jars) {
		super(uri)
		this.jars = jars
	}
	
	/**
	 * Return an EObject with the name specified by the uriFragment.
	 * 
	 * @param uriFragment
	 * 
	 * @return the EObject identified by the uriFragment or null if no such object exists. 
	 */
	override EObject getEObject(String uriFragment) {
		if (!this.getContents().empty) {
			for (object : this.getContents()) {
				if (object instanceof Model) {
					val types = (object as Model).types
					val result = types.findFirst[type |
						type.name.endsWith("." + uriFragment) || 
						type.name.equals(uriFragment)
					]
					if (result !== null)
						return result
				}
			}
			return super.getEObject(uriFragment)
		} else
			return super.getEObject(uriFragment)
	}

	/**
	 * Compute the uriFragment for a given EObject.
	 * 
	 * @param eObject the object the fragment is computed for.
	 * 
	 * @return returns the uriFragment for the given object.
	 */
	override String getURIFragment(EObject eObject) {
		if (eObject instanceof Type) {
			return (eObject as Type).name
		} else {
			return super.getURIFragment(eObject)
		}
	}

	/**
	 * load the resource iff it is not already loaded.
	 */
	override void load(Map<?, ?> options) throws IOException {
		if (!this.isLoaded) {
			this.doLoad(null, null)
		}
	}

	/**
	 * Saving this resource is not allowed, as it is a virtual resource.
	 */
	override void save(Map<?, ?> options) throws IOException {
		throw new UnsupportedOperationException()
	}

	/**
	 * This routine is called from ResourceImpl load after the load method above is triggered.
	 * It initializes the primitive type mirror.
	 * 
	 * @param inputStream
	 * @param options
	 * 
	 * @throws IOException
	 */
	override void doLoad(InputStream inputStream, Map<?, ?> options) throws IOException {
		if (this.getURI() !== null) {
			this.createModel()
		} else {
			try {
				throw new IOException("URI not set on ForeignModelResource.onLoad");
			} catch (IOException e) {
				e.printStackTrace()
			}
		}
	}

	/**
	 * Return prepared set over all inferred types.
	 */	
	public def Iterable<Type> getAllTypes() {
		modelTypes
	}

	/**
	 * Create an result model for a given ecore model.
	 */
	private synchronized def createModel() {
		if (!this.isLoaded) {
			val models = new HashMap<String,Model>()
			val typeMap = new HashMap<Class<?>,ComplexType>()
			val sourceTypes = new ArrayList<Class<?>>
			
			val file  = new File("/home/reiner/Projects/Kieker/irl/kieker.develop.rl.cli/lib/kieker.jar")
			val url = file.toURI().toURL  
			val urls = #[url]

			val cl = new URLClassLoader(urls)
			
			val cp=ClassPath.from(cl)
			
			/** find all types which are related to IMonitoringRecord. */
			cp.getTopLevelClassesRecursive("kieker.common.record").forEach[classInfo |
				val clazz = classInfo.load
				if (clazz.inherits("kieker.common.record.IMonitoringRecord") && 
					!EXCLUDE_CLASSES.exists[it == clazz.canonicalName]
				) {
					println("process " + clazz.canonicalName)
					val type = clazz.createComplexType
					typeMap.put(clazz, type)
					models.addType(clazz, type)
					modelTypes.add(type)
					sourceTypes.add(clazz)
				}
			]
		
				
			/** link types. */
			sourceTypes.forEach[clazz | clazz.linkType(typeMap)]
			
			
			models.values.forEach[v |
				println("> model " + v.name)
				v.types.forEach[t |
					println("\t> " + t.name + " contained " + (t.eContainer !== null))
					step()
				]
			]
			
			println("-- " + i + " " + sourceTypes.size + " " + modelTypes.size)
			
			if(models.values !== null) {
				this.getContents().addAll(models.values)
			}
		}
	}
	
	private def void step() {
		i++
	}
	
	private def boolean inherits(Class<?> clazz, String ifaceName) {
		if (clazz.canonicalName.equals(ifaceName))
			true
		else if (clazz.interfaces.exists[iface | 
			ifaceName.equals(iface.canonicalName) || iface.inherits(ifaceName)
		]) 
			true
		else if (clazz.superclass !== null)
			clazz.superclass.inherits(ifaceName)
		else
			false
	}
	
	private def void addType(HashMap<String, Model> models, Class<?> clazz, ComplexType type) {
		var model = models.get(clazz.package.name)
		if (model === null) {
			model = createModel(clazz)
			models.put(model.name, model)
		}
		model.types.add(type)
	}
	
	/**
	 * Link types.
	 */
	private def void linkType(Class<?> type, Map<Class<?>, ComplexType> typeMap) {
		val modelType = typeMap.get(type)
		if (modelType.eContainer !== null)
			println("type has container " + (modelType.eContainer as Model).name)
		else
			println("CONTAINER MISSING for " + modelType.name)
		switch(modelType) {
			TemplateType: {
				type.interfaces.forEach[iface |
					val template = typeMap.get(iface) 
					if (template !== null)
						modelType.inherits.add(template as TemplateType)
				]
				
			}
			EventType: {
				println("> " + type.canonicalName)
				type.interfaces.forEach[iface |
					val template = typeMap.get(iface) 
					if (template !== null) {
						println("\t" + " implements " + iface.canonicalName)
						modelType.inherits.add(template as TemplateType)
					}
				]
				if (type.superclass !== null) {
					val parentType = typeMap.get(type.superclass)
					if (parentType !== null) {
						println("\t" + " extends " + type.superclass.canonicalName)
						modelType.parent = parentType as EventType
					}
				}
			}
		}
	}
	
	private def Model createModel(Class<?> clazz) {
		val model = rlFactory.createModel
		model.name = clazz.package.name
		return model
	}
	
	private def ComplexType createComplexType(Class<?> type) {
		if (type.isInterface)
			type.createTemplateType
		else
			type.createEventType
	}
	
	private def EventType createEventType(Class<?> type) {
		// println("EVENT " + type.canonicalName)
		val result = rlFactory.createEventType
		
		result.name = type.simpleName
		result.createAttributes(type)
		
		return result
	}
	
	private def TemplateType createTemplateType(Class<?> type) {
		// println("TEMPLATE " + type.canonicalName)
		val result = rlFactory.createTemplateType
		
		result.name = type.simpleName
		result.createAttributes(type)
		
		return result
	}
	
	/**
	 * Create constants and properties based on methods of
	 * an interface declaration.
	 * 
	 * @param result the template type which is extended by constant and property declarations
	 * @param type the class used to infer the constants and properties from
	 */
	def void createAttributes(TemplateType result, Class<?> type) {
		type.methods.forEach[method |
			if ((method.modifiers.bitwiseAnd(Modifier.PUBLIC)) == Modifier.PUBLIC) {
				if (method.name.startsWith("get") &&
					!"getLoggingTimestamp".equals(method.name) &&
					!"getValueTypes".equals(method.name) &&
					!"getValueNames".equals(method.name)
				) {
					/** create property */
					val property = rlFactory.createProperty
					property.name = method.name.substring(3).toFirstLower
					property.type = method.returnType.createIRLType
				
					// TODO add constant and transient features later
					if (property.type === null) {
						createError(type.name, method.returnType.canonicalName, "property", property.name)
					} else {
						result.properties.add(property)
					}
				} else if (method.name.startsWith("is")) {
					/** create property */
					val property = rlFactory.createProperty
					property.name = method.name.substring(2).toFirstLower
					property.type = method.returnType.createIRLType
					
					// TODO add constant and transient features later
					if (property.type === null) {
						createError(type.name, method.returnType.canonicalName, "property", property.name)
					} else {
						result.properties.add(property)
					}
				}	
			}
		]
	}
		
	/**
	 * Create constants and properties based on fields of
	 * a class declaration.
	 * 
	 * @param result the event type which is extended by constant and property declarations
	 * @param type the class used to infer the constants and properties from
	 */
	def void createAttributes(EventType result, Class<?> type) {
		type.fields.forEach[field |
			if ((field.modifiers.bitwiseAnd(Modifier.PUBLIC) == Modifier.PUBLIC) &&
				(field.modifiers.bitwiseAnd(Modifier.STATIC) == Modifier.STATIC) &&
				(field.modifiers.bitwiseAnd(Modifier.FINAL) == Modifier.FINAL)) {
				if (!field.name.startsWith("TYPE_SIZE") && 
					!"TYPES".equals(field.name) && 
					!field.name.startsWith("CACHED_KIEKERRECORDS")) {
					/** create constants */
					val constant = rlFactory.createConstant
					constant.name = field.name
					constant.type = field.type.createIRLType
					constant.value = field.type.createLiteral
					
					if (constant.type === null) {
						createError(type.name, field.type.canonicalName, "constant", constant.name)
					} else {
						result.constants.add(constant)
					}
				}
			} else if ((field.modifiers.bitwiseAnd(Modifier.PRIVATE) == Modifier.PRIVATE) &&
				(field.modifiers.bitwiseAnd(Modifier.STATIC) == 0) &&
				(field.modifiers.bitwiseAnd(Modifier.FINAL) == Modifier.FINAL)) {
				/** create property */
				val property = rlFactory.createProperty
				property.name = field.name
				property.type = field.type.createIRLType
				// TODO add constant and transient features later
				if (property.type === null) {
					createError(type.name, field.type.canonicalName, "property", property.name)
				} else {
					result.properties.add(property)
				}
			}			
		]
	}
	
	/**
	 * Create an error message in the problem list of Eclipse.
	 * 
	 * @param name name of the Java type
	 * @param attributeTypeSignature type signature of the attribute (constant/property)
	 * @param kind is either constant or property
	 * @param attributeName is the name of the processed attribute
	 */
	private def void createError(String name, String attributeTypeSignature, String kind, String attributeName) {
		println("Kieker type " + name + " contains unsupported type " 
			+ attributeTypeSignature + " in " + kind + " declaration " + attributeName
		)
	}
	
	private def Literal createLiteral(Object object) {
		switch (object) {
			Integer: {
				val result = rlFactory.createIntLiteral
				result.value = object
				return result
			}
			Byte: {
				val result = rlFactory.createIntLiteral
				result.value = object
				return result
			}
			Boolean: {
				val result = rlFactory.createBooleanLiteral
				result.value = object
				return result
			}
			Character: {
				val result = rlFactory.createStringLiteral
				result.value = object.toString
				return result
			}
			Double: {
				val result = rlFactory.createFloatLiteral
				result.value = object.floatValue
				return result
			}
			Float: {
				val result = rlFactory.createFloatLiteral
				result.value = object
				return result
			}
			Long: {
				val result = rlFactory.createIntLiteral
				result.value = object.intValue
				return result
			}
			Short: {
				val result = rlFactory.createIntLiteral
				result.value = object.shortValue
				return result
			}
			String: {
				val result = rlFactory.createStringLiteral
				result.value = object
				return result
			}
			default: null	
		}
	}
	
	private def Classifier createIRLType(Class<?> clazz) {
		clazz.canonicalName.createType
	}
	
	private def Classifier createType(String typeId) {
		val classifier = rlFactory.createClassifier
		var id = typeId 
		while (id.startsWith("[")) {
			id = id.substring(1)
			classifier.sizes += createArraySize(0)
		}
		switch(id) {
			case "byte": classifier.type = BaseTypes.BYTE.getType
			case "char": classifier.type = BaseTypes.CHAR.getType
			case "double": classifier.type = BaseTypes.DOUBLE.getType
			case "float": classifier.type = BaseTypes.FLOAT.getType
			case "int": classifier.type = BaseTypes.INT.getType
			case "long": classifier.type = BaseTypes.LONG.getType
			case "short": classifier.type = BaseTypes.SHORT.getType
			case "boolean": classifier.type = BaseTypes.BOOLEAN.getType
			case "java.lang.String": classifier.type = BaseTypes.STRING.getType
			default:
				return null
		}
		
		return classifier
	}
	
	def createArraySize(int size) {
		val result = rlFactory.createArraySize
		result.size = size
		return result
	}
	
}