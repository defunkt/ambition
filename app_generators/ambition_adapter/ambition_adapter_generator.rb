class AmbitionAdapterGenerator < RubiGen::Base
#  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
#  default_options :author => nil

  attr_reader :adapter_name, :adapter_module
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    base_name         = self.base_name.sub(/ambitious(-|_)/,'')
    @adapter_name     = base_name
    @adapter_module   = base_name.split('_').map { |part| part[0] = part[0...1].upcase; part }.join
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory ''
      dirs = %W(
        lib/ambition/adapters/#{adapter_name}
        test
      )
      dirs.each { |path| m.directory path }

      ##
      # Translator / Query stubs
      adapter_path = "lib/ambition/adapters/#{adapter_name}"

      %w( base query select slice sort ).each do |file|
        m.template "lib/adapter/#{file}.rb.erb", "#{adapter_path}/#{file}.rb"
      end

      m.template 'lib/init.rb.erb', "#{adapter_path}.rb"

      ##
      # Test stubs
      Dir[File.dirname(__FILE__) + '/templates/test/*.rb.erb'].each do |file|
        file = File.basename(file, '.*')
        m.template "test/#{file}.erb", "test/#{file}"
      end

      ##
      # Normal files
      files = %w( LICENSE README Rakefile )
      files.each do |file|
        m.template file, file
      end
    end
  end

protected
  def banner
    "Usage: ambition_adapter adapter_name"
  end

  def add_options!(opts)
    opts.separator ''
    opts.separator 'Options:'
    opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    opts.separator ''
  end
  
  def extract_options; end
end
