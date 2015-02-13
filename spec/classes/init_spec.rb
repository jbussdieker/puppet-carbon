require 'spec_helper'

describe 'carbon' do
  it 'should contain stuff' do
    $stderr.puts subject.resources.to_yaml
    verify_contents(
      subject,
      "/var/lib/puppet/concat/_opt_graphite_conf_storage-schemas.conf/fragments/99_default_1min_for_1day",
      ["[default_1min_for_1day]"]
    )
  end
end
