//
//  CellTableViewCell.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/23/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var monthName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
