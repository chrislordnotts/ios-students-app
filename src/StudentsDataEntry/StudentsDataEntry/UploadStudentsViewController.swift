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
			var request = NSMutableURLRequest();
			request.url = URL(string: Globals.StudentsUploadEndpoint);
			request.httpMethod = "POST";
			request.cachePolicy = .reloadIgnoringLocalCacheData;
			request.setValue(Globals.JSONContentType, forHTTPHeaderField: "Content-Type");
			request.httpBody = json;

			// Create the data session task that will perform our request
			let config = URLSessionConfiguration.default;
			let session = URLSession(configuration: config)
			let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
				// The request has finished
				print(error);
				print(response);
				print(data);
			});
			
			task.resume();
		} catch _ {
			print("Fatal. Database Query Failed.");
			_ = self.navigationController?.popViewController(animated: true);
			
		}

		super.viewDidAppear(animated);
	}
}
