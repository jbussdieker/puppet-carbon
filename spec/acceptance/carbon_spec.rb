require 'spec_helper_acceptance'

describe 'carbon class' do
  let(:manifest) {
    <<-EOS
      class { 'carbon':
        revision => 'master',
        caches      => {
          'a' => {
            line_receiver_interface => '0.0.0.0',
            line_receiver_port      => 2003,
          }
        },
        relays      => {
          'a' => {
            relay_method            => 'consistent-hashing',
            line_receiver_interface => '0.0.0.0',
            line_receiver_port      => 2013,
          }
        },
        aggregators => {
          'a' => {
            line_receiver_interface => '0.0.0.0',
            line_receiver_port      => 2023,
          }
        },
        schemas     => {
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
        shell("/opt/graphite/bin/carbon-cache.py --help", :acceptable_exit_codes => 0)
      end

      it 'carbon-relay.py should work' do
        shell("/opt/graphite/bin/carbon-relay.py --help", :acceptable_exit_codes => 0)
      end

      it 'carbon-aggregator.py should work' do
        shell("/opt/graphite/bin/carbon-aggregator.py --help", :acceptable_exit_codes => 0)
      end

      it 'carbon-client.py should work' do
        shell("/opt/graphite/bin/carbon-client.py --help", :acceptable_exit_codes => 0)
      end
    end
  end
end
