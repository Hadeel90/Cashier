//
//  ViewController.swift
//  Cute
//
//  Created by Hadeel on 9/28/18.
//  Copyright © 2018 Hadeel Alharthi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    //outlets and variables
    @IBOutlet weak var AdminUsernameField: NSTextField!
    @IBOutlet weak var AdminPasswordField: NSSecureTextField!
    @IBOutlet weak var NewReceiptButtonOutlet: NSButton!
    @IBOutlet weak var ModifyDataButtonOutlet: NSButton!
    @IBOutlet weak var EmployeesServicesButtonOutlet: NSButton!
    @IBOutlet weak var DetailedStoreStatsButtonOutlet: NSButton!
    
    lazy var adminButtons: [NSButton] = [self.NewReceiptButtonOutlet, self.ModifyDataButtonOutlet, self.EmployeesServicesButtonOutlet, self.DetailedStoreStatsButtonOutlet]
    var home = FileManager.default.homeDirectoryForCurrentUser
        
    //methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        var pathToFile = "usr/lib"
//        var pathUrl = self.home.appendingPathComponent(pathToFile)
        UserDefaults.standard.set("admin", forKey: "AdminUsername")
        UserDefaults.standard.set("1234", forKey: "AdminPassword")
        UserDefaults.standard.synchronize()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //actions
    @IBAction func AdminSigninButton(_ sender: Any) {
        let AdminUsername: String = AdminUsernameField.stringValue
        let AdminPassword: String = AdminPasswordField.stringValue
        let usernameStored = UserDefaults.standard.string(forKey: "AdminUsername")
        let passwordStored = UserDefaults.standard.string(forKey: "AdminPassword")
        
        guard AdminUsername == usernameStored else {
            return
        }
        
        guard AdminPassword == passwordStored else {
            return
        }
        
        for button in adminButtons {
            button.isEnabled = true
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
    
}

