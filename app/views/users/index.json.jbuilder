json.array!(@users) do |user|
  json.extract! user, :name, :email, :accountNumber, :password_digest, :password_reset_token, :password_reset_at
  json.url user_url(user, format: :json)
end
