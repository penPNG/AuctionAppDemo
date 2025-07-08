//
//  HomeViewController.swift
//  AuctionAppDemo
//
//  Created by student on 5/21/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var users: [User] = [User]()
    private var createdUsers: [User] = [User]()
    var connected: Bool = false
    var networkMonitor: NetworkMonitor!
    
    init(nibName nibNameOrNil: String?, nibBundle nibBundleOrNil: Bundle?, networkMonitor: NetworkMonitor) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.networkMonitor = networkMonitor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let homeUsersTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addUserButton: UIBarButtonItem = {
            let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
            return button
        }()

        view.backgroundColor = .systemBackground
        
        // The navigationBar is built into the view !!!!
        navigationItem.title = "Users"
        navigationItem.rightBarButtonItem = addUserButton
        
        view.addSubview(homeUsersTableView)
        
        homeUsersTableView.delegate = self
        homeUsersTableView.dataSource = self
        
        getUserList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeUsersTableView.frame = view.bounds
    }
    
    @objc func addButtonPressed() {
        let viewController = UserCreateViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    private func getUserList() {
        DataPersistenceManager.shared.fetchDownloadedUsers { results in
            switch results {
            case .success(let _users):
                DispatchQueue.main.async { [weak self] in
                    for _user in _users {
                        self?.users.append(DataPersistenceManager.shared.unwrapUser(from: _user))
                    }
                    self?.homeUsersTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        DataPersistenceManager.shared.fetchCreatedUsers { results in
            switch results {
            case .success(let _createdUsers):
                
                DispatchQueue.main.async { [weak self] in
                    for _createdUser in _createdUsers {
                        var createdUser = DataPersistenceManager.shared.unwrapCreatedUser(from: _createdUser)
                        createdUser.id = Int(_createdUser.id)
                        self?.createdUsers.append(createdUser)
                    }
                    self?.homeUsersTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        if self.users.count > 0 { return }
        if networkMonitor.isReachable {
            APICaller.shared.getUsers { results in
                switch results {
                case .success(let _users):
                    DispatchQueue.main.async { [weak self] in
                        self?.users = _users
                        self?.homeUsersTableView.reloadData()
                        DataPersistenceManager.shared.saveDownloadedUsers(_users) { result in
                            switch result {
                            case .success(()): break
                            case .failure(let error):
                                print("Error saving users: \(error)")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if users.count == 0 {
                // This will cause a bug to be fixed!
                tableView.setEmptyView(title: "No Users Found", message: "No Internet Connection")
            } else {
                tableView.restoreView()
            }
            return users.count
        case 1:
            return createdUsers.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if users.count == 0 {
                return nil
            }
            return "Users"
        case 1:
            if createdUsers.count == 0 {
                return nil
            }
            return "Unsynced Users"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else {
            return UITableViewCell()
        }
        var content = cell.defaultContentConfiguration( )
        switch indexPath.section {
        case 0: content.text = self.users[indexPath.row].name
        case 1: content.text = self.createdUsers[indexPath.row].name
        default: content.text = ""
        }
        content.image = UIImage(systemName: "person.circle")
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0: return false
        case 1: return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataPersistenceManager.shared.deleteCreatedUser(at: indexPath.row) { result in
                switch result {
                case .success():
                    self.createdUsers.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedUser: User!
        switch indexPath.section {
        case 0: selectedUser = users[indexPath.row]
        case 1: selectedUser = createdUsers[indexPath.row]
        default: selectedUser = emptyUser()
        }
        
        let viewController = UserDetailViewController()
        viewController.user = selectedUser
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedPath = homeUsersTableView.indexPathForSelectedRow {
            homeUsersTableView.deselectRow(at: selectedPath, animated: true)
        }
        
        DataPersistenceManager.shared.fetchCreatedUsers { results in
            switch results {
            case .success(let _createdUsers):
                
                DispatchQueue.main.async { [weak self] in
                    self?.createdUsers.removeAll()  // The placement of this line caused an infuriating bug, but it's okay now
                    
                    for _createdUser in _createdUsers {
                        print("\(_createdUsers.count) viewWillAppear new users")
                        var createdUser = DataPersistenceManager.shared.unwrapCreatedUser(from: _createdUser)
                        createdUser.id = Int(_createdUser.id)
                        self?.createdUsers.append(createdUser)
                    }
                    self?.homeUsersTableView.reloadData()
                }
            
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
}

extension UITableView {
    // For now, mostly for no internet connection. But reusable!
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let messageLabel: UILabel = {
            let label = UILabel()
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.textAlignment = .center
        self.backgroundView = emptyView
    }
    
    func restoreView() {
        self.backgroundView = nil
    }
}
