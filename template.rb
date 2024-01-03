require "fileutils"
require "shellwords"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-user-template"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/ankurp/rails-user-template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-user-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def read_gemfile?
  File.open("Gemfile").each_line do |line|
    return true if line.strip.start_with?("rails") && line.include?("7.")
  end
end

def rails_version
  @rails_version ||= Gem::Version.new(Rails::VERSION::STRING) || read_gemfile?
end

def rails_7_1_or_newer?
  Gem::Requirement.new(">= 7.1.0").satisfied_by? rails_version
end

unless rails_7_1_or_newer?
  say "\n This template requires Rails 7.1 or newer. You are using #{rails_version}.", :green
  say "Please remove partially installed template files #{original_app_name} and try again.", :green
  exit 1
end

def add_gems
  add_gem "bcrypt"
end

def add_users
  generate "model", "user", "email:string:uniq", "password_digest:string", "password_challenge:string"
  insert_into_file "config/environments/development.rb", after: "Rails.application.configure do" do
    "\n\tconfig.action_mailer.default_url_options = { host: \"localhost\", port: 3000 }\n"
  end
  insert_into_file "app/views/layouts/application.html.erb", before: "\n  </head>" do
    "\n\t\t<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"
  end

  gsub_file 'app/views/layouts/application.html.erb', '<%= yield %>', """
    <header>
      <nav>
        <% if user_signed_in? %>
          <%= link_to \"Edit Password\", edit_password_path %>
          <%= button_to \"Sign out\", session_path, method: :delete %>
        <% else %>
          <%= link_to \"Sign Up\", new_registration_path %>
          <%= link_to \"Log in\", new_session_path %>
        <% end %>
      </nav>
    </header>
    <main>
      <% if notice.present? %>
        <p class=\"notice\"><%= notice %></p>
      <% end %>
      <% if alert.present? %>
        <p class=\"alert\"><%= alert %></p>
      <% end %>
      <%= yield %>
    </main>
    <footer></footer>
  """
  
  route "root to: 'home#index'"
  route "resource :registration, only: [:new, :create]"
  route "resource :session, only: [:new, :create, :destroy]"
  route "resource :password_reset, only: [:new, :create, :edit, :update]"
  route "resource :password, only: [:edit, :update]"
end

def copy_templates
  directory "app", force: true
end

def add_gem(name, *options)
  gem(name, *options) unless gem_exists?(name)
end

def gem_exists?(name)
  IO.read("Gemfile") =~ /^\s*gem ['"]#{name}['"]/
end

# Main setup
add_template_repository_to_source_path
add_gems

after_bundle do
  add_users

  # Make sure Linux is in the Gemfile.lock for deploying
  run "bundle lock --add-platform x86_64-linux"

  copy_templates

  # Commit everything to git
  unless ENV["SKIP_GIT"]
    git :init
    git add: "."
    # git commit will fail if user.email is not configured
    begin
      git commit: %( -m 'Initial commit' )
    rescue StandardError => e
      puts e.message
    end
  end

  say
  say "Rails app successfully created with user model!", :blue
  say
  say "To get started with your new app:", :green
  say "  cd #{original_app_name}"
  say
  say "  # Update config/database.yml with your database credentials"
  say
  say "  rails db:create"
  say "  rails db:migrate"
  say "  bin/rails s"
end