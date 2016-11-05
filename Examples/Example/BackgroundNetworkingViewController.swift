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

    //mark: - Private properties
    fileprivate lazy var urlSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "BackgroundNetworking")
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = true

        return Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    fileprivate var downloadTask: URLSessionDownloadTask?

    //mark: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coachMarksController?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startDownload()
    }

    //mark: - Internal Methods
    override func startInstructions() {
        // Do nothing and override super.
    }

    func startDownload() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        if let url = URL(string: "http://ephread.com/assets/videos/instructions.mp4") {
            downloadTask = urlSession.downloadTask(with: url)
            downloadTask?.resume()
        }
    }
}

//mark: - CoachMarksControllerDelegate
extension BackgroundNetworkingViewController: CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkWillShow coachMark: inout CoachMark, forIndex index: Int) {
        if index == 2 {
            coachMarksController.pause()
            startDownload()
        }
    }

}

//mark: - NSURLSessionDownloadDelegate
extension BackgroundNetworkingViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished.")

        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        DispatchQueue.main.async {
            if let coachMarksController = self.coachMarksController {
                if !coachMarksController.flow.started {
                    self.coachMarksController?.startOn(self)
                } else {
                    self.coachMarksController?.resume()
                }
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let size = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)

        print(String(format: "%.1f%% of %@",  progress * 100, size))
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
