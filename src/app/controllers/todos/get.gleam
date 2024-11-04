import app/models/api_response.{ApiResponse}
import app/models/todos.{Todo}
import birl

pub fn get_all_todos() {
  let tds = [
    Todo(
      id: 1,
      title: "",
      description: "",
      completed: False,
      due_date: birl.now(),
      priority: "medium",
      created_at: birl.now(),
    ),
  ]
  ApiResponse(status: "200", message: "Success", data: tds)
}

pub fn get_by_id(_id: String) {
  let tds =
    Todo(
      id: 1,
      title: "",
      description: "",
      completed: False,
      due_date: birl.now(),
      priority: "medium",
      created_at: birl.now(),
    )
  ApiResponse(status: "200", message: "Success", data: tds)
}
