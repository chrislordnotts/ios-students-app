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
	@IBOutlet weak var universityPicker : UIPickerView?;
	
	var universityDataSource : UniversityDataSource? = nil;
	var isMale : Bool = true;
	
	// MARK: - UI Events
	
	override func viewDidLoad() {
		self.universityDataSource = UniversityDataSource();
		self.universityPicker?.dataSource = self.universityDataSource as UIPickerViewDataSource?;
		self.universityPicker?.delegate = self.universityDataSource as UIPickerViewDelegate?;
		self.universityPicker!.reloadAllComponents();
		self.updateGenderUI();
	}
	
	// Event handler for when the user presses the male button
	@IBAction func didPressMaleButton() {
		self.isMale = true;
		self.view.endEditing(true);
		
		// User interface updates
		self.view.endEditing(true);
		self.updateGenderUI();
	}
	
	// Event handler for when the user presses the female button
	@IBAction func didPressFemaleButton() {
		self.isMale = false;
		
		// User interface updates
		self.view.endEditing(true);
		self.updateGenderUI();
	}
	
	// Event handler for when the save button is pressed
	@IBAction func didPressSaveButton() {
	
	// Event handler for when any text field has changed
	@IBAction func textFieldValueChanged() {
		print("Text field changed");
	}
	
	// MARK: - UITextFieldDelegate
	
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
	
	// MARK: -
	
	internal func updateGenderUI() {
		if isMale {
			self.maleButton!.setTitleColor(UIColor.green, for: .normal);
			self.femaleButton!.setTitleColor(UIColor.gray, for: .normal);
		} else {
			self.maleButton!.setTitleColor(UIColor.gray, for: .normal);
			self.femaleButton!.setTitleColor(UIColor.green, for: .normal);
		}
	}
}
