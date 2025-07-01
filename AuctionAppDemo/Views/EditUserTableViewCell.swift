//
//  EditUserTableViewCell.swift
//  AuctionAppDemo
//
//  Created by student on 6/25/25.
//

import UIKit

class EditUserTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var inputSelector: Int = 0

    static let identifier = "EditUserTableViewCell"
    
    class TextField: UITextField {
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
    }
    
    private let nameInput: TextField = {
        let textField = TextField()
        textField.placeholder = "Name"
        return textField
    }()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameInput)
        nameInput.delegate = self
        nameInput.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

}
