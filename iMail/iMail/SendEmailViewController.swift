import UIKit
import CoreData

class SendEmailViewController: UIViewController {

    var emails: [NSManagedObject] = []
    
    @IBOutlet weak var destRemView: UIView!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var subjectEmailTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        guard let sender = senderTextField.text, !sender.isEmpty,
              let message = messageTextField.text, !message.isEmpty,
              let subject = subjectEmailTextField.text, !subject.isEmpty,
              let to = toTextField.text, !to.isEmpty else {
            print("Há um campo em vazio")
            return
        }

        // Chame a função save para salvar os dados no Core Data
        save(sender: sender, message: message, subject: subject, to: to)
        
        // Apresente um alerta informando que o email foi enviado
        let alertController = UIAlertController(title: "Sucesso", message: "O e-mail foi enviado", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func save(sender: String, message: String, subject: String, to: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Emails", in: managedContext)!
        
        let email = NSManagedObject(entity: entity, insertInto: managedContext)
        email.setValue(sender, forKey: "sender")
        email.setValue(message, forKey: "message")
        email.setValue(subject, forKey: "subject")
        email.setValue(to, forKey: "to")
        email.setValue(Date(), forKey: "date") // Salvar a data atual
        
        // Busca o último índice
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Emails")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            if let lastEmail = try managedContext.fetch(fetchRequest).first,
               let lastIndex = lastEmail.value(forKey: "index") as? Int {
                email.setValue(lastIndex + 1, forKey: "index")
            } else {
                // Se não há emails ainda, define o índice como 0
                email.setValue(0, forKey: "index")
            }
        } catch let error as NSError {
            print("Erro ao recuperar o último índice: \(error)")
        }
        
        do {
            try managedContext.save()
            emails.append(email)
        } catch let error as NSError {
            print("Erro ao salvar o email: \(error)")
        }
    }
    
    func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        // Bordas UIView
        let path = UIBezierPath(
            roundedRect: destRemView.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        destRemView.layer.mask = mask
        
        // Botão enviar email
        sendEmailButton.layer.cornerRadius = 20
        sendEmailButton.clipsToBounds = true
    }
}
