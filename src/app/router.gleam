import app/controllers/todos/create
import app/controllers/todos/get
import app/controllers/todos/update
import app/models/api_response
import app/models/todos
import app/web
import gleam/http
import gleam/http/request.{type Request}
import gleam/io
import gleam/json
import mist.{type Connection}

pub fn handle_request(request: Request(Connection)) {
  case request.path_segments(request) {
    ["api", ..rest] -> {
      case rest {
        ["status"] -> {
          case request.method {
            http.Get -> api_response.ok_response("Ok!")
            _ -> api_response.not_allowed()
          }
        }
        ["todo", ..rest] -> {
          case rest {
            [] -> {
              case request.method {
                http.Get -> {
                  let response = get.get_all_todos()
                  let response_json =
                    api_response.api_response_decoder(
                      response,
                      todos.list_todo_encoder,
                    )
                    |> json.to_string
                  api_response.ok_response(response_json)
                }
                http.Post -> {
                  let body = web.get_body(request)
                  case todos.decode_todo_request(body) {
                    Ok(request) -> {
                      let response = create.create_todo(request)
                      let response_json =
                        api_response.api_response_decoder(
                          response,
                          todos.todo_encoder,
                        )
                        |> json.to_string
                      api_response.created_response(response_json)
                    }
                    Error(_) -> api_response.bad_request("")
                  }
                }
                _ -> api_response.not_allowed()
              }
            }
            [id] -> {
              case request.method {
                http.Get -> {
                  let response = get.get_by_id(id)
                  let response =
                    api_response.api_response_decoder(
                      response,
                      todos.todo_encoder,
                    )
                    |> json.to_string
                  api_response.ok_response(response)
                }
                http.Patch -> {
                  let body = web.get_body(request)
                  case todos.decode_todo_patch_request(body) {
                    Ok(new) -> {
                      let old = get.get_by_id(id)
                      let response = update.patch_todo(old.data, new)
                      let response_json =
                        api_response.api_response_decoder(
                          response,
                          todos.todo_option_encoder,
                        )
                        |> json.to_string
                      case response.status {
                        "400" -> api_response.bad_request(response_json)
                        _ -> api_response.ok_response(response_json)
                      }
                    }
                    Error(e) -> {
                      io.debug(e)
                      api_response.bad_request("")
                    }
                  }
                }
                http.Delete -> {
                  api_response.not_allowed()
                }
                _ -> api_response.not_allowed()
              }
            }
            _ -> api_response.not_found()
          }
        }
        __ -> api_response.not_found()
      }
    }
    _ -> api_response.not_found()
  }
}
