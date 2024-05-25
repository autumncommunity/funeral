
/*
    local request = HTTPRequestBuilder:new("https://example.com/endpoint", METHODS.GET)
        :SetContentType(MIME_TYPES.JSON)
        :SetHTTP(HTTP)
        :SetCallback(function(res)
            dump("\n\nSuccess: " + str(res:IsSuccess()) + " (code " + res:GetCode() + ")", "Body:", res:GetBody())
        end)
        :Send()
*/

local class = {}
class.name = "HTTPRequestBuilder"

function class:new(url, method)
    if not url or not method then
        return
    end

    self.HTTP = HTTP
    self.headers = {}
    self.url = url
    self.method = METHODS[method]
    self.type = MIME_TYPES.TEXT
end

/**
    * SetContentType
    * * Sets the MIME content-type of request.
    * @param type - MIME_TYPES enum
*/

function class:SetContentType(type)
    self.type = type
    return self
end

/**
    * SetHeader
    * * Sets the header.
    * @param header
    * @param value
*/

function class:SetHeader(header, value)
    self.headers[header] = value
    return self
end

/**
    * SetCallback
    * * Sets the callback function that is called when the HTTP server returns a response.
    * @param http - HTTP function
*/

function class:SetCallback(callback)
    self.callback = function(...)
        local response = HTTPResponse:new(...)

        callback(response)
    end

    return self
end

/**
    * SetBody
    * * Sets the body of request.
    * @param arg - Body
*/

function class:SetBody(arg)
    self.body = arg

    return self
end

/**
    * SetHTTP
    * * Sets the function that will send HTTP requests.
    * @param http - HTTP function
*/

function class:SetHTTP(http)
    if not isfunction(http) then
        return error("HTTP argument must be function!")
    end

    self.HTTP = http
    return self
end

/**
    * Send
    * * Sends HTTP request to server
    * ? This is supposed to be the last method to be called, so it returns nothing.
*/

function class:Send()
    if not isfunction(self.callback) then
        return error("Unable to send HTTP request - no callback!")
    end

    self.HTTP {
        url = self.url,
        method = self.method,
        success = self.callback,
        failed = self.callback,
        body = self.type == MIME_TYPES.JSON and type(self.body) == "table" and util.TableToJSON(self.body) or self.body,
        type = self.type + "; charset=utf-8",
        timeout = 30,
        headers = headers
    }
end

return class