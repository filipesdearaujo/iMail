import UIKit
import CoreData

class SendEmailViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    var emails: [NSManagedObject] = []
    var senderEmail: String?
    var originalEmailSender: String?
    var originalEmailTitle: String?
    var originalEmailMessage: String?
    var emailAction: EmailHandler.EmailAction?
    var originalMessageViewHeight: CGFloat?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var subjectEmailTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var messageConstrain: NSLayoutConstraint!
    @IBOutlet weak var messageView: UIView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSenderEmail()
        setupDismissKeyboardGesture()
        messageTextView.delegate = self
        
        originalMessageViewHeight = messageView.frame.height
        
        // Configure os campos com os dados do email original
        configureOriginalEmailData()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        sendEmailButton.layer.cornerRadius = 20
        sendEmailButton.clipsToBounds = true
        configureTextField(senderTextField, placeholder: "De:")
        configureTextField(toTextField, placeholder: "Para:")
        configureSubjectTextField(subjectEmailTextField)
        configureTextView(messageTextView)
        configureButton(sendEmailButton, imageName: "enviarButton")
        configureButton(trashButton, imageName: "trashIcon")
    }
    
    private func configureButton(_ button: UIButton, imageName: String) {
        let contentImage = UIImage(named: imageName)
        button.setImage(contentImage, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.borderStyle = .none
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.red.cgColor
        textField.layer.addSublayer(bottomBorder)
        textField.layoutIfNeeded()
        bottomBorder.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
    }
    
    private func configureSubjectTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.layer.masksToBounds = true
    }
    
    private func configureTextView(_ textView: UITextView) {
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        textView.layer.borderColor = UIColor.red.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10.0
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.returnKeyType = .default
        textView.autocorrectionType = .yes
    }
    
    private func configureOriginalEmailData() {
        guard let action = emailAction else { return }
        switch action {
        case .answer:
            if let sender = originalEmailSender {
                toTextField.text = sender
            }
            if let title = originalEmailTitle {
                subjectEmailTextField.text = "Re: \(title)"
            }
            if let message = originalEmailMessage {
                messageTextView.text = "\n\n--- Mensagem Original ---\n\(message)"
            }
        case .forward:
            if let title = originalEmailTitle {
                subjectEmailTextField.text = title.hasPrefix("Fw: ") ? title : "Fw: \(title)"
            }
            if let message = originalEmailMessage {
                messageTextView.text = "\n\n--- Mensagem Original ---\n\(message)"
            }
        }
    }
    
    // MARK: - Core Data Methods
    
    private func loadSenderEmail() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let person = result.first, let email = person.value(forKey: "email") as? String {
                senderEmail = email
                senderTextField.text = email
            } else {
                print("Nenhum email encontrado")
            }
        } catch {
            print("Erro ao carregar o email do remetente: \(error)")
        }
    }
    
    private func save(sender: String, message: String, subject: String, to: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Emails", in: managedContext)!
        let email = NSManagedObject(entity: entity, insertInto: managedContext)
        
        email.setValue(sender, forKey: "sender")
        email.setValue(message, forKey: "message")
        email.setValue(subject, forKey: "subject")
        email.setValue(to, forKey: "to")
        email.setValue(Date(), forKey: "date")
        email.setValue("usuarioEnviou", forKey: "topic")
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Emails")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            if let lastEmail = try managedContext.fetch(fetchRequest).first,
               let lastIndex = lastEmail.value(forKey: "index") as? Int {
                email.setValue(lastIndex + 1, forKey: "index")
            } else {
                email.setValue(0, forKey: "index")
            }
        } catch {
            print("Erro ao recuperar o último índice: \(error)")
        }
        
        do {
            try managedContext.save()
            emails.append(email)
        } catch {
            print("Erro ao salvar o email: \(error)")
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        guard let sender = senderTextField.text, !sender.isEmpty,
              let message = messageTextView.text, !message.isEmpty,
              let subject = subjectEmailTextField.text, !subject.isEmpty,
              let to = toTextField.text, !to.isEmpty else {
            showAlert(message: "Há um campo em vazio")
            return
        }
        
        if !isValidEmail(sender) {
            showAlert(message: "Verificar o email do remetente digitado")
            return
        }
        if !isValidEmail(to) {
            showAlert(message: "Verificar o email do destinatário digitado")
            return
        }
        
        save(sender: sender, message: message, subject: subject, to: to)
        showAlert(title: "Sucesso", message: "O e-mail foi enviado")
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(title: String = "", message: String) {
        let alertController = UIAlertController(title: title.isEmpty ? nil : title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if title == "Sucesso" {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".com")
    }
    
    // MARK: - UITextViewDelegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Escreva seu Email aqui..." {
            textView.text = ""
            textView.textColor = .white // Define o texto para branco ao iniciar a edição
        }
        
        // Expand the messageView to the top of the screen
        adjustMessageViewHeight(expand: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Escreva seu Email aqui..."
            textView.textColor = .lightGray
        }
        
        // Restore the original height of the messageView
        adjustMessageViewHeight(expand: false)
    }
    
    private func adjustMessageViewHeight(expand: Bool) {
        messageConstrain.isActive = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageConstrain = expand ? messageView.topAnchor.constraint(equalTo: view.topAnchor) : messageView.heightAnchor.constraint(equalToConstant: originalMessageViewHeight ?? 200)
        messageConstrain.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Gesture Configuration
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
