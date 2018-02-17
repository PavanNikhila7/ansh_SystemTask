//
//  CustomTableViewCell.swift
//  ansh_SystemTask
//
//  Created by Pavankumar G on 17/02/18.
//  Copyright © 2018 Pavankumar G. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var favouriteIndivateBtn: UIButton!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
