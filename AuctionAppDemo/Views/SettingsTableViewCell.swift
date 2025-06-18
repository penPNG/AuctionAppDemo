//
//  SettingsTableViewCell.swift
//  AuctionAppDemo
//
//  Created by student on 5/27/25.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let identifier = "SettingsTableViewCell"
    
    private let addressSwitch: UISwitch = {
        let swatch = UISwitch()
        DataPersistenceManager.shared.fetchSettings() { result in
            switch result {
            case .success(let settingsData):
                if settingsData.showAddress {
                    swatch.isOn = true
                } else {
                    swatch.isOn = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return swatch
    }()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addressSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        accessoryView = addressSwitch
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: "showAddress")
    }

}
