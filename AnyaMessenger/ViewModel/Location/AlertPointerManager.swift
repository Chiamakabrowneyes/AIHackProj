//
//  AlertPointerManager.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 2/15/24.
//

import Foundation
import FirebaseFirestore


class AlertPointerManager: ObservableObject {
    @Published var pointers = [AlertPointer]()
    var listenerRegistration: ListenerRegistration?


    init() {
        fetchPointers()
        observePointers()
    }


    
    func fetchPointers() {
        COLLECTION_ALERTS.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            self.pointers = documents.compactMap { doc -> AlertPointer? in
                var pointer = try? doc.data(as: AlertPointer.self)
                pointer?.id = doc.documentID // Manually set the id to the document's ID
                return pointer
            }
        }
    }

    func observePointers() {
        listenerRegistration?.remove() // Cancel the previous listener if any
        listenerRegistration = COLLECTION_ALERTS.addSnapshotListener { [weak self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching document changes: \(error!.localizedDescription)")
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                if let pointer = try? diff.document.data(as: AlertPointer.self) {
                    switch diff.type {
                    case .added, .modified:
                        if let index = self?.pointers.firstIndex(where: { $0.id == pointer.id }) {
                            self?.pointers[index] = pointer
                        } else {
                            self?.pointers.append(pointer)
                        }
                    case .removed:
                        self?.pointers.removeAll(where: { $0.id == pointer.id })
                    }
                }
            }
        }
    }

    
    deinit {
        listenerRegistration?.remove()
    }
}
