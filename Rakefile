require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "exacto_subscriber"
    gem.summary = %Q{Manage Exact Target List subscribers}
    gem.description = %Q{Manage Exact Target List subscribers: more coming}
    gem.email = "dpickett@enlightsolutions.com"
    gem.homepage = "http://github.com/dpickett/exacto_subscriber"
    gem.authors = ["Dan Pickett"]
    gem.add_dependency "configatron", ">= 2.6.3"
    gem.add_dependency "nokogiri", ">= 1.4.3.1"
    gem.add_dependency "httparty", ">= 0.6.1"
    gem.add_development_dependency "rspec", ">= 1.3.0"
    gem.add_development_dependency "fakeweb", "1.2.8"
    gem.add_development_dependency "vcr", "1.0.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'reek/adapters/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "exacto #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "obscures secure information in vcr files"
task :hide_credentials_in_cassettes do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

  require "cgi"
  require "exacto_subscriber"
  configatron.exacto.configure_from_yaml(File.join(File.dirname(__FILE__), 'spec', 'exact_target_credentials.yml'))

  Dir.glob("spec/cassettes/**/*.yml").each do |f|
    contents = File.read(f)
    File.open(f, "w") do |j|
      j << contents.gsub(CGI.escape(Exacto.username), "<%= CGI.escape username %>").
        gsub(CGI.escape(Exacto.password), "<%= CGI.escape password %>").
        gsub(CGI.escape(configatron.exacto.test_list_id.to_s), "<%= CGI.escape list_id %>")
    end
  end  
end
