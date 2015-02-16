require 'spec_helper'

describe 'carbon::relay_rule' do
  let(:title) { 'collectd' }
  let(:pattern) { 'collectd\.' }
  let(:destinations) { '127.0.0.1:2004:a, 127.0.0.1:2104:b' }
  let(:params) { default_params }
  let(:default_params) do
    {
      :destinations => destinations,
    }
  end

  [
    {
      :title => 'should set title',
      :attr  => 'title',
      :value => 'foo',
      :match => '[foo]',
    },
    {
      :title    => 'should exclude default if pattern is set',
      :attr     => 'pattern',
      :value    => 'a',
      :notmatch => 'default = true',
    },
    {
      :title => "should set default when pattern isn't specified",
      :attr  => 'title',
      :value => 'foo',
      :match => 'default = true',
    },
    {
      :title => 'should set pattern',
      :attr  => 'pattern',
      :value => 'a',
      :match => 'pattern = a',
    },
    {
      :title => 'should set destinations',
      :attr  => 'destinations',
      :value => 'b',
      :match => 'destinations = b',
    },
    {
      :title => 'should set continue',
      :attr  => 'continue',
      :value => 'true',
      :match => 'continue = true',
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

      it param[:title] do
        Array(param[:match]).each do |item|
          fragment_content.should match(item)
        end

        Array(param[:notmatch]).each do |item|
          fragment_content.should_not match(item)
        end
      end

      it { should contain_concat__fragment(title) }
    end
  end
end
