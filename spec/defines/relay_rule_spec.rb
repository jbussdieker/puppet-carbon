require 'spec_helper'

describe 'carbon::relay_rule' do
  let(:title) { 'default' }
  let(:params) { default_params }
  let(:default_params) do
    {
      :is_default => true,
      :pattern => 'a',
      :destinations => 'b',
      :continue => false,
    }
  end

  let (:thing) { "/var/lib/puppet/concat/_opt_graphite_conf_relay-rules.conf/fragments/10_default" }

  describe 'template' do
    [
      {
        :title => 'should set default',
        :attr  => 'is_default',
        :value => 'true',
        :match => 'default = true',
      },
      {
        :title => 'should set pattern',
        :attr  => 'pattern',
        :value => 'a',
        :match => 'pattern = a',
      },
      {
        :title => 'should set destinations',
        :attr  => 'destinations',
        :value => 'b',
        :match => 'destinations = b',
      },
      {
        :title => 'should set continue',
        :attr  => 'continue',
        :value => 'true',
        :match => 'continue = true',
      },
    ].each do |param|
      context "when #{param[:attr]} is #{param[:value]}" do
        let :params do default_params.merge({ param[:attr].to_sym => param[:value] }) end

        it { should contain_file(thing).with_mode('0640') }
        it param[:title] do
          verify_contents(subject.call, thing, Array(param[:match]))
          Array(param[:notmatch]).each do |item|
            should contain_file(thing).without_content(item)
          end
        end
      end
    end
  end
end
