require 'spec_helper'
describe 'boost' do

  context 'with defaults for all parameters' do
    it { should contain_class('boost') }
  end
end
