import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, MenuViewControllerDelegate, EmailUpdateDelegate, UITextFieldDelegate {

    var dados: [NSManagedObject] = []
    var menuViewController: MenuViewController?
    var originalCxEntradaConstraint: NSLayoutConstraint?

    @IBOutlet weak var tableViewCxEntrada: UITableView!
    @IBOutlet weak var backViewForMenu: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstForMenuView: NSLayoutConstraint!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var menubutton: UIButton!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var cxEntradaView: UIView!
    @IBOutlet weak var cxEntradaConstrain: NSLayoutConstraint!
    @IBOutlet weak var midView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backViewForMenu.isHidden = true
        tableViewCxEntrada.register(CxEntradaTableViewCell.nib, forCellReuseIdentifier: CxEntradaTableViewCell.cell)
        tableViewCxEntrada.dataSource = self
        tableViewCxEntrada.delegate = self
        searchTextField.delegate = self // Set the delegate for searchTextField
        setupMenuUI()
        setupBackgroundTapGesture()
        originalCxEntradaConstraint = cxEntradaConstrain
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        loadEmails()
    }

    func loadEmails(filter: String? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        // Criar uma fetch request para recuperar os emails filtrados pelo tópico "usuarioRecebeu"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")

        if let filter = filter, !filter.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "topic == %@ AND (sender CONTAINS[cd] %@ OR message CONTAINS[cd] %@ OR subject CONTAINS[cd] %@)", "usuarioRecebeu", filter, filter, filter)
        } else {
            fetchRequest.predicate = NSPredicate(format: "topic == %@", "usuarioRecebeu")
        }

        do {
            dados = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            tableViewCxEntrada.reloadData() // Atualizar a tabela com os novos dados
        } catch let error as NSError {
            print("Não foi possível retornar os registros. \(error)")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let filterText = textField.text {
            loadEmails(filter: filterText)
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "menuSegue") {
            if let controller = segue.destination as? MenuViewController {
                self.menuViewController = controller
                self.menuViewController?.delegate = self
                self.menuViewController?.emailUpdateDelegate = self  // Definir o delegado
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

        tableViewCxEntrada.separatorColor = .clear
        backViewForMenu.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
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
        searchTextField.placeholder = "Buscar"
        searchTextField.textColor = .white
        searchTextField.backgroundColor = .clear

        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Buscar",
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

    // Implementação do método do delegado para atualização da tabela de emails
    func didUpdateEmails() {
        loadEmails()
    }

    private func setupBackgroundTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        backViewForMenu.addGestureRecognizer(tapGesture)
    }

    @objc private func handleBackgroundTap() {
        self.hidenMenuVIew()
    }

    // Método do UIScrollViewDelegate para detectar quando o usuário começou a rolar a tabela
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("O usuário começou a rolar a tabela")
        // Certifique-se de que a restrição anterior seja desativada
        cxEntradaConstrain.isActive = false
        cxEntradaConstrain = cxEntradaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        cxEntradaConstrain.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // Método do UIScrollViewDelegate para detectar a rolagem
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        // Detecta quando está rolando de baixo para cima e chegou na primeira célula
        if offsetY < 0 && scrollView.isDragging {
            print("O usuário está rolando para cima e chegou na primeira célula")
            // Certifique-se de que a restrição anterior seja desativada
            cxEntradaConstrain.isActive = false
            cxEntradaConstrain = cxEntradaView.topAnchor.constraint(equalTo: midView.topAnchor, constant: -30)
            cxEntradaConstrain.isActive = true

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
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
        if let recievedemailDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecievedEmailDetailsViewController") as? RecievedEmailDetailsViewController {
            // Passando o índice do email para a próxima tela
            recievedemailDetailsVC.index = index
            recievedemailDetailsVC.delegate = self  // Definir o delegado

            // Apresentando o EmailDetailsViewController
            present(recievedemailDetailsVC, animated: true)
        }
    }
}
