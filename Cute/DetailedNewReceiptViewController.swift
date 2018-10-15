//
//  DetailedNewReceiptViewController.swift
//  Cute
//
//  Created by Hadeel on 10/6/18.
//  Copyright © 2018 Hadeel Alharthi. All rights reserved.
//

import Cocoa

class DetailedNewReceiptViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    //outlets and variables
    @IBOutlet weak var DetailedNewReceiptVendor: NSTextField!
    @IBOutlet weak var DetailedNewReceiptDate: NSTextField!
    @IBOutlet weak var DetailedNewReceiptTable: NSTableView!
    
    var vendor: String!
    var currentDate: String!
    var newReceipts: [NewReceipt] = []
    let cellIdentifier: String = "NewReceiptCell"
    
    //methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        DetailedNewReceiptTable.dataSource = self
        DetailedNewReceiptTable.delegate = self
    }
    
    override func viewDidAppear() {
        DetailedNewReceiptVendor.stringValue = vendor
        DetailedNewReceiptDate.stringValue = currentDate
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return newReceipts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var view: NSTextField! = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTextField
        
        for _ in newReceipts {
            if (view == nil) {
                view = NSTextField()
                view.identifier = NSUserInterfaceItemIdentifier(rawValue: cellIdentifier)
                view.backgroundColor = NSColor.clear
                view.isBordered = false
                view.isSelectable = false
                view.isEditable = false
            }
            
            //currency formatter
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencyCode = "SR "
            
            switch tableColumn?.title {
            case "Barcode":
                let currentdate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyMMdd"
                view.stringValue = dateFormatter.string(from: currentdate) + newReceipts[row].itemID
            case "Description":
                view.stringValue = newReceipts[row].vendorID
            case "QTY":
                view.intValue = Int32(newReceipts[row].quantity)
            case "Unit Cost":
                view.stringValue = currencyFormatter.string(from: newReceipts[row].unitCost! as NSNumber)!
            case "Indirect Cost":
                view.doubleValue = newReceipts[row].indirectCost
                view.isEditable = true
                view.identifier = NSUserInterfaceItemIdentifier(rawValue: "IndirectCost")
            case "Profit %":
                view.doubleValue = newReceipts[row].profitPercentage
                view.isEditable = true
                view.identifier = NSUserInterfaceItemIdentifier(rawValue: "Profit %")
            case "Price":
                view.stringValue = currencyFormatter.string(from: newReceipts[row].price as NSNumber)!
            case "Discount %":
                view.doubleValue = newReceipts[row].discount
                view.isEditable = true
                view.identifier = NSUserInterfaceItemIdentifier(rawValue: "Discount %")
            case "Final Price":
                view.stringValue = currencyFormatter.string(from: newReceipts[row].finalPrice as NSNumber)!
            default:
                break
            }
        }
        view.delegate = self
        return view
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        let view = obj.object as! NSTextField
        let id = view.identifier?.rawValue
        var costValue, profitValue, discountValue: Double!
        
        switch id {
        case "IndirectCost":
            costValue = Double(view.stringValue)
            newReceipts[DetailedNewReceiptTable.selectedRow].indirectCost = costValue
            newReceipts[DetailedNewReceiptTable.selectedRow].refresh()
        case "Profit %":
            profitValue = Double(view.stringValue)
            newReceipts[DetailedNewReceiptTable.selectedRow].profitPercentage = profitValue
            newReceipts[DetailedNewReceiptTable.selectedRow].refresh()
        case "Discount %":
            discountValue = Double(view.stringValue)
            newReceipts[DetailedNewReceiptTable.selectedRow].discount = discountValue
            newReceipts[DetailedNewReceiptTable.selectedRow].refresh()
        default:
            break
        }
        
        DetailedNewReceiptTable.reloadData()
    }
    
    //actions
    @IBAction func DetailedNewReceiptCloseButton(_ sender: Any) {
        dismiss(self)
    }
    
}
