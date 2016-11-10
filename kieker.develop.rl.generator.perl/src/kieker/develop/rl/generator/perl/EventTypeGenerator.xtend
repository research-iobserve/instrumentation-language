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
package kieker.develop.rl.generator.perl

import java.util.Collection
import kieker.develop.rl.generator.TypeInputModel
import kieker.develop.rl.recordLang.Classifier
import kieker.develop.rl.recordLang.Model
import kieker.develop.rl.recordLang.Property
import kieker.develop.rl.recordLang.EventType

import static extension kieker.develop.rl.typing.PropertyResolution.*
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
	 * Create a perl based record for kieker
	 */
	override generate(TypeInputModel<EventType> input) {
		val definedAuthor = if (input.type.author == null) input.author else input.type.author
		val definedVersion = if (input.type.since == null) input.version else input.type.since
		'''
		use strict;
		use warnings;
		
		package «input.type.recordName»;
		
		=head1 NAME
		
		«input.type.recordName» 
		
		=head1 SYNOPSIS
		
		 my $record = «input.type.recordName»->new(«input.type.collectAllDataProperties.createParameterCall»);
		 
		 $writer->write($record->genoutput());
		
		=head1 DESCRIPTION
		
		Auto-generated structures.
		Author: «definedAuthor»
		Since: «definedVersion»
				
		=head1 METHODS
		
		=head2 $record = «input.type.recordName»->new(«input.type.collectAllDataProperties.createParameterCall»);
		
		Creates a new record with the given parameters.
		
		=cut
		
		sub new {
		  my («input.type.collectAllDataProperties.createParameterCall») = @_;
		  my $this = {
		    «input.type.collectAllDataProperties.map[createProperty].join(',\n')»
		  };
		
		  return bless($this,$type);
		}
		
		=head2 $string = $record->genoutput();
		
		Serializes the record for output. Returns the serialized form of the record.
						
		=head1 COPYRIGHT and LICENCE
		
		«input.header»
		
		=cut
		'''
	}
	
	/**
	 * Create perl type names.
	 * Most likely this routine is never used, as perl sucks in typing.
	 */
	def createTypeName(Classifier classifier) {
		switch (classifier.type.name) {
			case 'string' : 'String'
			default : classifier.type.name
		}
	}
	
	/**
	 * Create one property for the type declaration.
	 */
	def createProperty(Property property) '''«property.name» => $«property.name»'''
	
	/**
	 * Compute the absolute Perl package name, which is a FQN name of the record.
	 */
	def recordName(EventType type) '''«(type.eContainer as Model).name.replace('.','::')»::«type.name»'''
		
	/**
	 * 
	 */
	def createParameterCall(Collection<Property> list) {
		list.map['''$«name»'''].join(', ')
	}
	
	
}