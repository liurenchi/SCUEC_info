//
//  hotTableViewCell.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/11.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit

class hotTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
