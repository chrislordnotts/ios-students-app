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
			
			// Turn the students into a JSON - represented by `Data` object
			let json = try JSONSerialization.data(withJSONObject: serializableOut, options: .prettyPrinted);
			
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
			let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in

				if(error != nil) {
					// Present an error informing the user the upload failed at this time
					let alert : UIAlertController = UIAlertController(title: "Upload Failed", message: "Sorry, a problem was encountered while uploading studing data. Please try again later. You have not lost any data.", preferredStyle: .alert);
					let dismiss : UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil);
					alert.addAction(dismiss);
					self.present(alert, animated: true, completion: nil);
					_ = self.navigationController?.popViewController(animated: true);
				} else {
					// Cast the response to a HTTPURLResponse to get the status code
					let httpResponse : HTTPURLResponse = response as! HTTPURLResponse;
					if(httpResponse.statusCode == 200) {
						
						// Now we can clear out the database
						// by iterating over each student
						for index in 0..<results.count {
							let student = results[index];
							managedObjectContext!.delete(student);
						}
						
						do {
							try managedObjectContext!.save();
							
							// We've finished - tell the user this
							let alert : UIAlertController = UIAlertController(title: "Upload Complete", message: "Your data has been uploaded to the server.", preferredStyle: .alert);
							let dismiss : UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: {(_ : UIAlertAction) in
								_ = self.navigationController?.popViewController(animated: true);
							});
							alert.addAction(dismiss);
							self.present(alert, animated: true, completion: nil);
							
						} catch _ {
							// This error is fatal - solutions for this part typically revolve around
							let alert : UIAlertController = UIAlertController(title: "Failed To Clear", message: "Local data could not be cleaned. Will try again next time.", preferredStyle: .alert);
							let dismiss : UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: {(_ : UIAlertAction) in
								_ = self.navigationController?.popViewController(animated: true);
							});
							alert.addAction(dismiss);
							self.present(alert, animated: true, completion: nil);
						}
						
					} else {
						// Present an error informing the user the upload failed at this time
						let alert : UIAlertController = UIAlertController(title: "Upload Failed", message: "The server encountered an issue. Please try again later. You have not lost any data.", preferredStyle: .alert);
						let dismiss : UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: {(_ : UIAlertAction) in
							_ = self.navigationController?.popViewController(animated: true);
						});
						alert.addAction(dismiss);
						self.present(alert, animated: true, completion: nil);
					}
				}
			});
			
			task.resume();
		} catch _ {
			// This is caused by misconfiguration
			print("Fatal. Database Query Failed.");
			_ = self.navigationController?.popViewController(animated: true);
		}

		super.viewDidAppear(animated);
	}
}
