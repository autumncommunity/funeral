/*
    Version Checker

    Works only with GitHub
*/

version_checker = {}
version_checker.authors = {"smokingplaya"}

function version_checker.Validate(user, repo, branch, current_version)
    print("https://github.com/" + user + "/" + repo + "/blob/" + branch + "/version.json")
    HTTPRequestBuilder:new("https://github.com/" + user + "/" + repo + "/blob/" + branch + "/version.json", METHODS.GET)
        :SetCallback(function(res)
            if res:IsError() then
                return logger.Error("I couldn't get the \"" + repo + "\" version. Response code: 404")
            end


        end)
        :Send()
end