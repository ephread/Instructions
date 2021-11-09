// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// Controller used to test Instructions behavior during background fetches.
// Unleash the Network Link Conditioner!
internal class BackgroundNetworkingViewController: DefaultViewController {

    // MARK: - Private properties
    private lazy var urlSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "BackgroundNetworking")
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = true

        return Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    private var downloadTask: URLSessionDownloadTask?

    var stopInstructions: Bool = false

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coachMarksController.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        stopInstructions = false
        startDownload()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopInstructions = true
    }

    // MARK: - Internal Methods
    override func startInstructions() {
        // Do nothing and override super.
    }

    func startDownload() {
        if let url = URL(string: "https://ephread.com/assets/videos/instructions.mp4") {
            downloadTask = urlSession.downloadTask(with: url)
            downloadTask?.resume()
        }
    }

    // MARK: CoachMarksControllerDelegate
    override func coachMarksController(_ coachMarksController: CoachMarksController,
                                       willShow coachMark: inout CoachMark,
                                       beforeChanging change: ConfigurationChange,
                                       at index: Int) {
        if index == 2 && change == .nothing {
            coachMarksController.flow.pause()
            startDownload()
        }
    }
}

// MARK: - NSURLSessionDownloadDelegate
extension BackgroundNetworkingViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished.")

        DispatchQueue.main.async {
            if self.stopInstructions { return }

            if !self.coachMarksController.flow.isStarted {
                self.coachMarksController.start(in: .window(over: self))
            } else {
                self.coachMarksController.flow.resume()
            }
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let size = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite,
                                             countStyle: ByteCountFormatter.CountStyle.binary)

        print(String(format: "%.1f%% of %@", progress * 100, size))
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let completionHandler = appDelegate.backgroundSessionCompletionHandler else { return }

        appDelegate.backgroundSessionCompletionHandler = nil

        DispatchQueue.main.async(execute: {
            completionHandler()
        })
    }
}
