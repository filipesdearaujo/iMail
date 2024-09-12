import UIKit

class LabelTableViewCell: UITableViewCell {
        
    @IBOutlet weak var labelButton: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyTheme()
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
    
    private func applyTheme() {
        // Obtém as cores do tema através do ThemeManager
        if let themeColors = ThemeManager.shared.fetchThemeColors() {
            // Aplicando as cores no backView e labels
            backView.backgroundColor = themeColors.backgroundColor
            labelButton.textColor = themeColors.labelColor
        }
    }
}

