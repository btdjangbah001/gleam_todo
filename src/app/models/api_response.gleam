import gleam/bytes_builder
import gleam/http/response
import gleam/json.{type Json, object, string}
import mist

pub type ApiResponse(a) {
  ApiResponse(status: String, message: String, data: a)
}

pub fn api_response_decoder(response: ApiResponse(a), data: fn(a) -> Json) {
  object([
    #("status", string(response.status)),
    #("message", string(response.message)),
    #("data", data(response.data)),
  ])
}

pub fn created_response(data: String) {
  response.new(201)
  |> response.set_body(mist.Bytes(bytes_builder.from_string(data)))
  |> response.set_header("content-type", "application/json")
}

pub fn ok_response(data: String) {
  response.new(200)
  |> response.set_body(mist.Bytes(bytes_builder.from_string(data)))
  |> response.set_header("content-type", "application/json")
}

pub fn not_allowed() {
  response.new(405) |> response.set_body(mist.Bytes(bytes_builder.new()))
}

pub fn not_found() {
  response.new(404)
  |> response.set_body(mist.Bytes(bytes_builder.from_string("NOT FOUND")))
}

pub fn bad_request(response: String) {
  response.new(400)
  |> response.set_body(mist.Bytes(bytes_builder.from_string(response)))
}
