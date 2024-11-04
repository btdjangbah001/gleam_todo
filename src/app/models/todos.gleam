import birl.{type Time}
import gleam/dynamic
import gleam/json.{bool, int, nullable, object, preprocessed_array, string}
import gleam/list
import gleam/option.{type Option}

pub type TodoRequest {
  TodoRequest(title: String, description: String, due_date: String)
}

pub type TodoPatchRequest {
  TodoPatchRequest(
    title: Option(String),
    description: Option(String),
    due_date: Option(String),
    priority: Option(String),
  )
}

pub type Todo {
  Todo(
    id: Int,
    title: String,
    description: String,
    completed: Bool,
    due_date: Time,
    priority: String,
    created_at: Time,
  )
}

pub fn todo_encoder(data: Todo) {
  object([
    #("id", int(data.id)),
    #("title", string(data.title)),
    #("description", string(data.description)),
    #("completed", bool(data.completed)),
    #("due_date", string(data.due_date |> birl.to_iso8601)),
    #("priority", string(data.priority)),
    #("created_at", string(data.created_at |> birl.to_iso8601)),
  ])
}

pub fn list_todo_encoder(data: List(Todo)) {
  preprocessed_array(data |> list.map(todo_encoder))
}

pub fn todo_option_encoder(data: Option(Todo)) {
  nullable(data, todo_encoder)
}

fn todo_request_decoder() {
  dynamic.decode3(
    TodoRequest,
    dynamic.field("title", dynamic.string),
    dynamic.field("description", dynamic.string),
    dynamic.field("due_date", dynamic.string),
  )
}

fn todo_patch_request() {
  dynamic.decode4(
    TodoPatchRequest,
    dynamic.optional_field("title", dynamic.string),
    dynamic.optional_field("description", dynamic.string),
    dynamic.optional_field("due_date", dynamic.string),
    dynamic.optional_field("priority", dynamic.string),
  )
}

pub fn decode_todo_request(body: String) {
  json.decode(body, todo_request_decoder())
}

pub fn decode_todo_patch_request(body: String) {
  json.decode(body, todo_patch_request())
}
