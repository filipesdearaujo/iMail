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
        profilePictureImage.layer.cornerRadius = 20
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
                    profileLabelUser.text = name
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
        
        if let buttonTitle = sender.titleLabel?.text {
            if buttonTitle == "Enviados" {
                if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
                    nextVC.topic = "usuarioEnviou"
                    nextVC.buttonTitle = buttonTitle
                    navigationController?.pushViewController(nextVC, animated: true)
                }
            } else if buttonTitle == "Favoritos" {
                if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
                    nextVC.topic = "usuarioSalvou"
                    nextVC.buttonTitle = buttonTitle
                    navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            // mais opções
        }
    }
}
