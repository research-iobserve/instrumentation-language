package de.cau.cs.se.instrumentation.rl.serializer;

import com.google.inject.Inject;
import de.cau.cs.se.instrumentation.rl.services.RecordLangGrammarAccess;
import java.util.List;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.IGrammarAccess;
import org.eclipse.xtext.RuleCall;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.serializer.analysis.GrammarAlias.AbstractElementAlias;
import org.eclipse.xtext.serializer.analysis.GrammarAlias.GroupAlias;
import org.eclipse.xtext.serializer.analysis.GrammarAlias.TokenAlias;
import org.eclipse.xtext.serializer.analysis.ISyntacticSequencerPDAProvider.ISynNavigable;
import org.eclipse.xtext.serializer.analysis.ISyntacticSequencerPDAProvider.ISynTransition;
import org.eclipse.xtext.serializer.sequencer.AbstractSyntacticSequencer;

@SuppressWarnings("all")
public class RecordLangSyntacticSequencer extends AbstractSyntacticSequencer {

	protected RecordLangGrammarAccess grammarAccess;
	protected AbstractElementAlias match_PartialRecordType___LeftCurlyBracketKeyword_5_0_RightCurlyBracketKeyword_5_2__q;
	protected AbstractElementAlias match_Property___LeftCurlyBracketKeyword_2_0_0_RightCurlyBracketKeyword_2_0_2__q;
	protected AbstractElementAlias match_RecordType___LeftCurlyBracketKeyword_7_0_RightCurlyBracketKeyword_7_2__q;
	
	@Inject
	protected void init(IGrammarAccess access) {
		grammarAccess = (RecordLangGrammarAccess) access;
		match_PartialRecordType___LeftCurlyBracketKeyword_5_0_RightCurlyBracketKeyword_5_2__q = new GroupAlias(false, true, new TokenAlias(false, false, grammarAccess.getPartialRecordTypeAccess().getLeftCurlyBracketKeyword_5_0()), new TokenAlias(false, false, grammarAccess.getPartialRecordTypeAccess().getRightCurlyBracketKeyword_5_2()));
		match_Property___LeftCurlyBracketKeyword_2_0_0_RightCurlyBracketKeyword_2_0_2__q = new GroupAlias(false, true, new TokenAlias(false, false, grammarAccess.getPropertyAccess().getLeftCurlyBracketKeyword_2_0_0()), new TokenAlias(false, false, grammarAccess.getPropertyAccess().getRightCurlyBracketKeyword_2_0_2()));
		match_RecordType___LeftCurlyBracketKeyword_7_0_RightCurlyBracketKeyword_7_2__q = new GroupAlias(false, true, new TokenAlias(false, false, grammarAccess.getRecordTypeAccess().getLeftCurlyBracketKeyword_7_0()), new TokenAlias(false, false, grammarAccess.getRecordTypeAccess().getRightCurlyBracketKeyword_7_2()));
	}
	
	@Override
	protected String getUnassignedRuleCallToken(EObject semanticObject, RuleCall ruleCall, INode node) {
		return "";
	}
	
	
	@Override
	protected void emitUnassignedTokens(EObject semanticObject, ISynTransition transition, INode fromNode, INode toNode) {
		if (transition.getAmbiguousSyntaxes().isEmpty()) return;
		List<INode> transitionNodes = collectNodes(fromNode, toNode);
		for (AbstractElementAlias syntax : transition.getAmbiguousSyntaxes()) {
			List<INode> syntaxNodes = getNodesFor(transitionNodes, syntax);
			if(match_PartialRecordType___LeftCurlyBracketKeyword_5_0_RightCurlyBracketKeyword_5_2__q.equals(syntax))
				emit_PartialRecordType___LeftCurlyBracketKeyword_5_0_RightCurlyBracketKeyword_5_2__q(semanticObject, getLastNavigableState(), syntaxNodes);
			else if(match_Property___LeftCurlyBracketKeyword_2_0_0_RightCurlyBracketKeyword_2_0_2__q.equals(syntax))
				emit_Property___LeftCurlyBracketKeyword_2_0_0_RightCurlyBracketKeyword_2_0_2__q(semanticObject, getLastNavigableState(), syntaxNodes);
			else if(match_RecordType___LeftCurlyBracketKeyword_7_0_RightCurlyBracketKeyword_7_2__q.equals(syntax))
				emit_RecordType___LeftCurlyBracketKeyword_7_0_RightCurlyBracketKeyword_7_2__q(semanticObject, getLastNavigableState(), syntaxNodes);
			else acceptNodes(getLastNavigableState(), syntaxNodes);
		}
	}

	/**
	 * Syntax:
	 *     ('{' '}')?
	 */
	protected void emit_PartialRecordType___LeftCurlyBracketKeyword_5_0_RightCurlyBracketKeyword_5_2__q(EObject semanticObject, ISynNavigable transition, List<INode> nodes) {
		acceptNodes(transition, nodes);
	}
	
	/**
	 * Syntax:
	 *     ('{' '}')?
	 */
	protected void emit_Property___LeftCurlyBracketKeyword_2_0_0_RightCurlyBracketKeyword_2_0_2__q(EObject semanticObject, ISynNavigable transition, List<INode> nodes) {
		acceptNodes(transition, nodes);
	}
	
	/**
	 * Syntax:
	 *     ('{' '}')?
	 */
	protected void emit_RecordType___LeftCurlyBracketKeyword_7_0_RightCurlyBracketKeyword_7_2__q(EObject semanticObject, ISynNavigable transition, List<INode> nodes) {
		acceptNodes(transition, nodes);
	}
	
}
