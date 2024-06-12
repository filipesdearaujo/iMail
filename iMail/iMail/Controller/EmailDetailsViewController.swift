import UIKit
import CoreData

class EmailDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var index: Int = 0
    var dados: [NSManagedObject] = []
    weak var delegate: EmailDetailsViewControllerDelegate?

    // MARK: - IBOutlets
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var emailMessageView: UIView!
    @IBOutlet weak var trashButton: UIButton!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmailDetails()
        setupUI()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        configureButton(trashButton, imageName: "trashIcon")
        trashButton.layer.cornerRadius = 20
        addTopLine(to: emailMessageView)
        messageTextView.isEditable = false
    }

    private func configureButton(_ button: UIButton, imageName: String) {
        let contentImage = UIImage(named: imageName)
        button.setImage(contentImage, for: .normal)
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)

        do {
            let result = try managedContext.fetch(fetchRequest)
            if let email = result.first as? NSManagedObject {
                updateUI(with: email)
            } else {
                print("Erro: Não foi possível encontrar o email com o índice especificado.")
            }
        } catch let error as NSError {
            print("Erro ao carregar os detalhes do email: \(error)")
        }
    }

    private func updateUI(with email: NSManagedObject) {
        senderLabel.text = email.value(forKey: "sender") as? String
        toLabel.text = email.value(forKey: "to") as? String
        subjectLabel.text = email.value(forKey: "subject") as? String
        messageTextView.text = email.value(forKey: "message") as? String
        
        if let date = email.value(forKey: "date") as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = "Data: Indisponível"
        }
    }

    // MARK: - Action Methods
    @IBAction func removeButtonPressed(_ sender: Any) {
        markAsDeleted(index: index)
    }

    private func markAsDeleted(index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)

        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for entity in fetchedResults {
                handleDeleteOrMarkAsDeleted(for: entity)
            }
            dados = try managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Emails"))
        } catch let error as NSError {
            print("Erro ao marcar o email como apagado ou ao remover: \(error)")
        }
    }

    private func handleDeleteOrMarkAsDeleted(for entity: NSManagedObject) {
        if let topic = entity.value(forKey: "topic") as? String, topic == "usuarioApagou" {
            showDeleteConfirmationAlert(for: entity)
        } else {
            showMarkedAsDeletedAlert(for: entity)
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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

    private func showMarkedAsDeletedAlert(for entity: NSManagedObject) {
        let alertController = UIAlertController(title: "Email Marcado como Apagado", message: "O email foi marcado como apagado.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.markEmailAsDeleted(entity: entity)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func markEmailAsDeleted(entity: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
}
