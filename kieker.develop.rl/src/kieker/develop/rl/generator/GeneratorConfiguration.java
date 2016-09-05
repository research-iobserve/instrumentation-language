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
package kieker.develop.rl.generator;

import java.util.ArrayList;
import java.util.Collection;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.IExtensionRegistry;
import org.eclipse.core.runtime.Platform;

import kieker.develop.rl.ouput.config.OutletConfiguration;

/**
 * Configuration and registration of IRL generators.
 * The class also contains functions for derived values based on the
 * configuration values.
 *
 * @author Reiner Jung
 *
 * @since 1.0
 *
 */
public final class GeneratorConfiguration {

	/** extension point name. */
	public static final String GENERATOR_PROVIDER = "kieker.develop.rl.generator.provider";
	/** extension point short name. */
	public static final String SHORT_EXTENSION_NAME = "provider";

	/**
	 * Empty default constructor.
	 */
	private GeneratorConfiguration() {
		// utility class nothing to do here
	}

	/**
	 * Collect and return all generators which consume an event type as input.
	 *
	 * @return Returns a collection of generator classes for event types
	 */
	public static Collection<Class<? extends AbstractRecordTypeGenerator>> getRecordTypeGenerators() {
		final Collection<Class<? extends AbstractRecordTypeGenerator>> generators = new ArrayList<Class<? extends AbstractRecordTypeGenerator>>();

		final IExtensionRegistry registry = Platform.getExtensionRegistry();
		final IConfigurationElement[] config = registry.getConfigurationElementsFor(GENERATOR_PROVIDER);

		for (final IConfigurationElement element : config) {
			try {
				final Object ext = element.createExecutableExtension(SHORT_EXTENSION_NAME);
				if (ext instanceof IGeneratorProvider) {
					final IGeneratorProvider generatorProvider = (IGeneratorProvider) ext;
					generators.addAll(generatorProvider.getRecordTypeGenerators());
				}
			} catch (final CoreException e) {
				e.printStackTrace();
			}
		}
		return generators;
	}

	/**
	 * Collect and return all generators which consume a template type as input.
	 *
	 * @return Returns a collection of generator classes for template types
	 */
	public static Collection<Class<? extends AbstractTemplateTypeGenerator>> getTemplateTypeGenerators() {
		final Collection<Class<? extends AbstractTemplateTypeGenerator>> generators = new ArrayList<Class<? extends AbstractTemplateTypeGenerator>>();

		final IExtensionRegistry registry = Platform.getExtensionRegistry();
		final IConfigurationElement[] config = registry.getConfigurationElementsFor(GENERATOR_PROVIDER);

		for (final IConfigurationElement element : config) {
			try {
				final Object ext = element.createExecutableExtension(SHORT_EXTENSION_NAME);
				if (ext instanceof IGeneratorProvider) {
					final IGeneratorProvider generatorProvider = (IGeneratorProvider) ext;
					generators.addAll(generatorProvider.getTemplateTypeGenerators());
				}
			} catch (final CoreException e) {
				e.printStackTrace();
			}
		}
		return generators;
	}

	/**
	 * Collect all outlets provided by the different generator providers.
	 *
	 * @return Returns a collection of outlet configurations
	 */
	public static Collection<OutletConfiguration> getOutletConfigurations() {
		final Collection<OutletConfiguration> outletConfigurations = new ArrayList<OutletConfiguration>();

		final IExtensionRegistry registry = Platform.getExtensionRegistry();

		final IConfigurationElement[] config = registry.getConfigurationElementsFor(GENERATOR_PROVIDER);

		for (final IConfigurationElement element : config) {
			try {
				final Object ext = element.createExecutableExtension(SHORT_EXTENSION_NAME);
				if (ext instanceof IGeneratorProvider) {
					final IGeneratorProvider generatorProvider = (IGeneratorProvider) ext;
					outletConfigurations.addAll(generatorProvider.getOutletConfigurations());
				}
			} catch (final CoreException e) {
				e.printStackTrace();
			}
		}
		return outletConfigurations;
	}

}
