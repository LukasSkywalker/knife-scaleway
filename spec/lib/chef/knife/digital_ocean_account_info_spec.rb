require 'spec_helper'

describe Chef::Knife::DigitalOceanAccountInfo do

  subject { Chef::Knife::DigitalOceanAccountInfo.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::DigitalOceanAccountInfo.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
  end

  describe "#run" do
    it "should validate the Digital Ocean config keys exist" do
      VCR.use_cassette('accountinfo') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it "should output the column headers" do
      VCR.use_cassette('accountinfo') do
        expect(subject).to receive(:puts).with(/^UUID\s+Email\s+Droplet Limit\s+Email Verified\n/)
        subject.run
      end
    end

    it "should output a list of the available Digital Ocean account info" do
      VCR.use_cassette('accountinfo') do
        expect(subject).to receive(:puts).with(/\b49e2e737d3a7407a042bb7e88f4da8629166f2b9\s+greg@gregf.org\s+20\s+true\s+\n/)
        subject.run
      end
    end
  end
end
