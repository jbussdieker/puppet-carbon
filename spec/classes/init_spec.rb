require 'spec_helper'

describe 'carbon' do
  let(:prefix) { "/opt/graphite" }
  let(:params) {
    {
      :prefix => prefix,
    }
  }

  it { should compile }

  it { should contain_concat("#{prefix}/conf/carbon.conf").with(:force => true) }
  it { should contain_concat("#{prefix}/conf/storage-schemas.conf").with(:force => true) }
  it { should contain_concat("#{prefix}/conf/storage-aggregation.conf").with(:force => true) }
  it { should contain_concat("#{prefix}/conf/aggregation-rules.conf").with(:force => true) }
  it { should contain_concat("#{prefix}/conf/relay-rules.conf").with(:force => true) }

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
