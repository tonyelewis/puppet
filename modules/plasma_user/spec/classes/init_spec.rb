require 'spec_helper'
describe 'plasma_user' do

  context 'with defaults for all parameters' do
    it { should contain_class('plasma_user') }
  end
end
