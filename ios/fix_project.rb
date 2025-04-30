#!/usr/bin/env ruby
require 'xcodeproj'

# Open the Xcode project
project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get your team ID from environment variable
team_id = ENV['TEAM_ID']

# Update the build settings to use the team ID
project.targets.each do |target|
  target.build_configurations.each do |config|
    config.build_settings['DEVELOPMENT_TEAM'] = team_id
    config.build_settings['CODE_SIGN_STYLE'] = 'Manual'
    config.build_settings['CODE_SIGN_IDENTITY'] = 'iPhone Distribution'
    config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = 'match AppStore com.sai.moodpal'
  end
end

# Save the changes
project.save