import app/models/api_response.{ApiResponse}
import app/models/todos.{type Todo, type TodoPatchRequest, Todo}
import birl
import gleam/option.{None, Some}

pub fn patch_todo(old: Todo, new: TodoPatchRequest) {
  let maybe_time = case new.due_date {
    Some(time) -> birl.parse(time) |> option.from_result
    None -> None
  }
  let td =
    Todo(
      ..old,
      title: option.unwrap(new.title, old.title),
      description: option.unwrap(new.description, old.description),
      priority: option.unwrap(new.priority, old.priority),
    )

  case maybe_time, new.due_date {
    None, Some(time) ->
      ApiResponse(
        status: "400",
        message: "Cound not parse " <> time <> " as a valid datetime",
        data: None,
      )
    _, _ -> ApiResponse(status: "200", message: "Success", data: Some(td))
  }
}
