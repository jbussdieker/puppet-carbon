require 'spec_helper'

describe 'carbon::aggregation_rule' do
  let(:title) { 'default' }
  let(:params) { default_params }
  let(:concat_title) { "carbon_aggregation_rule_#{title}" }
  let(:default_params) do
    {
      :output_template => '<env>.applications.<app>.all.requests',
      :frequency       => '60',
      :method          => 'sum',
      :input_pattern   => '<env>.applications.<app>.*.requests',
    }
  end

  [
    {
      :title => 'should set output_template',
      :attr  => 'output_template',
      :value => 'a',
      :match => 'a',
    },
    {
      :title => 'should set frequency',
      :attr  => 'frequency',
      :value => 'b',
      :match => '\(b\)',
    },
    {
      :title => 'should set method',
      :attr  => 'method',
      :value => 'c',
      :match => 'c',
    },
    {
      :title => 'should set input_pattern',
      :attr  => 'input_pattern',
      :value => 'd',
      :match => 'd',
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
end
