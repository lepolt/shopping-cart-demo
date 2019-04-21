//
//  UIColorExtensions.swift
//  shopping cart
//
//  Created by Jonathan Lepolt on 4/19/19.
//

import Foundation
import UIKit

extension UIColor {
    /**
     Translates a hex color string into a UIColor. Code inspired from:
        https://stackoverflow.com/a/27203691/589019

     - Parameter hex: The hex string with or without a #

     - Returns: UIColor
     */
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
