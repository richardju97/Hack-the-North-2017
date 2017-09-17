//
//  AppDelegate.swift
//  testHack
//
//  Created by Richard Ju on 9/16/17.
//  Copyright © 2017 Richard Ju. All rights reserved.
//

import Alamofire
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func myCoolFunc() {
        
        let parameters: Parameters = [
            "data": "Hi this is a string xD"
        ]

// Both calls are equivalent
        let r = Alamofire.request("http://24.240.32.197:8000", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
        
//        print(r)
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        myCoolFunc()
        
        return true
    }

}

