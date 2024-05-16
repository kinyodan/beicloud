# frozen_string_literal: true

module OnboardingsHelper
  def onboardingServiceGetBranches(repo)
    p repo
    # Authenticate with GitHub using a personal access token
    # p system("git clone #{$config[repo]} content")

    # client = Octokit::Client.new(access_token: access_token)
    # if client && client.repos
    #    return client.repos
    # else
    #    return false
    # end
    # Get the contents of a file in the repository
    # contents = client.contents("#{owner}/#{repo}", path: path_to_file)
    # puts contents.content # file content will be Base64 encoded
  end
end
