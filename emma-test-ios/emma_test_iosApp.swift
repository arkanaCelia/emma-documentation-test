//
//  emma_test_iosApp.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 26/6/25.
//

import SwiftUI

@main
struct emma_test_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            UIKitTabBarRootView()
        }
    }
}

// Runs CustomTabBarController as RootViewController
struct UIKitTabBarRootView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return CustomTabBarController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
