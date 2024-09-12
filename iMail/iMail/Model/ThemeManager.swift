import UIKit
import CoreData

struct ThemeColors {
    let backgroundColor: UIColor
    let secondColor: UIColor
    let thirdColor: UIColor
    let labelColor: UIColor
    let buttonImageName: String
}

class ThemeManager {

    // MARK: - Singleton
    static let shared = ThemeManager()
    
    // MARK: - Private Properties
    private let managedContext: NSManagedObjectContext
    
    // MARK: - Initializer
    private init() {
        // Obtém o contexto do Core Data do AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Não foi possível obter o AppDelegate.")
        }
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    func fetchThemeColors() -> ThemeColors? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            if let result = try managedContext.fetch(fetchRequest).first as? NSManagedObject,
               let theme = result.value(forKey: "theme") as? String {
                return getThemeColors(for: theme)
            }
        } catch let error as NSError {
            print("Erro ao buscar a configuração do tema: \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func fetchButtonImageName() -> String {
        guard let themeColors = fetchThemeColors() else {
            return "ImageWriteButton" // Nome da imagem padrão
        }
        return themeColors.buttonImageName
    }
    
    // MARK: - Private Methods
    private func getThemeColors(for theme: String) -> ThemeColors {
        switch theme {
        case "darkMode":
            return ThemeColors(
                backgroundColor: .black,
                secondColor: .darkGray,
                thirdColor: .red,
                labelColor: .white,
                buttonImageName: "menuButtonImage"
            )
            
        case "highcontrastMode":
            return ThemeColors(
                backgroundColor: .white,
                secondColor: .lightGray,
                thirdColor: .red,
                labelColor: .black,
                buttonImageName: "BlackMenuButtonImage"
            )
            
        default:
            // Para o tema padrão, cor de fundo com hex: #263746
            return ThemeColors(
                backgroundColor: UIColor(hex: "#263746"),
                secondColor: UIColor(hex: "#192B3B"),
                thirdColor: .red,
                labelColor: .white,
                buttonImageName: "menuButtonImage"
            )
        }
    }
}

// MARK: - UIColor Extension for Hex
extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

