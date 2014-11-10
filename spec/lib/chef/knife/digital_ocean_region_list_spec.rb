require 'spec_helper'

describe Chef::Knife::DigitalOceanRegionList do

  subject do
    s = Chef::Knife::DigitalOceanRegionList.new
    s
  end

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::DigitalOceanRegionList.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
  end

  describe "#run" do
    it "should validate the Digital Ocean config keys exist" do
      VCR.use_cassette('region') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it "should output the column headers" do
      VCR.use_cassette('region') do
        expect(subject).to receive(:puts).with(/^Name\s+Slug\n/)
        subject.run
      end
    end

    it "should output a list of the available Digital Ocean flavors" do
      VCR.use_cassette('region') do
        expect(subject).to receive(:puts).with(/\bNew York 1\b/)
        subject.run
      end
    end
  end
end
