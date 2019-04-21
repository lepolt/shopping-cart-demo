//
//  UIButtonExtensions.swift
//  shopping cart
//
//  Created by Jonathan Lepolt on 4/19/19.
//

import Foundation
import UIKit

extension UIButton {

    /**
     Adds a shadow to a UIButton. Code inspired from:
        https://stackoverflow.com/a/16159777/589019
     */
    func addShadow() {
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.2
    }

    open override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
