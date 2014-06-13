#
# Cookbook Name:: jenkins
# Resources:: users
#

# Data bag user object needs an "action": "remove" tag to actually be removed by the action.
actions :create, :remove

# :data_bag is the object to search
# :search_group is the groups name to search for, defaults to resource name
attribute :username, :kind_of => String, :default => nil
attribute :id, :kind_of => String, :name_attribute => true
attribute :password, :kind_of => String, :default => nil
attribute :comment, :kind_of => String, :default => ""
attribute :email, :kind_of => String, :default => ""
