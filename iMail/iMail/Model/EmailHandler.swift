import UIKit
import CoreData

class EmailHandler {
    var emailMessage: String?
    var emailTitle: String?
    var emailSender: String?
    
    enum EmailAction {
        case answer
        case forward
    }
    
    func handleEmailAction(index: Int, action: EmailAction, viewController: UIViewController) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let email = result.first {
                emailMessage = email.value(forKey: "message") as? String
                emailTitle = email.value(forKey: "subject") as? String
                emailSender = email.value(forKey: "sender") as? String
                switch action {
                case .answer:
                    viewController.performSegue(withIdentifier: "answerForwardEmailSegue", sender: (self, action))
                case .forward:
                    viewController.performSegue(withIdentifier: "answerForwardEmailSegue", sender: (self, action))
                }
            } else {
                print("Erro: Não foi possível encontrar o email com o índice especificado.")
            }
        } catch let error as NSError {
            print("Erro ao carregar os detalhes do email: \(error)")
        }
    }
}
