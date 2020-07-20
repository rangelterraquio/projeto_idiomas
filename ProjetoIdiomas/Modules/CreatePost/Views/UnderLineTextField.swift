//
//  CustomTextField.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
class UnderLineTextField:UITextField{

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor

        }
    }
    @IBInspectable var placeHolderText: String = "default place holder" {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])}

        }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width/2, width: frame.size.width, height: frame.size.height)

        textColor = UIColor.lightGray
        backgroundColor = UIColor.clear

        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true

        attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])}
}
