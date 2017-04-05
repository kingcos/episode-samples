//
//  ViewController.swift
//  AlamoFireDemo
//
//  Created by Mars on 2/11/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit
import Alamofire

enum DownloadStatus {
    case notStarted
    case downloading
    case suspended
    case cancelled
}

class ViewController: UIViewController {
    var currStatus = DownloadStatus.notStarted
    var request: Alamofire.Request?
    var episodeUrl: URL?
    
    @IBOutlet weak var downloadUrl: UITextField!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var suspendOrResumeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if !(self.episodesDirUrl as NSURL).checkResourceIsReachableAndReturnError(nil) {
            try! FileManager.default
                .createDirectory(at: self.episodesDirUrl,
                                withIntermediateDirectories: true,
                                attributes: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    var documentsDirUrl: URL {
        let fm = FileManager.default
        let url = fm.urls(for: .documentDirectory,
                                    in: .userDomainMask)[0]
        
        return url
    }
    
    var episodesDirUrl: URL {
        let url = self.documentsDirUrl
                    .appendingPathComponent("episodes", isDirectory: true)
        
        return url
    }
}

extension ViewController {
    fileprivate func displayNetworkAlert(
        _ errorMessage: String,
        data: Data? = nil,
        destination: DownloadRequest.DownloadFileDestination? = nil
        ) {
        // 1. Create a UIAlertController object
        let alert = UIAlertController(title: "Network error", message: errorMessage, preferredStyle: .alert)
        
        // 2. Add different actions according to data
        if let data = data {
            let resume = UIAlertAction(
                title: "Resume",
                style: .default,
                handler: { _ in
                    print("Resume downloading...")
                    
                    if let destination = destination {
                        defer {
                            Alamofire.download(resumingWith: data, to: destination)
                                .downloadProgress(queue: DispatchQueue.main, closure: { (progress) in
                                    self.downloadProgress.progress = Float(progress.fractionCompleted)
                                })
                        }
                    }
                }
            )
            
            alert.addAction(resume)
            
            let cancel = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: { _ in
                    print("Cancel downloading...")
                    
                    self.downloadUrl.text = nil
                    self.downloadProgress.progress = 0
                    self.beginBtn.isEnabled = false
                    self.suspendOrResumeBtn.isEnabled = false
                    self.cancelBtn.isEnabled = false
                }
            )
            
            alert.addAction(cancel)
        }
        else {
            let cancel = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: { _ in
                    print("Cancel downloading...")
                    
                    self.downloadUrl.text = nil
                    self.downloadProgress.progress = 0
                    self.beginBtn.isEnabled = false
                    self.suspendOrResumeBtn.isEnabled = false
                    self.cancelBtn.isEnabled = false
                }
            )
            
            alert.addAction(cancel)
        }
        
        // 3. Display the UIAlertController
        self.present(alert, animated: true, completion: nil)
    }
}
extension ViewController {
    @IBAction func valueChanged(_ sender: UITextField) {
        print("text field: \(sender.text ?? "nil")")
        
        if sender.text != "" {
            self.beginBtn.isEnabled = true
        }
        else {
            self.beginBtn.isEnabled = false
        }
    }
    
    // Button actions
    @IBAction func beginDownload(_ sender: AnyObject) {
        print("Begin downloading...")
        
        // TODO: Add begin downloading code here
        let dest: DownloadRequest.DownloadFileDestination = {
            temporaryUrl, response in
            print(temporaryUrl)
            
            // 1. Get the downloaded file name
            let pathComponent = response.suggestedFilename
            
            // 2. Generate the destination file NSURL
            let episodeUrl = self.episodesDirUrl.appendingPathComponent(pathComponent!)
            
            // 3. Check if the destination file already exists
            if try! episodeUrl.checkResourceIsReachable() {
                print("Clear the previous existing file")
                
                let fm = FileManager.default
                
                try! fm.removeItem(at: episodeUrl)
            }
            
            // 4. Return the destination file NSURL
            self.episodeUrl = episodeUrl
            return (episodeUrl, [])
        }
        
        if let resUrl = self.downloadUrl.text {
            self.request = Alamofire.download(resUrl, method: .get, to: dest)
                .downloadProgress(queue: DispatchQueue.main, closure: { (progress) in
                    self.downloadProgress.progress = Float(progress.fractionCompleted)
                })
                .response(completionHandler: { (response) in
                    if let error = response.error {
                        print("Download error: \(error.localizedDescription)")
                        
                        if let data = response.resumeData {
                            print("Resume data exists")
                            
                            self.displayNetworkAlert(
                                error.localizedDescription,
                                data: data,
                                destination: dest
                            )
                        }
                        else {
                            print("Resume data is nil")
                            
                            self.displayNetworkAlert(
                                error.localizedDescription
                            )
                        }
                    }
                    else {
                        // Download successfully
                        self.uploadBtn.isEnabled = true
                        
                        let alert = UIAlertController(title: "Success",
                                                      message: "Download finished successfully!",
                                                      preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(
                            title: "OK",
                            style: UIAlertActionStyle.default,
                            handler: { _ in
                                print("Finish downloading...")
                                
                                self.downloadUrl.text = nil
                                self.downloadProgress.progress = 0
                                self.beginBtn.isEnabled = false
                                self.suspendOrResumeBtn.isEnabled = false
                                self.cancelBtn.isEnabled = false
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                })
        }
        
        self.suspendOrResumeBtn.isEnabled = true;
        self.cancelBtn.isEnabled = true;
        self.currStatus = .downloading
    }
    
    @IBAction func suspendOrResumeDownload(_ sender: AnyObject) {
        var btnTitle: String?
        
        switch self.currStatus {
        case .downloading:
            print("Suspend downloading...")
            
            // TODO: Add suspending code here
            self.request!.suspend()
            
            self.currStatus = .suspended
            btnTitle = "Resume"
            
        case .suspended:
            print("Resume downloading...")
            
            // TODO: Add resuming code here
            self.request!.resume()
            
            self.currStatus = .downloading
            btnTitle = "Suspend"
            
        case .notStarted, .cancelled:
            break
        }
        
        self.suspendOrResumeBtn.setTitle(btnTitle, for: UIControlState())
    }
    
    @IBAction func cancelDownload(_ sender: AnyObject) {
        print("Cancel downloading...")
        
        switch self.currStatus {
        case .downloading, .suspended:
            // TODO: Add cancel code here
            self.request!.cancel()
            
            self.currStatus = .cancelled
            self.cancelBtn.isEnabled = false
            self.suspendOrResumeBtn.isEnabled = false
            self.suspendOrResumeBtn.setTitle("Suspend", for: UIControlState())
        default:
            break
        }
    }
    
    @IBAction func uploadFile(_ sender: AnyObject) {
        guard self.episodeUrl != nil else {
            print("Does not have any downloaded file.")
            return
        }
        
        print("Uploading \(self.episodeUrl!)")
        
        // TODO: add uploading code here
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(self.episodeUrl!,
                                     withName: "episode-demo")
        },
                         to: "https://apidemo.boxue.io/alamofire",
                         method: .post) { (encodingResult) in
                            switch encodingResult {
                            case .success(let request, _, _):
                                request.downloadProgress(queue: DispatchQueue.main, closure: { (progress) in
                                    self.downloadProgress.progress = Float(progress.fractionCompleted)
                                }).responseJSON(completionHandler: { (response) in
                                    debugPrint(response)
                                })
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        }
    }
}








































