import UIKit
import CoreData

class EmailDetailsViewController: UIViewController {

    var index: Int = 0
    var dados: [NSManagedObject] = []
    
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
        remove(index:  index)
        dismiss(animated: true)
    }
    
    func setupUI() {
        configureButton(trashButton, imageName: "trashIcon")
        trashButton.layer.cornerRadius = 20
        
        addTopLine(to: emailMessageView)
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
    
    func remove(index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for entity in fetchedResults {
                managedContext.delete(entity)
            }
            try managedContext.save()
            dados = try managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Emails"))
        } catch let error as NSError {
            print("Erro ao remover o email: \(error)")
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
