import Foundation
import FirebaseFirestore

struct TaskItem: Identifiable {
    let id: String
    let title: String
    let isCompleted: Bool
    let createdAt: Timestamp?

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let title = data["title"] as? String else { return nil }
        self.id = document.documentID
        self.title = title
        self.isCompleted = data["isCompleted"] as? Bool ?? false
        self.createdAt = data["createdAt"] as? Timestamp
    }
}
