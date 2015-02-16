require 'spec_helper'

describe 'carbon::aggregator' do
  let(:title) { 'a' }
  let(:concat_title) { "aggregator_#{title}" }

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
      {
        :title => 'should set pickle_receiver_interface',
        :attr  => 'pickle_receiver_interface',
        :value => '0.0.0.0',
        :match => 'PICKLE_RECEIVER_INTERFACE = 0.0.0.0',
      },
      {
        :title => 'should set pickle_receiver_port',
        :attr  => 'pickle_receiver_port',
        :value => '2024',
        :match => 'PICKLE_RECEIVER_PORT = 2024',
      },
    ].each do |param|
      context "when #{param[:attr]} is #{param[:value]}" do
        let(:params) do
          { param[:attr].to_sym => param[:value] }
        end

        if param[:attr] == 'title'
          let(:title) { param[:value] }
        end

        let(:fragment_content) { param_value(subject.call, 'concat::fragment', concat_title, :content) }

        it param[:title] do
          Array(param[:match]).each do |item|
            fragment_content.should match(item)
          end

          Array(param[:notmatch]).each do |item|
            fragment_content.should_not match(item)
          end
        end

        it { should contain_concat__fragment(concat_title) }
      end
    end
  end

  it { should contain_file("/etc/init/carbon-aggregator-#{title}.conf") }
  it { should contain_service("carbon-aggregator-#{title}") }
end
