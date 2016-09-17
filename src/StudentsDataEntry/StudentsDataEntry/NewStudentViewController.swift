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
class NewStudentViewController: ViewController {
	
	@IBOutlet weak var firstNameField : UITextField?;
	@IBOutlet weak var lastNameField : UITextField?;
	@IBOutlet weak var universityNameField : UITextField?;
	@IBOutlet weak var emailField : UITextField?;
	@IBOutlet weak var maleButton : UIButton?;
	@IBOutlet weak var femaleButton : UIButton?;
	
	// MARK: - UI Events
	
	// Event handler for when the user presses the male button
	@IBAction func didPressMaleButton() {
		print("Did press male button");
	}
	
	// Event handler for when the user presses the female button
	@IBAction func didPressFemaleButton() {
		print("Did press female button");
	}
}
