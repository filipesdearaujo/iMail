import UIKit
import CoreData
import EventKit
import EventKitUI

class RecievedEmailDetailsViewController: UIViewController, EKEventEditViewDelegate {
    
    // MARK: - Properties
    
    let eventStore = EKEventStore()
    
    var index: Int = 0
    var dados: [NSManagedObject] = []
    weak var delegate: EmailUpdateDelegate?
    var emailHandler = EmailHandler()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toImage: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var asnwerButton: UIButton!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmailDetails()
        setupUI()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        configImageButton(button: trashButton, imageName: "trashIcon", color: .clear)
        configImageButton(button: bookmarkButton, imageName: "bookmark", color: .clear)
        configImageButton(button: forwardButton, imageName: "enviarButton", color: .white)
        configImageButton(button: asnwerButton, imageName: "reply", color: .red)
        asnwerButton.layer.cornerRadius = 20
        forwardButton.layer.cornerRadius = 20
        addTopLine(to: messageView)
        messageTextView.isEditable = false
    }
    
    private func configImageButton(button: UIButton, imageName: String, color: UIColor) {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        let contentImage = UIImage(named: imageName)
        button.setImage(contentImage, for: .normal)
        button.backgroundColor = color
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }
    
    private func addTopLine(to view: UIView) {
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
    
    // MARK: - Core Data Methods
    
    private func loadEmailDetails() {
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
                    dateLabel.text = dateFormatter.string(from: date)
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
    
    // MARK: - EventKit Methods
    
    @IBAction func addEventButtonTapped(_ sender: Any) {
        requestAccessToCalendar()
    }
    
    private func requestAccessToCalendar() {
        eventStore.requestFullAccessToEvents { granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.presentEventEditViewController()
                }
            } else {
                if let error = error {
                    print("Erro ao solicitar permissão: \(error)")
                } else {
                    print("Permissão negada para acessar o calendário")
                }
            }
        }
    }
    
    private func presentEventEditViewController() {
        let event = EKEvent(eventStore: eventStore)
        event.title = subjectLabel.text ?? "Novo Evento"
        event.notes = messageTextView.text
        event.startDate = Date()
        event.endDate = event.startDate.addingTimeInterval(60*60) // 1 hora de duração
        
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = event
        eventEditViewController.eventStore = eventStore
        eventEditViewController.editViewDelegate = self
        
        present(eventEditViewController, animated: true, completion: nil)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        dismiss(animated: true, completion: nil)
        
        switch action {
        case .canceled:
            print("Edição de evento cancelada")
        case .saved:
            print("Evento salvo")
            showAlert(title: "Parabéns", message: "Evento criado")
        case .deleted:
            print("Evento deletado")
        @unknown default:
            print("Ação desconhecida")
        }
    }
    
    // MARK: - Alert Methods
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String, shouldDismiss: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if shouldDismiss {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Email Action Methods
    
    @IBAction func answerEmailButtonTapped(_ sender: Any) {
        emailHandler.handleEmailAction(index: index, action: .answer, viewController: self)
    }
    
    @IBAction func forwardEmailButtonTapped(_ sender: Any) {
        emailHandler.handleEmailAction(index: index, action: .forward, viewController: self)
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        markAsDeleted(index: index)
    }
    
    @IBAction func labelsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "moveToLabels", sender: self)
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        updateEmailTopic(to: "usuarioSalvou", successMessage: "O e-mail foi salvo.")
    }
    
    private func updateEmailTopic(to topic: String, successMessage: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let email = result.first as? NSManagedObject {
                email.setValue(topic, forKey: "topic")
                try managedContext.save()
                showAlert(title: "Sucesso", message: successMessage, shouldDismiss: true)
            } else {
                showAlert(title: "Erro", message: "Não foi possível salvar o email.", shouldDismiss: false)
            }
        } catch let error as NSError {
            print("Erro ao atualizar o email: \(error)")
        }
    }
    
    private func markAsDeleted(index: Int) {
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
    
    private func showDeleteConfirmationAlert(for entity: NSManagedObject) {
        let alertController = UIAlertController(title: "Apagar Email", message: "Você realmente deseja apagar este email? Isso será permanente.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Apagar", style: .destructive) { _ in
            self.deleteEmail(entity: entity)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteEmail(entity: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(entity)
        
        do {
            try managedContext.save()
            delegate?.didUpdateEmails() // Notificar o delegado sobre a atualização
        } catch let error as NSError {
            print("Erro ao apagar o email: \(error)")
        }
    }
    
    private func showMarkedAsDeletedAlert(for entity: NSManagedObject) {
        let alertController = UIAlertController(title: "Email Marcado como Apagado", message: "O email foi marcado como apagado.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.markEmailAsDeleted(entity: entity)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func markEmailAsDeleted(entity: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        entity.setValue("usuarioApagou", forKey: "topic")
        
        do {
            try managedContext.save()
            delegate?.didUpdateEmails() // Notificar o delegado sobre a atualização
            dismiss(animated: true)
        } catch let error as NSError {
            print("Erro ao marcar o email como apagado: \(error)")
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "answerForwardEmailSegue" {
            if let (handler, action) = sender as? (EmailHandler, EmailHandler.EmailAction),
               let destinationVC = segue.destination as? SendEmailViewController {
                destinationVC.originalEmailSender = handler.emailSender
                destinationVC.originalEmailTitle = handler.emailTitle
                destinationVC.originalEmailMessage = handler.emailMessage
                
                // Configurar os campos com base na ação (responder ou encaminhar)
                switch action {
                case .answer:
                    destinationVC.emailAction = .answer
                case .forward:
                    destinationVC.emailAction = .forward
                }
            }
        } else if segue.identifier == "moveToLabels" {
            if let destinationVC = segue.destination as? MoveViewController {
                destinationVC.index = index
            }
        }
    }
}
 
