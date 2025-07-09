//
//  AppDelegate.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 27/6/25.
//

import Foundation
import UIKit
import EMMA_iOS

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // EMMA uses window to display some InApp Messages
        self.window = UIWindow(frame:UIScreen.main.bounds)

        let configuration = EMMAConfiguration()
        configuration.sessionKey = "3DBF55A0B7BC550874edfbac6d5dc49f8"
        EMMA.startSession(with: configuration)
        
        // --- optional configs
        //configuration.trackScreenEvents = false // disable screens
        
        
        /*
        //Solicitar permiso de tracking para IDFA en iOS 14+ (optional)
        if #available(iOS 14.0, *) {
            EMMA.requestTrackingWithIdfa()
        }
        */
        
        return true
    }
    
    // function that processes the paths of the received Powlinks (configured in Associated Domains)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                EMMA.handleLink(url: url)
            }
        }
        return true
    }
}
