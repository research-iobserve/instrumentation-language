/**
 */
package de.cau.cs.se.instrumentation.al.aspectLang;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Node</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.se.instrumentation.al.aspectLang.Node#getConstraint <em>Constraint</em>}</li>
 * </ul>
 *
 * @see de.cau.cs.se.instrumentation.al.aspectLang.AspectLangPackage#getNode()
 * @model
 * @generated
 */
public interface Node extends EObject
{
  /**
   * Returns the value of the '<em><b>Constraint</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Constraint</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Constraint</em>' containment reference.
   * @see #setConstraint(PropertyConstraintExpression)
   * @see de.cau.cs.se.instrumentation.al.aspectLang.AspectLangPackage#getNode_Constraint()
   * @model containment="true"
   * @generated
   */
  PropertyConstraintExpression getConstraint();

  /**
   * Sets the value of the '{@link de.cau.cs.se.instrumentation.al.aspectLang.Node#getConstraint <em>Constraint</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Constraint</em>' containment reference.
   * @see #getConstraint()
   * @generated
   */
  void setConstraint(PropertyConstraintExpression value);

} // Node
