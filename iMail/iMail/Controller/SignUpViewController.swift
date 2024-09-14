//import UIKit
//import CoreData
//
//class SignUpViewController: UIViewController {
//    
//    // MARK: - Properties
//    var people: [NSManagedObject] = []
//
//    // MARK: - Outlets
//    @IBOutlet weak var SignUpNameTextField: UITextField!
//    @IBOutlet weak var SignUpEmailTextField: UITextField!
//    @IBOutlet weak var SignUpPasswordTextField: UITextField!
//    @IBOutlet weak var SignUpEnterButton: UIButton!
//    
//    // MARK: - Lifecycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureUI()
//        setupDismissKeyboardGesture()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        checkPersonEntity()
//    }
//    
//    // MARK: - UI Configuration
//    private func configureUI() {
//        configureTextField(SignUpNameTextField, placeholder: "Nome")
//        configureTextField(SignUpEmailTextField, placeholder: "Email")
//        configureTextField(SignUpPasswordTextField, placeholder: "Senha")
//        configureButton(SignUpEnterButton, title: "Entrar")
//    }
//    
//    private func configureTextField(_ textField: UITextField, placeholder: String) {
//        textField.placeholder = placeholder
//        textField.textColor = .white
//        textField.backgroundColor = .clear
//        textField.attributedPlaceholder = NSAttributedString(
//            string: placeholder,
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//        textField.borderStyle = .none
//        
//        let bottomBorder = CALayer()
//        bottomBorder.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
//        bottomBorder.backgroundColor = UIColor.red.cgColor
//        textField.layer.addSublayer(bottomBorder)
//        textField.layoutIfNeeded()
//        bottomBorder.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
//    }
//    
//    private func configureButton(_ button: UIButton, title: String) {
//        button.setTitle(title, for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .clear
//        button.layer.cornerRadius = 20
//        button.layer.borderWidth = 3
//        button.layer.borderColor = UIColor.red.cgColor
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
//    }
//    
//    // MARK: - Gesture Configuration
//    private func setupDismissKeyboardGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    
//    // MARK: - Core Data
//    private func checkPersonEntity() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
//        
//        do {
//            people = try managedContext.fetch(fetchRequest)
//            navigateToMainViewControllerIfNeeded()
//        } catch {
//            print("Failed to fetch records: \(error)")
//        }
//    }
//    
//    private func save(name: String, email: String, password: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
//        let person = NSManagedObject(entity: entity, insertInto: managedContext)
//        
//        person.setValue(name, forKey: "name")
//        person.setValue(email, forKey: "email")
//        person.setValue(password, forKey: "password")
//        person.setValue("defaultMode", forKey: "theme")
//
//        do {
//            try managedContext.save()
//            people.append(person)
//            navigateToMainViewController()
//        } catch {
//            print("Failed to save person: \(error)")
//        }
//    }
//    
//    private func createEmail() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        
//        if let entity = NSEntityDescription.entity(forEntityName: "Emails", in: context) {
//            let newEmail = NSManagedObject(entity: entity, insertInto: context)
//            newEmail.setValue(EmailRandomGenerator.shared.fetchIndex(), forKey: "index")
//            newEmail.setValue(EmailRandomGenerator.shared.fetchEmail(), forKey: "to")
//            newEmail.setValue(EmailRandomGenerator.shared.generateRandomEmailAddress(), forKey: "sender")
//            newEmail.setValue(EmailRandomGenerator.shared.generateRandomDate(), forKey: "date")
//            let message = EmailRandomGenerator.shared.getRandomMessage()
//            newEmail.setValue(message.message, forKey: "message")
//            newEmail.setValue(message.subject, forKey: "subject")
//            newEmail.setValue("usuarioRecebeu", forKey: "topic")
//            
//            do {
//                try context.save()
//            } catch {
//                print("Failed to save email: \(error)")
//            }
//        }
//    }
//    
//    // MARK: - Navigation
//    private func navigateToMainViewControllerIfNeeded() {
//        if !people.isEmpty {
//            navigateToMainViewController()
//        }
//    }
//
//    private func navigateToMainViewController() {
//        if let navigationController = self.navigationController,
//           let viewController = navigationController.storyboard?.instantiateViewController(withIdentifier: "ViewController") {
//            navigationController.setViewControllers([viewController], animated: true)
//        }
//    }
//
//    // MARK: - Actions
//    @IBAction func enterButtonPressed(_ sender: Any) {
//        guard let name = SignUpNameTextField.text, !name.isEmpty,
//              let email = SignUpEmailTextField.text, !email.isEmpty,
//              let password = SignUpPasswordTextField.text, !password.isEmpty else {
//            showAlert(message: "Há um campo vazio")
//            return
//        }
//        
//        if !isValidEmail(email) {
//            showAlert(message: "Isso não é um email válido")
//            return
//        }
//        
//        if name.count > 10 {
//            showAlert(message: "Escreva apenas o primeiro nome")
//            return
//        }
//        
//        // Salvando o novo usuário
//        save(name: name, email: email, password: password)
//        for _ in 1...10 {
//            createEmail()
//        }
//        showAlert(message: "Usuário cadastrado com sucesso! Por favor, faça o login novamente.")
//    }
//    
//    @IBAction func darkModeButtonTapped(_ sender: UIButton) {
//        showThemeChangeAlert(for: "darkMode")
//    }
//
//    @IBAction func defaultModeButtonTapped(_ sender: UIButton) {
//        showThemeChangeAlert(for: "defaultMode")
//    }
//
//    @IBAction func highcontrastModeButtonTapped(_ sender: UIButton) {
//        showThemeChangeAlert(for: "highcontrastMode")
//    }
//
//
//    // MARK: - Validation
//    private func isValidEmail(_ email: String) -> Bool {
//        return email.contains("@") && email.contains(".com")
//    }
//    
//    // MARK: - Alerts
//    private func showAlert(message: String) {
//        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    // MARK: - Auxiliar Functions
//    
//    private func showThemeChangeAlert(for theme: String) {
//        let alert = UIAlertController(title: "Alterar Tema", message: "Tem certeza de que deseja alterar o tema? O aplicativo será fechado automaticamente.", preferredStyle: .alert)
//        
//        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
//        
//        let confirmAction = UIAlertAction(title: "Sim", style: .destructive) { _ in
//            self.updateThemeInCoreData(to: theme)
//        }
//        
//        alert.addAction(cancelAction)
//        alert.addAction(confirmAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//    
//    private func updateThemeInCoreData(to theme: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
//        
//        do {
//            let people = try managedContext.fetch(fetchRequest)
//            if let person = people.first {
//                person.setValue(theme, forKey: "theme")
//                try managedContext.save()
//                print("Tema atualizado para: \(theme)")
//            }
//        } catch let error as NSError {
//            print("Erro ao atualizar o tema: \(error)")
//        }
//    }
//


import UIKit
import CoreData

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    var people: [NSManagedObject] = []
    var selectedTheme: String? // Variável para armazenar o tema selecionado temporariamente
    
    // MARK: - Outlets
    @IBOutlet weak var SignUpNameTextField: UITextField!
    @IBOutlet weak var SignUpEmailTextField: UITextField!
    @IBOutlet weak var SignUpPasswordTextField: UITextField!
    @IBOutlet weak var SignUpEnterButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var defaultModeButton: UIButton!
    @IBOutlet weak var highcontrastModeButton: UIButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDismissKeyboardGesture()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureTextField(SignUpNameTextField, placeholder: "Nome")
        configureTextField(SignUpEmailTextField, placeholder: "Email")
        configureTextField(SignUpPasswordTextField, placeholder: "Senha")
        configureButton(SignUpEnterButton, title: "Entrar")
        configureThemeButton(darkModeButton)
        configureThemeButton(defaultModeButton)
        configureThemeButton(highcontrastModeButton)
    }
        private func configureTextField(_ textField: UITextField, placeholder: String) {
            textField.placeholder = placeholder
            textField.textColor = .white
            textField.backgroundColor = .clear
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
    
    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.red.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    }
    
    private func configureThemeButton(_ button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Gesture Configuration
        private func setupDismissKeyboardGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
    
        @objc private func dismissKeyboard() {
            view.endEditing(true)
        }

    
    // MARK: - Core Data
    
    private func save(name: String, email: String, password: String, theme: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(email, forKey: "email")
        person.setValue(password, forKey: "password")
        person.setValue(theme, forKey: "theme")

        do {
            try managedContext.save()
            people.append(person)
            navigateToMainViewController()
        } catch {
            print("Failed to save person: \(error)")
        }
    }

    private func createEmail() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Emails", in: context) {
            let newEmail = NSManagedObject(entity: entity, insertInto: context)
            newEmail.setValue(EmailRandomGenerator.shared.fetchIndex(), forKey: "index")
            newEmail.setValue(EmailRandomGenerator.shared.fetchEmail(), forKey: "to")
            newEmail.setValue(EmailRandomGenerator.shared.generateRandomEmailAddress(), forKey: "sender")
            newEmail.setValue(EmailRandomGenerator.shared.generateRandomDate(), forKey: "date")
            let message = EmailRandomGenerator.shared.getRandomMessage()
            newEmail.setValue(message.message, forKey: "message")
            newEmail.setValue(message.subject, forKey: "subject")
            newEmail.setValue("usuarioRecebeu", forKey: "topic")
            
            do {
                try context.save()
            } catch {
                print("Failed to save email: \(error)")
            }
        }
    }

    // MARK: - Navigation
        private func navigateToMainViewController() {
            if let navigationController = self.navigationController,
               let viewController = navigationController.storyboard?.instantiateViewController(withIdentifier: "ViewController") {
                navigationController.setViewControllers([viewController], animated: true)
            }
        }

    // MARK: - Actions
    @IBAction func enterButtonPressed(_ sender: Any) {
        guard let name = SignUpNameTextField.text, !name.isEmpty,
              let email = SignUpEmailTextField.text, !email.isEmpty,
              let password = SignUpPasswordTextField.text, !password.isEmpty,
              let theme = selectedTheme else {
            showAlert(message: "Preencha todos os campos e selecione um tema.")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(message: "Isso não é um email válido.")
            return
        }
        
        if name.count > 10 {
            showAlert(message: "Escreva apenas o primeiro nome.")
            return
        }
        
        // Salvando o novo usuário com o tema selecionado
        save(name: name, email: email, password: password, theme: theme)
        for _ in 1...10 {
            createEmail()
        }
        dismiss(animated: true)
    }
    
    @IBAction func darkModeButtonTapped(_ sender: UIButton) {
        selectTheme("darkMode", for: darkModeButton)
    }

    @IBAction func defaultModeButtonTapped(_ sender: UIButton) {
        selectTheme("defaultMode", for: defaultModeButton)
    }

    @IBAction func highcontrastModeButtonTapped(_ sender: UIButton) {
        selectTheme("highcontrastMode", for: highcontrastModeButton)
    }

    private func selectTheme(_ theme: String, for selectedButton: UIButton) {
        selectedTheme = theme
        darkModeButton.layer.borderColor = UIColor.clear.cgColor
        defaultModeButton.layer.borderColor = UIColor.clear.cgColor
        highcontrastModeButton.layer.borderColor = UIColor.clear.cgColor
        selectedButton.layer.borderColor = UIColor.red.cgColor
    }

    // MARK: - Validation
    private func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".com")
    }

    // MARK: - Alerts
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

