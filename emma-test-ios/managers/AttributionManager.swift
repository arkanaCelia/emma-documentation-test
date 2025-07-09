//
//  AttributionManager.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 2/7/25.
//

import Foundation
import Combine
import EMMA_iOS

class AttributionManager: NSObject, EMMAInstallAttributionDelegate {

    static let shared = AttributionManager()
    var attributionPublisher = PassthroughSubject<String, Never>()
    
    // If using NSObject
    func requestAttributionInfo() {
        EMMA.installAttributionInfo(attributionDelegate: self)
        print("Solicitando attribution info a EMMA...")

    }
    
    // In case of using UIViewController (documentation example)
    /*
    override func viewDidLoad() {
            super.viewDidLoad()
            //We can get EMMA Attribution Info
            EMMA.installAttributionInfo(self)
        }
    */
    
    // MARK: - EMMA Attribution Delegate
    func onAttributionReceived(_ attribution: EMMAInstallAttribution!) {
        guard let info = attribution else {
            attributionPublisher.send("Error getting attribution info")
            return
        }
        attributionPublisher.send("Received attribution info: \(info)")
    }
}
