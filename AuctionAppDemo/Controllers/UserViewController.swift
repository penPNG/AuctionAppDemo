//
//  UserViewController.swift
//  AuctionAppDemo
//
//  Created by student on 7/15/25.
//

// This is our universal view controller for viewing user details.
// It will cover editing and viewing, which I could set in settings, but I'll wait for further instruction

import UIKit

class UserViewController: UIViewController {
    private let userTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(EditUserTableViewCell.self, forCellReuseIdentifier: EditUserTableViewCell.identifier)
        return table
    }()
    
    var workingUser = emptyUser()
    var isSyncedUser: Bool = false
    var isEditingUser: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(userTableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUser))
        
        // Move the screen when a keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        userTableView.keyboardDismissMode = .onDrag
        userTableView.delegate = self
        userTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        userTableView.frame = view.bounds
        userTableView.sectionHeaderHeight = 24
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userActivity = notification.userInfo else {return}
        let keyboardFrame:CGRect = (userActivity[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        userTableView.contentInset.bottom = keyboardFrame.height + 20
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        userTableView.contentInset.bottom = 0
    }
    
    // TODO: figure out how alerts work, saving blank data is dangerous
    @objc func saveUser() {
        if !isEditingUser {
            DataPersistenceManager.shared.saveCreatedUser(workingUser) { result in
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
        } else {
            DataPersistenceManager.shared.saveEditedUser(with: workingUser, isSynced: isSyncedUser) { result in
                switch result {
                case .success(()):
                    #if DEBUG
                    print("Saved changes to \(self.workingUser.name ?? "user") successfully")
                    #endif
                case .failure(let error):
                    #if DEBUG
                    print("Failed to save new user: \(error)")
                    #endif
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }

}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
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
                if isEditingUser { textInput.text = "\(self.workingUser.id)" }
            case 1: textInput.placeholder = "Name"
                if isEditingUser { textInput.text = "\(self.workingUser.name ?? "")" }
            case 2: textInput.placeholder = "Username"
                if isEditingUser { textInput.text = "\(self.workingUser.username ?? "")" }
            case 3: textInput.placeholder = "Email"
                if isEditingUser { textInput.text = "\(self.workingUser.email ?? "")" }
            case 4: textInput.placeholder = "Phone"
                if isEditingUser { textInput.text = "\(self.workingUser.phone ?? "")" }
            default: textInput.placeholder = ""
        }
        case 1:
            switch indexPath.row {
            case 0: textInput.placeholder = "Company"
                if isEditingUser { textInput.text = "\(self.workingUser.company?.name ?? "")" }
            case 1: textInput.placeholder = "Catchphrase"
                if isEditingUser { textInput.text = "\(self.workingUser.company?.catchPhrase ?? "")" }
            case 2: textInput.placeholder = "BS"
                if isEditingUser { textInput.text = "\(self.workingUser.company?.bs ?? "")" }
            default: textInput.placeholder = ""
        }
        case 2:
            switch indexPath.row {
            case 0: textInput.placeholder = "Street"
                if isEditingUser { textInput.text = "\(self.workingUser.address?.street ?? "")" }
            case 1: textInput.placeholder = "Suite"
                if isEditingUser { textInput.text = "\(self.workingUser.address?.suite ?? "")" }
            case 2: textInput.placeholder = "City"
                if isEditingUser { textInput.text = "\(self.workingUser.address?.city ?? "")" }
            case 3: textInput.placeholder = "Zipcode"
                if isEditingUser { textInput.text = "\(self.workingUser.address?.zipcode ?? "")" }
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

extension UserViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: TextField) {
        switch (textField.section) {
        case 0: // User Information
            switch (textField.row) {
            case 0: break // this is ID, which we can't write to
            case 1: workingUser.name = textField.text ?? ""
            case 2: workingUser.username = textField.text ?? ""
            case 3: workingUser.email = textField.text ?? ""
            case 4: workingUser.phone = textField.text ?? ""
            default: break
            }
        case 1: // Company Information
            switch (textField.row) {
            case 0: workingUser.company?.name = textField.text ?? ""
            case 1: workingUser.company?.catchPhrase = textField.text ?? ""
            case 2: workingUser.company?.bs = textField.text ?? ""
            default: break
            }
        case 2: // Address Information
            switch (textField.row) {
            case 0: workingUser.address?.street = textField.text ?? ""
            case 1: workingUser.address?.suite = textField.text ?? ""
            case 2: workingUser.address?.city = textField.text ?? ""
            case 3: workingUser.address?.zipcode = textField.text ?? ""
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
