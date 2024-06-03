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
    @IBOutlet weak var bookmarkButton: UIButton!
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
        setupUI()
    }
    func setupUI() {
        configImageButton(Button: trashButton, imageName: "trashIcon", color: .clear)
        configImageButton(Button: bookmarkButton, imageName: "bookmark", color: .clear)
        configImageButton(Button: forwardButton, imageName: "enviarButton", color: .white)
        configImageButton(Button: asnwerButton, imageName: "reply", color: .red)
        asnwerButton.layer.cornerRadius = 20
        forwardButton.layer.cornerRadius = 20
        addTopLine(to: messageView)
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
    
    func addTopLine(to view: UIView) {
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
