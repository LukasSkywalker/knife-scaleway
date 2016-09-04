require 'spec_helper'

describe Chef::Knife::ScalewayServerList do
  subject { Chef::Knife::ScalewayServerList.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::ScalewayServerList.load_deps
    Chef::Config['knife']['scaleway_access_token'] = access_token
    Chef::Config['knife']['public_droplets'] = true
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('droplet') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should output the column headers' do
      VCR.use_cassette('droplet') do
        expect(subject).to receive(:puts).with(/^ID\s+Name\s+Size\s+Region\s+IPv4\s+Image\s+Status\n/)
        subject.run
      end
    end

    it 'should output a list of the available Digital Ocean Droplets' do
      VCR.use_cassette('droplet') do
        expect(subject).to receive(:puts).with(/\b2257086\b/)
        subject.run
      end
    end
  end
end
