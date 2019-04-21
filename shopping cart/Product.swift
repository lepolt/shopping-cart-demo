//
//  Product.swift
//  shopping cart
//
//  Created by Jonathan Lepolt on 4/18/19.
//

import Foundation

// The initial "response" object when loading data
struct ProductResponse: Codable {
    let products: [Product]
}

// Describes a product
struct Product: Codable {
    let id: Int
    let name: String
    let image: String
    let style: String
    let unitprice: Int
    let qty: Int
    let color: ProductColor
}

// Describes a product color
struct ProductColor: Codable {
    let name: String
    let swatch: String
}
