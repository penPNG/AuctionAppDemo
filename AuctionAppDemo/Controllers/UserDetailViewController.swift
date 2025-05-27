//
//  UserDetailView.swift
//  AuctionAppDemo
//
//  Created by student on 5/27/25.
//

import UIKit

class UserDetailViewController: UIViewController {
    private let userDetailTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                content.text = "ID: "
            case 1:
                content.text = "Name: "
            case 2:
                content.text = "Username: "
            case 3:
                content.text = "Email: "
            case 4:
                content.text = "Phone: "
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0:
                content.text = "Company: "
            case 1:
                content.text = "Catchphrase: "
            case 2:
                content.text = "BS: "
            default: break
            }
        case 2:
            switch indexPath.row {
            case 0:
                content.text = "Street: "
            case 1:
                content.text = "Suite: "
            case 2:
                content.text = "City: "
            case 3:
                content.text = "Zipcode"
            default: break
            }
        default: break
        }
        cell.contentConfiguration = content
        
        return cell
    }
}
