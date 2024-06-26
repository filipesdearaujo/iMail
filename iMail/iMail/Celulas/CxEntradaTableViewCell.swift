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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
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
}
