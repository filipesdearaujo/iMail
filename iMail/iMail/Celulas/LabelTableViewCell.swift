//
//  LabelTableViewCell.swift
//  iMail
//
//  Created by Yuri Araujo on 06/06/24.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelButton: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var fileName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: fileName, bundle: nil)
    }
    
    static var cellIdentifier: String {
        return "labelCell"
    }
}

