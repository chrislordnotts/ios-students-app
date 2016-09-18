//
//  NewStudentViewController.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
		
		if(self.validate()) {
			// Create a new Student object
			let appDelegate = UIApplication.shared.delegate as! AppDelegate;
			let managedObjectContext = appDelegate.dataSource!.managedObjectContext;
			let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: managedObjectContext!) as! Student
			
			let university : NSDictionary = (self.universityDataSource?.selectedUniversity())!;
			
			// Adopt values from the UI
			student.isMale = self.isMale;
			student.firstName = self.firstNameField!.text;
			student.lastName = self.lastNameField!.text;
			student.email = self.emailField!.text;
			student.recordId = NSUUID().uuidString;
			
			// Convert the university objects uniqueId from an NSNumber to Int64
			let universityId : NSNumber = university.object(forKey: "uniqueId") as! NSNumber;
			student.universityId = universityId.int64Value;
			
			do {
				try managedObjectContext?.save();
				self.navigationController?.popViewController(animated: true);
			} catch let error {
				// This error occurs when the context is used
				// across multiple threads and it's down to good
				// thread hygene to prevent this.
				print("Failed to save: \(error.localizedDescription)");
				let alert : UIAlertController = UIAlertController(title: "Failed to Save", message: "Internal Database Error - please cancel and try again.", preferredStyle: .alert);
				let dismiss : UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil);
				alert.addAction(dismiss);
				self.present(alert, animated: true, completion: nil);
			}
		} else {
			// Present an error informing the user they need to address the form
			let alert : UIAlertController = UIAlertController(title: "Oops", message: "You need to fill out all fields correctly before you can save.", preferredStyle: .alert);
			let dismiss : UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil);
			alert.addAction(dismiss);
			self.present(alert, animated: true, completion: nil);
		}
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

	// MARK: - Form validation by component
	
	internal func updateGenderUI() {
		if isMale {
			self.maleButton!.setTitleColor(UIColor.green, for: .normal);
			self.femaleButton!.setTitleColor(UIColor.gray, for: .normal);
		} else {
			self.maleButton!.setTitleColor(UIColor.gray, for: .normal);
			self.femaleButton!.setTitleColor(UIColor.green, for: .normal);
		}
	}
	
	internal func validateFirstName() -> Bool {
		self.firstNameField?.borderStyle = .roundedRect;
		self.firstNameField?.layer.borderWidth = 1.0;
		
		// Validate the users first name
		let firstName = self.firstNameField!.text!
		if(firstName.characters.count == 0) {
			// There is no text here at the moment
			self.firstNameField?.layer.borderColor = UIColor.red.cgColor
			self.firstNameField?.becomeFirstResponder()
			return false
		} else {
			self.firstNameField?.layer.borderColor = UIColor.green.cgColor
			return true
		}
	}
	
	internal func validateLastName() -> Bool {
		self.lastNameField?.borderStyle = .roundedRect;
		self.lastNameField?.layer.borderWidth = 1.0;
		
		// Validate the users last name
		let lastName = self.lastNameField!.text!
		if(lastName.characters.count == 0) {
			// There is no text here at the moment
			self.lastNameField?.layer.borderColor = UIColor.red.cgColor
			self.lastNameField?.becomeFirstResponder()
			return false
		} else {
			self.lastNameField?.layer.borderColor = UIColor.green.cgColor
			return true
		}
	}
	
	internal func validateEmail() -> Bool {
		self.emailField?.borderStyle = .roundedRect;
		self.emailField?.layer.borderWidth = 1.0;

		// Validate the email address field
		let email = self.emailField!.text!
		if(email.characters.count == 0) {
			// There is no text here at the moment
			self.emailField?.layer.borderColor = UIColor.red.cgColor
			self.emailField?.becomeFirstResponder()
			return false
		} else {
			if(email.isValidEmail()) {
				// We have text and it is valid
				self.emailField?.layer.borderColor = UIColor.gray.cgColor
				return true
			} else {
				// We have text and it is not valid
				self.emailField?.layer.borderColor = UIColor.red.cgColor
				self.emailField?.becomeFirstResponder()
				return false
			}
		}
	}
	
	// Manually checks the contents of each form field to ensure
	// that valid input has been entered.
	//
	// @return false if incomplete/invalid
	internal func validate() -> Bool {
		if self.validateFirstName() && self.validateLastName() && self.validateEmail() {
			return true;
		}
		
		return false;
	}
}
