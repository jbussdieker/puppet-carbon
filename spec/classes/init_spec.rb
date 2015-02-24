require 'spec_helper'

describe 'carbon' do
  let(:facts) do
    {
      :operatingsystem => operatingsystem,
      :operatingsystemmajrelease => operatingsystemmajrelease
    }
  end
  let(:params) {
    {
      :prefix => prefix,
    }
  }

  let(:operatingsystem) { 'Ubuntu' }
  let(:operatingsystemmajrelease) { '12.04' }

  let(:prefix) { "/foo/bar" }

  it { should compile }

  it { should contain_concat("#{prefix}/conf/carbon.conf").with(:force => true) }
  it { should contain_concat("#{prefix}/conf/storage-schemas.conf").with(:force => true) }
  it { should contain_concat("#{prefix}/conf/storage-aggregation.conf").with(:force => true) }
  it { should contain_concat("#{prefix}/conf/aggregation-rules.conf").with(:force => true) }
  it { should contain_concat("#{prefix}/conf/relay-rules.conf").with(:force => true) }

  #it 'prints the catalog' do
  #  $stderr.puts subject.call.to_yaml
  #end

  context 'CentOS' do
    let(:operatingsystem) { 'CentOS' }
    it { should contain_package('python-twisted-core') }
  end

  context 'Debian' do
    let(:operatingsystem) { 'Debian' }
    it { should contain_package('python-twisted') }
  end

  context 'Ubuntu' do
    let(:operatingsystem) { 'Ubuntu' }
    it { should contain_package('python-twisted') }
  end

  it 'sets default schemas' do
    default_schema = param_value(subject.call, 'concat::fragment', 'default_1min_for_1day', :content)
    default_schema.should match("[default_1min_for_1day]")
  end
end
