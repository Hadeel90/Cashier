//
//  DetailedNewReceiptViewController.swift
//  Cute
//
//  Created by Hadeel on 10/6/18.
//  Copyright © 2018 Hadeel Alharthi. All rights reserved.
//

import Cocoa

class DetailedNewReceiptViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
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
        
        DetailedNewReceiptTable.reloadData()
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
            
            switch tableColumn?.title {
            case "Barcode":
                view.stringValue = newReceipts[row].itemID + String(123)
            case "Description":
                view.stringValue = newReceipts[row].vendorID
            case "QTY":
                view.intValue = Int32(newReceipts[row].quantity)
            case "Unit Price":
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                currencyFormatter.currencyCode = "SR "
                view.stringValue = currencyFormatter.string(from: newReceipts[row].unitPrice! as NSNumber)!
            default:
                break
            }
        }
        return view
    }
    
    //actions
    
}
