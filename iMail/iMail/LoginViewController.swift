import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    var people: [NSManagedObject] = []

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Verificar se a entidade "Person" não está vazia
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Não foi possível retornar os registros. \(error)")
        }
        
        // Se a entidade "Person" não estiver vazia, navegue diretamente para a ViewController
        if !people.isEmpty {
            if let navigationController = self.navigationController,
               let viewController = navigationController.storyboard?.instantiateViewController(withIdentifier: "ViewController") {
                navigationController.setViewControllers([viewController], animated: false)
            }
        }
    }
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Há um campo em vazio")
            return
        }
        
        // Validar o campo de email
        if !isValidEmail(email) {
            showAlert(message: "Isso não é um email")
            return
        }
        
        // Validar o campo de nome
        if name.count > 10 {
            showAlert(message: "Escreva apenas o primeiro nome")
            return
        }
        
        // Chame a função save para salvar os dados no Core Data
        save(name: name, email: email, password: password)
        //cria emails fakes para simular a caixa de entrada
        
        for _ in 1...10 {
            getEmails()
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".com")
    }
    
    func save(name: String, email: String, password: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        person.setValue(email, forKey: "email")
        person.setValue(password, forKey: "password")
        
        do {
            try managedContext.save()
            people.append(person)
            
            // Navegar para a ViewController após salvar com sucesso
            if let navigationController = self.navigationController,
               let viewController = navigationController.storyboard?.instantiateViewController(withIdentifier: "ViewController") {
                navigationController.setViewControllers([viewController], animated: true)
            }
        } catch let error as NSError {
            print("Erro ao salvar a pessoa: \(error)")
        }
    }

    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
       
    func getEmails() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return // Retorna se não conseguir acessar o contexto do CoreData
            }
            
            let context = appDelegate.persistentContainer.viewContext
            
            // Cria um novo objeto da entidade "Emails"
            if let entity = NSEntityDescription.entity(forEntityName: "Emails", in: context) {
                let newEmail = NSManagedObject(entity: entity, insertInto: context)
                newEmail.setValue(EmaiRandomGenerator.shared.fetchEmail(), forKey: "to")
                newEmail.setValue(EmaiRandomGenerator.shared.generateRandomEmailAddress(), forKey: "sender")
                newEmail.setValue(EmaiRandomGenerator.shared.generateRandomDate(), forKey: "date")
                newEmail.setValue(EmaiRandomGenerator.shared.getRandomMessage().message, forKey: "message")
                newEmail.setValue(EmaiRandomGenerator.shared.getRandomMessage().subject, forKey: "subject")
                newEmail.setValue(EmaiRandomGenerator.shared.fetchIndex(), forKey: "index")
    
                do {
                    // Tenta salvar o novo objeto no CoreData
                    try context.save()
                } catch {
                    print("Failed to save email: \(error)")
                }
            }
        }

}
