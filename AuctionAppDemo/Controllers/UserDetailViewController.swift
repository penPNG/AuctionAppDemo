//
//  UserDetailView.swift
//  AuctionAppDemo
//
//  Created by student on 5/27/25.
//

import UIKit

class UserDetailViewController: UIViewController {
    var user: User?
    private let userDetailTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UserDetailTableViewCell.self, forCellReuseIdentifier: "UserDetailTableViewCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(userDetailTable)
        
        userDetailTable.delegate = self
        userDetailTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        userDetailTable.frame = view.bounds
        userDetailTable.sectionHeaderHeight = 24
    }
}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
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
            let userDefaults = UserDefaults.standard
            if userDefaults.bool(forKey: "showAddress") {
                label.text = "Address"
            }
//            DataPersistenceManager.shared.fetchSettings { result in
//                switch result {
//                case .success(let settings):
//                    if settings.showAddress {
//                        label.text = "Address"
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
        default:
            label.text = ""
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 5
        case 1: return 3
        case 2:
            let userDefaults = UserDefaults.standard
            if userDefaults.bool(forKey: "showAddress") {
                return 4
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailTableViewCell.identifier, for: indexPath) as? UserDetailTableViewCell else {
            return UITableViewCell()
        }
        var content = cell.defaultContentConfiguration()
        content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        content.textToSecondaryTextVerticalPadding = 8
        content.secondaryTextProperties.color = .secondaryLabel
        content.prefersSideBySideTextAndSecondaryText = true
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                content.text = "ID"
                content.secondaryText = "\(user?.id ?? 0)"
            case 1:
                content.text = "Name"
                content.secondaryText = "\(user?.name ?? "")"
            case 2:
                content.text = "Username"
                content.secondaryText = "\(user?.username ?? "")"
            case 3:
                content.text = "Email"
                content.secondaryText = "\(user?.email ?? "")"
            case 4:
                content.text = "Phone"
                content.secondaryText = "\(user?.phone ?? "")"
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0:
                content.text = "Company"
                content.secondaryText = "\(user?.company?.name ?? "")"
            case 1:
                content.text = "Catchphrase"
                content.secondaryText = "\(user?.company?.catchPhrase ?? "")"
            case 2:
                content.text = "BS"
                content.secondaryText = "\(user?.company?.bs ?? "")"
            default: break
            }
        case 2:
            switch indexPath.row {
            case 0:
                content.text = "Street"
                content.secondaryText = "\(user?.address?.street ?? "")"
            case 1:
                content.text = "Suite"
                content.secondaryText = "\(user?.address?.suite ?? "")"
            case 2:
                content.text = "City"
                content.secondaryText = "\(user?.address?.city ?? "")"
            case 3:
                content.text = "Zipcode"
                content.secondaryText = "\(user?.address?.zipcode ?? "")"
            default: break
            }
        default: break
        }
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userDetailTable.reloadData()
    }
}
