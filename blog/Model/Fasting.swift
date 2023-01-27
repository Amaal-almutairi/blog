









import Foundation
import CloudKit

struct Fasting: Hashable {
    var start: Date
    var end: Date
    var goal: TimeInterval
}

enum FastingRecordKeys: String {
    case type = "Fasting"
    case start
    case end
    case goal
}

extension Fasting {
    var record: CKRecord {
        let record = CKRecord(recordType: FastingRecordKeys.type.rawValue)
        record[FastingRecordKeys.goal.rawValue] = goal
        record[FastingRecordKeys.start.rawValue] = start
        record[FastingRecordKeys.end.rawValue] = end
        return record
    }
}

extension Fasting {
    init?(from record: CKRecord) {
        guard
            let start = record[FastingRecordKeys.start.rawValue] as? Date,
            let end = record[FastingRecordKeys.end.rawValue] as? Date,
            let goal = record[FastingRecordKeys.goal.rawValue] as? TimeInterval
        else { return nil }
        self = .init(start: start, end: end, goal: goal)
    }
}
