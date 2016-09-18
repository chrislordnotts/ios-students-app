//
//  UploadStudentsViewController.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 18/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UploadStudentsViewController: UIViewController {
	@IBOutlet weak var activityView : UIActivityIndicatorView?;
	
	override func viewDidAppear(_ animated: Bool) {
		// Begin the synchronisation process
		let appDelegate = UIApplication.shared.delegate as! AppDelegate;
		let managedObjectContext = appDelegate.dataSource!.managedObjectContext;
		let request = NSFetchRequest<NSFetchRequestResult>();
		let entity = NSEntityDescription.entity(forEntityName: "Student", in: managedObjectContext!);
		request.entity = entity;
		
		
		
		do {
			var serializableOut : Array<Dictionary<String, String>> = [];
			
			// Perform the request and then iterate over each result
			let results = try managedObjectContext!.fetch(request) as! [Student];
			for index in 0..<results.count {
				let student = results[index];
				var genderIsMaleStr = "false";
				if(student.isMale) {
					genderIsMaleStr = "true";
				}
				
				// Create a serializable representation
				let dictionary = [
					"firstName" : student.firstName!,
					"lastName" : student.lastName!,
					"isMale" : genderIsMaleStr,
					"email" : student.email!,
					"id" : student.recordId!,
					"universityId" : String(student.universityId)
				] as Dictionary<String, String>
				serializableOut.append(dictionary)
			}
			
			let json = try JSONSerialization.data(withJSONObject: serializableOut, options: .prettyPrinted);
			print(json);
		} catch _ {
			print("Query failed.");
			
		}
//		if let result = managedObjectContext.
		
		super.viewDidAppear(animated);
	}
}
