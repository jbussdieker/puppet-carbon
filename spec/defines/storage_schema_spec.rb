require 'spec_helper'

describe 'carbon::storage_schema' do
  let(:title) { 'default' }
  let(:pattern) { '^carbon\.' }
  let(:retentions) { '60:90d' }
  let(:order) { (rand * 100).to_i }
  let(:params) { default_params }
  let(:concat_title) { "carbon_storage_schema_#{title}" }
  let(:default_params) {
    {
      :pattern    => pattern,
      :retentions => retentions,
      :order      => order,
    }
  }

  [
    {
      :title => 'should set title',
      :attr  => 'title',
      :value => 'foo',
      :match => '[foo]',
    },
    {
      :title => 'should set pattern',
      :attr  => 'pattern',
      :value => '.*',
      :match => 'pattern = .*',
    },
    {
      :title => 'should set destinations',
      :attr  => 'retentions',
      :value => '10:1d',
      :match => 'retentions = 10:1d',
    },
  ].each do |param|
    context "when #{param[:attr]} is #{param[:value]}" do
      let(:params) do
        if param[:attr] != 'title'
          default_params.merge({ param[:attr].to_sym => param[:value] })
        else
          default_params
        end
      end

      if param[:attr] == 'title'
        let(:title) { param[:value] }
      end

      let(:fragment_content) { param_value(subject.call, 'concat::fragment', concat_title, :content) }

      it { should contain_concat__fragment(concat_title) }

      it param[:title] do
        Array(param[:match]).each do |item|
          fragment_content.should match(item)
        end

        Array(param[:notmatch]).each do |item|
          fragment_content.should_not match(item)
        end
      end
    end
  end

  context 'target' do
    let(:target) { param_value(subject.call, 'concat::fragment', concat_title, :target) }

    it 'should be /opt/graphite/conf/storage-schemas.conf' do
      target.should eql('/opt/graphite/conf/storage-schemas.conf')
    end
  end
end
