require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

def verify_concat(subject, title, expected_lines)
  content = subject.resource('concat::fragment', title).send(:parameters)[:content]
  (content.split("\n") & expected_lines).should == expected_lines
end

RSpec.configure do |c|
  c.default_facts = {
    :kernel          => 'Linux',
    :concat_basedir  => '/var/lib/puppet/concat',
  }
end
