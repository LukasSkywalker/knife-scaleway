require 'spec_helper'

describe Chef::Knife::DigitalOceanDomainRecordCreate do
  subject { Chef::Knife::DigitalOceanDomainRecordCreate.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::DigitalOceanDomainRecordCreate.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
    subject.config[:domain] = 'kitchen-digital.org'
    subject.config[:type] = 'A'
    subject.config[:name] = 'www'
    subject.config[:data] = '192.168.1.1'
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('domain_record_create') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should create the domain record and exit with 0' do
      VCR.use_cassette('domain_record_create') do
        allow(subject.client).to receive_message_chain(:domain_records, :create)
        expect { subject.run }.not_to raise_error
      end
    end

    # TODO: Figure out why this is now failing
    # it 'should return OK' do
    #   VCR.use_cassette('domain_record_create') do
    #     expect($stdout).to receive(:puts).with('OK')
    #     expect(subject.run).to eq nil
    #   end
    # end
  end
end
