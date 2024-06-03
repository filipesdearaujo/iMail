import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, MenuViewControllerDelegate {
    
    var dados: [NSManagedObject] = []
    var menuViewController: MenuViewController?
    
    @IBOutlet weak var tableViewCxEntrada: UITableView!
    @IBOutlet weak var backViewForMenu: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstForMenuView: NSLayoutConstraint!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var menubutton: UIButton!
    @IBOutlet weak var calendarView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backViewForMenu.isHidden = true
        tableViewCxEntrada.register(CxEntradaTableViewCell.nib, forCellReuseIdentifier: CxEntradaTableViewCell.cell)
        tableViewCxEntrada.dataSource = self
        tableViewCxEntrada.delegate = self
        setupMenuUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        loadEmails()
    }

    func loadEmails() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Recuperar o email do destinatário atual da entidade "Person" do CoreData
        let recipientEmail = fetchRecipientEmail()
        
        // Verificar se foi possível recuperar o email do destinatário
        guard let recipientEmail = recipientEmail else {
            print("Não foi possível recuperar o email do destinatário.")
            return
        }
        
        // Criar uma fetch request para recuperar os emails filtrados pelo email do destinatário
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "sender != %@", recipientEmail)
        
        do {
            dados = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            tableViewCxEntrada.reloadData() // Atualizar a tabela com os novos dados
        } catch let error as NSError {
            print("Não foi possível retornar os registros. \(error)")
        }
    }

    func fetchRecipientEmail() -> String? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            if let person = try managedContext.fetch(fetchRequest).first as? NSManagedObject {
                return person.value(forKey: "email") as? String
            }
        } catch let error as NSError {
            print("Erro ao buscar o email do destinatário: \(error)")
        }
        
        return nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "menuSegue") {
            if let controller = segue.destination as? MenuViewController {
                self.menuViewController = controller
                self.menuViewController?.delegate = self
            }
        }
    }
    
    @IBAction func addNamePressed(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(identifier: "SendEmailViewController") as? SendEmailViewController {
            present(nextVC, animated: true)
        }
    }
    
    @IBAction func tappedOnMenuBackView(_ sender: Any) {
        self.hidenMenuVIew()
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.leadingConstForMenuView.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.1, animations: {
                self.leadingConstForMenuView.constant = 0
                self.view.layoutIfNeeded()
            }) { (status) in
                self.backViewForMenu.isHidden = false
            }
            self.backViewForMenu.isHidden = false
        }
    }

    func hidenMenuVIew() {
        self.hideMenuView()
    }
    
    private func hideMenuView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.leadingConstForMenuView.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.1, animations: {
                self.leadingConstForMenuView.constant = -280
                self.view.layoutIfNeeded()
            }) { (status) in
                self.backViewForMenu.isHidden = true
            }
            self.backViewForMenu.isHidden = true
        }
    }
    
    private func setupMenuUI() {
        sendEmailButton.layer.cornerRadius = 30
        sendEmailButton.clipsToBounds = true
        sendEmailButton.layer.borderWidth = 2
        sendEmailButton.layer.borderColor = UIColor.red.cgColor
        sendEmailButton.setTitleColor(.white, for: .normal)
        
        configureCalendarView(calendarView)
        configureSearchTextField()
        configImageButton(Button: sendEmailButton, imageName: "ImageWriteButton", color: .white)
        configImageButton(Button: menubutton, imageName: "menuButtonImage", color: .clear)
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
    func configureCalendarView(_ view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.masksToBounds = true
    }
    
    private func configureSearchTextField() {
        searchTextField.placeholder = "Search"
        searchTextField.textColor = .white
        searchTextField.backgroundColor = .clear
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        searchTextField.borderStyle = .none
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: searchTextField.frame.size.height - 1, width: searchTextField.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.red.cgColor
        searchTextField.layer.addSublayer(bottomBorder)
        
        searchTextField.layoutIfNeeded()
        bottomBorder.frame = CGRect(x: 0, y: searchTextField.frame.size.height - 1, width: searchTextField.frame.size.width, height: 1)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CxEntradaTableViewCell.cell, for: indexPath) as? CxEntradaTableViewCell else {
            fatalError("The dequeued cell is not an instance of CxEntradaTableViewCell.")
        }
        
        let email = dados[indexPath.row]
        
        if let sender = email.value(forKey: "sender") as? String,
           let message = email.value(forKey: "message") as? String,
           let subject = email.value(forKey: "subject") as? String,
           let date = email.value(forKey: "date") as? Date {
            cell.remetenteLabel.text = sender
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
        if let recievedemailDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecievedEmailDatailsViewController") as? RecievedEmailDatailsViewController {
            // Passando o índice do email para a próxima tela
            recievedemailDetailsVC.index = index
            
            // Apresentando o EmailDetailsViewController
            present(recievedemailDetailsVC, animated: true)
        }
    }
}
