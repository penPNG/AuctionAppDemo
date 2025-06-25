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
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "showAddress") != nil {
            if userDefaults.bool(forKey: "showAddress") {
                swatch.isOn = true
            } else {
                swatch.isOn = false
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
