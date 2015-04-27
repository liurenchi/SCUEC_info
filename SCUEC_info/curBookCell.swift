//
//  curBookCell.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/27.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

/*———————————————————————————————————————
custom cell
———————————————————————————————————————*/
import UIKit


class curBookCell: UITableViewCell {

    @IBOutlet weak var bookname: UILabel!
    @IBOutlet weak var bookauthor: UILabel!
    @IBOutlet weak var borrowdate: UILabel!
    @IBOutlet weak var duedate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
