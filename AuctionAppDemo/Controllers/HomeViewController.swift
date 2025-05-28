//
//  HomeViewController.swift
//  AuctionAppDemo
//
//  Created by student on 5/21/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var users: [User] = [User]()
    
    private let homeUsersTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeUsersTable)
        
        homeUsersTable.delegate = self
        homeUsersTable.dataSource = self
        
        getUserList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeUsersTable.frame = view.bounds
    }
    
    private func getUserList() {
        APICaller.shared.getUsers { results in
            switch results {
            case .success(let _users):
                DispatchQueue.main.async { [weak self] in
                    self?.users = _users
                    self?.homeUsersTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if let selectedPath = homeUsersTable.indexPathForSelectedRow {
            homeUsersTable.deselectRow(at: selectedPath, animated: true)
        }
    }
}
