module Ambition
  module Source
    def self.api_methods
      Ambition::API.instance_methods(false).reject do |method|
        method =~ /ambition|context/
      end
    end

    def self.included(base)
      singleton = (class << base; self end)
      api_methods.each do |method|
        ##
        # This is less than cool, but we do it to get what we want.
        # When define_method can create a method which is block-aware,
        # then we can move to pure Ruby.
        singleton.class_eval <<-end_eval
          def #{method}(*args, &block)
            return super unless @ambition_source
            @ambition_source.#{method}(*args, &block)
          end
        end_eval
      end
    end
  end

  module API
    attr_reader :ambition_source

    ##
    # This is a destructive method.  When given an array,
    # all Enumerable operations will be performed on the array
    # rather than on the database.
    #
    #   User.ambition_source = users(:chris, :pj) 
    #   User.select { |u| u.age > 30 }
    #
    # You don't have to use fixtures, of course.  Make stuff up on the fly.
    #
    #   users = [ User.new(:name => 'chris', :age => 11), User.new(:name => 'pj', :age => 100) ]
    #   User.ambition_source = users
    #   User.select { |u| u.age > 30 }
    #
    # Revert back to normal by setting ambition_source to nil.
    #
    #   User.ambition_source = nil
    #   User.select { |u| u.age > 30 }
    #
    def ambition_source=(records)
      @ambition_source = records
      include Source unless ancestors.include? Source
    end
  end
end
