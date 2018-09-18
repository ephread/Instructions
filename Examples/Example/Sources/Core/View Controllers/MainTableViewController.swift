//
//  MainTableViewController.swift
//  Instructions Example
//
//  Created by Frédéric Maquin on 03/06/2017.
//  Copyright © 2017 Ephread. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PausingOverlay" {
            if let controller = segue.destination as? PausingCodeViewController {
                controller.pauseStyle = .hideOverlay
            }
        } else if segue.identifier == "PausingInstructions" {
            if let controller = segue.destination as? PausingCodeViewController {
                controller.pauseStyle = .hideInstructions
            }
        } else if segue.identifier == "IndependantWindowContext" {
            if let controller = segue.destination as? DefaultViewController {
                controller.presentationContext = .independantWindow
                controller.windowLevel = UIWindow.Level.statusBar + 1
            }
        } else if segue.identifier == "ControllerWindowContext" {
            if let controller = segue.destination as? DefaultViewController {
                controller.presentationContext = .controllerWindow
            }
        } else if segue.identifier == "ControllerContext" {
            if let controller = segue.destination as? DefaultViewController {
                controller.presentationContext = .controller
            }
        }


    }
}
