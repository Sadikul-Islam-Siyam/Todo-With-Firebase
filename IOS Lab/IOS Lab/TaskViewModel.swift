import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class TaskViewModel: ObservableObject {
    @Published private(set) var tasks: [TaskItem] = []
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private var tasksCollection: CollectionReference? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        return db.collection("users").document(userID).collection("tasks")
    }

    init() {
        listenForTasks()
    }

    deinit {
        listener?.remove()
    }

    func listenForTasks() {
        listener?.remove()
        guard let collection = tasksCollection else {
            tasks = []
            return
        }

        listener = collection.order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                Task { @MainActor in
                    if let error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    self?.tasks = snapshot?.documents.compactMap(TaskItem.init(document:)) ?? []
                }
            }
    }

    func addTask(title: String) {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTitle.isEmpty, let collection = tasksCollection else { return }

        collection.addDocument(data: [
            "title": cleanTitle,
            "isCompleted": false,
            "createdAt": FieldValue.serverTimestamp()
        ]) { [weak self] error in
            if let error {
                Task { @MainActor in self?.errorMessage = error.localizedDescription }
            }
        }
    }

    func toggleTask(_ task: TaskItem) {
        tasksCollection?.document(task.id).updateData([
            "isCompleted": !task.isCompleted
        ]) { [weak self] error in
            if let error {
                Task { @MainActor in self?.errorMessage = error.localizedDescription }
            }
        }
    }

    func deleteTask(_ task: TaskItem) {
        tasksCollection?.document(task.id).delete { [weak self] error in
            if let error {
                Task { @MainActor in self?.errorMessage = error.localizedDescription }
            }
        }
    }
}
