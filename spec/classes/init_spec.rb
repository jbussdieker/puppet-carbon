require 'spec_helper'

describe 'carbon' do
  it 'should contain stuff' do
    $stderr.puts subject.call.to_yaml
    verify_contents(
      subject.call,
      "/var/lib/puppet/concat/_opt_graphite_conf_storage-schemas.conf/fragments/99_default_1min_for_1day",
      ["[default_1min_for_1day]"]
    )
  end
end
