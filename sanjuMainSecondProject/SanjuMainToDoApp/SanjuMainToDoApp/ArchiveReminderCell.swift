//
//  ArchiveReminderCell.swift
//  SanjuMainToDoApp
//
//  Created by Admin on 01/04/1939 Saka.
//  Copyright © 1939 Saka BridgeLabz Solutions LLP. All rights reserved.
//

import UIKit

class ArchiveReminderCell: UICollectionViewCell {

    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var remindDate: UILabel!
    @IBOutlet weak var cellview: UIView!
    override func awakeFromNib() {
        tittle.numberOfLines = 0
        self.tittle.sizeToFit()
        notes.numberOfLines = 0
        self.notes.sizeToFit()
        remindDate.numberOfLines = 0
        self.remindDate.sizeToFit()
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        super.awakeFromNib()
    }
}
