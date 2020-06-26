//
//  NoteTableViewCell.swift
//  MyNotes
//
//  Created by Pace Wisdom on 23/06/20.
//  Copyright © 2020 Pace Wisdom. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var attachmentImg: UIImageView!
    
    @IBOutlet weak var selectionBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
