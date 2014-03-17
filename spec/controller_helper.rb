RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.before(:each) do
    PaperTrail.enabled = false
  end

  config.before(:each, versioning: true) do
    PaperTrail.enabled = true
  end
end
