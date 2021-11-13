// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

class MainTableViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PausingOverlay",
           let controller = segue.destination as? PausingCodeViewController {
            controller.pauseStyle = .hideOverlay
        } else if segue.identifier == "PausingInstructions",
                  let controller = segue.destination as? PausingCodeViewController {
            controller.pauseStyle = .hideInstructions
        } else if segue.identifier == "IndependentWindowContext",
               let controller = segue.destination as? DefaultViewController {
            controller.presentationContext = .independentWindow
        } else if segue.identifier == "WindowLevel",
                  let controller = segue.destination as? DefaultViewController {
            controller.presentationContext = .independentWindow
            controller.windowLevel = UIWindow.Level.statusBar + 1
        } else if segue.identifier == "ControllerWindowContext",
                  let controller = segue.destination as? DefaultViewController {
            controller.presentationContext = .controllerWindow
        } else if segue.identifier == "ControllerContext",
                  let controller = segue.destination as? DefaultViewController {
            controller.presentationContext = .controller
        } else if segue.identifier == "InvisibleOverlay",
            let controller = segue.destination as? DefaultViewController {
            controller.useInvisibleOverlay = true
        } else if segue.identifier == "BlurInControllerWindowContext",
            let controller = segue.destination as? BlurringOverlayViewController {
            controller.presentationContext = .controllerWindow
        } else if segue.identifier == "BlurInControllerContext",
            let controller = segue.destination as? BlurringOverlayViewController {
            controller.presentationContext = .controller
        }
    }
}
