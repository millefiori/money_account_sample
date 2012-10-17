# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
	include U::MoneyAccountable
	attr_accessible :money

	validates :money, numericality: { greater_than_or_equal_to: 0 }
end
