//
//  ViewController.swift
//  iMail
//
//  Created by Yuri Araujo on 25/05/24.
//

import UIKit

class ViewController: UIViewController, MenuViewControllerDelegate {
    
    var names: [String] = []
    
    
    @IBOutlet weak var tableViewCxEntrada: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backViewForMenu: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstForMenuView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backViewForMenu.isHidden = true
        setupMenuUI()
        
        //table view
        tableViewCxEntrada.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

    
    @IBAction func addNamePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Nome", message: "Insira o nome", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else {
                return
            }
            
            self.names.append(nameToSave)
            self.tableViewCxEntrada.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}
