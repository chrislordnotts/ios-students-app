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

typealias CompletionBlock = (String?) -> Void

//
// This view controller will present an activity indicator while
// it uploads users in batches to an API endpoint defined in Globals.
// Users are deleted only if the HTTP response code is 200 - users
// can attempt retry immediately as no data is lost.
//
class UploadStudentsViewController: UIViewController {
	@IBOutlet weak var activityView : UIActivityIndicatorView?;
	
	var uploadTask : URLSessionDataTask?;
	
	// Takes Array<Students> and serializes them into a JSON string
	internal func serializeStudents(_ students : Array<Student>) -> Data {
		var serializableOut : Array<Dictionary<String, String>> = [];
		
		// Perform the request and then iterate over each result
		for index in 0..<students.count {
			let student = students[index];
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
		
		// Turn the students into a JSON - represented by `Data` object
		return try! JSONSerialization.data(withJSONObject: serializableOut, options: .prettyPrinted);
	}
	
	// Fetches a limited number of users and uploads them to
	// the provided API endpoint. If the result is 200 then 
	// the CompletionBlock will have a nil error parameter.
	// This method also ensures that successfully uploaded 
	// users are cleaned from the local file system.
	internal func uploadBatchOfStudents(then: CompletionBlock?) {
		let students: Array<Student> = Student.loadStudents(max: Globals.NumberOfStudentsPerUpload);
		let json: Data = self.serializeStudents(students);
		
		// Setup the request to the server
		let request = NSMutableURLRequest();
		request.url = URL(string: Globals.StudentsUploadEndpoint);
		request.httpMethod = "POST";
		request.cachePolicy = .reloadIgnoringLocalCacheData;
		request.setValue(Globals.JSONContentType, forHTTPHeaderField: "Content-Type");
		request.httpBody = json;
		
		// Create the data session task that will perform our request
		let config = URLSessionConfiguration.default;
		let session = URLSession(configuration: config)
		self.uploadTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
			if(error != nil) {
				then!("Failed to upload");
			} else {
				// Cast the response to a HTTPURLResponse to get the status code
				let httpResponse : HTTPURLResponse = response as! HTTPURLResponse;
				if(httpResponse.statusCode == 200) {
					let appDelegate = UIApplication.shared.delegate as! AppDelegate;
					let managedObjectContext = appDelegate.dataSource!.managedObjectContext;
					
					// Now we can clear out the database
					// by iterating over each student
					for index in 0..<students.count {
						let student = students[index];
						managedObjectContext!.delete(student);
					}
					
					do {
						try managedObjectContext!.save();
						then!(nil);
					} catch _ {
						// The data will remain in the database and be picked up on the next sync!
						then!("Failed to clear database after upload.");
					}
				} else {
					then!("Encountered a non-200 code from the server.");
				}
			}
		});
		
		// Start the task asynchronously
		self.uploadTask!.resume();
	}
	
	// Starts uploading students. On completion, if there are any
	// students left in the table (because of batching) then this 
	// function will recurse until all students have been uploaded.
	internal func beginUploadingStudents() {
		// Start uploading students
		self.uploadBatchOfStudents(then:{
			if($0 == nil) {
				if(Student.hasStudentsToUpload()) {
					print("Go again!");
					self.beginUploadingStudents();
				} else {
					// We completed successfully
					let alert : UIAlertController = UIAlertController(title: "Upload Complete", message: "Your data has been uploaded to the server.", preferredStyle: .alert);
					let dismiss : UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: {(_ : UIAlertAction) in
						_ = self.navigationController?.popViewController(animated: true);
					});
					alert.addAction(dismiss);
					self.present(alert, animated: true, completion: nil);
				}
			} else {
				// Present an error informing the user the upload failed at this time
				let alert : UIAlertController = UIAlertController(title: "Upload Failed", message: "Sorry, a problem was encountered while uploading studing data. Please try again later. You have not lost any data.", preferredStyle: .alert);
				let dismiss : UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: {(_ : UIAlertAction) in
					_ = self.navigationController?.popViewController(animated: true);
				});
				alert.addAction(dismiss);
				self.present(alert, animated: true, completion: nil);
			}
		});
	}


	// When the view appears, we will begin the upload of users
	// on the local disk.
	override func viewDidAppear(_ animated: Bool) {
		self.beginUploadingStudents();

		super.viewDidAppear(animated);
	}
	
	// Pressing the close button should cancel any asynchronous activity
	@IBAction func didPressCancelButton(sender : UIBarButtonItem) {
		if(self.uploadTask != nil) {
			self.uploadTask!.cancel();
		}
	}
}
