//
//  DeliveredViewController.swift
//  iMail
//
//  Created by Filipe Simões on 28/05/24.
//

import UIKit
import CoreData

protocol MenuViewControllerDelegate: AnyObject {
    func hidenMenuVIew()
}

class DeliveredViewController: UIViewController, UITableViewDelegate {
    
    var dados: [NSManagedObject] = []
    
    @IBOutlet weak var tableViewDelivered: UITableView!
    @IBOutlet weak var reloadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelivered.register(DeliveredTableViewCell.nib, forCellReuseIdentifier: DeliveredTableViewCell.cell)
        //tableViewDelivered.delegate = self
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
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        tableViewDelivered.reloadData()
    }
}

extension DeliveredViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableViewDelivered.dequeueReusableCell(withIdentifier: DeliveredTableViewCell.cell, for: indexPath) as? DeliveredTableViewCell else {
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
    //ajusta a altura da celula
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    //torna as celulas clicáveis
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Aqui você pode acessar a célula selecionada e realizar as ações desejadas
        let selectedEmail = dados[indexPath.row]
        print("Email selecionado:", selectedEmail)
        
        // Extrair o índice do objeto NSManagedObject
        guard let index = selectedEmail.value(forKey: "index") as? Int else {
            print("Erro: Não foi possível obter o índice do objeto NSManagedObject.")
            return
        }

        // Instanciando EmailDetailsViewController a partir do storyboard
        if let emailDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmailDetailsViewController") as? EmailDetailsViewController {
            // Passando o índice do email para a próxima tela
            emailDetailsVC.index = index
            
            // Apresentando o EmailDetailsViewController
            present(emailDetailsVC, animated: true)
        }
    }
}