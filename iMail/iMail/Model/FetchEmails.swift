import UIKit
import CoreData

class FetchEmails {
    
    // Método para buscar emails com um tópico específico
    func fetch(topic: String, completion: @escaping ([NSManagedObject]) -> Void) {
        // Verificar se o AppDelegate está disponível
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Configurar a request para buscar emails da entidade "Emails" com o tópico especificado
        let emailFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        emailFetchRequest.predicate = NSPredicate(format: "topic == %@", topic)
        
        // Tentar buscar os dados do Core Data
        do {
            let fetchedDados = try managedContext.fetch(emailFetchRequest)
            // Retornar os dados buscados através do completion handler
            completion(fetchedDados)
        } catch let error as NSError {
            // Imprimir erro no console caso ocorra uma falha na busca
            print("Não foi possível retornar os registros. \(error)")
        }
    }
}
