//
//  MenuViewController.swift
//  iMail
//
//  Created by Yuri Araujo on 25/05/24.
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
        self.profileMenuView.layer.cornerRadius = 20
        self.profileMenuView.clipsToBounds = true
        
        self.profilePictureImage.layer.cornerRadius = 45
        self.profilePictureImage.clipsToBounds = true
    }
    
    
    @IBAction func MenuButtonClicked(_ sender: Any) {
        self.delegate?.hidenMenuVIew()
        //dismiss Menu When clicked on this button
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
