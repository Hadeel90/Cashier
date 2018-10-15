//
//  ViewController.swift
//  Cute
//
//  Created by Hadeel on 9/28/18.
//  Copyright © 2018 Hadeel Alharthi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTabViewDelegate {
    
    //outlets and variables
    @IBOutlet weak var LandingTabView: NSTabView!
    @IBOutlet weak var AdminUsernameField: NSTextField!
    @IBOutlet weak var AdminPasswordField: NSSecureTextField!
    @IBOutlet weak var AdminSigninButtonOutlet: NSButton!
    @IBOutlet weak var AdminLoginErrorMessage: NSTextField!
    @IBOutlet weak var NewReceiptButtonOutlet: NSButton!
    @IBOutlet weak var ModifyDataButtonOutlet: NSButton!
    @IBOutlet weak var EmployeesServicesButtonOutlet: NSButton!
    @IBOutlet weak var DetailedStoreStatsButtonOutlet: NSButton!
    @IBOutlet weak var ReferenceNumbersButtonOutlet: NSButton!
    
    lazy var adminButtons: [NSButton] = [self.NewReceiptButtonOutlet, self.ModifyDataButtonOutlet, self.EmployeesServicesButtonOutlet, self.DetailedStoreStatsButtonOutlet, self.ReferenceNumbersButtonOutlet]
    lazy var adminFields: [NSTextField] = [self.AdminUsernameField, self.AdminPasswordField]
    var buttonState: Int = 0
    
    //methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        //access data
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //check for empty Admins entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SystemAdmin")
        
        //development purposes
//        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
//        do {
//            try context.execute(batchDelete)
//        } catch {
//            print("Failed")
//        }
        
        do {
            let _ = try context.fetch(request)
            let count = try context.count(for: request)
            if (count <= 0) {
                presentAsSheet(storyboard?.instantiateController(withIdentifier: "NewAdmin") as! NSViewController)
            }
        } catch {
            print(request.debugDescription)
        }
        
        //tabview delegate
        LandingTabView.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        if tabViewItem?.label != "Administrator" && buttonState == 1 {
            AdminSigninButtonOutlet.title = "Sign in"
            for button in adminButtons {
                button.isEnabled = false
            }
            for field in adminFields {
                field.isEnabled = true
                field.stringValue = ""
            }
            AdminUsernameField.selectText(self)
            buttonState = 0
        }
    }
    
    //actions
    @IBAction func AdminSigninButton(_ sender: Any) {
        //get user input
        let AdminUsername = AdminUsernameField.stringValue
        let AdminPassword = AdminPasswordField.stringValue
        
        //access data
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //validate data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SystemAdmin")
        do {
            let results = try context.fetch(request)
            let count = try context.count(for: request)
            if (count >= 0) {
                for data in results as! [NSManagedObject] {
                    let usernameStored = data.value(forKey: "username") as! String
                    let passwordStored = data.value(forKey: "password") as! String
                    
                    if !AdminUsername.isEmpty && !AdminPassword.isEmpty {
                        guard AdminUsername == usernameStored, AdminPassword == passwordStored else {
                            AdminLoginErrorMessage.stringValue = "Invalid username or password. Please verify your information and try again."
                            return
                        }
                        if buttonState == 0 {
                            AdminSigninButtonOutlet.title = "Sign out"
                            for button in adminButtons {
                                button.isEnabled = true
                            }
                            for field in adminFields {
                                field.isEnabled = false
                            }
                            buttonState = 1
                        } else if buttonState == 1 {
                            AdminSigninButtonOutlet.title = "Sign in"
                            for button in adminButtons {
                                button.isEnabled = false
                            }
                            for field in adminFields {
                                field.isEnabled = true
                                field.stringValue = ""
                            }
                            AdminUsernameField.selectText(self)
                            buttonState = 0
                        }
                        AdminLoginErrorMessage.stringValue = ""
                    } else {
                        AdminLoginErrorMessage.stringValue = "Fields can't be empty"
                    }
                    
                }
                
            }
        } catch {
            print(request.debugDescription)
        }
        
    }
    @IBAction func NewReceiptButton(_ sender: Any) {
        performSegue(withIdentifier: "NewReceiptSegue", sender: self)
    }
    @IBAction func ModifyDataButton(_ sender: Any) {
        performSegue(withIdentifier: "ModifyDataSegue", sender: self)
    }
    @IBAction func EmployeesServicesButton(_ sender: Any) {
        performSegue(withIdentifier: "EmployeesServicesSegue", sender: self)
    }
    @IBAction func DetailedStoreStatsButton(_ sender: Any) {
        performSegue(withIdentifier: "DetailedStoreStatsSegue", sender: self)
    }
    @IBAction func ReferenceNumbersButton(_ sender: Any) {
        performSegue(withIdentifier: "ReferenceNumbersSegue", sender: self)
    }
    
}

