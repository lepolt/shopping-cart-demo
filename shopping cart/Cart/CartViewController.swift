//
//  CartViewController.swift
//  shopping cart
//
//  Created by Jonathan Lepolt on 4/18/19.
//

import Foundation
import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet var emptyStateView: UIView!

    var viewModel: CartViewModel? = nil

    override func viewDidLoad() {
        // Setup our view model
        viewModel = CartViewModel(delegate: self)
        viewModel?.setup()

        // Some table delegates
        tableView.delegate = self
        tableView.dataSource = self

        // Add a shadow to the button.
        btnCheckout.addShadow()
    }

    @IBAction func didTapCheckout(_ sender: Any) {
        guard let viewModel = viewModel else {
            return
        }

        // Sanity check
        if viewModel.cartItemsCount > 0 {
            let alert = UIAlertController(title: "Go To Checkout", message: "Are you ready to check out? Your total is $\(viewModel.total)", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let confirmAction = UIAlertAction(title: "Check out", style: .default) { (UIAlertAction) in
                self.showDoneAlert()
            }

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)

            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func didTapReset(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Cart", message: "Do you want to reset the contents of your cart?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let resetAction = UIAlertAction(title: "Reset cart", style: .destructive) { (UIAlertAction) in
            self.viewModel?.reset()
            self.tableView.reloadData()
        }

        alert.addAction(cancelAction)
        alert.addAction(resetAction)

        present(alert, animated: true, completion: nil)

    }

    fileprivate func showDoneAlert() {
        let alert = UIAlertController(title: "Not Implemented", message: "You have reached the end of this demo app.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let resetAction = UIAlertAction(title: "Reset cart", style: .destructive) { (UIAlertAction) in
            self.viewModel?.reset()
            self.tableView.reloadData()
        }

        alert.addAction(okayAction)
        alert.addAction(resetAction)

        present(alert, animated: true, completion: nil)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numSections = viewModel?.cartItemsCount ?? 0

        if numSections > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView = emptyStateView
            tableView.separatorStyle = .none
        }

        return numSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartItemCell", for: indexPath) as? CartItemTableCell else {
            fatalError("Could not fetch table cell")
        }

        guard let product = viewModel?.cartItems[indexPath.row] else {
            fatalError()
        }

        // Update this cell view with details from the Product
        cell.update(product)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // There *should* only be one section in our tableView...
        assert(section == 0, "Unexpected number of sections in tableView")

        // If there is more than 1 section we have bigger problems... just return the title
        return "My cart"
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // There *should* only be one section in our tableView...
        assert(section == 0, "Unexpected number of sections in tableView")

        // Build a custom label to display in our table
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 50)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 30)
        headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isOpaque = true
        view.addSubview(headerLabel)

        return view
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Allow users to remove items from their cart...
        let removeAction = UIContextualAction(style: .destructive, title: "Remove", handler: { (action, view, completionHandler) in

            // ...but warn them first!
            let alert = UIAlertController(title: "Remove From Cart", message: "Do you want to remove this item from your cart?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                completionHandler(false)
            })

            let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (UIAlertAction) in
                // Remove item from our model, then delete from the tableView
                self.viewModel?.removeCartItem(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)

                completionHandler(true)
            })

            alert.addAction(cancelAction)
            alert.addAction(removeAction)

            self.present(alert, animated: true, completion: nil)
        })

        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}

extension CartViewController: CartViewDelegate {
    /**
     Updates the displayed prices in our view controller

     - Parameter subtotal: Current subtotal, not including shipping
     - Parameter subtotal: Shipping fee
     - Parameter subtotal: Total amount of cart purchase
     */
    func didUpdatePrices(subtotal: Int, shipping: Int, total: Int) {
        lblSubtotal.text = "$\(subtotal)"
        lblShipping.text = "$\(shipping)"
        lblTotal.text = "$\(total)"
    }

    /**
     Called when the items in our cart have changed... basically adding/removing
     */
    func didUpdateCart() {
        guard let viewModel = viewModel else {
            return
        }

        btnCheckout.isEnabled = (viewModel.cartItemsCount > 0)
    }

    /**
     Called when there is an error loading our cart data
     */
    func loadDataError(error: String) {
        let alert = UIAlertController(title: "Error", message: "There was an error loading your cart: \n\(error)", preferredStyle: .alert)

        let tryAgain = UIAlertAction(title: "Try again", style: .default) { (UIAlertAction) in
            self.viewModel?.setup()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(tryAgain)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

}
