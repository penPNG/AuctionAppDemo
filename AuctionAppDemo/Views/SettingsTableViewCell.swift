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
        swatch.isOn = true
        return swatch
    }()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = addressSwitch
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
