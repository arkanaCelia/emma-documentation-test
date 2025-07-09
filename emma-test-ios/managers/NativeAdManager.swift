//
//  NativeAdManager.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 3/7/25.
//
// test

import Foundation
import EMMA_iOS

/// A manager class responsible for handling native ad requests using EMMA's SDK.
class NativeAdManager: NSObject, EMMAInAppMessageDelegate {
    
    /// Singleton instance of `NativeAdManager`.
    static let shared = NativeAdManager()
    
    /// Callback executed when a native ad is received.
    var onAdReceived: ((EMMANativeAd?) -> Void)?
    
    /// Requests a native ad for a given template ID.
    ///
    /// - Parameter templateId: The ID of the native ad template configured in the EMMA dashboard.
    func getNativeAd(templateId: String) {
        print("getting native ad")
        let nativeAdRequest = EMMANativeAdRequest()
        nativeAdRequest.templateId = templateId
        EMMA.inAppMessage(request: nativeAdRequest, withDelegate: self) // delegate
        print("finish getting native ad")
    }

    /// Delegate method called when a native ad is successfully received.
    ///
    /// - Parameter nativeAd: The received native ad object.
    func onReceived(_ nativeAd: EMMANativeAd!) {
        print("NativeAd recibido: \(String(describing: nativeAd))")
        onAdReceived?(nativeAd)
    }
    
    func onShown(_ campaign: EMMACampaign!) {}
    func onHide(_ campaign: EMMACampaign!) {}
    func onClose(_ campaign: EMMACampaign!) {}
}
