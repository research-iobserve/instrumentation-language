package kieker.develop.rl.generator.perl

import java.util.Collection
import kieker.develop.rl.generator.IGeneratorProvider
import kieker.develop.rl.ouput.config.AbstractOutletConfiguration
import kieker.develop.rl.recordLang.ComplexType

class GeneratorProvider implements IGeneratorProvider<ComplexType, CharSequence> {
	
	public static String LANG_PERL = "perl"
	
	public static String TECH_KIEKER_PERL = "kieker-perl"	
	
	override addOutletConfigurations(Collection<AbstractOutletConfiguration<ComplexType, CharSequence>> configurations) {
		configurations += new PerlOutletConfiguration()
	}
	
}