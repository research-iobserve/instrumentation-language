/**
 */
package de.cau.cs.se.instrumentation.al.applicationLang;

import de.cau.cs.se.instrumantation.model.structure.Container;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Container Node</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link de.cau.cs.se.instrumentation.al.applicationLang.ContainerNode#getContainer <em>Container</em>}</li>
 * </ul>
 * </p>
 *
 * @see de.cau.cs.se.instrumentation.al.applicationLang.ApplicationLangPackage#getContainerNode()
 * @model
 * @generated
 */
public interface ContainerNode extends Node
{
  /**
   * Returns the value of the '<em><b>Container</b></em>' reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Container</em>' reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Container</em>' reference.
   * @see #setContainer(Container)
   * @see de.cau.cs.se.instrumentation.al.applicationLang.ApplicationLangPackage#getContainerNode_Container()
   * @model
   * @generated
   */
  Container getContainer();

  /**
   * Sets the value of the '{@link de.cau.cs.se.instrumentation.al.applicationLang.ContainerNode#getContainer <em>Container</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Container</em>' reference.
   * @see #getContainer()
   * @generated
   */
  void setContainer(Container value);

} // ContainerNode