//
//  BookingViewCell.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/27/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit

class BookingViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bookingId: UILabel!
    @IBOutlet weak var eventName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
