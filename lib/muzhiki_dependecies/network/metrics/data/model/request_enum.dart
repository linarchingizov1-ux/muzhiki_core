import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum RequestPlatform {
  @JsonValue('android')
  android,

  @JsonValue('ios')
  ios,
}

@JsonEnum(alwaysCreate: true)
enum RequestMethod {
  @JsonValue('GET')
  get,

  @JsonValue('POST')
  post,

  @JsonValue('PUT')
  put,

  @JsonValue('PATCH')
  patch,

  @JsonValue('DELETE')
  delete,
}

@JsonEnum(alwaysCreate: true)
enum RequestError {
  @JsonValue('null')
  none,

  @JsonValue('timeout')
  timeout,

  @JsonValue('connection')
  connection,

  @JsonValue('dns')
  dns,

  @JsonValue('cancelled')
  cancelled,

  @JsonValue('http_4xx')
  http4xx,

  @JsonValue('http_5xx')
  http5xx,

  @JsonValue('unknown')
  unknown,
}

@JsonEnum(alwaysCreate: true)
enum RequestNetwork {
  @JsonValue('wifi')
  wifi,

  @JsonValue('cellular')
  cellular,

  @JsonValue('ethernet')
  ethernet,

  @JsonValue('none')
  none,

  @JsonValue('unknown')
  unknown,
}
