//
//  UserReportEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/09/03.
//
//

import Foundation
import CoreData


extension UserReportEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserReportEntity> {
        return NSFetchRequest<UserReportEntity>(entityName: "UserReportEntity")
    }

    @NSManaged public var userId: Int64

}
