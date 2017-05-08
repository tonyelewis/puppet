require 'spec_helper'
describe 'eclipse_user' do

  context 'with defaults for all parameters' do
    it { should contain_class('eclipse_user') }
  end
end
