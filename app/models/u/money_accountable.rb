# -*- coding: utf-8 -*-
module U::MoneyAccountable
	extend ActiveSupport::Concern

	included do
		has_many :money_accounts, after_add: :after_change_collection
		after_rollback :clear_money_cache
	end

	def clear_money_cache
		@money = nil
	end

	def money
		if self.new_record?
			self[:money] || 0
		else
			@money ||= money_accounts.sum :value
			self[:money] = @money
		end
	end

	def money=(v)
		self[:money] ||= 0
		diff = v.to_i - money
		self[:money] += diff
		@money = nil
		self.money_accounts.concat MoneyAccount.new( value: diff ) if diff != 0
	end

	def after_change_collection x
		@collection_changed ||= !x.new_record?

		if @collection_changed && errors.empty? && self.changed_for_autosave?
			raise ActiveRecord::Rollback unless self.save
		end
	end
end
