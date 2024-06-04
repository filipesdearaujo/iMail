//
//  DeliveredTableViewCell.swift
//  iMail
//
//  Created by Filipe Simões on 29/05/24.
//

import UIKit

class DeliveredTableViewCell: UITableViewCell {

    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame.size.height = 100
        configureCell()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    static var  fileName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: fileName, bundle: nil)
    }
    
    static var cell: String {
        return "cell"
    }
    
    private func configureCell() {
        backView.layer.cornerRadius = 20
        backView.layer.masksToBounds = true
        let path = UIBezierPath(
            roundedRect: profileImage.bounds,
            byRoundingCorners: [.bottomRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        profileImage.layer.mask = mask
        
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
    }
}
