//
//  DeliveredTableViewCell.swift
//  iMail
//
//  Created by Filipe Simões on 29/05/24.
//

import UIKit

class DeliveredTableViewCell: UITableViewCell {


    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame.size.height = 100
        configureCell()
        applyTheme()
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
    }
    private func applyTheme() {
        // Obtém as cores do tema através do ThemeManager
        if let themeColors = ThemeManager.shared.fetchThemeColors() {
            // Aplicando as cores no backView e labels
            backView.backgroundColor = themeColors.secondColor
            senderLabel.textColor = themeColors.labelColor
            subjectLabel.textColor = themeColors.labelColor
            messageLabel.textColor = themeColors.labelColor
            dateLabel.textColor = themeColors.labelColor
        }
    }
    
}
