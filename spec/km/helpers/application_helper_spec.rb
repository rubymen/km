require 'spec_helper'
require 'factory_girl'

describe ApplicationHelper do
  describe '#app_size' do
    require 'file/find'
    total = 0
    File::Find.new(path: './spec/km/controllers', follow: false).find { |f| total += File.stat(f).size }
    let(:total) { total }

    it 'returns the size of the application' do
      expect(total).to eq(10394)
    end
  end

  describe '#app_number_files' do
    total_files = []
    File::Find.new(path: './spec/km/controllers', follow: false).find { |f| total_files << f }
    let(:number_of_files) { total_files.length }

    it 'returns the number of files in the folder' do
      expect(number_of_files).to eq(4)
    end
  end
end
