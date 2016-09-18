//
//  DependencyTests.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 18/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import XCTest

class DependencyTests: XCTestCase {
	func testEmail() {
		// Valid email addresses
		XCTAssert("chris.lord@flarepoint.org".isValidEmail() == true, "Expecting isValidEmail() to return true");
		XCTAssert("chris.lord+tracker@flarepoint.org".isValidEmail() == true, "Expecting isValidEmail() to return true");
		
		// Invalid email addresses
		XCTAssert("".isValidEmail() == false, "Expecting isValidEmail() to return false");
		XCTAssert("abc".isValidEmail() == false, "Expecting isValidEmail() to return false");
	}
}
