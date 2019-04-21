//
//  CartItemTableCell.swift
//  shopping cart
//
//  Created by Jonathan Lepolt on 4/18/19.
//

import Foundation
import UIKit

class CartItemTableCell: UITableViewCell {
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductStyle: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    func update(_ product: Product) {
        lblProductName.text = product.name.uppercased()
        lblProductStyle.text = product.style.lowercased()
        lblCost.text = "$\(product.unitprice)"
        colorView.backgroundColor = UIColor.blue
        lblQuantity.text = String(product.qty)

        thumbnail.image = UIImage(named: product.image)

        // Color swatch
        colorView.backgroundColor = UIColor().hexStringToUIColor(hex: product.color.swatch)
    }
}
