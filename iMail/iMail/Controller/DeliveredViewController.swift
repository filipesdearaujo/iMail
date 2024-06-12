import UIKit
import CoreData

// Protocolos para os delegados
protocol MenuViewControllerDelegate: AnyObject {
    func hidenMenuVIew()
}

protocol EmailDetailsViewControllerDelegate: AnyObject {
    func didUpdateEmail()
}

// ViewController para os emails entregues
class DeliveredViewController: UIViewController, UITableViewDelegate, EmailDetailsViewControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var dados: [NSManagedObject] = []
    let fetchEmails = FetchEmails()
    var topic: String?
    var buttonTitle: String?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableViewDelivered: UITableView!
    @IBOutlet weak var enviadosSearchTextField: UITextField!
    @IBOutlet weak var subectLabel: UILabel!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Configure the subject label with the button title
        if let buttonTitle = buttonTitle {
            subectLabel.text = buttonTitle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEmails()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        tableViewDelivered.register(DeliveredTableViewCell.nib, forCellReuseIdentifier: DeliveredTableViewCell.cell)
        tableViewDelivered.dataSource = self
        tableViewDelivered.delegate = self
        enviadosSearchTextField.delegate = self
        configureTextField(enviadosSearchTextField)
        tableViewDelivered.separatorColor = .clear
        configureButton(deleteAllButton, imageName: "trashIcon")
    }
    
    private func configureButton(_ button: UIButton, imageName: String) {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        let contentImage = UIImage(named: imageName)
        button.setImage(contentImage, for: .normal)
        button.backgroundColor = .clear
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }
    
    private func configureTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.layer.masksToBounds = true
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Pesquisar em \(buttonTitle ?? "")", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    // MARK: - Core Data Methods
    
    private func loadEmails(filter: String? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        
        if let topic = topic {
            if let filter = filter, !filter.isEmpty {
                fetchRequest.predicate = NSPredicate(format: "topic == %@ AND (sender CONTAINS[cd] %@ OR message CONTAINS[cd] %@ OR subject CONTAINS[cd] %@)", topic, filter, filter, filter)
            } else {
                fetchRequest.predicate = NSPredicate(format: "topic == %@", topic)
            }
        }
        
        do {
            dados = try managedContext.fetch(fetchRequest)
            tableViewDelivered.reloadData()
        } catch let error as NSError {
            print("Não foi possível retornar os registros. \(error)")
        }
    }
    
    private func deleteAllEmails(includingLabel: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if includingLabel {
            // Fetch the label to delete
            let fetchLabelRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Label")
            fetchLabelRequest.predicate = NSPredicate(format: "name == %@", buttonTitle ?? "")
            
            do {
                if let labelsToDelete = try managedContext.fetch(fetchLabelRequest) as? [NSManagedObject] {
                    for label in labelsToDelete {
                        managedContext.delete(label)
                    }
                }
            } catch let error as NSError {
                print("Não foi possível apagar a etiqueta. \(error)")
            }
        }
        
        // Fetch emails from "Emails" entity with the specified topic
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "topic == %@", topic ?? "")
        
        do {
            let emailsToDelete = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            for email in emailsToDelete {
                managedContext.delete(email)
            }
            try managedContext.save()
            dados.removeAll()
            tableViewDelivered.reloadData()
            self.navigationController?.popViewController(animated: true) // Voltar para a tela anterior
        } catch let error as NSError {
            print("Não foi possível apagar os registros. \(error)")
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loadEmails(filter: textField.text)
        return true
    }
    
    // MARK: - EmailDetailsViewControllerDelegate Methods
    
    func didUpdateEmail() {
        loadEmails()
    }
    
    // MARK: - IBActions
    
    @IBAction func deleteAllTapped(_ sender: Any) {
        guard let topic = topic else { return }
        
        let message = topic != "usuarioApagou" && topic != "usuarioSpam" && topic != "usuarioEnviou" ? "Você realmente deseja apagar todos os emails? Esta ação não pode ser desfeita. Isso também apagará a etiqueta \(buttonTitle ?? "") e os emails associados." : "Você realmente deseja apagar todos os emails? Esta ação não pode ser desfeita."
        
        let alertController = UIAlertController(title: "Apagar Todos", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Apagar", style: .destructive) { _ in
            self.deleteAllEmails(includingLabel: message.contains("etiqueta"))
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension DeliveredViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliveredTableViewCell.cell, for: indexPath) as? DeliveredTableViewCell else {
            fatalError("The dequeued cell is not an instance of DeliveredTableViewCell.")
        }
        
        let email = dados[indexPath.row]
        
        // Configure a célula com os atributos da entidade "Emails"
        if let sender = email.value(forKey: "sender") as? String,
           let message = email.value(forKey: "message") as? String,
           let subject = email.value(forKey: "subject") as? String,
           let date = email.value(forKey: "date") as? Date {
            cell.senderLabel.text = sender
            cell.subjectLabel.text = subject
            cell.messageLabel.text = message
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        return cell
    }
    
    // Torna as células clicáveis
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmail = dados[indexPath.row]
        
        // Extrair o índice do objeto NSManagedObject
        guard let index = selectedEmail.value(forKey: "index") as? Int else {
            print("Erro: Não foi possível obter o índice do objeto NSManagedObject.")
            return
        }
        
        // Instanciando EmailDetailsViewController a partir do storyboard
        if let emailDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmailDetailsViewController") as? EmailDetailsViewController {
            // Passando o índice do email para a próxima tela
            emailDetailsVC.index = index
            emailDetailsVC.delegate = self
            
            // Apresentando o EmailDetailsViewController
            navigationController?.pushViewController(emailDetailsVC, animated: true)
        }
    }
}
