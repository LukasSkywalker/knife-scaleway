require 'spec_helper'

describe Chef::Knife::ScalewaySshkeyCreate do
  subject { Chef::Knife::ScalewaySshkeyCreate.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::ScalewaySshkeyCreate.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
    subject.config[:name] = 'test-key'
    subject.config[:public_key] = 'spec/fixtures/keys/id_rsa.pub'
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('sshkey_create') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should create the domain and exit with 0' do
      VCR.use_cassette('sshkey_create') do
        allow(subject.client).to receive_message_chain(:ssh_keys, :create)
        expect { subject.run }.not_to raise_error
      end
    end

    # TODO: Figure out why this is now failing
    # it 'should return OK' do
    #   VCR.use_cassette('sshkey_create') do
    #     expect($stdout).to receive(:puts).with('OK')
    #     expect(subject.run).to eq nil
    #   end
    # end
  end
end
