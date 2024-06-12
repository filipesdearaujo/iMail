import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Core Data stack
    
    // Container persistente para gerenciar o armazenamento de dados do Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iMail") // Substitua "iMail" pelo nome do seu modelo Core Data
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Erro não resolvido \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // Método para salvar o contexto do Core Data
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Erro não resolvido \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Application Lifecycle
    
    // Personaliza a aparência global da aplicação após o lançamento
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        return true
    }
    
    // MARK: - Customization Methods
    
    // Personaliza a aparência da barra de navegação e do botão "Voltar"
    private func customizeAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = .white // Cor do botão "Voltar"
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Cor do texto do título
        appearance.barTintColor = .black // Cor de fundo da barra de navegação
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Chamado quando uma nova sessão de cena está sendo criada.
        // Use este método para selecionar uma configuração para criar a nova cena.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Chamado quando o usuário descarta uma sessão de cena.
        // Libere recursos específicos das cenas descartadas, pois elas não retornarão.
    }
}
