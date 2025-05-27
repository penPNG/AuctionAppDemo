//
//  UsersTableViewCell.swift
//  AuctionAppDemo
//
//  Created by student on 5/25/25.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    private var user: User?

    static let identifier = "UsersTableViewCell"
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        self.user = user
    }

}
