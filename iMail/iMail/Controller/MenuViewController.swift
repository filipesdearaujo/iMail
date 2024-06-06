//import UIKit
//import CoreData
//
//protocol EmailUpdateDelegate: AnyObject {
//    func didUpdateEmails()
//}
//
//class MenuViewController: UIViewController {
//
//    var delegate: MenuViewControllerDelegate?
//    weak var emailUpdateDelegate: EmailUpdateDelegate?
//    var labels: [Label] = [] // Armazena os objetos Label
//    
//    @IBOutlet weak var profileMenuView: UIView!
//    @IBOutlet weak var profilePictureImage: UIImageView!
//    @IBOutlet weak var profileLabelUser: UILabel!
//    @IBOutlet weak var userEmailLabel: UILabel!
//    @IBOutlet weak var logoffButton: UIButton!
//    @IBOutlet weak var generateEmailButton: UIButton!
//    @IBOutlet weak var LabelsButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupMenuUI()
//        loadUserInfo()
//        fetchLabels()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchLabels()
//        updateLabelsMenu()
//    }
//
//    private func setupMenuUI() {
//        profilePictureImage.layer.cornerRadius = 20
//        profilePictureImage.clipsToBounds = true
//        logoffButton.layer.cornerRadius = 10
//        logoffButton.clipsToBounds = true
//        generateEmailButton.layer.cornerRadius = 10
//        generateEmailButton.clipsToBounds = true
//    }
//    
//    private func loadUserInfo() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
//        
//        do {
//            let people = try managedContext.fetch(fetchRequest)
//            if let person = people.first {
//                if let name = person.value(forKey: "name") as? String {
//                    profileLabelUser.text = name
//                }
//                if let email = person.value(forKey: "email") as? String {
//                    userEmailLabel.text = email
//                }
//            }
//        } catch let error as NSError {
//            print("Erro ao carregar informações do usuário: \(error)")
//        }
//    }
//    
//    private func fetchLabels() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<Label>(entityName: "Label")
//        
//        do {
//            labels = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Erro ao buscar labels: \(error)")
//        }
//    }
//
//    @IBAction func labelsButtonTapped(_ sender: Any) {
//        updateLabelsMenu()
//        LabelsButton.showsMenuAsPrimaryAction = true
//    }
//
//    private func createLabelsMenu() -> UIMenu {
//        var actions = [UIAction]()
//        
//        for label in labels {
//            let action = UIAction(title: label.name ?? "Sem Nome", handler: { _ in
//                print("Selecionou o marcador: \(label.name ?? "Sem Nome")")
//            })
//            actions.append(action)
//        }
//        
//        return UIMenu(title: "Marcadores", children: actions)
//    }
//    
//    private func updateLabelsMenu() {
//        LabelsButton.menu = createLabelsMenu()
//    }
//    
//    private func saveLabel(name: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Label", in: managedContext)!
//        let label = NSManagedObject(entity: entity, insertInto: managedContext) as! Label
//        
//        label.name = name
//        
//        do {
//            try managedContext.save()
//            labels.append(label)
//            updateLabelsMenu()
//            print("Label saved: \(label.name ?? "")")
//        } catch let error as NSError {
//            print("Error saving label: \(error)")
//        }
//    }
//    
//    @IBAction func MenuButtonClicked(_ sender: UIButton) {
//        self.delegate?.hidenMenuVIew()
//        
//        if let buttonTitle = sender.titleLabel?.text {
//            if buttonTitle == "Enviados" {
//                if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
//                    nextVC.topic = "usuarioEnviou"
//                    nextVC.buttonTitle = buttonTitle
//                    navigationController?.pushViewController(nextVC, animated: true)
//                }
//            } else if buttonTitle == "Favoritos" {
//                if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
//                    nextVC.topic = "usuarioSalvou"
//                    nextVC.buttonTitle = buttonTitle
//                    navigationController?.pushViewController(nextVC, animated: true)
//                }
//            } else if buttonTitle == "Lixeira" {
//                if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
//                    nextVC.topic = "usuarioApagou"
//                    nextVC.buttonTitle = buttonTitle
//                    navigationController?.pushViewController(nextVC, animated: true)
//                }
//            } else if buttonTitle == "Spam" {
//                if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
//                    nextVC.topic = "usuarioSpam"
//                    nextVC.buttonTitle = buttonTitle
//                    navigationController?.pushViewController(nextVC, animated: true)
//                }
//            }
//            // mais opções
//        }
//    }
//    
//    @IBAction func logoffButtonTapped(_ sender: Any) {
//        let alertController = UIAlertController(title: "Sair", message: "Você realmente deseja sair? Isso apagará todos os emails e dados salvos.", preferredStyle: .alert)
//        
//        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
//        let logoutAction = UIAlertAction(title: "Sair", style: .destructive) { _ in
//            self.deleteAllData()
//            self.navigateToLoginScreen()
//        }
//        
//        alertController.addAction(cancelAction)
//        alertController.addAction(logoutAction)
//        
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    private func deleteAllData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        let entities = appDelegate.persistentContainer.managedObjectModel.entities
//        for entity in entities {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            
//            do {
//                try managedContext.execute(deleteRequest)
//                try managedContext.save()
//            } catch let error as NSError {
//                print("Erro ao apagar os dados: \(error)")
//            }
//        }
//    }
//    
//    private func createEmail() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        
//        if let entity = NSEntityDescription.entity(forEntityName: "Emails", in: context) {
//            let newEmail = NSManagedObject(entity: entity, insertInto: context)
//            newEmail.setValue(EmailRandomGenerator.shared.fetchIndex(), forKey: "index")
//            newEmail.setValue(EmailRandomGenerator.shared.fetchEmail(), forKey: "to")
//            newEmail.setValue(EmailRandomGenerator.shared.generateRandomEmailAddress(), forKey: "sender")
//            newEmail.setValue(EmailRandomGenerator.shared.generateRandomDate(), forKey: "date")
//            let message = EmailRandomGenerator.shared.getRandomMessage()
//            newEmail.setValue(message.message, forKey: "message")
//            newEmail.setValue(message.subject, forKey: "subject")
//            newEmail.setValue("usuarioRecebeu", forKey: "topic")
//            
//            do {
//                try context.save()
//            } catch {
//                print("Failed to save email: \(error)")
//            }
//        }
//    }
//    
//    private func navigateToLoginScreen() {
//        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
//            navigationController?.setViewControllers([loginViewController], animated: true)
//        }
//    }
//    
//    @IBAction func generateEmailTapped(_ sender: Any) {
//        createEmail()
//        emailUpdateDelegate?.didUpdateEmails()  // Notificar o delegate que os emails foram atualizados
//    }
//}
//


import UIKit
import CoreData

protocol EmailUpdateDelegate: AnyObject {
    func didUpdateEmails()
}

class MenuViewController: UIViewController {

    var delegate: MenuViewControllerDelegate?
    weak var emailUpdateDelegate: EmailUpdateDelegate?
    var labels: [Label] = [] // Armazena os objetos Label
    
    @IBOutlet weak var profileMenuView: UIView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var profileLabelUser: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var logoffButton: UIButton!
    @IBOutlet weak var generateEmailButton: UIButton!
    @IBOutlet weak var LabelsButton: UIButton!

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

    @IBAction func labelsButtonTapped(_ sender: Any) {
        updateLabelsMenu()
        LabelsButton.showsMenuAsPrimaryAction = true
    }

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
    
    @IBAction func MenuButtonClicked(_ sender: UIButton) {
        self.delegate?.hidenMenuVIew()
        
        if let buttonTitle = sender.titleLabel?.text {
            if buttonTitle == "Enviados" {
                navigateToDeliveredViewController(with: "usuarioEnviou", buttonTitle: buttonTitle)
            } else if buttonTitle == "Favoritos" {
                navigateToDeliveredViewController(with: "usuarioSalvou", buttonTitle: buttonTitle)
            } else if buttonTitle == "Lixeira" {
                navigateToDeliveredViewController(with: "usuarioApagou", buttonTitle: buttonTitle)
            } else if buttonTitle == "Spam" {
                navigateToDeliveredViewController(with: "usuarioSpam", buttonTitle: buttonTitle)
            }
            // mais opções
        }
    }
    
    private func navigateToDeliveredViewController(with topic: String, buttonTitle: String? = nil) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
            nextVC.topic = topic
            nextVC.buttonTitle = buttonTitle
            navigationController?.pushViewController(nextVC, animated: true)
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
    
    private func navigateToLoginScreen() {
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            navigationController?.setViewControllers([loginViewController], animated: true)
        }
    }
    
    @IBAction func generateEmailTapped(_ sender: Any) {
        createEmail()
        emailUpdateDelegate?.didUpdateEmails()  // Notificar o delegate que os emails foram atualizados
    }
}
