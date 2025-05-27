//
//  SettingsViewController.swift
//  AuctionAppDemo
//
//  Created by student on 5/21/25.
//

import UIKit

class SettingsViewController: UIViewController {

    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(settingsTable)
        
        settingsTable.delegate = self
        settingsTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        settingsTable.frame = view.bounds
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        var content = cell.defaultContentConfiguration()
        content.text = "Show Address"
        cell.contentConfiguration = content
        
        return cell
    }
}
