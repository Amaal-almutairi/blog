//
//  OnboardingView.swift
//  blog
//
//  Created by Amaal Almutairi on 03/07/1444 AH.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var accountStatusAlertShown = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("startUsingApp") {
            if viewModel.accountStatus != .available {
                accountStatusAlertShown = true
            } else {
                dismiss()
            }
            print("startUsingApp")
        }
        .alert("iCloudAccountDisabled", isPresented: $accountStatusAlertShown) {
            Button("cancel", role: .cancel, action: {})
        }
        .task {
            await viewModel.fetchAccountStatus()
           
        }
       
    }
}
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
