require 'spec_helper'

describe Knife::DigitalOcean do
  it 'should have a VERSION defined' do
    described_class::VERSION.should_not be_empty
  end
end

