import UIKit
import CoreData
import EventKit

class ViewController: UIViewController, UITableViewDelegate, MenuViewControllerDelegate, EmailUpdateDelegate, UITextFieldDelegate {
    
    func hidenMenuVIew() {
        self.hideMenuView()
    }
    

    // MARK: - Properties
    
    var dados: [NSManagedObject] = []
    var menuViewController: MenuViewController?
    var originalCxEntradaConstraint: NSLayoutConstraint?
    
    let eventStore = EKEventStore()
    var nextEvent: EKEvent?

    // MARK: - IBOutlets

    @IBOutlet weak var tableViewCxEntrada: UITableView!
    @IBOutlet weak var backViewForMenu: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstForMenuView: NSLayoutConstraint!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var menubutton: UIButton!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var cxEntradaView: UIView!
    @IBOutlet weak var cxEntradaConstrain: NSLayoutConstraint!
    @IBOutlet weak var midView: UIView!
    
    @IBOutlet weak var subjectEventLabel: UILabel!
    @IBOutlet weak var hourEventLabel: UILabel!
    @IBOutlet weak var dateEventLabel: UILabel!

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        requestAccessToCalendar()
        configureTapGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        loadEmails()
        fetchNextEvent()
    }

    // MARK: - Setup Methods

    private func initialSetup() {
        backViewForMenu.isHidden = true
        tableViewCxEntrada.register(CxEntradaTableViewCell.nib, forCellReuseIdentifier: CxEntradaTableViewCell.cell)
        tableViewCxEntrada.dataSource = self
        tableViewCxEntrada.delegate = self
        searchTextField.delegate = self
        setupMenuUI()
        originalCxEntradaConstraint = cxEntradaConstrain
    }

    private func setupMenuUI() {
        configureButton(sendEmailButton, imageName: "ImageWriteButton", color: .white)
        configureCalendarView(calendarView)
        configureSearchTextField()
        
        tableViewCxEntrada.separatorColor = .clear
        backViewForMenu.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    }

    private func configureTapGestures() {
        let calendarTapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarViewTapped))
        calendarView.addGestureRecognizer(calendarTapGesture)
        calendarView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        backViewForMenu.addGestureRecognizer(tapGesture)
    }

    // MARK: - Core Data Methods

    func loadEmails(filter: String? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emails")

        if let filter = filter, !filter.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "topic == %@ AND (sender CONTAINS[cd] %@ OR message CONTAINS[cd] %@ OR subject CONTAINS[cd] %@)", "usuarioRecebeu", filter, filter, filter)
        } else {
            fetchRequest.predicate = NSPredicate(format: "topic == %@", "usuarioRecebeu")
        }

        do {
            dados = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            tableViewCxEntrada.reloadData()
        } catch let error as NSError {
            print("Não foi possível retornar os registros. \(error)")
        }
    }

    func didUpdateEmails() {
        loadEmails()
    }

    // MARK: - Event Handling Methods

    func requestAccessToCalendar() {
        eventStore.requestFullAccessToEvents { granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.fetchNextEvent()
                }
            } else {
                if let error = error {
                    print("Erro ao solicitar permissão: \(error)")
                } else {
                    print("Permissão negada para acessar o calendário")
                }
            }
        }
    }

    func fetchNextEvent() {
        let calendars = eventStore.calendars(for: .event)
        let now = Date()
        let oneYearFromNow = Date(timeIntervalSinceNow: 365*24*3600)
        let predicate = eventStore.predicateForEvents(withStart: now, end: oneYearFromNow, calendars: calendars)
        let events = eventStore.events(matching: predicate).sorted(by: { $0.startDate < $1.startDate })

        if let nextEvent = events.first {
            updateEventLabels(with: nextEvent)
        } else {
            clearEventLabels()
        }
    }

    private func updateEventLabels(with event: EKEvent) {
        nextEvent = event
        subjectEventLabel.text = event.title

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        hourEventLabel.text = event.isAllDay ? "" : dateFormatter.string(from: event.startDate)

        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.dateFormat = "dd/MM/yyyy"
        dateEventLabel.text = Calendar.current.isDateInToday(event.startDate) ? "Hoje" : dateOnlyFormatter.string(from: event.startDate)
    }

    private func clearEventLabels() {
        subjectEventLabel.text = "Nenhum evento"
        hourEventLabel.text = ""
        dateEventLabel.text = ""
    }

    @objc private func calendarViewTapped() {
        guard let nextEvent = nextEvent else { return }

        if let eventURL = URL(string: "calshow://")?.appendingPathComponent(nextEvent.eventIdentifier) {
            if UIApplication.shared.canOpenURL(eventURL) {
                UIApplication.shared.open(eventURL)
            } else {
                print("Não foi possível abrir o aplicativo Calendário.")
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuSegue", let controller = segue.destination as? MenuViewController {
            menuViewController = controller
            menuViewController?.delegate = self
            menuViewController?.emailUpdateDelegate = self
        }
    }

    // MARK: - IBActions

    @IBAction func addNamePressed(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SendEmailViewController") as? SendEmailViewController {
            present(nextVC, animated: true)
        }
    }

    @IBAction func tappedOnMenuBackView(_ sender: Any) {
        hideMenuView()
    }

    @IBAction func menuButtonClicked(_ sender: Any) {
        toggleMenuView(show: true)
    }

    func hideMenuView() {
        toggleMenuView(show: false)
    }

    private func toggleMenuView(show: Bool) {
        let finalConstant: CGFloat = show ? 0 : -280
        UIView.animate(withDuration: 0.2, animations: {
            self.leadingConstForMenuView.constant = 10
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.leadingConstForMenuView.constant = finalConstant
                self.view.layoutIfNeeded()
            }) { _ in
                self.backViewForMenu.isHidden = !show
            }
        }
    }

    // MARK: - Helper Methods

    private func configureButton(_ button: UIButton, imageName: String, color: UIColor) {
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(.white, for: .normal)
        let contentImage = UIImage(named: imageName)
        button.setImage(contentImage, for: .normal)
        button.backgroundColor = color
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }

    private func configureCalendarView(_ view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.masksToBounds = true
    }

    private func configureSearchTextField() {
        searchTextField.placeholder = "Buscar"
        searchTextField.textColor = .white
        searchTextField.backgroundColor = .clear
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Buscar",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        searchTextField.borderStyle = .none

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: searchTextField.frame.size.height - 1, width: searchTextField.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.red.cgColor
        searchTextField.layer.addSublayer(bottomBorder)

        searchTextField.layoutIfNeeded()
        bottomBorder.frame = CGRect(x: 0, y: searchTextField.frame.size.height - 1, width: searchTextField.frame.size.width, height: 1)
    }

    @objc private func handleBackgroundTap() {
        hideMenuView()
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        updateCxEntradaConstraint(topAnchor: view.safeAreaLayoutGuide.topAnchor)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && scrollView.isDragging {
            updateCxEntradaConstraint(topAnchor: midView.topAnchor, constant: -30)
        }
    }

    private func updateCxEntradaConstraint(topAnchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        cxEntradaConstrain.isActive = false
        cxEntradaConstrain = cxEntradaView.topAnchor.constraint(equalTo: topAnchor, constant: constant)
        cxEntradaConstrain.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let filterText = textField.text {
            loadEmails(filter: filterText)
        }
        return true
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dados.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CxEntradaTableViewCell.cell, for: indexPath) as? CxEntradaTableViewCell else {
            fatalError("The dequeued cell is not an instance of CxEntradaTableViewCell.")
        }

        let email = dados[indexPath.row]

        if let sender = email.value(forKey: "sender") as? String,
           let message = email.value(forKey: "message") as? String,
           let subject = email.value(forKey: "subject") as? String,
           let date = email.value(forKey: "date") as? Date {
            cell.remetenteLabel.text = sender
            cell.subjectLabel.text = subject
            cell.messageLabel.text = message
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmail = dados[indexPath.row]

        guard let index = selectedEmail.value(forKey: "index") as? Int else {
            print("Erro: Não foi possível obter o índice do objeto NSManagedObject.")
            return
        }

        if let recievedemailDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecievedEmailDetailsViewController") as? RecievedEmailDetailsViewController {
            recievedemailDetailsVC.index = index
            recievedemailDetailsVC.delegate = self
            present(recievedemailDetailsVC, animated: true)
        }
    }
}
