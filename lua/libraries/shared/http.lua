include("utils.lua") // yes, you can do that

METHODS = enum {
    "GET",
    "POST",
    "OPTIONS",
    "TRACE",
    "PUT",
    "PATCH",
    "DELETE",
    "CONNECT"
}

/**
    * TODO: We need more MIME types..
*/

MIME_TYPES = enum {
    JSON = "application/json",
    YAML = "application/x-yaml",
    XML = "application/xml",
    TEXT = "text/plain",
}