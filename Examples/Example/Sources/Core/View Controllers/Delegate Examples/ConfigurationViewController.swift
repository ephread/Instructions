// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

internal class ConfigurationViewController: DefaultViewController {

    private var instructionsNavigationController: InstructionsNavigationController? {
        return navigationController as? InstructionsNavigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        coachMarksController.statusBarVisibility = .hidden
        coachMarksController.rotationStyle = .manual
        coachMarksController.interfaceOrientations =
            .userDefined(as: supportedInterfaceOrientations)

        instructionsNavigationController?.isLocked = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        instructionsNavigationController?.isLocked = false
    }

    override var shouldAutorotate: Bool {
        return instructionsNavigationController?.shouldAutorotate ?? true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return instructionsNavigationController?.supportedInterfaceOrientations ?? .all
    }
}
