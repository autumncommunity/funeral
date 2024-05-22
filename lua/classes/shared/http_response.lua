local class = {}
class.name = "HTTPResponse"

/*
    Response Code
*/

function class:new(code_or_reason, body, headers)
    self.code = 0
    /* error */
    self.error = ""
    self.isServerError = isnumber(code_or_reason) and (code_or_reason >= 500) or false
    self.isClientError = isnumber(code_or_reason) and (code_or_reason >= 400 and code_or_reason < 500) or false
    self.headers = headers
    self.body = body

    if isstring(code_or_reason) then
        return self:SetError(code_or_reason) // ¯\_(ツ)_/¯
    end

    self:SetCode(code_or_reason)
end

/* Server Error */

function class:SetServerError(error)
    self.isServerError = true
    self.error = error
end

function class:IsServerError()
    return self.isServerError
end

/* Client Error */

function class:SetClientError(error)
    self.isClientError = true
    self.error = error
end

function class:IsClientError()
    return self.isClientError
end

/* General Error */

function class:SetError(error)
    self.error = error
end

function class:IsError()
    return self.error != ""
end

function class:IsSuccess()
    return self.error == ""
end

function class:GetError()
    return self.error
end

/* Response code */

function class:SetCode(code)
    self.code = code
    return self
end

function class:GetCode()
    return self.code
end

/* Headers */

function class:GetHeaders()
    return self.headers
end

/* Body */

function class:GetBody()
    local content_type = self.headers["Content-Type"]

    return content_type and content_type:find(MIME_TYPES.JSON) and self.body:json() or self.body
end

return class