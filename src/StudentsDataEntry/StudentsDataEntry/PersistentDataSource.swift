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
	case modelLoadFailed
	case storeCreateFailed
	case storeLoadFailed
	case contextCreateFailed
}

class PersistentDataSource {
	
	var managedObjectModel : NSManagedObjectModel?;
	var coordinator : NSPersistentStoreCoordinator?;
	var managedObjectContext : NSManagedObjectContext?;

	// @param storePath The path to manage the data source at.
	// @param modelName The name of the momd file to use
	init(url : URL, modelName : String) throws {
		self.managedObjectModel = nil;
		self.managedObjectContext = nil;
		self.coordinator = nil;
		
		try self.initManagedObjectModel(modelName: modelName);
		try self.initPersistentStoreCoordinator(url: url);
		try self.initManagedObjectContext();
	}
	
	// Initializes the managed object model by loading it from
	// the main application bundle.
	//
	// @throws PersistentStoreError.modelNotFound The model file does not exist in the main application bundle.
	// @throws PersistentStoreError.modelLoadFailed The model exists but it could not be loaded.
	internal func initManagedObjectModel(modelName : String) throws {
		// Determine if the model exists in the main bundle
		let url = Bundle.main.url(forResource: modelName, withExtension: "momd")!;
		if(!FileManager.default.fileExists(atPath: url.path)) {
			throw PersistentStoreError.modelNotFound;
		}
		
		// Attempt to load the model
		self.managedObjectModel = NSManagedObjectModel(contentsOf: url);
		if(self.managedObjectModel == nil) {
			throw PersistentStoreError.modelLoadFailed
		}
	}
	
	// Initializes the persistent store - the location CoreData
	// will read and write data from. On the first load, this will
	// end up creating the database. On second load, this will not
	// only load the old database - but it will validate that it 
	// it conforms to the MOMD.
	//
	// @throw PersistentStoreError.storeCreateFailed Could not create the store object. Ensure that the URL is valid.
	// @throw PersistentStoreError.storeLoadFailed The store could not be loaded: ensure the correct model is being used.
	internal func initPersistentStoreCoordinator(url : URL) throws {
		
		print("initPersist");
		self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!);
		if(coordinator == nil) {
			throw PersistentStoreError.storeCreateFailed
		} else {
			do {
				try self.coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
			} catch let error as NSError {
				// This is a serious error that is caused by bad configuration
				// of the managed object model. In most scenarios, the best way
				// to recover is to delete the database. Obviously we'll loose
				// data in that scenario - but it is completely preventable by
				// being aware that model updates have to be done correctly.
				print("Failed to load persistent store: \(error.localizedDescription)");
				throw PersistentStoreError.storeLoadFailed
			}
		}
	}
	
	// Initializes the main object context for the master thread.
	//
	// @warn This should only ever be used on the master thread.
	// @throw PersistentStoreError.contextCreateFailed Failed to create the default read/write context.
	internal func initManagedObjectContext() throws {
		
		// Create the managed object context
		self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType);
		if(self.managedObjectContext == nil) {
			throw PersistentStoreError.contextCreateFailed
		}
		
		self.managedObjectContext?.persistentStoreCoordinator = self.coordinator;
	}
}
