require 'spec_helper'

describe 'carbon::cache' do
  let(:title) { 'a' }
  let(:concat_title) { "cache_#{title}" }

  describe "concat::fragment" do
    [
      {
        :title => 'should set LOCAL_DATA_DIR = 50',
        :attr  => 'local_data_dir',
        :value => '50',
        :match => 'LOCAL_DATA_DIR = 50',
      },
      {
        :title => 'should set MAX_CACHE_SIZE = 50',
        :attr  => 'max_cache_size',
        :value => '50',
        :match => 'MAX_CACHE_SIZE = 50',
      },
      {
        :title => 'should set MAX_UPDATES_PER_SECOND = 50',
        :attr  => 'max_updates_per_second',
        :value => '50',
        :match => 'MAX_UPDATES_PER_SECOND = 50',
      },
      {
        :title => 'should set MAX_UPDATES_PER_SECOND_ON_SHUTDOWN = 50',
        :attr  => 'max_updates_per_second_on_shutdown',
        :value => '50',
        :match => 'MAX_UPDATES_PER_SECOND_ON_SHUTDOWN = 50',
      },
      {
        :title => 'should set MAX_CREATES_PER_MINUTE = 50',
        :attr  => 'max_creates_per_minute',
        :value => '50',
        :match => 'MAX_CREATES_PER_MINUTE = 50',
      },
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
        :title => 'should set ENABLE_UDP_LISTENER = 50',
        :attr  => 'enable_udp_listener',
        :value => '50',
        :match => 'ENABLE_UDP_LISTENER = 50',
      },
      {
        :title => 'should set UDP_RECEIVER_INTERFACE = 50',
        :attr  => 'udp_receiver_interface',
        :value => '50',
        :match => 'UDP_RECEIVER_INTERFACE = 50',
      },
      {
        :title => 'should set UDP_RECEIVER_PORT = 50',
        :attr  => 'udp_receiver_port',
        :value => '50',
        :match => 'UDP_RECEIVER_PORT = 50',
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
        :title => 'should set USE_INSECURE_UNPICKLER = 50',
        :attr  => 'use_insecure_unpickler',
        :value => '50',
        :match => 'USE_INSECURE_UNPICKLER = 50',
      },
      {
        :title => 'should set CACHE_QUERY_INTERFACE = 50',
        :attr  => 'cache_query_interface',
        :value => '50',
        :match => 'CACHE_QUERY_INTERFACE = 50',
      },
      {
        :title => 'should set CACHE_QUERY_PORT = 50',
        :attr  => 'cache_query_port',
        :value => '50',
        :match => 'CACHE_QUERY_PORT = 50',
      },
      {
        :title => 'should set USE_FLOW_CONTROL = 50',
        :attr  => 'use_flow_control',
        :value => '50',
        :match => 'USE_FLOW_CONTROL = 50',
      },
      {
        :title => 'should set LOG_UPDATES = 50',
        :attr  => 'log_updates',
        :value => '50',
        :match => 'LOG_UPDATES = 50',
      },
      {
        :title => 'should set LOG_CACHE_HITS = 50',
        :attr  => 'log_cache_hits',
        :value => '50',
        :match => 'LOG_CACHE_HITS = 50',
      },
      {
        :title => 'should set WHISPER_AUTOFLUSH = 50',
        :attr  => 'whisper_autoflush',
        :value => '50',
        :match => 'WHISPER_AUTOFLUSH = 50',
      },
      {
        :title => 'should set WHISPER_SPARSE_CREATE = 50',
        :attr  => 'whisper_sparse_create',
        :value => '50',
        :match => 'WHISPER_SPARSE_CREATE = 50',
      },
      {
        :title => 'should set WHISPER_FALLOCATE_CREATE = 50',
        :attr  => 'whisper_fallocate_create',
        :value => '50',
        :match => 'WHISPER_FALLOCATE_CREATE = 50',
      },
      {
        :title => 'should set WHISPER_LOCK_WRITES = 50',
        :attr  => 'whisper_lock_writes',
        :value => '50',
        :match => 'WHISPER_LOCK_WRITES = 50',
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
        :title => 'should set ENABLE_AMQP = 50',
        :attr  => 'enable_amqp',
        :value => '50',
        :match => 'ENABLE_AMQP = 50',
      },
      {
        :title => 'should set AMQP_VERBOSE = 50',
        :attr  => 'amqp_verbose',
        :value => '50',
        :match => 'AMQP_VERBOSE = 50',
      },
      {
        :title => 'should set AMQP_HOST = 50',
        :attr  => 'amqp_host',
        :value => '50',
        :match => 'AMQP_HOST = 50',
      },
      {
        :title => 'should set AMQP_PORT = 50',
        :attr  => 'amqp_port',
        :value => '50',
        :match => 'AMQP_PORT = 50',
      },
      {
        :title => 'should set AMQP_VHOST = 50',
        :attr  => 'amqp_vhost',
        :value => '50',
        :match => 'AMQP_VHOST = 50',
      },
      {
        :title => 'should set AMQP_USER = 50',
        :attr  => 'amqp_user',
        :value => '50',
        :match => 'AMQP_USER = 50',
      },
      {
        :title => 'should set AMQP_PASSWORD = 50',
        :attr  => 'amqp_password',
        :value => '50',
        :match => 'AMQP_PASSWORD = 50',
      },
      {
        :title => 'should set AMQP_EXCHANGE = 50',
        :attr  => 'amqp_exchange',
        :value => '50',
        :match => 'AMQP_EXCHANGE = 50',
      },
      {
        :title => 'should set AMQP_METRIC_NAME_IN_BODY = 50',
        :attr  => 'amqp_metric_name_in_body',
        :value => '50',
        :match => 'AMQP_METRIC_NAME_IN_BODY = 50',
      },
      {
        :title => 'should set ENABLE_MANHOLE = 50',
        :attr  => 'enable_manhole',
        :value => '50',
        :match => 'ENABLE_MANHOLE = 50',
      },
      {
        :title => 'should set MANHOLE_INTERFACE = 50',
        :attr  => 'manhole_interface',
        :value => '50',
        :match => 'MANHOLE_INTERFACE = 50',
      },
      {
        :title => 'should set MANHOLE_PORT = 50',
        :attr  => 'manhole_port',
        :value => '50',
        :match => 'MANHOLE_PORT = 50',
      },
      {
        :title => 'should set MANHOLE_USER = 50',
        :attr  => 'manhole_user',
        :value => '50',
        :match => 'MANHOLE_USER = 50',
      },
      {
        :title => 'should set MANHOLE_PUBLIC_KEY = 50',
        :attr  => 'manhole_public_key',
        :value => '50',
        :match => 'MANHOLE_PUBLIC_KEY = 50',
      },
      {
        :title => 'should set BIND_PATTERNS = 50',
        :attr  => 'bind_patterns',
        :value => '50',
        :match => 'BIND_PATTERNS = 50',
      },
    ].each do |param|
      context "when #{param[:attr]} is #{param[:value]}" do
        let(:params) do
          if param[:attr] == 'title'
            {}
          else
            { param[:attr].to_sym => param[:value] } 
          end
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

  it { should contain_file("/etc/init.d/carbon-cache-#{title}") }
  it { should contain_service("carbon-cache-#{title}") }
end
