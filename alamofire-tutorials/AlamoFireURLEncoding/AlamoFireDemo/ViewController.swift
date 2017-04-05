//
//  ViewController.swift
//  AlamoFireDemo
//
//  Created by Mars on 2/11/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var requestUrl =
        "https://apidemo.boxue.io/alamofire?XDEBUG_SESSION_START=PHPSTORM"
        // Define a simple KV parameter
        let parameters: [String : Any] = [
                "foo": [1, 2],
                "bar": [
                        "x": "a",
                        "y": 2
                ]
        ]

        // Parameters encoding in URL
        // [ "foo": [1, 2]]
        // [ "bar": ["x": "a", "y": 2]]
//        let requestParameters = "&foo[]=1&foo[]=2&bar[x]=a&bar[y]=2"
//        requestUrl = requestUrl + requestParameters
//        requestUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        // URLEncoding.default
        // HEAD / GET / DELETE - Put encoded parameter in request uri
        // Others - in HTTP body
        // .URLEncodedInURL (Removed in Alamofire 4)
        // Always put encoded parameters in request url
        Alamofire.request(requestUrl,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
//        Alamofire.request(requestUrl, method: .get)
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let json):
                print("JSON: ================")
                print("\(json)")
            case .failure(let error):
                print("\(error)")
            }
        })


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
