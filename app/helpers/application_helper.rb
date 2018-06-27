module ApplicationHelper
  def flash_message(type)
    case type
    when "alert" then "alert alert-danger"
    when "notice" then "alert alert-primary"
    end
  end

  def gravatar(user)
    if user
      email = Digest::MD5.hexdigest(user.email)
      url = "https://s.gravatar.com/avatar/d0c97f60baa8529d972ebbdc8d70ffbf?s=100"
      image_tag(url, alt: user.name, class: "rounded-circle")
    end
  end
end
