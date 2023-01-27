//
//  OnboardingViewModel.swift
//  blog
//
//  Created by Amaal Almutairi on 05/07/1444 AH.
//

import Foundation
import CloudKit
import os

@MainActor final class OnboardingViewModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.Amaal.blog",
        category: String(describing: OnboardingViewModel.self)
    )

    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine

    private let cloudKitService = CloudKitService()

    func fetchAccountStatus() async {
        do {
            accountStatus = try await cloudKitService.checkAccountStatus()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
}
