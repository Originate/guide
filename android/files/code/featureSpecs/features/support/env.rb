require 'appium_lib'
require 'cucumber'

# get latest APP_PATH for USER & APPNAME
APP_PATH = "#{Dir.pwd}/app/build/outputs/apk/app-appium.apk"
puts "Using App Path : %s" % APP_PATH

# set the app package which will be needed for some Appium commands
APP_PACKAGE = "com.originate.feedapp"
APP_ACTIVITY = "#{APP_PACKAGE}.activity.SplashScreenActivity"

Before do
  setup_emulator
end

After do
  driver_quit
end

# Create a custom World class so we don't pollute `Object` with Appium methods
class AppiumWorld
end

# Create a new Appium session for testing apps.
def setup_emulator
  capabilities = {
  	'appium-version': '1.0',
  	'platformName': 'Android',
  	'platformVersion': '4.4',
  	'deviceName': 'testAVD',
  	'app': APP_PATH,
  	'appPackage': APP_PACKAGE,
  	'appActivity': APP_ACTIVITY
  }
  Appium::Driver.new(caps: capabilities).start_driver
  Appium.promote_appium_methods AppiumWorld
end

World do
  AppiumWorld.new
end
