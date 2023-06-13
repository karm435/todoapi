import Foundation
import Dependency
import Models
import Network

@MainActor
class TasksListViewModel: ObservableObject {
	@Dependency(\.networkClient) var networkClient
	@Published var state: State = .loading
	
	private var tasks: [Todo] = []
	
	public func onAppear() async {
		state = .loading
		do {
			tasks = try await networkClient.get(endPoint: TaskEndPoint.all)
			state = .display(tasks: tasks)
		}
		catch {
			state = .error(error: error)
			print(error)
		}
	}
	
	public func delete(_ indexes: IndexSet) async {
		if let index = indexes.first {
			do {
				try await networkClient.delete(endPoint: TaskEndPoint.delete(id: tasks[index].id))
				tasks.remove(at: index)
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}



extension TasksListViewModel {
	public enum State {
		case loading
		case error(error: Error)
		case display(tasks: [Todo])
	}
}

extension TasksListViewModel {
	static var preview: TasksListViewModel {
		let viewModel = TasksListViewModel()
		viewModel.state = .display(tasks: Todo.placeholderTasks)
		return viewModel
	}
}
