//
//  StudentsDataEntryTests.swift
//  StudentsDataEntryTests
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import XCTest

@testable import StudentsDataEntry

class StudentsDataEntryTests: XCTestCase {
	var dataSource : PersistentDataSource? = nil;
	
	// Called before each test.
    override func setUp() {
        super.setUp()
		
		do {
			// Create the persistent store for testing
			let model = "StudentsDataEntry";
			let url = self.persistentStoreURL();
			self.dataSource = try PersistentDataSource(storePath: url, modelName: model);
		} catch let error as NSError {
			XCTAssert(false, "Failed to initialize data store: \(error.localizedDescription)");
		}
    }
	
	// Called after each test
    override func tearDown() {
        super.tearDown()
    }
	
	// MARK: - Helper Methods
	
	func testPlaceholder() {
	}

	// @return URL pointing to the user document directory.
	func persistentStoreURL() -> URL {
		// This is a generic apple-provided segment for getting the home directory
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[urls.count - 1].appendingPathComponent("data.sqlite");
	}
}
