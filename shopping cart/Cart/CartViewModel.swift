//
//  CartViewModel.swift
//  shopping cart
//
//  Created by Jonathan Lepolt on 4/18/19.
//

import Foundation

protocol CartViewDelegate {
    func didUpdatePrices(subtotal: Int, shipping: Int, total: Int)
    func didUpdateCart()
    func loadDataError(error: String)
}

class CartViewModel {
    let delegate: CartViewDelegate
    var products: [Product]     // Stores all items from the JSON in case we choose to reload.
    var cartItems: [Product]    // Used to manage the contents of our cart
    var subtotal: Int = 0
    var shipping: Int = 0
    var total: Int = 0

    var cartItemsCount: Int {
        get {
            return cartItems.count
        }
    }

    init(delegate: CartViewDelegate) {
        self.delegate = delegate
        self.products = [Product]()
        self.cartItems = [Product]()
    }

    // Do initial setup for this view model
    func setup() {
        if let cartItems = loadData(filename: "cart") {
            self.products = cartItems
            self.cartItems = cartItems
        }

        updatePrices()
    }

    // Reset our data so we can start the demo over
    func reset() {
        cartItems = products
        updatePrices()
        delegate.didUpdateCart()
    }

    /**
     Loads data from a specified JSON file. Code inspired from:
        https://stackoverflow.com/a/36827996/589019

     - Returns: Array of Product objects
     */
    func loadData(filename fileName: String) -> [Product]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ProductResponse.self, from: data)
                return jsonData.products
            } catch {
                delegate.loadDataError(error: error.localizedDescription)
            }
        }
        return nil
    }

    /**
     Initializes the price details for items in our cart. Thought about updating prices in "realtime" when things are
     added/removed, but decided this was fine.
    */
    fileprivate func updatePrices() {
        shipping = 0
        total = 0

        subtotal = cartItems.reduce(0) { (result: Int, product: Product) -> Int in
            return result + product.unitprice
        }

        total = subtotal + shipping

        delegate.didUpdatePrices(subtotal: subtotal, shipping: shipping, total: total)
    }

    /**
     Removes an item in our cart at a specified index

     - Parameter index: The index of the item we want to remove
     */
    func removeCartItem(at index: Int) {
        _ = cartItems.remove(at: index) // Not currently using return value

        updatePrices()

        delegate.didUpdateCart()
    }

}

