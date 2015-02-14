require 'spec_helper_acceptance'

describe 'carbon class' do
  let(:manifest) {
    <<-EOS
      class { 'carbon':
        revision => 'master'
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
