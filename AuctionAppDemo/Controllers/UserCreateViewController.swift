//
//  UserCreateViewController.swift
//  AuctionAppDemo
//
//  Created by student on 6/25/25.
//

import UIKit

class UserCreateViewController: UIViewController {
    
    private let editUserTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(EditUserTableViewCell.self, forCellReuseIdentifier: EditUserTableViewCell.identifier)
        return table
    }()
    
    private var newUser: User = emptyUser()
    private var editingUser: Bool = false
    var userToEdit: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userToEdit != nil {
            navigationItem.title = "Edit User"
            newUser = userToEdit!   // I really don't want to rewrite some of the code below
            editingUser = true
        } else {
            navigationItem.title = "Add User"
        }
        
        view.backgroundColor = .systemBackground
        view.addSubview(editUserTableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUser))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        editUserTableView.keyboardDismissMode = .onDrag
        editUserTableView.delegate = self
        editUserTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        editUserTableView.frame = view.bounds
        editUserTableView.sectionHeaderHeight = 24
    }
    
    // TODO figure out how alerts work, saving blank data is dangerous
    @objc func saveUser() {
        DataPersistenceManager.shared.saveCreatedUser(newUser) { result in
            switch result {
            case .success(()):
                #if DEBUG
                print("New user saved successfully")
                #endif
            case .failure(let error):
                #if DEBUG
                print("Failed to save new user: \(error)")
                #endif
            }
        }
        print(newUser)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userActivity = notification.userInfo else {return}
        let keyboardFrame:CGRect = (userActivity[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        editUserTableView.contentInset.bottom = keyboardFrame.height + 20
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        editUserTableView.contentInset.bottom = 0
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

extension UserCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .secondaryLabel
        
        switch section {
        case 0:
            label.text = "Details"
        case 1:
            label.text = "Company Information"
        case 2:
            label.text = "Address"
        default:
            label.text = ""
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 5
        case 1: return 3
        case 2: return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditUserTableViewCell.identifier, for: indexPath) as? EditUserTableViewCell else {
            return UITableViewCell()
        }
        let textInput: TextField = TextField()
        textInput.delegate = self
        textInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        cell.contentView.isUserInteractionEnabled = false
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: textInput.placeholder = "ID"; textInput.isEnabled = false
                if editingUser { textInput.text = "\(self.userToEdit?.id ?? 0)" }
            case 1: textInput.placeholder = "Name"
                if editingUser { textInput.text = "\(self.userToEdit?.name ?? "")" }
            case 2: textInput.placeholder = "Username"
                if editingUser { textInput.text = "\(self.userToEdit?.username ?? "")" }
            case 3: textInput.placeholder = "Email"
                if editingUser { textInput.text = "\(self.userToEdit?.email ?? "")" }
            case 4: textInput.placeholder = "Phone"
                if editingUser { textInput.text = "\(self.userToEdit?.phone ?? "")" }
            default: textInput.placeholder = ""
        }
        case 1:
            switch indexPath.row {
            case 0: textInput.placeholder = "Company"
                if editingUser { textInput.text = "\(self.userToEdit?.company?.name ?? "")" }
            case 1: textInput.placeholder = "Catchphrase"
                if editingUser { textInput.text = "\(self.userToEdit?.company?.catchPhrase ?? "")" }
            case 2: textInput.placeholder = "BS"
                if editingUser { textInput.text = "\(self.userToEdit?.company?.bs ?? "")" }
            default: textInput.placeholder = ""
        }
        case 2:
            switch indexPath.row {
            case 0: textInput.placeholder = "Street"
                if editingUser { textInput.text = "\(self.userToEdit?.address?.street ?? "")" }
            case 1: textInput.placeholder = "Suite"
                if editingUser { textInput.text = "\(self.userToEdit?.address?.suite ?? "")" }
            case 2: textInput.placeholder = "City"
                if editingUser { textInput.text = "\(self.userToEdit?.address?.city ?? "")" }
            case 3: textInput.placeholder = "Zipcode"
                if editingUser { textInput.text = "\(self.userToEdit?.address?.zipcode ?? "")" }
            default: textInput.placeholder = ""
            }
        default: textInput.placeholder = ""
        }
        
        textInput.section = indexPath.section
        textInput.row = indexPath.row
        
        cell.addSubview(textInput)
        textInput.frame = cell.bounds
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserCreateViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: TextField) {
        switch (textField.section) {
        case 0: // User Information
            switch (textField.row) {
            case 0: break // this is ID, which we can't write to
            case 1: newUser.name = textField.text ?? ""
            case 2: newUser.username = textField.text ?? ""
            case 3: newUser.email = textField.text ?? ""
            case 4: newUser.phone = textField.text ?? ""
            default: break
            }
        case 1: // Company Information
            switch (textField.row) {
            case 0: newUser.company?.name = textField.text ?? ""
            case 1: newUser.company?.catchPhrase = textField.text ?? ""
            case 2: newUser.company?.bs = textField.text ?? ""
            default: break
            }
        case 2: // Address Information
            switch (textField.row) {
            case 0: newUser.address?.street = textField.text ?? ""
            case 1: newUser.address?.suite = textField.text ?? ""
            case 2: newUser.address?.city = textField.text ?? ""
            case 3: newUser.address?.zipcode = textField.text ?? ""
            default: break
            }
        default: break
        }
    }
    
    class TextField: UITextField {
        var section: Int?
        var row: Int?
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
    }
}
