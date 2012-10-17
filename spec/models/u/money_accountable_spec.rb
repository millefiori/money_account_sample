# -*- coding: utf-8 -*-
require 'spec_helper'

describe U::MoneyAccountable do

	context "初期状態は、" do
	  context "new record の時" do
			let( :user ) { User.make }
			subject { user }

			its( :money ) { should == 0 }

			context "セーブ後" do
				before do
					user.save!
				end

				subject { user.reload }
				its( :id ) { should_not be_nil }
				its( :money ) { should == 0 }
				its( :money_accounts ) { should be_empty }
			end
		end

	  context "new record with parameter の時" do
			let( :user ) { User.make money: 102 }
			subject { user }

			its( :money ) { should == 102 }

			context "セーブ後" do
				before do
					user.save!
				end

				subject { user.reload }
				its( :id ) { should_not be_nil }
				its( :money ) { should == 102 }
				its( :money_accounts ) { should_not be_empty }
				its( :money_accounts ) { should have(1).item }

				it "accountに金額が入っている" do
					user.money_accounts.last.value.should == 102
				end
			end
		end
	end

	context "未セーブでの操作" do
	  context "money:0 の初期状態から" do
			let( :user ) { User.make }

			context "マイナスの値が設定された時" do
				before do
					user.money -= 100
				end
	
				subject { user }
				its( :money ) { should == -100 }
				it { should_not be_valid }
	
				it "セーブできない" do
					user.save.should be_false
				end
			end

			context "複数回の操作があった時" do
				before do
					user.money += 100
					user.money += 100
				end

				subject { user }
				its( :money ) { should == 200 }
				it { should be_valid }

				context "セーブ後" do
					before do
						user.save
					end

					it "履歴が全部残っている" do
						user.reload.money_accounts.should have(2).item
					end
				end
			end
		end

	  context "金額を設定した状態から" do
			let( :user ) { User.make money: 102 }

			context "マイナスになったとき" do
				before do
					user.money -= 112
				end

				subject { user }
				its( :money ) { should == -10 }
				it { should_not be_valid }

				it "セーブできない" do
					user.save.should be_false
				end
			end
		end
	end

  context "既存レコードの操作" do
		let!( :user ) { User.make! money: 10 }

		context "操作の前後の変化、" do
			subject{ lambda { update_money } }

			context "増減なしで" do
				let( :update_money ) { user.money += 0 }
	
				it "入金伝票が増えない" do
					subject.should_not change { user.reload.money_accounts.size }
				end

				it "所持金が増えない" do
					subject.should_not change { user.reload.money }
				end
			end

			context "増える操作で" do
				let( :update_money ) { user.money += 100 }
	
				it "入金伝票が増える" do
					subject.should change { user.reload.money_accounts.size }.by 1
				end
	
				it "所持金が増える" do
					subject.should change { user.reload.money }.by 100
				end
			end
	
			context "減る操作で" do
				context "所持金がプラスのとき" do
					let( :update_money ) { user.money -= 5 }
	
					it "入金伝票が増える" do
						subject.should change { user.reload.money_accounts.size }.by 1
					end
	
					it "所持金が減る" do
						subject.should change { user.reload.money }.by -5
					end
				end
	
				context "所持金がマイナスのとき" do
					let( :update_money ) { user.money -= 15 }
	
					it "入金伝票が増えない" do
						subject.should_not change { user.reload.money_accounts.size }
					end
	
					it "所持金が変動しない" do
						subject.should_not change { user.reload.money }
					end
				end
			end
		end

		context "増えた時" do
			subject { user }
			
			before do
				user.money += 105
			end

			it "自動的に保存" do
				user.money.should == 115
				user.reload.money.should == 115
			end

			its( :money_accounts ) { should have(2).item }

			it "入金伝票に反映" do
				user.money_accounts.last.value.should == 105
			end

			context "減ってプラスの時" do
				before do
					user.money -= 10
				end

				it "自動的に保存" do
					user.money.should == 105
					user.reload.money == 105
				end

				it "入金伝票に反映" do
					user.money_accounts.last.value.should == -10
				end
			end

			context "減ってマイナスの時" do
				before do
					user.money -= 120
				end

				it "errorでsave出来ない" do
					user.errors.should_not be_empty
				end

				it "保存されない" do
					user.money.should == 115
					user.reload.money == 115
				end
			end
		end

		context "減ってマイナスになった時" do
			before do
				user.money -= 102
			end

			it do
				user.errors.should_not be_empty
				user.reload.money.should == 10
			end
		end
	end

end
