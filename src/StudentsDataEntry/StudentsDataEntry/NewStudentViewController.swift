//
//  NewStudentViewController.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import Foundation
import UIKit

// Manages the data entry view controller for adding new students.
class NewStudentViewController: ViewController, UITextFieldDelegate {
	
	@IBOutlet weak var firstNameField : UITextField?;
	@IBOutlet weak var lastNameField : UITextField?;
	@IBOutlet weak var universityNameField : UITextField?;
	@IBOutlet weak var emailField : UITextField?;
	@IBOutlet weak var maleButton : UIButton?;
	@IBOutlet weak var femaleButton : UIButton?;
	@IBOutlet weak var saveButton : UIBarButtonItem?;
	
	var isMale : Bool = true;
	
	// MARK: - UI Events
	
	// Event handler for when the user presses the male button
	@IBAction func didPressMaleButton() {
		print("Did press male button");
	}
	
	// Event handler for when the user presses the female button
	@IBAction func didPressFemaleButton() {
		print("Did press female button");
	}
	
	// Event handler for when the save button is pressed
	@IBAction func didPressSaveButton() {
		print("Did press save button");
	}
	
	// Event handler for when any text field has changed
	@IBAction func textFieldValueChanged() {
		print("Text field changed");
	}
	
	// MARK: - UITextFieldDelete
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		// Each element on the interface has a meta field called 'tag'.
		// This tag allows us to manually select which element should
		// be focused next.
		let nextTag = textField.tag + 1;
		let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
		if(nextResponder != nil) {
			nextResponder?.becomeFirstResponder();
		} else {
			textField.resignFirstResponder();
		}
		
		return false;
	}
	
}
