require 'spec_helper_acceptance'

describe 'carbon class' do
  let(:prefix) { "/opt/foo" }
  let(:manifest) {
    <<-EOS
      class { 'whisper':
        ensure => present,
      }

      user { 'carbon':
        ensure => present,
      }
      ->
      class { 'carbon':
        revision => 'master',
        prefix   => '#{prefix}',
        user     => 'carbon',
        caches      => {
          'default' => {
            local_data_dir => '/tmp/carbondata',
          },
          'a' => {
            line_receiver_port   => 2003,
            pickle_receiver_port => 2004,
            cache_query_port     => 7002,
          },
          'b' => {
            line_receiver_port   => 2103,
            pickle_receiver_port => 2104,
            cache_query_port     => 7102,
          }
        },
        relays      => {
          'default' => {
            relay_method => 'consistent-hashing',
          },
          'a' => {
            line_receiver_port   => 2013,
            pickle_receiver_port => 2014,
          },
          'b' => {
            line_receiver_port   => 2113,
            pickle_receiver_port => 2114,
          }
        },
        aggregators => {
          'default' => {
            max_queue_size => 'inf',
          },
          'a' => {
            line_receiver_port   => 2023,
            pickle_receiver_port => 2024,
          },
          'b' => {
            line_receiver_port   => 2123,
            pickle_receiver_port => 2124,
          }
        },
        storage_schemas => {
          'carbon' => {
            pattern    => '^carbon\.',
            retentions => '60:90d',
            order      => 1,
          },
          'default_1min_for_1day' => {
            pattern    => '.*',
            retentions => '60s:1d',
            order      => 99,
          },
        },
        storage_aggregations => {
          'carbon_agg_test' => {
            pattern            => '^carbon\.',
            x_files_factor     => '0.7',
            aggregation_method => 'sum',
          },
        },
        aggregation_rules => {
          'rollups' => {
            output_template => 'foo.*',
            frequency       => '60',
            method          => 'sum',
            input_pattern   => 'bar.*',
          }
        },
        relay_rules => {
          'test1' => {
            pattern      => 'test1.*',
            destinations => '127.0.0.1:2004',
            continue     => true,
            order        => 1,
          },
          'default' => {
            destinations => '127.0.0.1:2004',
            continue     => false,
            order        => 99,
          },
        },
      }
    EOS
  }

  describe 'running puppet code' do
    it 'should work with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(manifest, :catch_failures => true)
      expect(apply_manifest(manifest, :catch_changes => true).exit_code).to be_zero
    end

    describe 'command line tools' do
      before do
        apply_manifest(manifest, :catch_failures => true)
        apply_manifest(manifest, :catch_changes => true)
      end

      it 'carbon-cache.py should work' do
        shell("#{prefix}/bin/carbon-cache.py --help", :acceptable_exit_codes => 0)
      end

      it 'carbon-relay.py should work' do
        shell("#{prefix}/bin/carbon-relay.py --help", :acceptable_exit_codes => 0)
      end

      it 'carbon-aggregator.py should work' do
        shell("#{prefix}/bin/carbon-aggregator.py --help", :acceptable_exit_codes => 0)
      end

      it 'carbon-client.py should work' do
        shell("#{prefix}/bin/carbon-client.py --help", :acceptable_exit_codes => 0)
      end
    end
  end
end
