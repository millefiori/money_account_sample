# -*- coding: utf-8 -*-
class MoneyAccount < ActiveRecord::Base
	belongs_to :user
	attr_accessible :value
end
