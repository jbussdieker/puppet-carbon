require 'spec_helper'

describe 'carbon::relay' do
  let(:title) { 'a' }
  let(:concat_title) { "carbon_relay_#{title}" }

  describe "carbon.conf template content" do
    [
      {
        :title => 'should set LINE_RECEIVER_INTERFACE = 50',
        :attr  => 'line_receiver_interface',
        :value => '50',
        :match => 'LINE_RECEIVER_INTERFACE = 50',
      },
      {
        :title => 'should set LINE_RECEIVER_PORT = 50',
        :attr  => 'line_receiver_port',
        :value => '50',
        :match => 'LINE_RECEIVER_PORT = 50',
      },
      {
        :title => 'should set PICKLE_RECEIVER_INTERFACE = 50',
        :attr  => 'pickle_receiver_interface',
        :value => '50',
        :match => 'PICKLE_RECEIVER_INTERFACE = 50',
      },
      {
        :title => 'should set PICKLE_RECEIVER_PORT = 50',
        :attr  => 'pickle_receiver_port',
        :value => '50',
        :match => 'PICKLE_RECEIVER_PORT = 50',
      },
      {
        :title => 'should set RELAY_METHOD = 50',
        :attr  => 'relay_method',
        :value => '50',
        :match => 'RELAY_METHOD = 50',
      },
      {
        :title => 'should set REPLICATION_FACTOR = 50',
        :attr  => 'replication_factor',
        :value => '50',
        :match => 'REPLICATION_FACTOR = 50',
      },
      {
        :title => 'should set DESTINATIONS = 50',
        :attr  => 'destinations',
        :value => '50',
        :match => 'DESTINATIONS = 50',
      },
      {
        :title => 'should set MAX_QUEUE_SIZE = 50',
        :attr  => 'max_queue_size',
        :value => '50',
        :match => 'MAX_QUEUE_SIZE = 50',
      },
      {
        :title => 'should set MAX_DATAPOINTS_PER_MESSAGE = 50',
        :attr  => 'max_datapoints_per_message',
        :value => '50',
        :match => 'MAX_DATAPOINTS_PER_MESSAGE = 50',
      },
      {
        :title => 'should set QUEUE_LOW_WATERMARK_PCT = 50',
        :attr  => 'queue_low_watermark_pct',
        :value => '50',
        :match => 'QUEUE_LOW_WATERMARK_PCT = 50',
      },
      {
        :title => 'should set TIME_TO_DEFER_SENDING = 50',
        :attr  => 'time_to_defer_sending',
        :value => '50',
        :match => 'TIME_TO_DEFER_SENDING = 50',
      },
      {
        :title => 'should set USE_FLOW_CONTROL = 50',
        :attr  => 'use_flow_control',
        :value => '50',
        :match => 'USE_FLOW_CONTROL = 50',
      },
      {
        :title => 'should set USE_WHITELIST = 50',
        :attr  => 'use_whitelist',
        :value => '50',
        :match => 'USE_WHITELIST = 50',
      },
      {
        :title => 'should set CARBON_METRIC_PREFIX = 50',
        :attr  => 'carbon_metric_prefix',
        :value => '50',
        :match => 'CARBON_METRIC_PREFIX = 50',
      },
      {
        :title => 'should set CARBON_METRIC_INTERVAL = 50',
        :attr  => 'carbon_metric_interval',
        :value => '50',
        :match => 'CARBON_METRIC_INTERVAL = 50',
      },
      {
        :title => 'should set LOG_LISTENER_CONN_SUCCESS = 50',
        :attr  => 'log_listener_conn_success',
        :value => '50',
        :match => 'LOG_LISTENER_CONN_SUCCESS = 50',
      },
      {
        :title => 'should set USE_RATIO_RESET = 50',
        :attr  => 'use_ratio_reset',
        :value => '50',
        :match => 'USE_RATIO_RESET = 50',
      },
      {
        :title => 'should set MIN_RESET_STAT_FLOW = 50',
        :attr  => 'min_reset_stat_flow',
        :value => '50',
        :match => 'MIN_RESET_STAT_FLOW = 50',
      },
      {
        :title => 'should set MIN_RESET_RATIO = 50',
        :attr  => 'min_reset_ratio',
        :value => '50',
        :match => 'MIN_RESET_RATIO = 50',
      },
      {
        :title => 'should set MIN_RESET_INTERVAL = 50',
        :attr  => 'min_reset_interval',
        :value => '50',
        :match => 'MIN_RESET_INTERVAL = 50',
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

  it { should contain_file("/etc/init.d/carbon-relay-#{title}") }
  it { should contain_service("carbon-relay-#{title}") }
end
