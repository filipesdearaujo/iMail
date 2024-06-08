import UIKit
import CoreData

class EmailDetailsViewController: UIViewController {

    var index: Int = 0
    var dados: [NSManagedObject] = []
    weak var delegate: EmailDetailsViewControllerDelegate?
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var emailMessageView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmailDetails()
        setupUI()
    }

    @IBAction func removeButtonPressed(_ sender: Any) {
        markAsDeleted(index: index)
    }
    
    func setupUI() {
        configureButton(trashButton, imageName: "trashIcon")
        trashButton.layer.cornerRadius = 20
        
        addTopLine(to: emailMessageView)
        messageTextView.isEditable = false
    }
    
    func addTopLine(to view: UIView) {
        let topLine = UIView()
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.backgroundColor = .red
        view.addSubview(topLine)

        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: view.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func configureButton(_ button: UIButton, imageName: String) {
        let contentImage = UIImage(named: imageName)
        button.setImage(contentImage, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }
    
    func markAsDeleted(index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for entity in fetchedResults {
                if let topic = entity.value(forKey: "topic") as? String, topic == "usuarioApagou" {
                    showDeleteConfirmationAlert(for: entity)
                } else {
                    showMarkedAsDeletedAlert(for: entity)
                }
            }
            dados = try managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Emails"))
        } catch let error as NSError {
            print("Erro ao marcar o email como apagado ou ao remover: \(error)")
        }
    }
    
    func showDeleteConfirmationAlert(for entity: NSManagedObject) {
        let alertController = UIAlertController(title: "Apagar Email", message: "Você realmente deseja apagar este email? Isso será permanente.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Apagar", style: .destructive) { _ in
            self.deleteEmail(entity: entity)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteEmail(entity: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(entity)
        
        do {
            try managedContext.save()
            delegate?.didUpdateEmail()
            dismiss(animated: true)
        } catch let error as NSError {
            print("Erro ao apagar o email: \(error)")
        }
    }
    
    func showMarkedAsDeletedAlert(for entity: NSManagedObject) {
        let alertController = UIAlertController(title: "Email Marcado como Apagado", message: "O email foi marcado como apagado.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.markEmailAsDeleted(entity: entity)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func markEmailAsDeleted(entity: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        entity.setValue("usuarioApagou", forKey: "topic")
        
        do {
            try managedContext.save()
            delegate?.didUpdateEmail()
            dismiss(animated: true)
        } catch let error as NSError {
            print("Erro ao marcar o email como apagado: \(error)")
        }
    }
    
    func loadEmailDetails() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let email = result.first as? NSManagedObject {
                // Extrair as informações do email
                if let sender = email.value(forKey: "sender") as? String {
                    senderLabel.text = sender
                }
                if let to = email.value(forKey: "to") as? String {
                    toLabel.text = to
                }
                if let subject = email.value(forKey: "subject") as? String {
                    subjectLabel.text = subject
                }
                if let message = email.value(forKey: "message") as? String {
                    messageTextView.text = message
                }
                
                // Exibir a data
                if let date = email.value(forKey: "date") as? Date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                    let dateString = dateFormatter.string(from: date)
                    dateLabel.text = dateString
                    print(index)
                } else {
                    dateLabel.text = "Data: Indisponível"
                }
            } else {
                print("Erro: Não foi possível encontrar o email com o índice especificado.")
            }
        } catch let error as NSError {
            print("Erro ao carregar os detalhes do email: \(error)")
        }
    }
}
