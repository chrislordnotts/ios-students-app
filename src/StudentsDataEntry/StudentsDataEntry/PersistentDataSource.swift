//
//  PersistentDataSource.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import Foundation
import CoreData

enum PersistentStoreError: Error {
	case notImplemented
	case modelNotFound
}

class PersistentDataSource {
	
	var managedObjectModel : NSManagedObjectModel?;

	// @param storePath The path to manage the data source at.
	// @param modelName The name of the momd file to use
	init(storePath : URL, modelName : String) throws {
		try self.initManagedObjectModel(modelName: modelName);
		try self.initPersistentStoreCoordinator(path: storePath);
		try self.initManagedObjectContext();
	}
	
	// Initializes the managed object model by loading it from
	// the main application bundle.
	//
	// @throws PersistentStoreError.modelNotFound The model file does not exist in the main application bundle.
	internal func initManagedObjectModel(modelName : String) throws {
		// Determine if the model exists in the main bundle
		let url = Bundle.main.url(forResource: modelName, withExtension: "momd")!;
		if(!FileManager.default.fileExists(atPath: url.path)) {
			throw PersistentStoreError.modelNotFound;
		}
		
		self.managedObjectModel = NSManagedObjectModel(contentsOf: url);
	}
	
	// Initializes the persistent store - the location CoreData
	// will read and write data from. On the first load, this will
	// end up creating the database. On second load, this will not
	// only load the old database - but it will validate that it 
	// it conforms to the MOMD.
	internal func initPersistentStoreCoordinator(path : URL) throws {
		throw PersistentStoreError.notImplemented;
	}
	
	// Initializes the main object context for the master thread.
	internal func initManagedObjectContext() throws {
		throw PersistentStoreError.notImplemented;
	}
}
