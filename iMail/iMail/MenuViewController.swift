//
//  MenuViewController.swift
//  iMail
//
//  Created by Filipe Simões on 25/05/24.
//

import UIKit

protocol MenuViewControllerDelegate{
    func hidenMenuVIew()
}

class MenuViewController: UIViewController {

    var delegate: MenuViewControllerDelegate?
    @IBOutlet weak var profileMenuView: UIView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var profileLabelUser: UILabel!
    


override func viewDidLoad() {
        super.viewDidLoad()

    setupMenuUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupMenuUI() {
        let path = UIBezierPath(
                    roundedRect: profileMenuView.bounds,
                    byRoundingCorners: [.bottomRight],
                    cornerRadii: CGSize(width: 20, height: 20)
                )
                let mask = CAShapeLayer()
                mask.path = path.cgPath
        profileMenuView.layer.mask = mask
        
        self.profilePictureImage.layer.cornerRadius = 45
        self.profilePictureImage.clipsToBounds = true
    }
    
    
    @IBAction func MenuButtonClicked(_ sender: UIButton) {
        self.delegate?.hidenMenuVIew()
        //dismiss Menu When clicked on this button
        
        if sender.tag == 5 {
                if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DeliveredViewController") as? DeliveredViewController {
                    navigationController?.pushViewController(nextVC, animated: true)
                }
            }

        
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
