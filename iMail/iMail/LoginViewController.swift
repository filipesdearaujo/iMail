import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    var people: [NSManagedObject] = []

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPersonEntity()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureTextField(nameTextField, placeholder: "Nome")
        configureTextField(emailTextField, placeholder: "Email")
        configureTextField(passwordTextField, placeholder: "Senha")
        configureButton(enterButton, title: "Entrar")
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.borderStyle = .none
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.red.cgColor
        textField.layer.addSublayer(bottomBorder)
        textField.layoutIfNeeded()
        bottomBorder.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
    }
    
    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.red.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    }
    
    // MARK: - Core Data
    private func checkPersonEntity() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
            navigateToMainViewControllerIfNeeded()
        } catch {
            print("Failed to fetch records: \(error)")
        }
    }
    
    private func save(name: String, email: String, password: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(email, forKey: "email")
        person.setValue(password, forKey: "password")
        
        do {
            try managedContext.save()
            people.append(person)
            navigateToMainViewController()
        } catch {
            print("Failed to save person: \(error)")
        }
    }
    
    private func getEmails() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Emails", in: context) {
            let newEmail = NSManagedObject(entity: entity, insertInto: context)
            newEmail.setValue(EmaiRandomGenerator.shared.fetchEmail(), forKey: "to")
            newEmail.setValue(EmaiRandomGenerator.shared.generateRandomEmailAddress(), forKey: "sender")
            newEmail.setValue(EmaiRandomGenerator.shared.generateRandomDate(), forKey: "date")
            newEmail.setValue(EmaiRandomGenerator.shared.getRandomMessage().message, forKey: "message")
            newEmail.setValue(EmaiRandomGenerator.shared.getRandomMessage().subject, forKey: "subject")
            newEmail.setValue(EmaiRandomGenerator.shared.fetchIndex(), forKey: "index")
            
            do {
                try context.save()
            } catch {
                print("Failed to save email: \(error)")
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToMainViewControllerIfNeeded() {
        if !people.isEmpty {
            navigateToMainViewController()
        }
    }
    
    private func navigateToMainViewController() {
        if let navigationController = self.navigationController,
           let viewController = navigationController.storyboard?.instantiateViewController(withIdentifier: "ViewController") {
            navigationController.setViewControllers([viewController], animated: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func enterButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Há um campo em vazio")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(message: "Isso não é um email")
            return
        }
        
        if name.count > 10 {
            showAlert(message: "Escreva apenas o primeiro nome")
            return
        }
        
        save(name: name, email: email, password: password)
        
        for _ in 1...10 {
            getEmails()
        }
    }
    
    // MARK: - Validation
    private func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".com")
    }
    
    // MARK: - Alerts
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
