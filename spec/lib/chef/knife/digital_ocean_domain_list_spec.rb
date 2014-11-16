require 'spec_helper'

describe Chef::Knife::DigitalOceanDomainList do

  subject { Chef::Knife::DigitalOceanDomainList.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::DigitalOceanDomainList.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('domain_list') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should output the column headers' do
      VCR.use_cassette('domain_list') do
        expect(subject).to receive(:puts).with(/^Name\s+TTL/)
        subject.run
      end
    end

    it 'should output a list of the available Digital Ocean domains' do
      VCR.use_cassette('domain_list') do
        expect(subject).to receive(:puts).with(/\bgregf.org\s+1800\n/)
        subject.run
      end
    end
  end
end
