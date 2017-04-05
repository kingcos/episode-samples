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
    
    @IBOutlet weak var downloadUrl: UITextField!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var suspendOrResumeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
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
        let dest: DownloadRequest.DownloadFileDestination = { temporaryUrl, response in
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
            return (episodeUrl, [])
        }
        
        if let resUrl = self.downloadUrl.text {
            Alamofire.download(resUrl, method: .get, to: dest)
                .downloadProgress(queue: DispatchQueue.main, closure: { (progress) in
                    self.downloadProgress.progress = Float(progress.fractionCompleted)
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
            
            
            self.currStatus = .suspended
            btnTitle = "Resume"
            
        case .suspended:
            print("Resume downloading...")
            
            // TODO: Add resuming code here
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
            
            self.currStatus = .cancelled
            self.cancelBtn.isEnabled = false
            self.suspendOrResumeBtn.isEnabled = false
            self.suspendOrResumeBtn.setTitle("Suspend", for: UIControlState())
        default:
            break
        }
    }
}
