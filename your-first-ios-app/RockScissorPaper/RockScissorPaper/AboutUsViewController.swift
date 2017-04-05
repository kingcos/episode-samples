//
//  AboutUsViewController.swift
//  RockScissorPaper
//
//  Created by Mars on 1/1/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var aboutUs: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let htmlFile = Bundle.main.path(forResource: "aboutus", ofType: "html")
        
        if (htmlFile != nil) {
            if let htmlData = try? Data(contentsOf: URL(fileURLWithPath: htmlFile!)) {
                let mainBundleUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
                self.aboutUs.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: mainBundleUrl)
            }
        }
        
        self.view.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
