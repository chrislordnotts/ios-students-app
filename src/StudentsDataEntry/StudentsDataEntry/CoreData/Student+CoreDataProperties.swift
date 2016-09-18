//
//  Student+CoreDataProperties.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student");
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var isMale: Bool
    @NSManaged public var lastName: String?
    @NSManaged public var recordId: String?
    @NSManaged public var universityId: Int64

}
