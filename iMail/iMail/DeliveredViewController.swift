//
//  DeliveredViewController.swift
//  iMail
//
//  Created by Yuri Araujo on 28/05/24.
//

import UIKit
import CoreData

class DeliveredViewController: UIViewController {
    
    var dados: [NSManagedObject] = []

    @IBOutlet weak var tableViewDelivered: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelivered.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        
        do {
            dados = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Não foi possivel retornar os registros. \(error)")
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Remover Nome", message: "Insira o nome a ser removido", preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Remover", style: .destructive) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                  let nameToRemove = textField.text else {
                return
            }
            
            remove(name: nameToRemove)
            self.tableViewDelivered.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addTextField()
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)

    }
    
    
    
    func remove(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "sender == %@", name)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for entity in fetchedResults {
                managedContext.delete(entity)
            }
            try managedContext.save()
            dados = try managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Emails"))
        } catch let error as NSError {
            print("Erro ao remover o nome \(error)")
        }
    }
}

extension DeliveredViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dados.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let email = dados[indexPath.row]
        cell.textLabel?.text = email.value(forKey: "sender") as? String
        return cell
    }
}
