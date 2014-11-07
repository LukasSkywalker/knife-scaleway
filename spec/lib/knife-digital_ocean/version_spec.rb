require 'spec_helper'

describe Knife::DigitalOcean do
  it 'should have a VERSION defined' do
    expect(described_class::VERSION).not_to be_empty
  end
end
