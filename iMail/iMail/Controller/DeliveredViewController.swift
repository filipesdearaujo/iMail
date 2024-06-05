import UIKit
import CoreData

protocol MenuViewControllerDelegate: AnyObject {
    func hidenMenuVIew()
}

protocol EmailDetailsViewControllerDelegate: AnyObject {
    func didUpdateEmail()
}

class DeliveredViewController: UIViewController, UITableViewDelegate, EmailDetailsViewControllerDelegate {
    
    var dados: [NSManagedObject] = []
    let fetchEmails = FetchEmails()
    var topic: String?
    var buttonTitle: String?
    
    @IBOutlet weak var tableViewDelivered: UITableView!
    @IBOutlet weak var enviadosSearchTextField: UITextField!
    @IBOutlet weak var subectLabel: UILabel!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelivered.register(DeliveredTableViewCell.nib, forCellReuseIdentifier: DeliveredTableViewCell.cell)
        tableViewDelivered.dataSource = self
        tableViewDelivered.delegate = self
        setupUI()
        
        // Configure the subject label with the button title
        if let buttonTitle = buttonTitle {
            subectLabel.text = buttonTitle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let topic = topic else { return }
        fetchEmails.fetch(topic: topic) { [weak self] fetchedDados in
            guard let self = self else { return }
            self.dados = fetchedDados
            DispatchQueue.main.async {
                self.tableViewDelivered.reloadData()
            }
        }
    }
    
    @IBAction func deleteAllTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Apagar Todos", message: "Você realmente deseja apagar todos os emails? Esta ação não pode ser desfeita.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Apagar", style: .destructive) { _ in
            self.deleteAllEmails()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteAllEmails() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
        } catch let error as NSError {
            print("Não foi possível apagar os registros. \(error)")
        }
    }
    
    func setupUI() {
        configureTextField(enviadosSearchTextField)
        tableViewDelivered.separatorColor = .clear
        configImageButton(Button: deleteAllButton, imageName: "trashIcon", color: .clear)
    }
    
    func configImageButton(Button: UIButton, imageName: String, color: UIColor) {
        Button.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        let contentImage = UIImage(named: imageName)
        Button.setImage(contentImage, for: .normal)

        // Definir a cor de fundo do botão como branco
        Button.backgroundColor = color

        // Ajustar o conteúdo para centralizar a imagem
        Button.contentVerticalAlignment = .center
        Button.contentHorizontalAlignment = .center
    }
    
    private func configureTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.layer.masksToBounds = true
        textField.textColor = .white
        
        let placeholderText = textField.placeholder ?? "Pesquisar em \(buttonTitle!)"
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    // Implementação do método do delegado
    func didUpdateEmail() {
        guard let topic = topic else { return }
        fetchEmails.fetch(topic: topic) { [weak self] fetchedDados in
            guard let self = self else { return }
            self.dados = fetchedDados
            DispatchQueue.main.async {
                self.tableViewDelivered.reloadData()
            }
        }
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
        if let to = email.value(forKey: "to") as? String,
           let message = email.value(forKey: "message") as? String,
           let subject = email.value(forKey: "subject") as? String,
           let date = email.value(forKey: "date") as? Date {
            cell.toLabel.text = to
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
        // Aqui você pode acessar a célula selecionada e realizar as ações desejadas
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
            emailDetailsVC.delegate = self // Define o delegado
            
            // Apresentando o EmailDetailsViewController
            present(emailDetailsVC, animated: true)
        }
    }
}

