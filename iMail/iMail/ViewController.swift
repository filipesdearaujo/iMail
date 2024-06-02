import UIKit
import CoreData

class ViewController: UIViewController, MenuViewControllerDelegate {
    
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
        setupMenuUI()
        tableViewCxEntrada.register(CxEntradaTableViewCell.nib, forCellReuseIdentifier: CxEntradaTableViewCell.cell)
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
}
