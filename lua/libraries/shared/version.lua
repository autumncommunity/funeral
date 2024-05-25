/*
    Version Checker

    Works only with GitHub
*/

version_checker = {}
version_checker.authors = {"smokingplaya"}

function version_checker:Validate(user, repo, branch, current_version)
    local name = repo:UpperFirst()

    logger.Info("Check is " + name + " up to date")

    HTTPRequestBuilder:new("https://raw.githubusercontent.com/" + user + "/" + repo + "/" + branch + "/version.json", METHODS.GET)
        :SetCallback(function(res)
            if res:IsError() then
                return logger.Error("Couldn't get version of \"" + repo + "\". Response code: 404")
            end

            local body = res:GetBody()

            if not isstring(body) then
                return logger.Error("Version check failed: Failed to process the body of the response.")
            end

            local json = body:json()

            local version = json.version

            if not version then
                return logger.Error("Version check failed: JSON file structure is bad")
            end

            logger.Info(version == current_version and name + " " + current_version + " is up to date" or name + " needs to be updated")
        end)
        :Send()
end