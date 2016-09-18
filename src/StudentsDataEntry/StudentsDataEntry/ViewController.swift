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
		let studentsCount = Student.numberOfPendingStudents();
		if(studentsCount > 0) {
			self.uploadUserImage?.image = UIImage(named: "upload-students-icon");
			self.uploadUserImage?.isUserInteractionEnabled = true;
			self.uploadButton?.isEnabled = true;
			self.uploadButton?.setTitle("Upload \(studentsCount) Students", for: .normal);
		} else {
			self.uploadUserImage?.image = UIImage(named: "upload-students-icon-disabled");
			self.uploadUserImage?.isUserInteractionEnabled = false;
			self.uploadButton?.isEnabled = false;
			self.uploadButton?.setTitle("No Data", for: .normal);
		}
	}
	
}

