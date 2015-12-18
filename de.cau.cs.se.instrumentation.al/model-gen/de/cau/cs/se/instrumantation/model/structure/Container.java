/**
 */
package de.cau.cs.se.instrumantation.model.structure;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Container</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.se.instrumantation.model.structure.Container#getModifier <em>Modifier</em>}</li>
 *   <li>{@link de.cau.cs.se.instrumantation.model.structure.Container#getOperations <em>Operations</em>}</li>
 *   <li>{@link de.cau.cs.se.instrumantation.model.structure.Container#getAttributes <em>Attributes</em>}</li>
 *   <li>{@link de.cau.cs.se.instrumantation.model.structure.Container#getType <em>Type</em>}</li>
 * </ul>
 *
 * @see de.cau.cs.se.instrumantation.model.structure.StructurePackage#getContainer()
 * @model
 * @generated
 */
public interface Container extends Containment, Feature {
	/**
	 * Returns the value of the '<em><b>Modifier</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Modifier</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Modifier</em>' reference.
	 * @see #setModifier(ContainerModifier)
	 * @see de.cau.cs.se.instrumantation.model.structure.StructurePackage#getContainer_Modifier()
	 * @model required="true"
	 * @generated
	 */
	ContainerModifier getModifier();

	/**
	 * Sets the value of the '{@link de.cau.cs.se.instrumantation.model.structure.Container#getModifier <em>Modifier</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Modifier</em>' reference.
	 * @see #getModifier()
	 * @generated
	 */
	void setModifier(ContainerModifier value);

	/**
	 * Returns the value of the '<em><b>Operations</b></em>' containment reference list.
	 * The list contents are of type {@link de.cau.cs.se.instrumantation.model.structure.Operation}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Operations</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Operations</em>' containment reference list.
	 * @see de.cau.cs.se.instrumantation.model.structure.StructurePackage#getContainer_Operations()
	 * @model containment="true"
	 * @generated
	 */
	EList<Operation> getOperations();

	/**
	 * Returns the value of the '<em><b>Attributes</b></em>' containment reference list.
	 * The list contents are of type {@link de.cau.cs.se.instrumantation.model.structure.Attribute}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Attributes</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Attributes</em>' containment reference list.
	 * @see de.cau.cs.se.instrumantation.model.structure.StructurePackage#getContainer_Attributes()
	 * @model containment="true"
	 * @generated
	 */
	EList<Attribute> getAttributes();

	/**
	 * Returns the value of the '<em><b>Type</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Type</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Type</em>' reference.
	 * @see #setType(TypeReference)
	 * @see de.cau.cs.se.instrumantation.model.structure.StructurePackage#getContainer_Type()
	 * @model
	 * @generated
	 */
	TypeReference getType();

	/**
	 * Sets the value of the '{@link de.cau.cs.se.instrumantation.model.structure.Container#getType <em>Type</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Type</em>' reference.
	 * @see #getType()
	 * @generated
	 */
	void setType(TypeReference value);

} // Container
