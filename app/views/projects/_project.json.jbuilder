json.extract! project, :id, :title, :description, :tech_stack, :project_link, :repo_link, :position, :created_at, :updated_at
json.image_url url_for(project.image) if project.image.attached?
json.url project_url(project, format: :json)
