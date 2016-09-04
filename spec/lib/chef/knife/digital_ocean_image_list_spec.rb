require 'spec_helper'

describe Chef::Knife::ScalewayImageList do
  subject { Chef::Knife::ScalewayImageList.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::ScalewayImageList.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should validate the Digital Ocean config keys exist' do
      VCR.use_cassette('image') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it 'should output the column headers' do
      VCR.use_cassette('image') do
        expect(subject).to receive(:puts).with(/^ID\s+Distribution\s+Name\s+Slug\n/)
        subject.run
      end
    end

    it 'should output a list of the available Digital Ocean Images' do
      VCR.use_cassette('image') do
        expect(subject).to receive(:puts).with(/\b7992108\s+Debian\s+Debian test\s+\n/)
        subject.run
      end
    end
  end

  context 'public images' do
    describe '#run' do
      it 'should output a list of the available Digital Ocean Images' do
        VCR.use_cassette('public_images') do
          subject.config[:public_images] = true
          expect(subject).to receive(:puts).with(/\b6886342\s+CoreOS\s+444.5.0 \(stable\)\s+coreos-stable/)
          subject.run
        end
      end
    end
  end
end
