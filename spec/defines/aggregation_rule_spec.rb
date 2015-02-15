require 'spec_helper'

describe 'carbon::aggregation_rule' do
  let(:title) { 'default' }
  let(:params) { default_params }
  let(:default_params) do
    {
      :output_template => 'a',
      :frequency       => 'b',
      :method          => 'c',
      :input_pattern   => 'd',
    }
  end

  let (:thing) { "/var/lib/puppet/concat/_opt_graphite_conf_aggregation-rules.conf/fragments/10_default" }

  describe 'template' do
    [
      {
        :title => 'should set output_template',
        :attr  => 'output_template',
        :value => 'a',
        :match => 'a (b) = c d',
      },
      {
        :title => 'should set frequency',
        :attr  => 'frequency',
        :value => 'b',
        :match => 'a (b) = c d',
      },
      {
        :title => 'should set method',
        :attr  => 'method',
        :value => 'c',
        :match => 'a (b) = c d',
      },
      {
        :title => 'should set input_pattern',
        :attr  => 'input_pattern',
        :value => 'd',
        :match => 'a (b) = c d',
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
