json.extract! app, :id, :user_id, :subdomain, :anchor_url, :back_up_url, :main_url, :github_account, :github_repo_name, :github_owner, :status, :app_dashboard_id, :created_at, :updated_at
json.url app_url(app, format: :json)
