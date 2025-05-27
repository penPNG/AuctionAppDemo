//
//  UserDetailTableViewCell.swift
//  AuctionAppDemo
//
//  Created by student on 5/27/25.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {
    
    static let identifier = "UserDetailTableViewCell"
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
