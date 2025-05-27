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
        let table = UITableView(frame: .zero, style: .plain)
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
        cell.textLabel?.text = self.users[indexPath.row].name
        cell.imageView?.image = UIImage(systemName: "person.circle")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedUser = users[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "UserDetailViewController") as? UserDetailViewController {
            
            //show(viewController, sender: self)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
