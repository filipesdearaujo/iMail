//
//  MainViewController.swift
//  iMail
//
//  Created by Yuri Araujo on 25/05/24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
    }
    
    
    private func setupMenuUI() {
        self.searchView.layer.cornerRadius = 5
        self.searchView.clipsToBounds = true
        
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
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
