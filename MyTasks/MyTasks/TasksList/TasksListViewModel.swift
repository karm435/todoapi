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
			print(error)
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
