//
//  ReferenceNumbersViewController.swift
//  Cute
//
//  Created by Hadeel on 10/9/18.
//  Copyright © 2018 Hadeel Alharthi. All rights reserved.
//

import Cocoa

class ReferenceNumber {
    //properties
    var id: Int!
    var desc: String!
    
    init(_id: Int, _desc: String) {
        id = _id
        desc = _desc
    }
}

//code from http://rosettacode.org/wiki/Binary_search#Swift, extension by https://stackoverflow.com/questions/26678362/how-do-i-insert-an-element-at-the-correct-position-into-a-sorted-array-in-swift
extension Array {
    func insertionIndex(of elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}

class ReferenceNumbersViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    //outlets
    @IBOutlet weak var ReferenceNumberField: NSTextField!
    @IBOutlet weak var ReferenceDescriptionField: NSTextField!
    @IBOutlet weak var ReferenceDeleteButtonOutlet: NSButton!
    @IBOutlet weak var ReferenceDoneButtonOutlet: NSButton!
    @IBOutlet weak var ReferenceTable: NSTableView!
    
    var referenceNumbers: [ReferenceNumber] = []
    let cellIdentifier: String = "ReferenceCell"
    
    //methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        ReferenceTable.dataSource = self
        ReferenceTable.delegate = self
    }
    
    override func viewDidAppear() {
        //access data
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //fetch data from reference entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reference")
        
        //development purposes
//        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
//        do {
//            try context.execute(batchDelete)
//        } catch {
//            print("Failed")
//        }
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        //add data into array
        do {
            let results = try context.fetch(request)
            for item in results as! [NSManagedObject] {
                referenceNumbers.append(ReferenceNumber(_id: item.value(forKey: "id") as! Int, _desc: item.value(forKey: "desc") as! String))
            }
            ReferenceTable.reloadData()
        } catch {
            print(request.debugDescription)
        }
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return referenceNumbers.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var view: NSTextField! = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTextField
        
        for _ in referenceNumbers {
            if view == nil {
                view = NSTextField()
                view.identifier = NSUserInterfaceItemIdentifier(rawValue: cellIdentifier)
                view.backgroundColor = NSColor.clear
                view.isBordered = false
                view.isSelectable = false
                view.isEditable = false
            }

            switch tableColumn?.title {
            case "Reference No.":
                view.intValue = Int32(referenceNumbers[row].id)
            case "Description":
                view.stringValue = referenceNumbers[row].desc
            default:
                break
            }
        }
        
        if view == nil {
            view = NSTextField()
            view.identifier = NSUserInterfaceItemIdentifier(rawValue: cellIdentifier)
            view.backgroundColor = NSColor.clear
            view.isBordered = false
            view.isSelectable = false
            view.isEditable = false
        }
        
        switch tableColumn?.title {
        case "Reference No.":
            view.intValue = Int32(referenceNumbers[row].id)
        case "Description":
            view.stringValue = referenceNumbers[row].desc
        default:
            break
        }
        return view
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        ReferenceDeleteButtonOutlet.isEnabled = (referenceNumbers.count > 0 && ReferenceTable.numberOfSelectedRows > 0)
    }
    
    //actions
    @IBAction func AddNewReferenceButton(_ sender: Any) {
        //populate table
        let emptyError = NSAlert()
        emptyError.messageText = "Empty Fields"
        emptyError.informativeText = "Please make sure all fields are filled"
        
        if (!(ReferenceNumberField.stringValue.isEmpty || ReferenceDescriptionField.stringValue.isEmpty)) {
            
            //append to sorted position in array
            let elem = ReferenceNumber(_id: Int(ReferenceNumberField.intValue), _desc: ReferenceDescriptionField.stringValue)
            let index = referenceNumbers.insertionIndex(of: elem) {$0.id < $1.id}
            referenceNumbers.insert(elem, at: index)
            
            //append at end of array
//            referenceNumbers.append(ReferenceNumber(_id: Int(ReferenceNumberField.intValue), _desc: ReferenceDescriptionField.stringValue))
            
            // save to database
            //access data
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //save data
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reference")
            let entity = NSEntityDescription.entity(forEntityName: "Reference", in: context)
            let newRef = NSManagedObject(entity: entity!, insertInto: context)
            
            newRef.setValue(ReferenceNumberField.intValue, forKey: "id")
            newRef.setValue(ReferenceDescriptionField.stringValue, forKey: "desc")
            
            do {
                try context.save()
                let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
                request.sortDescriptors = [sortDescriptor]
                ReferenceNumberField.stringValue = ""
                ReferenceDescriptionField.stringValue = ""
                ReferenceNumberField.selectText(self)
                print("saved")
            } catch {
                print(request.debugDescription)
            }
            
        } else {
            emptyError.beginSheetModal(for: view.window!)
        }
        
        ReferenceTable.reloadData()
    }
    @IBAction func ReferenceDeleteButton(_ sender: Any) {
        if (referenceNumbers.count > 0) {
            //remove from array
            referenceNumbers.remove(at: ReferenceTable.selectedRow)
            
            //access data
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //remove data
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reference")
            
            let results = try! context.fetch(request) as! [NSManagedObject]
            context.delete(results[ReferenceTable.selectedRow])
            
            do {
                try context.save()
                let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
                request.sortDescriptors = [sortDescriptor]
            } catch {
                print(request.debugDescription)
            }
            
            ReferenceTable.deselectAll(self)
            ReferenceTable.reloadData()
        }
    }
    @IBAction func ReferenceDoneButton(_ sender: Any) {
        dismiss(self)
    }
    
}
