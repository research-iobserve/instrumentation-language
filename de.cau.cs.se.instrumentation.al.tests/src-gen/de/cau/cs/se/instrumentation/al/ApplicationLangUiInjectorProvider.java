/*
* generated by Xtext
*/
package de.cau.cs.se.instrumentation.al;

import org.eclipse.xtext.junit4.IInjectorProvider;

import com.google.inject.Injector;

public class ApplicationLangUiInjectorProvider implements IInjectorProvider {
	
	public Injector getInjector() {
		return de.cau.cs.se.instrumentation.al.ui.internal.ApplicationLangActivator.getInstance().getInjector("de.cau.cs.se.instrumentation.al.ApplicationLang");
	}
	
}