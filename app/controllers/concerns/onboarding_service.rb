

require 'octokit'

module OnboardingService
    extend ActiveSupport::Concern

        def onboardingServiceImportFromGithub(access_token,owner, repo, path_to_file)
            client = Octokit::Client.new(access_token: access_token)
            if client && client.repos
               repos = client.repos.select {|r| r[:id] == 63977794 }
               return client.repos
            else
               return false 
            end 
            # Get the contents of a file in the repository
            # contents = client.contents("#{owner}/#{repo}", path: path_to_file)
            # puts contents.content # file content will be Base64 encoded
        end 

        def onboardingServiceGetBranches(repo,dir_name)
            p repo
            system("rm -rf ../#{dir_name}")
            p system("git clone #{repo} ../#{dir_name}")
            system("cd /home/me/dev/dev3/beicloud/#{dir_name}")
            # p system("cd #{dir_name}")
            p system("pwd")
            p system("git add .")
            p system("git commit -m 'commit for deploy to dokku' ")
            # p system("git fetch --all")
            # p system("git branch --all ")
            p system("app003-63977794")
            p system("echo '@Confucius@me2' | sudo -S dokku --force apps:destroy app003-#{dir_name}")
            p system("echo '@Confucius@me2' | sudo -S dokku apps:create app003-#{dir_name}")
            # p system("sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git")
            radnm = SecureRandom.hex(10)
            db_name = "#{SecureRandom.hex(10)}db#{dir_name}"
            p system("sudo dokku postgres:create #{db_name}")
            p system("sudo dokku postgres:link #{db_name} app003-#{dir_name}")
            p system("sudo dokku git:initialize app003-#{dir_name}")
            p system("git remote remove dokku")
            p system("git remote add dokku dokku@beicloud.com:app003-#{dir_name}")
            p system("git push dokku main")

        end 
end 