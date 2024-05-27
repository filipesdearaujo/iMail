//
//  SendEmailViewController.swift
//  iMail
//
//  Created by Yuri Araujo on 27/05/24.
//

import UIKit
import CoreData

class SendEmailViewController: UIViewController {

    var people: [NSManagedObject] = []
    @IBOutlet weak var destRemView: UIView!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var destinatarioLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Nome", message: "Insira o nome", preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: "Salvar", style: .default) {
                    [unowned self] action in
                    
                    guard let textField = alert.textFields?.first,
                          let nameToSave = textField.text else {
                        return
                    }
                    
                    save(name: nameToSave)
                }
                
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
                
                alert.addTextField()
                alert.addAction(saveAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true)

    }
    
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Emails", in: managedContext)!
                
                let person = NSManagedObject(entity: entity, insertInto: managedContext)
                person.setValue(name, forKey: "sender")
                
                do {
                    try managedContext.save()
                    people.append(person)
                    updateLabel()
                } catch let error as NSError {
                    print("Erro ao salvar o remetente \(error)")
                }
    }
    
    func updateLabel() {
            if let lastPerson = people.last, let name = lastPerson.value(forKey: "sender") as? String {
                destinatarioLabel.text = name
            }
        }
    
    func setupUI() {
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
