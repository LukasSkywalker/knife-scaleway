require 'spec_helper'

describe Chef::Knife::ScalewaySshkeyList do
  subject do
    s = Chef::Knife::ScalewaySshkeyList.new
    s
  end

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::ScalewaySshkeyList.load_deps
    Chef::Config['knife']['scaleway_access_token'] = access_token
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('sshkey') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should output the column headers' do
      VCR.use_cassette('sshkey') do
        expect(subject).to receive(:puts).with(/^ID\s+Name\s+Fingerprint\s+\n/)
        subject.run
      end
    end

    it 'should output a list of the available Digital Ocean ssh keys' do
      VCR.use_cassette('sshkey') do
        expect(subject).to receive(:puts).with(/\bgregf\b/)
        subject.run
      end
    end
  end
end
