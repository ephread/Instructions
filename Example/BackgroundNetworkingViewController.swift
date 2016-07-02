// BackgroundNetworkingViewController.swift
//
// Copyright (c) 2016 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Instructions

// Controller used to test Instructions behavior during background fetches.
// Unleash the Network Link Conditioner!
internal class BackgroundNetworkingViewController: DefaultViewController {

    //MARK: - Private properties
    private lazy var urlSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("BackgroundNetworking")
        configuration.sessionSendsLaunchEvents = true
        configuration.discretionary = true

        return NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    private var downloadTask: NSURLSessionDownloadTask?

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coachMarksController?.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        startDownload()
    }

    //MARK: - Internal Methods
    override func startInstructions() {
        // Do nothing and override super.
    }

    func startDownload() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        if let url = NSURL(string: "http://ephread.com/assets/videos/instructions.mp4") {
            downloadTask = urlSession.downloadTaskWithURL(url)
            downloadTask?.resume()
        }
    }
}

//MARK: - CoachMarksControllerDelegate
extension BackgroundNetworkingViewController: CoachMarksControllerDelegate {
    func coachMarksController(coachMarksController: CoachMarksController, inout coachMarkWillShow coachMark: CoachMark, forIndex index: Int) {
        if index == 2 {
            coachMarksController.pause()
            startDownload()
        }
    }

}

//MARK: - NSURLSessionDownloadDelegate
extension BackgroundNetworkingViewController: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("Finished.")

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        dispatch_async(dispatch_get_main_queue()) {
            if let coachMarksController = self.coachMarksController {
                if !coachMarksController.started {
                    self.coachMarksController?.startOn(self)
                } else {
                    self.coachMarksController?.resume()
                }
            }
        }
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let size = NSByteCountFormatter.stringFromByteCount(totalBytesExpectedToWrite, countStyle: NSByteCountFormatterCountStyle.Binary)

        print(String(format: "%.1f%% of %@",  progress * 100, size))
    }

    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else { return }
        guard let completionHandler = appDelegate.backgroundSessionCompletionHandler else { return }

        appDelegate.backgroundSessionCompletionHandler = nil

        dispatch_async(dispatch_get_main_queue(), {
            completionHandler()
        })
    }
}
