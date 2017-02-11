//
//  ViewController.swift
//  Battery
//
//  Created by Dilpreet Singh on 7/1/17.
//  Copyright © 2017 Dilpreet Singh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// Show the quit alert
        let alert = createQuitAlert()
		if alert.runModal() == NSAlertFirstButtonReturn {
			// Exit on button press
			exit(0)
		}
    }
	
	private func createQuitAlert() -> NSAlert {
		let quitAlert = NSAlert()
		quitAlert.addButton(withTitle: "Quit")
		quitAlert.messageText = "Battery"
		quitAlert.informativeText = "Add the widget in Notification Center :)"
		quitAlert.alertStyle = .informational
		return quitAlert
	}
	
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
