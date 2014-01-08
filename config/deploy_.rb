require 'bundler/capistrano'
require 'rvm/capistrano'
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))


set :user, "root"
#set :use_sudo, 'true'
set :password, "*PASSWORD*"
set :application, "killer_fizteh"

set :rvm_ruby, "ruby-2.0.0-p247"
set :rvm_ruby_string, "ruby-2.0.0-p247@killer_fizteh"
set :rvm_gem_home, "/usr/local/rvm/gems/#{fetch(:rvm_ruby_string)}"

=begin
set :rvm_ruby_string, 'ruby-2.0.0-p247@dvr'
set :rvm_ruby_path, "/usr/local/rvm/rubies/#{fetch(:rvm_ruby)}"
set :default_environment, {
		'RUBY_VERSION' => fetch(:rvm_ruby),
		'GEM_HOME' => "#{fetch(:rvm_gem_home)}:#{fetch(:rvm_gem_home)}@global",
		'BUNDLE_PATH' => fetch(:rvm_gem_home),
		'PATH' => "#{fetch(:rvm_gem_home)}/bin:#{fetch(:rvm_gem_home)}@global/bin:#{fetch(:rvm_ruby_path)}/bin:/home/rails/.rvm/bin;",
}
=end


#set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_type, :system  # Copy the exact line. I really mean :system here*

set :scm, :none
set :repository, '.'
set :deploy_via, :copy

set :copy_exclude, ['public/system/*', '.git/']

set :rails_env, 'production'


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server '46.38.63.5', :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
#
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
	task :start do ; end
	task :stop do ; end
	task :restart, :roles => :app, :except => { :no_release => true } do
		run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
	  run "chmod -R 755 #{current_path}"
		fix_file_permissions
		change_phusion_user
	end
end

set :deploy_to, "/var/sites/killer_fizteh/"

desc "Fix file permissions"
task :fix_file_permissions, :roles => [ :app, :db, :web ] do
	run "#{try_sudo} chown -R killer_fizteh:www-data #{current_path}/"
end



desc "Change the user in whose name the application (Phusion process) will be run"
# this is determined by the owner of environment.rb... (see: http://www.modrails.com/documentation/Users%20guide%20Apache.html#user_switching)
task :change_phusion_user do
	run "#{try_sudo} chown www-data:www-data #{current_release}/config/environment.rb"
end


