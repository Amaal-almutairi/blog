////
////  FlogViewModel.swift
////  blog
////
////  Created by Amaal Almutairi on 03/07/1444 AH.
////
//
//import Foundation
//import CloudKit
//
//class FlogViewModel:ObservableObject{
//    
//    func getiCloudStatus(){
//        //ask for userDiscoverability otherwise you will obtain nil each time you try to search for him
//        CKContainer.default().requestApplicationPermission(CKContainer.ApplicationPermissions.userDiscoverability) { (status, error) in
//            switch status {
//            case .granted:
//                print("granted")
//            case .denied:
//                print("denied")
//            case .initialState:
//                print("initial state")
//            case .couldNotComplete:
//                print("an error as occurred: ", error ?? "Unknown error")
//            }
//        }
//    }
//    
//    
//    func createPublicRecord() {
//        let aRecord = CKRecord(recordType: "MyUser")
//        aRecord.setObject("John" as CKRecordValue, forKey: "firstName")
//        aRecord.setObject("Appleseed" as CKRecordValue, forKey: "lastName")
//
//        let container = CKContainer.default()
//        let publicDatabase = container.publicCloudDatabase
//        
//        publicDatabase.save(aRecord, completionHandler: { (record, error) -> Void in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("record saved successfully")
//            }
//        })
//    }
//    
//    
//    func createFavZone(completionHandler:@escaping (CKRecordZone?, Error?)->Void) {
//        let container = CKContainer.default()
//        let privateDatabase = container.privateCloudDatabase
//        let customZone = CKRecordZone(zoneName: "FavZone")
//        
//        privateDatabase.save(customZone, completionHandler: ({returnRecord, error in
//            completionHandler(returnRecord, error)
//        }))
//    }
//    
//    func createPrivateRecord() {
//        let container = CKContainer.default()
//        let privateDatabase = container.privateCloudDatabase
//
//        let recordZone: CKRecordZone = CKRecordZone(zoneName: "FavZone")
//        let aRecord = CKRecord(recordType: "PrivateInfo", zoneID: recordZone.zoneID)
//
//        aRecord.setObject("+393331112223" as CKRecordValue, forKey: "phoneNumber")
//        aRecord.setObject("john@appleseed.com" as CKRecordValue, forKey: "email")
//
//        
//        privateDatabase.save(aRecord, completionHandler: { (record, error) -> Void in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("record saved successfully")
//            }
//        })
//    }
//    
//    
//    func createDefaultShareProfileURL() {
//        let container = CKContainer.default()
//        let privateDatabase = container.privateCloudDatabase
//        
//        let query = CKQuery(recordType: "PrivateInfo", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
//        let recordZone: CKRecordZone = CKRecordZone(zoneName: "FavZone")
//        privateDatabase.fetch(withQuery: <#T##CKQuery#>, completionHandler: <#T##(Result<(matchResults: [(CKRecord.ID, Result<CKRecord, Error>)], queryCursor: CKQueryOperation.Cursor?), Error>) -> Void#>)
//        //fetch(withQuery:inZoneWith:desiredKeys:resultsLimit:completionHandler:)
//        privateDatabase.perform(query, inZoneWith: recordZone.zoneID) { (results, error) -> Void in
//            if let error = error {
//                print(error)
//            }
//            else if let results = results, let ourRecord = results.first {
//                let share = CKShare(rootRecord: ourRecord)
//                
//                let modOp: CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [ourRecord, share], recordIDsToDelete: nil)
//                modOp.savePolicy = .ifServerRecordUnchanged
//                modOp.modifyRecordsCompletionBlock = { records, recordIDs, error in
//                    if let error = error  {
//                        print("error in modifying the records: ", error)
//                    }
//                    else if let anURL = share.url {
//                        let container = CKContainer.default()
//                        let publicDatabase = container.publicCloudDatabase
//                        let query = CKQuery(recordType: "MyUser", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
//                        var myPublicProfile:CKRecord?
//                        
//                        publicDatabase.perform(query, inZoneWith: nil) { (results, error) -> Void in
//                            if let error = error {
//                                print("error: ", error)
//                            }
//                            else if let results = results {
//                                for aRecord in results {
//                                    if aRecord.creatorUserRecordID?.recordName == "__defaultOwner__" {
//                                        myPublicProfile = aRecord
//                                        break
//                                    }
//                                }
//                            }
//                            if let myPublicProfile = myPublicProfile {
//                                myPublicProfile.setObject(anURL.absoluteString as CKRecordValue, forKey: "privateShareUrl")
//                                publicDatabase.save(myPublicProfile, completionHandler: { (record, error) -> Void in
//                                    if let error = error {
//                                        print("error: ", error)
//                                    }
//                                    else {
//                                        print("all done, folks!")
//                                    }
//                                })
//                            }
//                        }
//                    }
//                }
//                privateDatabase.add(modOp)
//            }
//        }
//    }
//    
//    func refreshUserInformation(_ userRecordID: CKRecord.ID) {
//        let container = CKContainer.default()
//        let publicDatabase = container.publicCloudDatabase
//        
//        publicDatabase.fetch(withRecordID: userRecordID) { (record, error) in
//            if let error = error {
//                print(error)
//            }
//            else if let record = record {
//                let firstName = record.object(forKey: "firstName") as? String
//                let lastName = record.object(forKey: "lastName") as? String
//                
//                //do something with firstName and lastName, updating UI
//                
//                if let shareURL = record.object(forKey: "privateShareUrl") as? String {
//                    let sharedDatabase = container.sharedCloudDatabase
//                    let anURL = URL(string: shareURL)!
//                    
//                    let op = CKFetchShareMetadataOperation(shareURLs: [anURL])
//                    op.perShareMetadataBlock = { shareURL, shareMetadata, error in
//                        if let error = error {
//                            print(error)
//                        }
//                        else if let shareMetadata = shareMetadata {
//                            if shareMetadata.participantStatus == .accepted {
//                                let query = CKQuery(recordType: "PrivateInfo", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
//                                let zone = CKRecordZone.ID(zoneName: "FavZone", ownerName: (shareMetadata.ownerIdentity.userRecordID?.recordName)!)
//                                sharedDatabase.perform(query, inZoneWith: zone, completionHandler: { (records, error) in
//                                    if let error = error {
//                                        print(error)
//                                    }
//                                    else if let records = records, let firstRecord = records.first {
//                                        let phoneNumber = firstRecord.object(forKey: "phoneNumber") as? String
//                                        let email = firstRecord.object(forKey: "email") as? String
//                                        
//                                        //do something with private infos
//                                    }
//                                })
//                            }
//                            else if shareMetadata.participantStatus == .pending {
//                                let acceptOp = CKAcceptSharesOperation(shareMetadatas: [shareMetadata])
//                                acceptOp.qualityOfService = .userInteractive
//                                acceptOp.perShareResultBlock = { meta, share, error in
//                                    if let error = error {
//                                        print(error)
//                                    }
//                                    else if let share = share {
//                                        let query = CKQuery(recordType: "PrivateInfo", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
//                                        let zone = CKRecordZone.ID(zoneName: "FavZone", ownerName: (share.owner.userIdentity.userRecordID?.recordName)!)
//                                        sharedDatabase.perform(query, inZoneWith: zone, completionHandler: { (records, error) in
//                                            if let error = error {
//                                                print(error)
//                                            }
//                                            else if let records = records, let firstRecord = records.first {
//                                                let phoneNumber = firstRecord.object(forKey: "phoneNumber") as? String
//                                                let email = firstRecord.object(forKey: "email") as? String
//                                                
//                                                //do something with private infos
//                                            }
//                                        })
//                                    }
//                                }
//                                container.add(acceptOp)
//                            }
//                        }
//                    }
//                    op.fetchShareMetadataCompletionBlock = { error in
//                        if let error = error {
//                            print(error)
//                        }
//                    }
//                    container.add(op)
//                }
//            }
//        }
//    }
//    
//    
//}
//
