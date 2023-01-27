//
//  NewFastingViewModel.swift
//  blog
//
//  Created by Amaal Almutairi on 03/07/1444 AH.
//

import Foundation
import os


//And now, we can finally create a form to populate fasting record data and save it to the private database of the current user on CloudKit.
@MainActor final class NewFastingViewModel: ObservableObject {
    
    private static let logger = Logger(
        subsystem: "com.Amaal.blog",
        category: String(describing: NewFastingViewModel.self)
    )

    @Published var fasting: Fasting = .init(
        start: .now,
        end: .now,
        goal: 16 * 3600
    )
    @Published private(set) var isSaving = false

    private let cloudKitService = CloudKitService()

    func save() async {
        isSaving = true

        do {
            try await cloudKitService.save(fasting.record)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }

        isSaving = false
    }
}
