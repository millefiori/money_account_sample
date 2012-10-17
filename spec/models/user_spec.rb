# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do

  # User::PUBLISHED = 1

  unless defined?(User::PUBLISHED)
    User.blueprint do
    end
  end

  describe ".create" do
    subject { User.make }
    it { should be_valid }
  end

  describe ".destroy" do
    subject { User.make!.destroy }
    it { should be_destroyed }

    describe ".find_by_id", "after destroy" do
      let(:id) { User.make!.id }
      before { User.destroy id }
      subject { User.find_by_id id }
      it { should be_blank }
    end
  end
end
