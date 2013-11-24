require 'spec_helper'

def mock_api_response(data = {})
  Hashie::Rash.new(data)
end

describe Chef::Knife::DigitalOceanDropletCreate do

  subject {
    s = Chef::Knife::DigitalOceanDropletCreate.new
    s.stub(:client).and_return mock(DigitalOcean::API)
    s
  }

  let(:config) {
    {
      :digital_ocean_client_id => 'CLIENT_ID',
      :digital_ocean_api_key   => 'API_KEY',
      :server_name => 'sever-name.example.com',
      :image       => 11111,
      :location    => 22222,
      :size        => 33333,
      :ssh_key_ids => [ 44444, 44445 ]
    }
  }

  let(:custom_config) {
    {}
  }

  let(:api_response) {
    {
      :status => 'OK',
      :droplet => { :id => '123' }
    }
  }

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
    let(:custom_config) {
      {
       :bootstrap => true
      }
    }

    describe 'should use the default bootstrap class' do
      let(:subject) {
        s = super()
        s.client.stub_chain(:droplets, :create).and_return mock_api_response(api_response)
        s.stub!(:ip_address_available).and_return '123.123.123.123'
        s.stub!(:tcp_test_ssh).and_return true
        s
      }

      it 'should use the right bootstrap class' do
        subject.bootstrap_class.should eql(Chef::Knife::Bootstrap)
      end

      it 'should call #run on the bootstrap class' do
        Chef::Knife::Bootstrap.any_instance.stub(:run)
        lambda { subject.run }.should_not raise_error(SystemExit)
      end
    end
  end

  context 'bootstrapping for knife-solo' do

    let(:custom_config) {
      {
       :solo => true
      }
    }

    describe 'when knife-solo is installed' do
      before do
        # simulate installed knife-solo gem
        require 'chef/knife/solo_bootstrap'
      end

      let(:subject) {
        s = super()
        s.client.stub_chain(:droplets, :create).and_return mock_api_response(api_response)
        s.stub!(:ip_address_available).and_return '123.123.123.123'
        s.stub!(:tcp_test_ssh).and_return true
        s
      }

      it 'should use the right bootstrap class' do
        subject.bootstrap_class.should eql(Chef::Knife::SoloBootstrap)
      end

      it 'should call #run on the bootstrap class' do
        Chef::Knife::SoloBootstrap.any_instance.should_receive(:run)
        Chef::Knife::Bootstrap.any_instance.should_not_receive(:run)
        lambda { subject.run }.should_not raise_error(SystemExit)
      end
    end

    describe 'when knife-solo is not installed' do
      before do
        # simulate knife-solo gem is not installed
        Chef::Knife.send(:remove_const, :SoloBootstrap) if defined?(Chef::Knife::SoloBootstrap)
      end

      it 'should not create a droplet' do
        subject.client.should_not_receive(:droplets)
        lambda { subject.run }.should raise_error(SystemExit)
      end
    end

  end

  context 'no bootstrapping' do
    let(:custom_config) {
      {}
    }

    describe 'should not do any bootstrapping' do
      let(:subject) {
        s = super()
        s.client.stub_chain(:droplets, :create).and_return mock_api_response(api_response)
        s.stub!(:ip_address_available).and_return '123.123.123.123'
        s.stub!(:tcp_test_ssh).and_return true
        s
      }

      it 'should call #bootstrap_for_node' do
        subject.should_not_receive(:bootstrap_for_node)
        expect { subject.run }.to raise_error
      end

      it 'should have a 0 exit code' do
        expect { subject.run }.to raise_error { |e|
          e.status.should eql(0)
          e.should be_a(SystemExit)
        }
      end
    end
  end

  context 'passing json attributes (-j)' do
    let(:json_attributes) { '{ "apache": { "listen_ports": 80 } }' }
    let(:custom_config) {
      {
       :json_attributes => json_attributes
      }
    }

    it 'should configure the first boot attributes on Bootstrap' do
      bootstrap = subject.bootstrap_for_node('123.123.123.123')
      bootstrap.config[:first_boot_attributes].should eql(json_attributes)
    end
  end

end

