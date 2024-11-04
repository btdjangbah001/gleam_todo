import app/models/api_response.{ApiResponse}
import app/models/todos.{type TodoRequest, Todo}
import birl

pub fn create_todo(request: TodoRequest) {
  let td =
    Todo(
      id: 1,
      title: request.title,
      description: request.description,
      completed: False,
      due_date: birl.now(),
      priority: "medium",
      created_at: birl.now(),
    )
  ApiResponse(status: "201", message: "Success", data: td)
}
