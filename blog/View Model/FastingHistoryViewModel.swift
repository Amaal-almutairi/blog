//
//  FastingHistoryViewModel.swift
//  blog
//
//  Created by Amaal Almutairi on 03/07/1444 AH.
//

import Foundation
import os

@MainActor final class FastingHistoryViewModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.aaplab.fastbot",
        category: String(describing: FastingHistoryViewModel.self)
    )

    @Published var interval: DateInterval = .init(
        start: .now.addingTimeInterval(-30 * 34 * 3600),
        end: .now
    )

    @Published private(set) var history: [Fasting] = []
    @Published private(set) var isLoading = false

    private let cloudKitService = CloudKitService()

    func fetch() async {
        isLoading = true

        do {
            history = try await cloudKitService.fetchFastingRecords(in: interval)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }

        isLoading = false
    }
}
