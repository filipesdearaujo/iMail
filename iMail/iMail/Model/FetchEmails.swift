import UIKit
import CoreData

class FetchEmails {

    func fetch(topic: String, completion: @escaping ([NSManagedObject]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Fetch emails from "Emails" entity with the specified topic
        let emailFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emails")
        emailFetchRequest.predicate = NSPredicate(format: "topic == %@", topic)
        
        do {
            let fetchedDados = try managedContext.fetch(emailFetchRequest)
            completion(fetchedDados)
        } catch let error as NSError {
            print("Não foi possível retornar os registros. \(error)")
        }
    }
}
