//
//  Note.swift
//  MyNotes
//
//  Created by Pace Wisdom on 23/06/20.
//  Copyright © 2020 Pace Wisdom. All rights reserved.
//

import Foundation

class Note {
var title: String?
var description: String?
    
    var imageData: Data?
    var isSelected: Bool?

    init(title: String?, description: String?, imageData:Data?,isSelected:Bool) {
    self.title = title
    self.description = description
        self.imageData = imageData
        self.isSelected = isSelected
        
    }
}
