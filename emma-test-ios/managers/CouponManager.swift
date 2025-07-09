//
//  CouponManager.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 4/7/25.
//

import Foundation
import EMMA_iOS

class CouponManager: NSObject, EMMACouponDelegate {
    static let shared = CouponManager()
    
    var onCouponsReceived: (([EMMACoupon]) -> Void)?
    var onError: (() -> Void)?
    
    func getCoupons() {
        EMMA.addCouponDelegate(delegate: self) // delegate
        let request = EMMAInAppRequest(type: .Coupons)
        EMMA.inAppMessage(request: request)
    }
    
    // Delegate functions
    
    func onCouponsReceived(_ coupons: [EMMACoupon]!) {
        guard let coupons = coupons else {
            onError?()
            return
        }
        onCouponsReceived?(coupons)
    }
    
    func onCouponsFailure() {
        onError?()
    }
}
