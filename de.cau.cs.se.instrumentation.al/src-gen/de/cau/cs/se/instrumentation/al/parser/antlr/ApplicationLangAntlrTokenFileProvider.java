/*
* generated by Xtext
*/
package de.cau.cs.se.instrumentation.al.parser.antlr;

import java.io.InputStream;
import org.eclipse.xtext.parser.antlr.IAntlrTokenFileProvider;

public class ApplicationLangAntlrTokenFileProvider implements IAntlrTokenFileProvider {
	
	public InputStream getAntlrTokenFile() {
		ClassLoader classLoader = getClass().getClassLoader();
    	return classLoader.getResourceAsStream("de/cau/cs/se/instrumentation/al/parser/antlr/internal/InternalApplicationLang.tokens");
	}
}
