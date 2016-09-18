//
//  UniversityTests.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 18/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import XCTest

class UniversityTests: XCTestCase {
	
	// Simply test that the university data source loads from
	// the disk without producing any exceptions
	func testUniversityLoadFromBundle() {
		let dataSource = UniversityDataSource();
		XCTAssert(dataSource.isAvailable(), "No data available!");
	}
}
