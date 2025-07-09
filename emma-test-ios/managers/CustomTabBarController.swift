//
//  CustomTabBarController.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 4/7/25.
//

import UIKit
import SwiftUI
import EMMA_iOS

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Creates the SwiftUI as UIHostingController
        let homeView = UIHostingController(rootView: HomeView())
        homeView.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let testView = UIHostingController(rootView: Text("Test tab content"))
        testView.tabBarItem = UITabBarItem(title: "Test", image: UIImage(systemName: "star"), tag: 1)

        viewControllers = [homeView, testView]

        // Delegate to EMMA
        EMMA.setPromoTabBarController(tabBarController: self)
    }
}
