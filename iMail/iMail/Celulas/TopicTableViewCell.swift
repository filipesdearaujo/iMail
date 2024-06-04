//
//  TopicTableViewCell.swift
//  iMail
//
//  Created by Yuri Araujo on 04/06/24.
//

import UIKit

class TopicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var fileName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: fileName, bundle: nil)
    }
    
    static var cell: String {
        return "topicCell"
    }
    
    private func configureCell() {
        backView.layer.cornerRadius = 20
        backView.layer.masksToBounds = true
    }
    
}
