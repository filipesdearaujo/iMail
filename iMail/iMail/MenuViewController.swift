import UIKit
import CoreData

class MenuViewController: UIViewController {

    var delegate: MenuViewControllerDelegate?
    
    @IBOutlet weak var profileMenuView: UIView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var profileLabelUser: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuUI()
        loadUserInfo()
    }
    
    private func setupMenuUI() {
        let path = UIBezierPath(
            roundedRect: profileMenuView.bounds,
            byRoundingCorners: [.bottomRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        profileMenuView.layer.mask = mask
        
        profilePictureImage.layer.cornerRadius = 45
        profilePictureImage.clipsToBounds = true
    }
    
    private func loadUserInfo() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            let people = try managedContext.fetch(fetchRequest)
            if let person = people.first {
                if let name = person.value(forKey: "name") as? String {
                    profileLabelUser.text = "Olá, \(name)"
                }
                if let email = person.value(forKey: "email") as? String {
                    userEmailLabel.text = email
                }
            }
        } catch let error as NSError {
            print("Erro ao carregar informações do usuário: \(error)")
        }
    }
    
    @IBAction func MenuButtonClicked(_ sender: UIButton) {
        self.delegate?.hidenMenuVIew()
        
        //dismiss Menu When clicked on this button
        if sender.tag == 5 {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
}
