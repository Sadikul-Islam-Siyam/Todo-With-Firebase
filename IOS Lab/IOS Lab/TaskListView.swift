import SwiftUI

struct TaskListView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var newTaskTitle = ""

    private var remainingCount: Int {
        taskViewModel.tasks.filter { !$0.isCompleted }.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your tasks")
                            .font(.largeTitle.bold())
                        Text(remainingCount == 1 ? "1 task left to do" : "\(remainingCount) tasks left to do")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "sun.max.fill")
                        .font(.title)
                        .foregroundStyle(.orange)
                }

                HStack(spacing: 10) {
                    TextField("What needs to get done?", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit(addTask)

                    Button(action: addTask) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 42, height: 42)
                            .background(.indigo, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Add task")
                }

                if let message = taskViewModel.errorMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if taskViewModel.tasks.isEmpty {
                    Spacer()
                    Image(systemName: "checkmark.seal")
                        .font(.system(size: 46))
                        .foregroundStyle(.secondary)
                    Text("Nothing on your list yet")
                        .font(.headline)
                    Text("Add a task above and make today count.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(taskViewModel.tasks) { task in
                            HStack(spacing: 12) {
                                Button {
                                    taskViewModel.toggleTask(task)
                                } label: {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundStyle(task.isCompleted ? .green : .indigo)
                                }
                                .buttonStyle(.plain)

                                Text(task.title)
                                    .strikethrough(task.isCompleted)
                                    .foregroundStyle(task.isCompleted ? .secondary : .primary)

                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .swipeActions {
                                Button(role: .destructive) {
                                    taskViewModel.deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Log out", systemImage: "rectangle.portrait.and.arrow.right") {
                        authViewModel.signOut()
                    }
                    .labelStyle(.iconOnly)
                }
            }
            .onAppear { taskViewModel.listenForTasks() }
        }
    }

    private func addTask() {
        taskViewModel.addTask(title: newTaskTitle)
        newTaskTitle = ""
    }
}
