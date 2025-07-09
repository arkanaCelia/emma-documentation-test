//
//  CouponView.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 4/7/25.
//

import Foundation
import SwiftUI
import EMMA_iOS

struct CouponView: View {
    var coupon: EMMACoupon

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(coupon.title)
                    .font(.title)
                    .fontWeight(.bold)

                Text(coupon.couponDescription)
                    .font(.body)

                if let imageUrl = URL(string: coupon.imageUrl) {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                }

                Button("Canjear") {
                    let redeemRequest = EMMAInAppRequest(type: .RedeemCoupon)
                    redeemRequest.inAppMessageId = "\(coupon.couponId)"
                    EMMA.inAppMessage(request: redeemRequest)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
