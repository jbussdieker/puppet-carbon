require 'spec_helper'

describe 'carbon::aggregator' do
  let(:title) { 'a' }
  let(:thing) { "/var/lib/puppet/concat/_opt_graphite_conf_carbon.conf/fragments/30_aggregator_#{title}" }

  describe "carbon.conf template content" do
    [
      {
        :title => 'should set line_receiver_interface',
        :attr  => 'line_receiver_interface',
        :value => '0.0.0.0',
        :match => 'LINE_RECEIVER_INTERFACE = 0.0.0.0',
      },
      {
        :title => 'should set line_receiver_port',
        :attr  => 'line_receiver_port',
        :value => '2004',
        :match => 'LINE_RECEIVER_PORT = 2004',
      },
    ].each do |param|
      context "when #{param[:attr]} is #{param[:value]}" do
        let :params do { param[:attr].to_sym => param[:value] } end

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

  it { should contain_file("/etc/init/carbon-aggregator-#{title}.conf") }
  it { should contain_service("carbon-aggregator-#{title}") }
end
