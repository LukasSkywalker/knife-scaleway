require 'spec_helper'

describe Chef::Knife::DigitalOceanDomainRecordList do

  subject { Chef::Knife::DigitalOceanDomainRecordList.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::DigitalOceanDomainRecordList.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
    subject.config[:name] = 'kitchen-digital.org'
  end

  describe "#run" do
    it "should validate the Digital Ocean config keys exist" do
      VCR.use_cassette('domain_record_list') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it "should output the column headers" do
      VCR.use_cassette('domain_record_list') do
        expect(subject).to receive(:puts).with(/^ID\s+Type\s+Name\s+Data/)
        subject.run
      end
    end

    it "should output a list of the available Digital Ocean domains" do
      VCR.use_cassette('domain_record_list') do
        expect(subject).to receive(:puts).with(/\b3364507\s+A\s+www\s+192.168.1.1\s+\n/)
        subject.run
      end
    end
  end
end
