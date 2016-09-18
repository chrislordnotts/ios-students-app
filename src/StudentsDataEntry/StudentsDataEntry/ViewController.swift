//
//  ViewController.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import UIKit

// This view controller is completely automated
// via the main storyboard.
class ViewController: UIViewController {
	@IBOutlet weak var uploadButton : UIButton?;
	@IBOutlet weak var addStudentButton : UIButton?;
	@IBOutlet weak var uploadUserImage : UIImageView?;
	@IBOutlet weak var addUserImage : UIImageView?;
	
	override func viewWillAppear(_ animated: Bool) {
		self.uploadButton?.isEnabled = Student.hasStudentsToUpload()
	}
	
}

