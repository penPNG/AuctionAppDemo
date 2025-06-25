//
//  HomeViewController.swift
//  AuctionAppDemo
//
//  Created by student on 5/21/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var users: [User] = [User]()
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
        print("button pressed")
        let viewController = UserDetailViewController()
        viewController.user = users[0]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    private func getUserList() {
        DataPersistenceManager.shared.fetchUsers { results in
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
        if self.users.count > 0 { return }
        if networkMonitor.isReachable {
            APICaller.shared.getUsers { results in
                switch results {
                case .success(let _users):
                    DispatchQueue.main.async { [weak self] in
                        self?.users = _users
                        self?.homeUsersTableView.reloadData()
                        DataPersistenceManager.shared.saveUsers(_users) { result in
                            switch result {
                            case .success(()):
                                print("Users saved successfully")
                            case .failure(let error):
                                print("Error saving settings: \(error)")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count == 0 {
            tableView.setEmptyView(title: "No Users Found", message: "No Internet Connection")
        } else {
            tableView.restoreView()
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else {
            return UITableViewCell()
        }
        var content = cell.defaultContentConfiguration( )
        content.text = self.users[indexPath.row].name
        content.image = UIImage(systemName: "person.circle")
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        
        let viewController = UserDetailViewController()
        viewController.user = selectedUser
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedPath = homeUsersTableView.indexPathForSelectedRow {
            homeUsersTableView.deselectRow(at: selectedPath, animated: true)
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
