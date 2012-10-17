Rails.application.class.configure do
  config.generators do |g|
    g.fixture_replacement :machinist
    g.template_engine :haml
    g.test_framework  :rspec, :fixture => true
    g.view_specs false
    g.helper false
    g.helper_specs false
    g.stylesheets false
    g.javascripts false
  end
end
