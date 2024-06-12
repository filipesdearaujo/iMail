import UIKit
import CoreData

// Protocolo para atualizar emails
protocol EmailUpdateDelegate: AnyObject {
    func didUpdateEmails()
}

// Classe responsável pelo menu
class MenuViewController: UIViewController {

    // MARK: - Properties
    
    var delegate: MenuViewControllerDelegate?
    weak var emailUpdateDelegate: EmailUpdateDelegate?
    var labels: [Label] = [] // Armazena os objetos Label
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileMenuView: UIView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var profileLabelUser: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var logoffButton: UIButton!
    @IBOutlet weak var generateEmailButton: UIButton!
    @IBOutlet weak var LabelsButton: UIButton!

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuUI()
        loadUserInfo()
        fetchLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLabels()
        updateLabelsMenu()
    }

    // MARK: - Setup Methods

    private func setupMenuUI() {
        profilePictureImage.layer.cornerRadius = 20
        profilePictureImage.clipsToBounds = true
        logoffButton.layer.cornerRadius = 10
        logoffButton.clipsToBounds = true
        generateEmailButton.layer.cornerRadius = 10
        generateEmailButton.clipsToBounds = true
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
                profileLabelUser.text = person.value(forKey: "name") as? String
                userEmailLabel.text = person.value(forKey: "email") as? String
            }
        } catch let error as NSError {
            print("Erro ao carregar informações do usuário: \(error)")
        }
    }
    
    private func fetchLabels() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Label>(entityName: "Label")
        
        do {
            labels = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Erro ao buscar labels: \(error)")
        }
    }

    // MARK: - Action Methods

    @IBAction func labelsButtonTapped(_ sender: Any) {
        updateLabelsMenu()
        LabelsButton.showsMenuAsPrimaryAction = true
    }

    @IBAction func MenuButtonClicked(_ sender: UIButton) {
        self.delegate?.hidenMenuVIew()
        
        guard let buttonTitle = sender.titleLabel?.text else { return }

        switch buttonTitle {
        case "Enviados":
            navigateToDeliveredViewController(with: "usuarioEnviou", buttonTitle: buttonTitle)
        case "Favoritos":
            navigateToDeliveredViewController(with: "usuarioSalvou", buttonTitle: buttonTitle)
        case "Lixeira":
            navigateToDeliveredViewController(with: "usuarioApagou", buttonTitle: buttonTitle)
        case "Spam":
            navigateToDeliveredViewController(with: "usuarioSpam", buttonTitle: buttonTitle)
        default:
            break
        }
    }
    
    @IBAction func logoffButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Sair", message: "Você realmente deseja sair? Isso apagará todos os emails e dados salvos.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "Sair", style: .destructive) { _ in
            self.deleteAllData()
            self.navigateToLoginScreen()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func generateEmailTapped(_ sender: Any) {
        createEmail()
        emailUpdateDelegate?.didUpdateEmails()  // Notificar o delegate que os emails foram atualizados
    }

    // MARK: - Helper Methods

    private func createLabelsMenu() -> UIMenu {
        var actions = [UIAction]()
        
        for label in labels {
            let action = UIAction(title: label.name ?? "Sem Nome", handler: { _ in
                self.navigateToDeliveredViewController(with: "usuario\(label.name!)", buttonTitle: label.name!)
            })
            actions.append(action)
        }
        
        return UIMenu(title: "Marcadores", children: actions)
    }
    
    private func updateLabelsMenu() {
        LabelsButton.menu = createLabelsMenu()
    }
    
    private func saveLabel(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Label", in: managedContext)!
        let label = NSManagedObject(entity: entity, insertInto: managedContext) as! Label
        
        label.name = name
        
        do {
            try managedContext.save()
            labels.append(label)
            updateLabelsMenu()
            print("Label saved: \(label.name ?? "")")
        } catch let error as NSError {
            print("Error saving label: \(error)")
        }
    }
    
    private func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entities = appDelegate.persistentContainer.managedObjectModel.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext.execute(deleteRequest)
                try managedContext.save()
            } catch let error as NSError {
                print("Erro ao apagar os dados: \(error)")
            }
        }
    }
    
    private func createEmail() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Emails", in: context) {
            let newEmail = NSManagedObject(entity: entity, insertInto: context)
            newEmail.setValue(EmailRandomGenerator.shared.fetchIndex(), forKey: "index")
            newEmail.setValue(EmailRandomGenerator.shared.fetchEmail(), forKey: "to")
            newEmail.setValue(EmailRandomGenerator.shared.generateRandomEmailAddress(), forKey: "sender")
            newEmail.setValue(EmailRandomGenerator.shared.generateRandomDate(), forKey: "date")
            let message = EmailRandomGenerator.shared.getRandomMessage()
            newEmail.setValue(message.message, forKey: "message")
            newEmail.setValue(message.subject, forKey: "subject")
            newEmail.setValue("usuarioRecebeu", forKey: "topic")
            
            do {
                try context.save()
            } catch {
                print("Failed to save email: \(error)")
            }
        }
    }
    
    private func navigateToDeliveredViewController(with topic: String, buttonTitle: String? = nil) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
            nextVC.topic = topic
            nextVC.buttonTitle = buttonTitle
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    private func navigateToLoginScreen() {
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            navigationController?.setViewControllers([loginViewController], animated: true)
        }
    }
}
