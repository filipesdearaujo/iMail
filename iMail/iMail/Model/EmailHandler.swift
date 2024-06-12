import UIKit
import CoreData

class EmailHandler {
    
    // Propriedades para armazenar os detalhes do email
    var emailMessage: String?
    var emailTitle: String?
    var emailSender: String?
    
    // Enum para definir as ações possíveis de email
    enum EmailAction {
        case answer
        case forward
    }
    
    // Método para lidar com as ações de email (responder ou encaminhar)
    func handleEmailAction(index: Int, action: EmailAction, viewController: UIViewController) {
        // Verificar se o AppDelegate está disponível
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        // Tentar buscar os dados do Core Data
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let email = result.first {
                // Extrair os detalhes do email
                emailMessage = email.value(forKey: "message") as? String
                emailTitle = email.value(forKey: "subject") as? String
                emailSender = email.value(forKey: "sender") as? String
                
                // Executar a ação correspondente
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
