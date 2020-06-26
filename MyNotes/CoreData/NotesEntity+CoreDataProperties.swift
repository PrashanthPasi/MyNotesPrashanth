//
//  NotesEntity+CoreDataProperties.swift
//  MyNotes
//
//  Created by Pace Wisdom on 24/06/20.
//  Copyright © 2020 Pace Wisdom. All rights reserved.
//
//

import Foundation
import CoreData


extension NotesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesEntity> {
        return NSFetchRequest<NotesEntity>(entityName: "NotesEntity")
    }

    @NSManaged public var attachment: Data?
    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var isSelected: Bool

}
