//import UIKit
//import CoreData
//
//class MoveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    var index: Int!
//    var labels: [Label] = [] // Armazena os objetos Label
//    weak var delegate: EmailUpdateDelegate?
//    
//    @IBOutlet weak var cxEntradaButton: UIButton!
//    @IBOutlet weak var spamButton: UIButton!
//    @IBOutlet weak var favoritosButton: UIButton!
//    @IBOutlet weak var lixeiraButton: UIButton!
//    @IBOutlet weak var labelsView: UIView!
//    @IBOutlet weak var labelsTableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        labelsTableView.register(LabelTableViewCell.nib, forCellReuseIdentifier: LabelTableViewCell.cellIdentifier)
//        labelsTableView.dataSource = self
//        labelsTableView.delegate = self
//        setupUI()
//        fetchLabels()
//    }
//    
//    func fetchLabels() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<Label>(entityName: "Label")
//        
//        do {
//            labels = try managedContext.fetch(fetchRequest)
//            labelsTableView.reloadData()
//        } catch let error as NSError {
//            print("Erro ao buscar labels: \(error)")
//        }
//    }
//    
//    @IBAction func addLabelButtonTapped(_ sender: Any) {
//        let alertController = UIAlertController(title: "Criar novo Marcador", message: nil, preferredStyle: .alert)
//        
//        alertController.addTextField { textField in
//            textField.placeholder = "Nome do marcador"
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
//        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//            if let textField = alertController.textFields?.first, let labelName = textField.text {
//                self.saveLabel(name: labelName)
//            }
//        }
//        
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    func saveLabel(name: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Label", in: managedContext)!
//        let label = NSManagedObject(entity: entity, insertInto: managedContext) as! Label
//        
//        label.name = name
//        
//        do {
//            try managedContext.save()
//            labels.append(label)
//            labelsTableView.reloadData()
//            print("Label saved: \(label.name ?? "")")
//        } catch let error as NSError {
//            print("Error saving label: \(error)")
//        }
//    }
//    
//    @IBAction func favoritosButtonTapped(_ sender: Any) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")
//        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
//        
//        do {
//            let result = try managedContext.fetch(fetchRequest)
//            if let email = result.first as? NSManagedObject {
//                email.setValue("usuarioSalvou", forKey: "topic")
//                
//                try managedContext.save()
//                showAlert(title: "Sucesso", message: "O e-mail foi Salvo.", shouldDismiss: true)
//                print("Email marcado como salvo.")
//            } else {
//                showAlert(title: "Erro", message: "Não Foi possível salvar o Email.", shouldDismiss: false)
//                print("Erro: Não foi possível encontrar o email com o índice especificado.")
//            }
//        } catch let error as NSError {
//            print("Erro ao atualizar o email: \(error)")
//        }
//    }
//    
//    @IBAction func spamButtonTapped(_ sender: Any) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")
//        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
//        
//        do {
//            let result = try managedContext.fetch(fetchRequest)
//            if let email = result.first as? NSManagedObject {
//                email.setValue("usuarioSpam", forKey: "topic")
//                
//                try managedContext.save()
//                showAlert(title: "Sucesso", message: "O e-mail foi Movido.", shouldDismiss: true)
//                print("Email foi marcado como Spam.")
//            } else {
//                showAlert(title: "Erro", message: "Não Foi possível mover o Email.", shouldDismiss: false)
//                print("Erro: Não foi possível mover o email com o índice especificado.")
//            }
//        } catch let error as NSError {
//            print("Erro ao mover o email: \(error)")
//        }
//    }
//    
//    @IBAction func lixeiraButtonTapped(_ sender: Any) {
//        markAsDeleted(index: index)
//    }
//    
//    func markAsDeleted(index: Int) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//    }
//    
//    func setupUI() {
//        addTopLine(to: labelsView)
//    }
//    
//    func addTopLine(to view: UIView) {
//        let topLine = UIView()
//        topLine.translatesAutoresizingMaskIntoConstraints = false
//        topLine.backgroundColor = .red
//        view.addSubview(topLine)
//        
//        NSLayoutConstraint.activate([
//            topLine.topAnchor.constraint(equalTo: view.topAnchor),
//            topLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            topLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            topLine.heightAnchor.constraint(equalToConstant: 1)
//        ])
//    }
//    
//    func showAlert(title: String, message: String, shouldDismiss: Bool) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//            if shouldDismiss {
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    // MARK: - UITableViewDataSource Methods
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return labels.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.cellIdentifier, for: indexPath) as? LabelTableViewCell else {
//            fatalError("The dequeued cell is not an instance of LabelTableViewCell.")
//        }
//        
//        let label = labels[indexPath.row]
//        cell.labelButton.text = label.name
//        
//        return cell
//    }
//    
//    // MARK: - UITableViewDelegate Methods
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let label = labels[indexPath.row]
//        performSegue(withIdentifier: "labelidentifier", sender: label)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "labelidentifier", let destinationVC = segue.destination as? DeliveredViewController, let label = sender as? Label {
//            destinationVC.topic = label.name
//            destinationVC.buttonTitle = label.name ?? "Sem Nome"
//        }
//    }
//}

import UIKit
import CoreData

class MoveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var index: Int!
    var labels: [Label] = []
    weak var delegate: EmailUpdateDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cxEntradaButton: UIButton!
    @IBOutlet weak var spamButton: UIButton!
    @IBOutlet weak var favoritosButton: UIButton!
    @IBOutlet weak var lixeiraButton: UIButton!
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var labelsTableView: UITableView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchLabels()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        labelsTableView.register(LabelTableViewCell.nib, forCellReuseIdentifier: LabelTableViewCell.cellIdentifier)
        labelsTableView.dataSource = self
        labelsTableView.delegate = self
        addTopLine(to: labelsView)
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
    
    private func fetchLabels() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Label>(entityName: "Label")
        
        do {
            labels = try managedContext.fetch(fetchRequest)
            labelsTableView.reloadData()
        } catch let error as NSError {
            print("Erro ao buscar labels: \(error)")
        }
    }
    
    private func saveLabel(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Label", in: managedContext)!
        let label = NSManagedObject(entity: entity, insertInto: managedContext) as! Label
        
        label.name = name
        
        do {
            try managedContext.save()
            labels.append(label)
            labelsTableView.reloadData()
            print("Label saved: \(label.name ?? "")")
        } catch let error as NSError {
            print("Error saving label: \(error)")
        }
    }
    
    private func updateEmailTopic(with topic: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let email = result.first {
                email.setValue("usuario\(topic)", forKey: "topic")
                
                try managedContext.save()
                showAlert(title: "Sucesso", message: "O e-mail foi movido para \(topic).", shouldDismiss: true)
                print("Email marcado como \(topic).")
            } else {
                showAlert(title: "Erro", message: "Não foi possível mover o email.", shouldDismiss: false)
                print("Erro: Não foi possível encontrar o email com o índice especificado.")
            }
        } catch let error as NSError {
            print("Erro ao atualizar o email: \(error)")
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func addLabelButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Criar novo Marcador", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Nome do marcador"
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = alertController.textFields?.first, let labelName = textField.text {
                self.saveLabel(name: labelName)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func favoritosButtonTapped(_ sender: Any) {
        updateEmailTopic(with: "usuarioSalvou")
    }
    
    @IBAction func spamButtonTapped(_ sender: Any) {
        updateEmailTopic(with: "usuarioSpam")
    }
    
    @IBAction func lixeiraButtonTapped(_ sender: Any) {
        updateEmailTopic(with: "usuarioLixeira")
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
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.cellIdentifier, for: indexPath) as? LabelTableViewCell else {
            fatalError("The dequeued cell is not an instance of LabelTableViewCell.")
        }
        
        let label = labels[indexPath.row]
        cell.labelButton.text = label.name
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let label = labels[indexPath.row]
        moveEmailToLabel(labelName: label.name ?? "Sem Nome")
    }
    
    private func moveEmailToLabel(labelName: String) {
        updateEmailTopic(with: labelName)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "labelidentifier", let destinationVC = segue.destination as? DeliveredViewController, let label = sender as? Label {
            destinationVC.topic = label.name
            destinationVC.buttonTitle = label.name ?? "Sem Nome"
        }
    }
}
