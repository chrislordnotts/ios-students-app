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

//
// The new student view controller allows the user to enter some information
// about a student and have the record stored permanently in Core Data - until
// it is uploaded that is.
//
class NewStudentViewController: ViewController, UITextFieldDelegate {
	
	@IBOutlet weak var firstNameField : UITextField?;
	@IBOutlet weak var lastNameField : UITextField?;
	@IBOutlet weak var emailField : UITextField?;
	@IBOutlet weak var maleButton : UIButton?;
	@IBOutlet weak var femaleButton : UIButton?;
	@IBOutlet weak var saveButton : UIBarButtonItem?;
	@IBOutlet weak var universityPicker : UIPickerView?;
	@IBOutlet weak var maleIndicatorImage : UIImageView?;
	@IBOutlet weak var femaleIndicatorImage : UIImageView?;
	@IBOutlet weak var emailErrorLabel : UILabel?;
	@IBOutlet weak var firstNameErrorLabel : UILabel?;
	@IBOutlet weak var lastNameErrorLabel : UILabel?;
	
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
			// Fetch the information required to create a new student record
			let university : NSDictionary = (self.universityDataSource?.selectedUniversity())!;
			let universityId : NSNumber = university.object(forKey: "uniqueId") as! NSNumber;
			let firstName = self.firstNameField!.text!;
			let lastName = self.lastNameField!.text!;
			let email = self.emailField!.text!;
			let isMale = self.isMale;
			
			// Create a student on the main thread context
			let appDelegate = UIApplication.shared.delegate as! AppDelegate;
			let managedObjectContext = appDelegate.dataSource!.managedObjectContext!;
			_ = Student.create(firstName: firstName, lastName: lastName, email: email, isMale: isMale, universityId: universityId.int64Value, context: managedObjectContext);
		
			do {
				try managedObjectContext.save();
				_ = self.navigationController?.popViewController(animated: true);
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
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		switch(textField.tag) {
		case 0:
			_ = self.validateFirstName();
			break;
			
		case 1:
			_ = self.validateLastName();
			break;
			
		case 2:
			_ = self.validateEmail();
			break;
			
		default:
			// Do nothing..
			break;
		}
		
		return true;
	}
	
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
		
		return true;
	}

	// MARK: - Form validation by component
	
	// Updates the look of the gender buttons based on the 
	// current value of self.isMale
	internal func updateGenderUI() {
		
		if isMale {
			self.maleButton!.setTitleColor(UIColor.green, for: .normal);
			self.femaleButton!.setTitleColor(UIColor.gray, for: .normal);
			
			self.maleIndicatorImage!.image = UIImage(named: "circle-check-green");
			self.femaleIndicatorImage!.image = UIImage(named: "circle-check-gray");
		} else {
			self.maleButton!.setTitleColor(UIColor.gray, for: .normal);
			self.femaleButton!.setTitleColor(UIColor.green, for: .normal);
			self.maleIndicatorImage!.image = UIImage(named: "circle-check-gray");
			self.femaleIndicatorImage!.image = UIImage(named: "circle-check-green");
		}
	}
	
	// If the users first name field is empty then this method
	// will highlight it in red, make it the first responder and
	// then return false. If returning true, then the first name
	// field contains a valid name.
	internal func validateFirstName() -> Bool {
		self.firstNameField?.borderStyle = .roundedRect;
		self.firstNameField?.layer.borderWidth = 1.0;
		self.firstNameErrorLabel?.isHidden = true;
		
		// Validate the users first name
		let firstName = self.firstNameField!.text!
		if(firstName.characters.count == 0) {
			// There is no text here at the moment
			self.firstNameErrorLabel?.text = "cannot be empty";
			self.firstNameErrorLabel?.isHidden = false;
			self.firstNameField?.layer.borderColor = UIColor.red.cgColor
			self.firstNameField?.becomeFirstResponder()
			return false
		} else {
			self.firstNameField?.layer.borderColor = UIColor.green.cgColor
			return true
		}
	}
	
	// If the users last name field is empty then this method
	// should highlight it, make it the first responder and let
	// the caller know by returning false. If this method returns
	// true then the last name contains a valid name.
	internal func validateLastName() -> Bool {
		self.lastNameField?.borderStyle = .roundedRect;
		self.lastNameField?.layer.borderWidth = 1.0;
		self.lastNameErrorLabel?.isHidden = true;
		
		// Validate the users last name
		let lastName = self.lastNameField!.text!
		if(lastName.characters.count == 0) {
			// There is no text here at the moment
			self.lastNameErrorLabel?.text = "cannot be empty";
			self.lastNameErrorLabel?.isHidden = false;
			self.lastNameField?.layer.borderColor = UIColor.red.cgColor
			self.lastNameField?.becomeFirstResponder()
			return false
		} else {
			self.lastNameField?.layer.borderColor = UIColor.green.cgColor
			return true
		}
	}
	
	// Checks to see if the enterered email address
	// is valid or not. It will highlight an invalid
	// email as well as making it the first responder.
	internal func validateEmail() -> Bool {
		self.emailField?.borderStyle = .roundedRect;
		self.emailField?.layer.borderWidth = 1.0;
		self.emailErrorLabel?.isHidden = true;

		// Validate the email address field
		let email = self.emailField!.text!
		if(email.characters.count == 0) {
			// There is no text here at the moment
			self.emailErrorLabel?.text = "cannot be empty";
			self.emailErrorLabel?.isHidden = false;
			self.emailField?.layer.borderColor = UIColor.red.cgColor
			self.emailField?.becomeFirstResponder()
			return false
		} else {
			if(email.isValidEmail()) {
				// We have text and it is valid
				self.emailField?.layer.borderColor = UIColor.green.cgColor
				return true
			} else {
				// We have text and it is not valid
				self.emailErrorLabel?.text = "not a valid email";
				self.emailErrorLabel?.isHidden = false;
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
