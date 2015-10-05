Given(/^I am on the Home Screen$/) do
  feed_me_button_exists
end

When(/^I press the Feed Me button$/) do
  click_feed_me_button
end

Then(/^I end up on the Feed Page$/) do
  feed_is_visible
end
