//
//  ToastView.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 1/7/25.
//

import Foundation
import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: message)
    }
}

