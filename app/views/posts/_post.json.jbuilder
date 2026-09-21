json.extract! post, :id, :title, :slug, :body, :published, :published_at, :created_at, :updated_at
json.image_url url_for(post.image) if post.image.attached?
json.url post_url(post, format: :json)
