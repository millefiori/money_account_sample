# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do

	# User::PUBLISHED = 1

	unless defined?(User::PUBLISHED)
		User.blueprint do
			money {}
		end
	end

	describe ".create" do
		subject { User.make }
		it { should be_valid }

		context "money is nil" do
			subject { User.make(money: nil) }
			it { should be_valid }
		end
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
