////
////  ViewController.swift
////  iMail
////
////  Created by Yuri Araujo on 25/05/24.
////
//
//import UIKit
//import CoreData
//
//class ViewController: UIViewController, MenuViewControllerDelegate {
//    
//    var people: [NSManagedObject] = []
//    
//    @IBOutlet weak var tableViewCxEntrada: UITableView!
//    @IBOutlet weak var searchView: UIView!
//    @IBOutlet weak var backViewForMenu: UIView!
//    @IBOutlet weak var menuView: UIView!
//    @IBOutlet weak var leadingConstForMenuView: NSLayoutConstraint!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        backViewForMenu.isHidden = true
//        setupMenuUI()
//        
//        //table view
//        tableViewCxEntrada.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
//        
//        do {
//            people = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Não foi possivel retornar os registros. \(error)")
//        }
//    }
//    
//    
//    var menuViewController:MenuViewController?
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "menuSegue") {
//            if let controller = segue.destination as? MenuViewController {
//                self.menuViewController = controller
//                self.menuViewController?.delegate = self
//            }
//        }
//    }
//
//    
//    @IBAction func addNamePressed(_ sender: Any) {
//        let alert = UIAlertController(title: "Nome", message: "Insira o nome", preferredStyle: .alert)
//        
//        let saveAction = UIAlertAction(title: "Salvar", style: .default) {
//            [unowned self] action in
//            
//            guard let textField = alert.textFields?.first,
//                  let nameToSave = textField.text else {
//                return
//            }
//            
//            save(name: nameToSave)
//            self.tableViewCxEntrada.reloadData()
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
//        
//        alert.addTextField()
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true)
//    }
//        
//    
//    @IBAction func tappedOnMenuBackView(_ sender: Any) {
//        self.hidenMenuVIew()
//        
//    }
//    
//    @IBAction func menuButtonClicked(_ sender: Any) {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.leadingConstForMenuView.constant = 10
//            self.view.layoutIfNeeded()
//        }) { (status) in
//            UIView.animate(withDuration: 0.1, animations: {
//                self.leadingConstForMenuView.constant = 0
//                self.view.layoutIfNeeded()
//            }) { (status) in
//                self.backViewForMenu.isHidden = false
//            }
//            self.backViewForMenu.isHidden = false
//        }
//    }
//    
//    
//    
//    
//    func hidenMenuVIew() {
//        self.hideMenuView()
//    }
//    
//    private func hideMenuView() {
//        
//        UIView.animate(withDuration: 0.2, animations: {
//            self.leadingConstForMenuView.constant = 10
//            self.view.layoutIfNeeded()
//        }) { (status) in
//            UIView.animate(withDuration: 0.1, animations: {
//                self.leadingConstForMenuView.constant = -280
//                self.view.layoutIfNeeded()
//            }) { (status) in
//                self.backViewForMenu.isHidden = true
//            }
//            self.backViewForMenu.isHidden = true
//        }
//
//    }
//    
//    
//    private func setupMenuUI() {
//        self.searchView.layer.cornerRadius = 5
//        self.searchView.clipsToBounds = true
//    }
//    
//    func save(name: String){
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
//        
//        let person = NSManagedObject(entity: entity, insertInto: managedContext)
//        person.setValue(name, forKey: "name")
//        
//        do {
//            try managedContext.save()
//            people.append(person)
//        } catch let error as NSError {
//            print("Erro ao salvar novo nome \(error)")
//        }
//        
//    }
//    
//
//}
//
//
//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return people.count
//    }
//        
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let person = people[indexPath.row]
//        
//        
//        cell.textLabel?.text = person.value(forKey: "name") as? String
//        return cell
//    }
//}


//
//  ViewController.swift
//  iMail
//
//  Created by Filipe Simões on 25/05/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, MenuViewControllerDelegate {
    
    var people: [NSManagedObject] = []
    var menuViewController: MenuViewController?

    
    @IBOutlet weak var tableViewCxEntrada: UITableView!
    @IBOutlet weak var backViewForMenu: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstForMenuView: NSLayoutConstraint!
    @IBOutlet weak var sendEmailButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backViewForMenu.isHidden = true
        setupMenuUI()
        
        //table view
        tableViewCxEntrada.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Não foi possivel retornar os registros. \(error)")
        }
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "menuSegue") {
            if let controller = segue.destination as? MenuViewController {
                self.menuViewController = controller
                self.menuViewController?.delegate = self
            }
        }
    }

    
    @IBAction func addNamePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Nome", message: "Insira o nome", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else {
                return
            }
            
            save(name: nameToSave)
            self.tableViewCxEntrada.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
        
    @IBAction func removeNamePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Remover Nome", message: "Insira o nome a ser removido", preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Remover", style: .destructive) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                  let nameToRemove = textField.text else {
                return
            }
            
            remove(name: nameToRemove)
            self.tableViewCxEntrada.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addTextField()
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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
        sendEmailButton.layer.cornerRadius = 20  // Metade da altura do botão para bordas totalmente arredondadas
        sendEmailButton.clipsToBounds = true

    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Erro ao salvar novo nome \(error)")
        }
    }
    
    func remove(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for entity in fetchedResults {
                managedContext.delete(entity)
            }
            try managedContext.save()
            people = try managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Person"))
        } catch let error as NSError {
            print("Erro ao remover o nome \(error)")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
}
