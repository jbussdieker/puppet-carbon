require 'spec_helper'

describe 'carbon::relay' do
  let(:title) { 'a' }
  let(:thing) { "/var/lib/puppet/concat/_opt_graphite_conf_carbon.conf/fragments/20_relay_#{title}" }

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
        :value => '2013',
        :match => 'LINE_RECEIVER_PORT = 2013',
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
        :value => '2014',
        :match => 'PICKLE_RECEIVER_PORT = 2014',
      },
      {
        :title => 'should set relay_method',
        :attr  => 'relay_method',
        :value => 'rules',
        :match => 'RELAY_METHOD = rules',
      },
      {
        :title => 'should set replication_factor',
        :attr  => 'replication_factor',
        :value => '1',
        :match => 'REPLICATION_FACTOR = 1',
      },
      {
        :title => 'should set destinations',
        :attr  => 'destinations',
        :value => '127.0.0.1:2004',
        :match => 'DESTINATIONS = 127.0.0.1:2004',
      },
      {
        :title => 'should set max_queue_size',
        :attr  => 'max_queue_size',
        :value => '10000',
        :match => 'MAX_QUEUE_SIZE = 10000',
      },
      {
        :title => 'should set max_datapoints_per_message',
        :attr  => 'max_datapoints_per_message',
        :value => '500',
        :match => 'MAX_DATAPOINTS_PER_MESSAGE = 500',
      },
      {
        :title => 'should set queue_low_watermark_pct',
        :attr  => 'queue_low_watermark_pct',
        :value => '0.8',
        :match => 'QUEUE_LOW_WATERMARK_PCT = 0.8',
      },
      {
        :title => 'should set time_to_defer_sending',
        :attr  => 'time_to_defer_sending',
        :value => '0.0001',
        :match => 'TIME_TO_DEFER_SENDING = 0.0001',
      },
      {
        :title => 'should set use_flow_control',
        :attr  => 'use_flow_control',
        :value => true,
        :match => 'USE_FLOW_CONTROL = True',
      },
      {
        :title => 'should set use_whitelist',
        :attr  => 'use_whitelist',
        :value => false,
        :match => 'USE_WHITELIST = False',
      },
      {
        :title => 'should set carbon_metric_prefix',
        :attr  => 'carbon_metric_prefix',
        :value => 'carbon',
        :match => 'CARBON_METRIC_PREFIX = carbon',
      },
      {
        :title => 'should set carbon_metric_interval',
        :attr  => 'carbon_metric_interval',
        :value => '60',
        :match => 'CARBON_METRIC_INTERVAL = 60',
      },
      {
        :title => 'should set log_listener_conn_success',
        :attr  => 'log_listener_conn_success',
        :value => true,
        :match => 'LOG_LISTENER_CONN_SUCCESS = True',
      },
      {
        :title => 'should set use_ratio_reset',
        :attr  => 'use_ratio_reset',
        :value => false,
        :match => 'USE_RATIO_RESET = False',
      },
      {
        :title => 'should set min_reset_stat_flow',
        :attr  => 'min_reset_stat_flow',
        :value => '1000',
        :match => 'MIN_RESET_STAT_FLOW = 1000',
      },
      {
        :title => 'should set min_reset_ratio',
        :attr  => 'min_reset_ratio',
        :value => '0.9',
        :match => 'MIN_RESET_RATIO = 0.9',
      },
      {
        :title => 'should set min_reset_interval',
        :attr  => 'min_reset_interval',
        :value => '121',
        :match => 'MIN_RESET_INTERVAL = 121',
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

  it { should contain_file("/etc/init/carbon-relay-#{title}.conf") }
  it { should contain_service("carbon-relay-#{title}") }
end
