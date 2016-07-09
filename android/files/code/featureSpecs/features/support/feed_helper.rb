def click_feed_me_button
  click_id "#{APP_PACKAGE}:id/splash_button"
end

def feed_me_button_exists
  find_id "#{APP_PACKAGE}:id/splash_button"
end

def feed_is_visible
  find_id "#{APP_PACKAGE}:id/feed_list"
end
