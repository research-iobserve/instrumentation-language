/*
* generated by Xtext
*/
package de.cau.cs.se.instrumentation.al.parser.antlr;

import com.google.inject.Inject;

import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import de.cau.cs.se.instrumentation.al.services.ApplicationLangGrammarAccess;

public class ApplicationLangParser extends org.eclipse.xtext.parser.antlr.AbstractAntlrParser {
	
	@Inject
	private ApplicationLangGrammarAccess grammarAccess;
	
	@Override
	protected void setInitialHiddenTokens(XtextTokenStream tokenStream) {
		tokenStream.setInitialHiddenTokens("RULE_WS", "RULE_ML_COMMENT", "RULE_SL_COMMENT");
	}
	
	@Override
	protected de.cau.cs.se.instrumentation.al.parser.antlr.internal.InternalApplicationLangParser createParser(XtextTokenStream stream) {
		return new de.cau.cs.se.instrumentation.al.parser.antlr.internal.InternalApplicationLangParser(stream, getGrammarAccess());
	}
	
	@Override 
	protected String getDefaultRuleName() {
		return "Model";
	}
	
	public ApplicationLangGrammarAccess getGrammarAccess() {
		return this.grammarAccess;
	}
	
	public void setGrammarAccess(ApplicationLangGrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}
	
}
