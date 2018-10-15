//
//  NewReceiptWindowController.swift
//  Cute
//
//  Created by Hadeel on 9/29/18.
//  Copyright © 2018 Hadeel Alharthi. All rights reserved.
//

import Foundation
import Cocoa;

class NewReceipt{
    //properties
    var itemID, vendorID: String!
    var quantity: Int!
    var unitCost, indirectCost, profitPercentage, price, discount, finalPrice: Double!
    
    init(_itemID: String, _vendorID: String, _quantity: Int, _unitPrice: Double){
        self.itemID = _itemID
        self.vendorID = _vendorID
        self.quantity = _quantity
        self.unitCost = _unitPrice
        self.indirectCost = 0
        self.profitPercentage = 0
        self.price = (unitCost + indirectCost) * (1 + profitPercentage/100)
        self.discount = 0
        self.finalPrice = price * (1 - (discount/100))
    }
    
    func refresh() {
        self.price = (unitCost + indirectCost) * (1 + profitPercentage/100)
        self.finalPrice = price * (1 - (discount/100))
    }
}

class NewReceiptViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate {
    //outlets and variables
    @IBOutlet weak var NewReceiptVendorField: NSTextField!
    @IBOutlet weak var NewReceiptDate: NSTextField!
    @IBOutlet weak var NewReceiptItemIDField: NSTextField!
    @IBOutlet weak var NewReceiptVendorIDField: NSTextField!
    @IBOutlet weak var NewReceiptQuantityField: NSTextField!
    @IBOutlet weak var NewReceiptUnitPriceField: NSTextField!
    @IBOutlet weak var NewReceiptTable: NSTableView!
    @IBOutlet weak var NewReceiptEditButtonOutlet: NSButton!
    @IBOutlet weak var NewReceiptDeleteButtonOutlet: NSButton!
    @IBOutlet weak var NewReceiptSaveButtonOutlet: NSButton!
    
    var newReceipts: [NewReceipt] = []
    let cellIdentifier: String = "NewReceiptCell"
    
    var rowIndex: Int!
    var item: NewReceipt!
    
    //methods
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy HH:mm:ss"
        NewReceiptDate.stringValue = "\(dateFormatter.string(from: currentDate))"
    }
    
    func handleSheetDismissed() {
        NewReceiptTable.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return newReceipts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var view: NSTextField! = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTextField
        
        if (view == nil) {
            view = NSTextField()
            view.identifier = NSUserInterfaceItemIdentifier(rawValue: cellIdentifier)
            view.backgroundColor = NSColor.clear
            view.isBordered = false
            view.isSelectable = false
            view.isEditable = false
        }
        
        switch tableColumn?.title {
        case "Reference":
            view.stringValue = newReceipts[row].itemID
        case "Vendor ID":
            view.stringValue = newReceipts[row].vendorID
        case "QTY":
            view.intValue = Int32(newReceipts[row].quantity)
        case "Unit Price":
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencyCode = "SR "
            view.stringValue = currencyFormatter.string(from: newReceipts[row].unitCost! as NSNumber)!
        default:
            break
        }
        return view
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        NewReceiptEditButtonOutlet.isEnabled = (newReceipts.count > 0 && NewReceiptTable.numberOfSelectedRows > 0)
        NewReceiptDeleteButtonOutlet.isEnabled = (newReceipts.count > 0 && NewReceiptTable.numberOfSelectedRows > 0)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditNewReceiptSegue") {
            let view = segue.destinationController as? EditNewReceiptViewController
            
            rowIndex = NewReceiptTable.selectedRow
            item = newReceipts[rowIndex]
            
            view?.itemIDValue = (NewReceiptTable.view(atColumn: 0, row: rowIndex, makeIfNecessary: false) as! NSTextField).stringValue
            view?.vendorIDValue = (NewReceiptTable.view(atColumn: 1, row: rowIndex, makeIfNecessary: false) as! NSTextField).stringValue
            view?.quantityValue = (NewReceiptTable.view(atColumn: 2, row: rowIndex, makeIfNecessary: false) as! NSTextField).stringValue
            view?.unitPriceValue = (NewReceiptTable.view(atColumn: 3, row: rowIndex, makeIfNecessary: false) as! NSTextField).stringValue
            
        }
        
        if (segue.identifier == "DetailedNewReceiptSegue") {
            let view = segue.destinationController as? DetailedNewReceiptViewController
            
            view?.vendor = NewReceiptVendorField.stringValue
            view?.currentDate = NewReceiptDate.stringValue
            
            let sortedNewReceipts = newReceipts.sorted(by: {$0.itemID < $1.itemID})
            view?.newReceipts = sortedNewReceipts
        }
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        let closeAlert = NSAlert()
        closeAlert.messageText = "Unsaved Data"
        closeAlert.informativeText = "You have unsaved data. Are you sure you want to close the form?"
        closeAlert.addButton(withTitle: "Yes")
        closeAlert.addButton(withTitle: "Cancel")
        closeAlert.alertStyle = NSAlert.Style(rawValue: 2)!
        if newReceipts.count > 0 {
            let result = closeAlert.runModal()
            return result.rawValue != 1001
        }
        return true
    }
    
    //actions
    @IBAction func NewReceiptAddButton(_ sender: Any) {
        let emptyError = NSAlert()
        emptyError.messageText = "Empty Fields"
        emptyError.informativeText = "Please make sure all fields are filled"
        let integerError = NSAlert()
        integerError.messageText = "Wrong Value"
        integerError.informativeText = "Please make sure values are correct. Integer;"
        let doubleError = NSAlert()
        doubleError.messageText = "Wrong Value"
        doubleError.informativeText = "Please make sure values are correct. Double;"
        
        if (!(NewReceiptItemIDField.stringValue.isEmpty || NewReceiptVendorIDField.stringValue.isEmpty || NewReceiptQuantityField.stringValue.isEmpty || NewReceiptUnitPriceField.stringValue.isEmpty)){
            
            if (Int(NewReceiptQuantityField.stringValue) == nil) {
                integerError.beginSheetModal(for: view.window!)
            } else if (Double(NewReceiptUnitPriceField.stringValue) == nil) {
                doubleError.beginSheetModal(for: view.window!)
            } else {
                newReceipts.append(NewReceipt(_itemID: NewReceiptItemIDField.stringValue, _vendorID: NewReceiptVendorIDField.stringValue, _quantity: Int(NewReceiptQuantityField.intValue), _unitPrice: NewReceiptUnitPriceField.doubleValue))
                
                NewReceiptItemIDField.stringValue = ""
                NewReceiptVendorIDField.stringValue = ""
                NewReceiptQuantityField.stringValue = ""
                NewReceiptUnitPriceField.stringValue = ""
                NewReceiptItemIDField.selectText(self)
            }
            
        } else {
            emptyError.beginSheetModal(for: view.window!)
        }
        
        NewReceiptTable.dataSource = self
        NewReceiptTable.delegate = self
        
        NewReceiptTable.reloadData()
        NewReceiptSaveButtonOutlet.isEnabled = newReceipts.count > 0
        
    }
    @IBAction func NewReceiptEditButton(_ sender: Any) {
        if (newReceipts.count > 0) {
            performSegue(withIdentifier: "EditNewReceiptSegue", sender: self)
        }
        NewReceiptTable.deselectAll(self)
    }
    @IBAction func NewReceiptDeleteButton(_ sender: Any) {
        if (newReceipts.count > 0) {
            rowIndex = NewReceiptTable.selectedRow
            newReceipts.remove(at: rowIndex)
            NewReceiptTable.deselectAll(self)
            NewReceiptTable.reloadData()
        }
        
    }
    @IBAction func NewReceiptSaveButton(_ sender: Any) {
        performSegue(withIdentifier: "DetailedNewReceiptSegue", sender: self)
    }

}
