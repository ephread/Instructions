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
        if segue.identifier == "WindowLevel" {
            if let controller = segue.destination as? DefaultViewController {
                controller.coachMarksController.overlay.windowLevel = UIWindowLevelStatusBar + 1
            }
        }
    }

}
