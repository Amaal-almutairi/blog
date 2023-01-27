////
////  CloudSharingView.swift
////  (cloudkit-samples) Sharing
////
//
//import Foundation
//import SwiftUI
//import UIKit
//import CloudKit
//import os
//
//struct CloudKitShareView: UIViewControllerRepresentable {
//    let share: CKShare
//
//    func makeUIViewController(context: Context) -> UICloudSharingController {
//        let sharingController = UICloudSharingController(
//            share: share,
//            container: CloudKitService.container
//        )
//        
//        sharingController.availablePermissions = [.allowReadOnly, .allowPrivate]
//        sharingController.modalPresentationStyle = .formSheet
//        return sharingController
//    }
//
//    func updateUIViewController(
//        _ uiViewController: UIViewControllerType,
//        context: Context
//    ) { }
//}
//
//
//
//extension CloudKitService {
//    func accept(_ metadata: CKShare.Metadata) async throws {
//        try await Self.container.accept(metadata)
//    }
//}
//
//private final class SceneDelegate: NSObject, UIWindowSceneDelegate {
//    private let logger = Logger(
//        subsystem: "com.Amaal.blog",
//        category: "SceneDelegate"
//    )
//    
//    private let cloudKitService = CloudKitService()
//
//    func windowScene(
//        _ windowScene: UIWindowScene,
//        userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata
//    ) {
//        Task {
//            do {
//                try await cloudKitService.accept(cloudKitShareMetadata)
//            } catch {
//                logger.error("\(error.localizedDescription, privacy: .public)")
//            }
//        }
//    }
//}
//
//
