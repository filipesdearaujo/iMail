//
//  RecievedEmailDatailsViewController.swift
//  iMail
//
//  Created by Filipe Simões on 03/06/24.
//

import UIKit
import CoreData

class RecievedEmailDatailsViewController: UIViewController {
    
    var index: Int = 0
    var dados: [NSManagedObject] = []

    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toImage: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var asnwerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmailDetails()
    }
    
    func loadEmailDetails() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let email = result.first as? NSManagedObject {
                // Extrair as informações do email
                if let sender = email.value(forKey: "sender") as? String {
                    senderLabel.text = sender
                }
                if let to = email.value(forKey: "to") as? String {
                    toLabel.text = to
                }
                if let subject = email.value(forKey: "subject") as? String {
                    subjectLabel.text = subject
                }
                if let message = email.value(forKey: "message") as? String {
                    messageTextView.text = message
                }
                
                // Exibir a data
                if let date = email.value(forKey: "date") as? Date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                    let dateString = dateFormatter.string(from: date)
                    dateLabel.text = dateString
                } else {
                    dateLabel.text = "Data: Indisponível"
                }
            } else {
                print("Erro: Não foi possível encontrar o email com o índice especificado.")
            }
        } catch let error as NSError {
            print("Erro ao carregar os detalhes do email: \(error)")
        }
    }

}
