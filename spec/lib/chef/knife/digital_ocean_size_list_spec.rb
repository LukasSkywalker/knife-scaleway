require 'spec_helper'

describe Chef::Knife::DigitalOceanSizeList do

  subject do
    s = Chef::Knife::DigitalOceanSizeList.new
    s
  end

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::DigitalOceanSizeList.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('sizes') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should output the column headers' do
      VCR.use_cassette('sizes') do
        expect(subject).to receive(:puts).with(/^Slug \n/)
        subject.run
      end
    end

    it 'should output a list of the available Digital Ocean sizes' do
      VCR.use_cassette('sizes') do
        expect(subject).to receive(:puts).with(/\b512mb\b/)
        subject.run
      end
    end
  end
end
