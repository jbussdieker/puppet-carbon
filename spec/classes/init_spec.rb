require 'spec_helper'

describe 'carbon' do
  #it 'prints the catalog' do
  #  $stderr.puts subject.call.to_yaml
  #end

  it 'sets default schemas' do
    verify_contents(
      subject.call,
      "/var/lib/puppet/concat/_opt_graphite_conf_storage-schemas.conf/fragments/99_default_1min_for_1day",
      ["[default_1min_for_1day]"]
    )
  end
end
