import app/router
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import mist.{type Connection, type ResponseData}

pub fn main() {
  let assert Ok(_) =
    fn(request: Request(Connection)) -> Response(ResponseData) {
      router.handle_request(request)
    }
    |> mist.new
    |> mist.port(8080)
    |> mist.start_http

  process.sleep_forever()
}
