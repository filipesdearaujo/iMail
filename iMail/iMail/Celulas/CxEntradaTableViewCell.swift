//import UIKit
//
//class CxEntradaTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var remetenteLabel: UILabel!
//    @IBOutlet weak var subjectLabel: UILabel!
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var backView: UIView!
//    
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        configureCell()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        configureCell()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Manter o fundo transparente quando a célula é selecionada
//        let selectedBackgroundView = UIView()
//        selectedBackgroundView.backgroundColor = .clear
//        self.selectedBackgroundView = selectedBackgroundView
//    }
//
//    static var fileName: String {
//        return String(describing: self)
//    }
//    
//    static var nib: UINib {
//        return UINib(nibName: fileName, bundle: nil)
//    }
//    
//    static var cell: String {
//        return "Mycell"
//    }
//    
//    private func configureCell() {
//        backView.layer.cornerRadius = 20
//        backView.layer.masksToBounds = true
//    }
//}

import UIKit

class CxEntradaTableViewCell: UITableViewCell {

    @IBOutlet weak var remetenteLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
        applyTheme()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
        applyTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Manter o fundo transparente quando a célula é selecionada
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        self.selectedBackgroundView = selectedBackgroundView
    }

    static var fileName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: fileName, bundle: nil)
    }
    
    static var cell: String {
        return "Mycell"
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
            remetenteLabel.textColor = themeColors.labelColor
            subjectLabel.textColor = themeColors.labelColor
            messageLabel.textColor = themeColors.labelColor
            dateLabel.textColor = themeColors.labelColor
        }
    }
}

