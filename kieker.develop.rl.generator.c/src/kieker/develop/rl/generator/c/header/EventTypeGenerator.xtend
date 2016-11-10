/***************************************************************************
 * Copyright 2016 Kieker Project (http://kieker-monitoring.net)
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
package kieker.develop.rl.generator.c.header

import kieker.develop.rl.generator.TypeInputModel
import kieker.develop.rl.recordLang.Property
import kieker.develop.rl.recordLang.EventType

import static extension kieker.develop.rl.generator.c.CommonCFunctionsExtension.*
import static extension kieker.develop.rl.typing.PropertyResolution.*
import static extension kieker.develop.rl.typing.TypeResolution.*
import kieker.develop.rl.recordLang.Type
import kieker.develop.rl.generator.ITypeGenerator

class EventTypeGenerator implements ITypeGenerator<EventType, CharSequence> {
	
		
	override accepts(Type type) {
		if (type instanceof EventType)
			!(type as EventType).abstract
		else
			false
	}

	/**
	 * Primary code generation template.
	 * 
	 * @params type
	 * 		one record type to be used to create monitoring record
	 */
	override generate(TypeInputModel<EventType> input) {
		'''
			«input.header»#include <stdlib.h>
			#include <kieker.h>
			
			/*
			 * Author: «if (input.type.author == null) input.author else input.type.author»
			 * Version: «if (input.type.since == null) input.version else input.type.since»
			 */
			«input.type.createStructure»
			
			«input.type.createSerializerDeclaration»
		'''
	}

	private def createStructure(EventType type) '''
		typedef struct {
			«type.collectAllDataProperties.map[createPropertyDeclaration].join»
		} «type.packageName»_«type.name.cstyleName»;
	'''

	private def createPropertyDeclaration(Property property) '''
		«property.findType.createTypeName» «property.name»;
	'''

	/**
	 * Generate the serializer for the given record type.
	 */
	private def createSerializerDeclaration(
		EventType type) '''
		/*
		 * Serialize an «type.name» and return the size of the written structure.
		 *
		 * buffer = the buffer to send the data
		 * id = id to identify the record type
		 * offset = store data to buffer at offset
		 * value = the value to be stored
		 *
		 * returns size of written structure
		 */
		int «type.packageName»_«type.name.cstyleName»_serialize(char *buffer, const int id, const int offset, const «type.packageName»_«type.name.cstyleName» value);
	'''

}
