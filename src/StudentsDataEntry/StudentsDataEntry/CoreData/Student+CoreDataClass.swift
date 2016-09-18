//
//  Student+CoreDataClass.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Student: NSManagedObject {
	
	// Uses the shared managed object context.
	// Returns true if there are more students to upload
	public static func numberOfPendingStudents() -> Int {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate;
		let managedObjectContext = appDelegate.dataSource!.managedObjectContext;
		
		// Create a fetch request and set any options
		let request = NSFetchRequest<NSFetchRequestResult>();
		request.includesSubentities = false;
		
		// Assign the entity descriptor
		let entity = NSEntityDescription.entity(forEntityName: "Student", in: managedObjectContext!);
		request.entity = entity;
		
		do {
			return try managedObjectContext!.count(for: request);
		} catch _ {
			// This is an error only a developer is likely to encounter
			// returning true incorrectly will fail the user tests, yet
			// still keep the users application syncable.
			return -1;
		}
	}
	
	// Loads a set number of Student entities from Core Data
	public static func loadStudents(max : Int) -> Array<Student> {
		// Begin the synchronisation process
		let appDelegate = UIApplication.shared.delegate as! AppDelegate;
		let managedObjectContext = appDelegate.dataSource!.managedObjectContext;
		let request = NSFetchRequest<NSFetchRequestResult>();
		let entity = NSEntityDescription.entity(forEntityName: "Student", in: managedObjectContext!);
		
		request.entity = entity;
		request.fetchLimit = max;
		
		return try! managedObjectContext!.fetch(request) as! [Student]
	}
	
	// Create a new user
	public static func create(firstName: String, lastName: String, email: String, isMale : Bool, universityId: Int64, context: NSManagedObjectContext) -> Student {
		let entity = NSEntityDescription.entity(forEntityName: "Student", in: context);
		let student = Student(entity: entity!, insertInto: context);
		student.firstName = firstName;
		student.lastName = lastName;
		student.email = email;
		student.universityId = universityId;
		student.isMale = isMale;
		student.recordId = NSUUID().uuidString;
		return student;
	}
}
