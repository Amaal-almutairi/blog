//
//  CloudKitService.swift
//  blog
//
//  Created by Amaal Almutairi on 03/07/1444 AH.
//

import CloudKit
import os

final class CloudKitService {
    private static let logger = Logger(
        subsystem: "com.Amaal.blog",
        category: String(describing: CloudKitService.self)
    )

    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
}


extension CloudKitService {
    func save(_ record: CKRecord) async throws {
        try await CKContainer.default().privateCloudDatabase.save(record)
    }
}

extension CloudKitService {
    func fetchFastingRecords(in interval: DateInterval) async throws -> [Fasting] {
        let predicate = NSPredicate(
            format: "\(FastingRecordKeys.start.rawValue) >= %@ AND \(FastingRecordKeys.end.rawValue) <= %@",
            interval.start as NSDate,
            interval.end as NSDate
        )

        let query = CKQuery(
            recordType: FastingRecordKeys.type.rawValue,
            predicate: predicate
        )

        query.sortDescriptors = [.init(key: FastingRecordKeys.end.rawValue, ascending: true)]

        let result = try await CKContainer.default().privateCloudDatabase.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(Fasting.init)
    }
}
