/*
* generated by Xtext
*/
package de.cau.se.instrumentation.language;

import org.eclipse.xtext.junit4.IInjectorProvider;

import com.google.inject.Injector;

public class ProbeLangUiInjectorProvider implements IInjectorProvider {
	
	public Injector getInjector() {
		return de.cau.se.instrumentation.language.ui.internal.ProbeLangActivator.getInstance().getInjector("de.cau.se.instrumentation.language.ProbeLang");
	}
	
}
