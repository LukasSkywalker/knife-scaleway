require 'spec_helper'

describe Chef::Knife::DigitalOceanDropletReboot do
  subject { Chef::Knife::DigitalOceanDropletReboot.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::DigitalOceanDropletReboot.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
    allow(subject).to receive(:wait_for_status).and_return('OK')
    subject.config[:id] = '4829346'
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('droplet_reboot') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should reboot the droplet and exit with 0' do
      VCR.use_cassette('droplet_reboot') do
        allow(subject.client).to receive_message_chain(:droplet_actions, :reboot)
        expect { subject.run }.not_to raise_error
      end
    end

    it 'should return OK' do
      VCR.use_cassette('droplet_reboot') do
        expect(subject.run).to eq 'OK'
      end
    end
  end
end
