//
//  CxEntradaTableViewCell.swift
//  iMail
//
//  Created by Yuri Araujo on 01/06/24.
//

import UIKit

class CxEntradaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var remetenteLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var  fileName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: fileName, bundle: nil)
    }
    
    static var cell: String {
        return "Mycell"
    }
}
