//
//  StringExt.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 18/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import Foundation

extension String {
	// This was reworked from an example at http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
	func isValidEmail() -> Bool {
		let pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
		do {
			let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive);
			return (regex.firstMatch(in: self, options: .anchored, range: NSMakeRange(0, self.characters.count)) != nil);
		} catch _ {
			return false;
		}
	}
}
