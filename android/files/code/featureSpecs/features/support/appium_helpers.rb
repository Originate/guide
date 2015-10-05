# Clicks the element with the given id
def click_id id
  wait { find_element(:id, id).click }
end

# Clicks the element at the given XPath
def click_xpath path
  wait { find_element(:xpath, path).click }
end

# finds the element with the given id
def find_id id
  wait { find_element(:id, id) }
end

# finds the element at the given XPath
def find_xpath path
  wait { find_element(:xpath, path) }
end

# Waits the given number of times for the given block to become true
def wait timeout: 3, &block
  wait = Selenium::WebDriver::Wait.new timeout: timeout
  wait.until(&block)
end
