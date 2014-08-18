require 'spec_helper'

describe 'carbon::schema' do
  let(:title) { 'default' }
  let(:params) { default_params }
  let(:default_params) do
    {
      :pattern    => '^carbon\.',
      :retentions => '60:90d',
    }
  end

  let (:thing) { "/var/lib/puppet/concat/_opt_graphite_conf_storage-schemas.conf/fragments/10_default" }

  describe 'template' do
    [
      {
        :title => 'should set pattern',
        :attr  => 'pattern',
        :value => '.*',
        :match => 'pattern = .*',
      },
      {
        :title => 'should set destinations',
        :attr  => 'retentions',
        :value => '60:90d',
        :match => 'retentions = 60:90d',
      },
    ].each do |param|
      context "when #{param[:attr]} is #{param[:value]}" do
        let :params do default_params.merge({ param[:attr].to_sym => param[:value] }) end

        it { should contain_file(thing).with_mode('0640') }
        it param[:title] do
          verify_contents(subject, thing, Array(param[:match]))
          Array(param[:notmatch]).each do |item|
            should contain_file(thing).without_content(item)
          end
        end
      end
    end
  end
end
