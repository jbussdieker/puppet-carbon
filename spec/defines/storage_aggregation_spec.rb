require 'spec_helper'

describe 'carbon::storage_aggregation' do
  let(:title) { 'default' }
  let(:pattern) { '^carbon\.' }
  let(:x_files_factor) { 0.1 }
  let(:aggregation_method) { 'sum' }
  let(:order) { (rand * 100).to_i }
  let(:params) { default_params }
  let(:default_params) {
    {
      :pattern            => pattern,
      :order              => order,
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
      :title    => 'should exclude xFilesFactor if not set',
      :attr     => 'title',
      :value    => 'foo',
      :notmatch => 'xFilesFactor',
    },
    {
      :title => 'should set xFilesFactor',
      :attr  => 'x_files_factor',
      :value => '0.1',
      :match => 'xFilesFactor = 0.1',
    },
    {
      :title    => 'should exclude aggregationMethod if not set',
      :attr     => 'title',
      :value    => 'foo',
      :notmatch => 'aggregationMethod',
    },
    {
      :title => 'should set aggregationMethod',
      :attr  => 'aggregation_method',
      :value => 'sum',
      :match => 'aggregationMethod = sum',
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

      let(:fragment_content) { param_value(subject.call, 'concat::fragment', title, :content) }

      it { should contain_concat__fragment(title) }

      it param[:title] do
        verify_concat(subject.call, title, Array(param[:match]))

        Array(param[:notmatch]).each do |item|
          fragment_content.should_not match(item)
        end
      end
    end
  end
end
