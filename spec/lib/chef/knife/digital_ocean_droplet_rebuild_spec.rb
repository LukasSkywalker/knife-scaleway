require 'spec_helper'

describe Chef::Knife::ScalewayServerRebuild do
  subject { Chef::Knife::ScalewayServerRebuild.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::ScalewayServerRebuild.load_deps
    Chef::Config['knife']['scaleway_access_token'] = access_token
    allow(subject).to receive(:puts)
    allow(subject).to receive(:wait_for_status).and_return('OK')
    subject.config[:id] = '4829346'
    subject.config[:image] = '10322059'
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('droplet_rebuild') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should rebuild the droplet and exit with 0' do
      VCR.use_cassette('droplet_rebuild') do
        allow(subject.client).to receive_message_chain(:droplet_actions, :rebuild)
        expect { subject.run }.not_to raise_error
      end
    end

    it 'should return OK' do
      VCR.use_cassette('droplet_rebuild') do
        expect(subject.run).to eq 'OK'
      end
    end
  end
end
