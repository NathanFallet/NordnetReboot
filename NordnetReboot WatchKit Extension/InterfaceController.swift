//
//  InterfaceController.swift
//  NordnetReboot WatchKit Extension
//
//  Created by Nathan FALLET on 08/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var button: WKInterfaceButton!
    
    @IBAction func buttonClicked() {
        // Disable the button
        button.setEnabled(false)
        
        // Send the reboot request
        Reboot.reboot() {
            // Enable the button
            self.button.setEnabled(true)
        }
    }

}
