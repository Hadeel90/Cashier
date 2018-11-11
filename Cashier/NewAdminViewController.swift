//
//  NewAdminViewController.swift
//  Cute
//
//  Created by Hadeel on 10/5/18.
//  Copyright © 2018 Hadeel Alharthi. All rights reserved.
//

import Cocoa

class NewAdminViewController: NSViewController {
    
    //outlets and variables
    @IBOutlet weak var NewAdminUsernameField: NSTextField!
    @IBOutlet weak var NewAdminPasswordField: NSSecureTextField!

    //methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    //actions
    @IBAction func NewAdminButton(_ sender: Any) {
        //access data
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        //save data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SystemAdmin")
        let entity = NSEntityDescription.entity(forEntityName: "SystemAdmin", in: context)
        let newAdmin = NSManagedObject(entity: entity!, insertInto: context)
        
        newAdmin.setValue(NewAdminUsernameField.stringValue, forKey: "username")
        newAdmin.setValue(NewAdminPasswordField.stringValue, forKey: "password")
        do {
            try context.save()
        } catch {
            print(request.debugDescription)
        }
        dismiss(self)
    }
    
}
