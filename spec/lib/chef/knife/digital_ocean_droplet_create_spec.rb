require 'spec_helper'

def mock_api_response(data = {})
  Hashie::Mash.new(data)
end

describe Chef::Knife::DigitalOceanDropletCreate do

  subject do
    s = Chef::Knife::DigitalOceanDropletCreate.new
    allow(s).to receive(:client).and_return double(DropletKit::Droplet)
    s
  end

  let(:config) do
    {
      digital_ocean_access_token: 'ACCESS_TOKEN',
      server_name: 'sever-name.example.com',
      image: 11_111,
      location: 22_222,
      size: 33_333,
      ssh_key_ids: [44_444, 44_445]
    }
  end

  let(:custom_config) do
    {}
  end

  let(:api_response) do
    {
      status: 'OK',
      droplet: { id: '123' }
    }
  end

  before do
    Chef::Knife::DigitalOceanDropletCreate.load_deps

    # reset
    if Chef::Config[:knife].respond_to?(:reset)
      # mixlib-config >= 2
      Chef::Config[:knife].reset
    else
      # mixlib-config < 2
      Chef::Config[:knife] = {}
    end

    # config
    config.merge(custom_config).each do |k, v|
      Chef::Config[:knife][k] = v
    end
  end

  context 'bootstrapping for chef-server' do
    let(:custom_config) do
      {
        bootstrap: true
      }
    end

    describe 'should use the default bootstrap class' do
      let(:subject) do
        s = super()
        allow(s.client).to receive_message_chain(:droplets, :create).and_return mock_api_response(api_response)
        allow(s).to receive(:ip_address_available).and_return '123.123.123.123'
        allow(s).to receive(:tcp_test_ssh).and_return true
        s
      end

      it 'should use the right bootstrap class' do
        expect(subject.bootstrap_class).to eql(Chef::Knife::Bootstrap)
      end

      it 'should call #run on the bootstrap class' do
        allow_any_instance_of(Chef::Knife::Bootstrap).to receive(:run)
        expect { subject.run }.not_to raise_error
      end
    end
  end

  context 'bootstrapping for knife-solo' do

    let(:custom_config) do
      {
        solo: true
      }
    end

    describe 'when knife-solo is installed' do
      before do
        # simulate installed knife-solo gem
        require 'chef/knife/solo_bootstrap'
      end

      let(:subject) do
        s = super()
        allow(s.client).to receive_message_chain(:droplets, :create).and_return mock_api_response(api_response)
        allow(s).to receive(:ip_address_available).and_return '123.123.123.123'
        allow(s).to receive(:tcp_test_ssh).and_return true
        s
      end

      it 'should use the right bootstrap class' do
        expect(subject.bootstrap_class).to eql(Chef::Knife::SoloBootstrap)
      end

      it 'should call #run on the bootstrap class' do
        expect_any_instance_of(Chef::Knife::SoloBootstrap).to receive(:run)
        expect_any_instance_of(Chef::Knife::Bootstrap).not_to receive(:run)
        expect { subject.run }.not_to raise_error
      end
    end

    describe 'when knife-solo is not installed' do
      before do
        # simulate knife-solo gem is not installed
        Chef::Knife.send(:remove_const, :SoloBootstrap) if defined?(Chef::Knife::SoloBootstrap)
      end

      it 'should not create a droplet' do
        expect(subject.client).not_to receive(:droplets)
        expect { subject.run }.to raise_error(SystemExit)
      end
    end

  end

  context 'no bootstrapping' do
    let(:custom_config) do
      {}
    end

    describe 'should not do any bootstrapping' do
      let(:subject) do
        s = super()
        allow(s.client).to receive_message_chain(:droplets, :create).and_return mock_api_response(api_response)
        allow(s).to receive(:ip_address_available).and_return '123.123.123.123'
        allow(s).to receive(:tcp_test_ssh).and_return true
        s
      end

      it 'should call #bootstrap_for_node' do
        expect(subject).not_to receive(:bootstrap_for_node)
        expect { subject.run }.to raise_error
      end

      it 'should have a 0 exit code' do
        expect { subject.run }.to raise_error { |e|
          expect(e.status).to eql(0)
          expect(e).to be_a(SystemExit)
        }
      end
    end
  end

  context 'passing json attributes (-j)' do
    let(:json_attributes) { '{ "apache": { "listen_ports": 80 } }' }
    let(:custom_config) do
      {
        json_attributes: json_attributes
      }
    end

    it 'should configure the first boot attributes on Bootstrap' do
      bootstrap = subject.bootstrap_for_node('123.123.123.123')
      expect(bootstrap.config[:first_boot_attributes]).to eql(json_attributes)
    end
  end

  context 'passing secret_file (--secret-file)' do
    let(:secret_file) { '/tmp/sekretfile' }
    let(:custom_config) do
      {
        secret_file: secret_file
      }
    end

    it 'secret_file should be available to Bootstrap' do
      bootstrap = subject.bootstrap_for_node('123.123.123.123')
      expect(bootstrap.config[:secret_file]).to eql(secret_file)
    end
  end

  context 'passing ssh_port (--ssh-port)' do
    let(:ssh_port) { 22 }
    let(:custom_config) do
      {
        ssh_port: ssh_port
      }
    end

    it 'ssh_port should be available to Bootstrap' do
      bootstrap = subject.bootstrap_for_node('123.123.123.123')
      expect(bootstrap.config[:ssh_port]).to eql(ssh_port)
    end
  end

end
