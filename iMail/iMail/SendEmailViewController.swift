//
//  SendEmailViewController.swift
//  iMail
//
//  Created by Filipe Simões on 27/05/24.
//

import UIKit
import CoreData

class SendEmailViewController: UIViewController {

    var people: [NSManagedObject] = []
    @IBOutlet weak var destRemView: UIView!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var subjectEmailTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        guard let sender = senderTextField.text, !sender.isEmpty,
                  let message = messageTextField.text, !message.isEmpty,
                  let subject = subjectEmailTextField.text, !subject.isEmpty,
                  let to = toTextField.text, !to.isEmpty else {
                print("há um campo em vazio")
                return
            }

            // Chame a função save para salvar os dados no Core Data
            save(sender: sender, message: message, subject: subject, to: to)
            
            // Apresente um alerta informando que o email foi enviado
            let alertController = UIAlertController(title: "Sucesso", message: "O e-mail foi enviado", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)

//        let alert = UIAlertController(title: "Nome", message: "Insira o nome", preferredStyle: .alert)
//                
//                let saveAction = UIAlertAction(title: "Salvar", style: .default) {
//                    [unowned self] action in
//                    
//                    guard let textField = alert.textFields?.first,
//                          let nameToSave = textField.text else {
//                        return
//                    }
//                    
//                    save(name: nameToSave)
//                }
//                
//                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
//                
//                alert.addTextField()
//                alert.addAction(saveAction)
//                alert.addAction(cancelAction)
//                
//                present(alert, animated: true)

    }
    
    
    func save(sender: String, message: String, subject: String, to: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Emails", in: managedContext)!
        
        let email = NSManagedObject(entity: entity, insertInto: managedContext)
        email.setValue(sender, forKey: "sender")
        email.setValue(message, forKey: "message")
        email.setValue(subject, forKey: "subject")
        email.setValue(to, forKey: "to")
        
        do {
            try managedContext.save()
            people.append(email)
        } catch let error as NSError {
            print("Erro ao salvar o email: \(error)")
        }
    }
    
    func setupUI() {
        navigationController?.isNavigationBarHidden = true
        //bordas UIView
        let path = UIBezierPath(
                   roundedRect: destRemView.bounds,
                   byRoundingCorners: [.bottomLeft, .bottomRight],
                   cornerRadii: CGSize(width: 20, height: 20)
               )
               let mask = CAShapeLayer()
               mask.path = path.cgPath
        destRemView.layer.mask = mask
        
        //botão enviar email
        sendEmailButton.layer.cornerRadius = 20
        sendEmailButton.clipsToBounds = true
        //atualizar dado botao
    }
}
