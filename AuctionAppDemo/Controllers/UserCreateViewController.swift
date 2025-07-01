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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(editUserTableView)
        navigationItem.title = "Add User"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUser))
        
        editUserTableView.delegate = self
        editUserTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        editUserTableView.frame = view.bounds
        editUserTableView.sectionHeaderHeight = 24
    }
    
    @objc func saveUser() {
        
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

extension UserCreateViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
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
        cell.contentView.isUserInteractionEnabled = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
