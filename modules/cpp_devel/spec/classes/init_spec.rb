require 'spec_helper'
describe 'cpp_devel' do

  context 'with defaults for all parameters' do
    it { should contain_class('cpp_devel') }
  end
end
