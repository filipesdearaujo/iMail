import UIKit

class CxEntradaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var remetenteLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
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
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
    }
}
