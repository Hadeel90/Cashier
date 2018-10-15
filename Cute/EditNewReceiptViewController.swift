//
//  EditNewReceiptViewController.swift
//  Cute
//
//  Created by Hadeel on 10/2/18.
//  Copyright © 2018 Hadeel Alharthi. All rights reserved.
//

import Foundation
import Cocoa

class EditNewReceiptViewController: NSViewController {
    //outlets and variables
    @IBOutlet weak var EditNewReceiptItemIDField: NSTextField!
    @IBOutlet weak var EditNewReceiptVendorIDField: NSTextField!
    @IBOutlet weak var EditNewReceiptQuantityField: NSTextField!
    @IBOutlet weak var EditNewReceiptUnitPriceField: NSTextField!
    var itemIDValue: String!
    var vendorIDValue: String!
    var quantityValue: String!
    var unitPriceValue: String!
    
    //methods
    override func viewDidLoad() {
        EditNewReceiptItemIDField.stringValue = itemIDValue
        EditNewReceiptVendorIDField.stringValue = vendorIDValue
        EditNewReceiptQuantityField.stringValue = quantityValue
        EditNewReceiptUnitPriceField.stringValue = String(unitPriceValue.suffix(unitPriceValue.count-3))
    }
    
    //actions
    @IBAction func EditNewReceiptSaveButton(_ sender: Any) {
        if let presenter = presentingViewController as? NewReceiptViewController {
            presenter.item.itemID = EditNewReceiptItemIDField.stringValue
            presenter.item.vendorID = EditNewReceiptVendorIDField.stringValue
            presenter.item.quantity = Int(EditNewReceiptQuantityField.intValue)
            presenter.item.unitCost = EditNewReceiptUnitPriceField.doubleValue
            presenter.handleSheetDismissed()
        }
        dismiss(self)
    }
    
}
