//
//  ViewController.swift
//  iMail
//
//  Created by Yuri Araujo on 25/05/24.
//

import UIKit

class ViewController: UIViewController, MenuViewControllerDelegate {
    

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backViewForMenu: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstForMenuView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backViewForMenu.isHidden = true
        setupMenuUI()
        
        // Do any additional setup after loading the view.
    }
    
    var menuViewController:MenuViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "menuSegue") {
            if let controller = segue.destination as? MenuViewController {
                self.menuViewController = controller
                self.menuViewController?.delegate = self
            }
        }
    }

    @IBAction func tappedOnMenuBackView(_ sender: Any) {
        self.hidenMenuVIew()
        
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.leadingConstForMenuView.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.1, animations: {
                self.leadingConstForMenuView.constant = 0
                self.view.layoutIfNeeded()
            }) { (status) in
                self.backViewForMenu.isHidden = false
            }
            self.backViewForMenu.isHidden = false
        }
    }
    
    
    
    
    func hidenMenuVIew() {
        self.hideMenuView()
    }
    
    private func hideMenuView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.leadingConstForMenuView.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.1, animations: {
                self.leadingConstForMenuView.constant = -280
                self.view.layoutIfNeeded()
            }) { (status) in
                self.backViewForMenu.isHidden = true
            }
            self.backViewForMenu.isHidden = true
        }

    }
    
    
    private func setupMenuUI() {
        self.searchView.layer.cornerRadius = 5
        self.searchView.clipsToBounds = true
    }

}

