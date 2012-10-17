namespace :app do
	desc "initialize database"
	task :init => "db:load_config" do
		[ "db:create", "db:migrate", "db:seed", "db:test:prepare" ].each do |x|
			Rake::Task[ x ].invoke
		end
	end
end
