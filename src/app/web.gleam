import gleam/bit_array
import gleam/http/request.{type Request}
import gleam/result
import mist.{type Connection}
import mist/internal/http.{Initial} as _misthttp

pub fn get_body(request: Request(Connection)) {
  case request.body.body {
    Initial(obj) -> bit_array.to_string(obj) |> result.unwrap("")
    _ -> ""
  }
}
