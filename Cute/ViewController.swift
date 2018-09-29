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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //actions and methods
    @IBAction func NewReceiptButton(_ sender: NSButton) {
        performSegue(withIdentifier: "NewReceiptSegue", sender: self)
    }

}

