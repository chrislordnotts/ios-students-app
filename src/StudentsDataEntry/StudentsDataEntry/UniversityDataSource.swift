//
//  UniversityDataSource.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import Foundation
import UIKit

class UniversityDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
	var universities : Array<NSDictionary>?;
	var selectedIndex = 0;
	
	// Reads a static configuration file containing a list
	// of universities and loads it for enumeration.
	override init() {
		self.universities = nil;
		
		// Attempt to locate the built-in static configuration file
		let path = Bundle.main.path(forResource: "Config", ofType: "plist")
		if(path != nil) {
			// File found, now attempt to load it..
			let config = NSDictionary(contentsOfFile:path!);
			if(config != nil) {
				self.universities = config!["Universities"] as? Array<NSDictionary>
			}
		}
		
		super.init();
	}
	
	func isAvailable() -> Bool {
		return self.universities != nil;
	}
	
	func selectedUniversity() -> NSDictionary {
		return self.universities![self.selectedIndex];
	}
	
	// MARK: - UIPickerViewDataSource
	
	// @return The number of columns to show in the picker view
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1;
	}
	
	// @return The number of universities found in the configuration file
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if(self.universities != nil) {
			return self.universities!.count;
		} else {
			return 0;
		}
	}
	
	// MARK: - UIPickerViewDelegate
	
	// @return The name of the university for the picklist view
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if(self.universities != nil) {
			// Use a name from the universities array
			let university : NSDictionary = self.universities![row];
			let name : String? = university.value(forKey: "name") as! String?;
			return name;
		} else {
			// This shouldn't happen
			return "#badvalue";
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.selectedIndex = row
		print(self.selectedIndex);
	}
}
