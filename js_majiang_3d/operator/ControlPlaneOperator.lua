
--获取牌定义类
local Card = require("js_majiang_3d.card.card")

local ControlPlaneOperator = class("ControlPlaneOperator")

IMAGE_SHOW_TYPE_HU = "hu0"
IMAGE_SHOW_TYPE_GANG = "gang0"
IMAGE_SHOW_TYPE_PENG = "peng0"
IMAGE_SHOW_TYPE_CHI = "chi0"
IMAGE_SHOW_TYPE_GUO = "majong_guo_bt_n"
IMAGE_SHOW_TYPE_LIANG = "liang0"
IMAGE_SHOW_TYPE_BUHUA = "buhua0"
IMAGE_SHOW_TYPE_CAIPIAO = "caipiao0"
IMAGE_SHOW_TYPE_ZIMO = "zimo0"

CHILD_NAME_SELECT_BOX = "select_box"
CHILD_NAME_GANG_SELECT_BOX = "gang_select_box"
CHILD_NAME_LEFT_CHI_BT = "left_chi_bt"
CHILD_NAME_MIDDLE_CHI_BT = "middle_chi_bt"
CHILD_NAME_RIGHT_CHI_BT = "right_chi_bt"

local CHILD_NAME_EFFECT_LIGHT = "light"
local CHILD_NAME_EFFECT_1 = "effect_1"
local CHILD_NAME_EFFECT_2 = "effect_2"
local CHILD_NAME_EFFECT_3 = "effect_3"

local CHILD_NAME_COMMIT_BT = "commit_bt"

local CONTROL_BT_SPLIT = 20

local boxscale = 1.2

--操作界面初始化
function ControlPlaneOperator:init(playerType, img, plane, lgPlane, tingHuPlane)
	img:setVisible(false)

	local position = cc.p(img:getSize().width / 2, img:getSize().height / 2)

	--光效
	local light_img = ccui.ImageView:create()
    light_img:loadTexture("js_majiang_3d/image/effect/effect_guang.png")
    light_img:setPosition(position)
    light_img:setName(CHILD_NAME_EFFECT_LIGHT)
    img:addChild(light_img)

    --底字
    local effect_3_img = ccui.ImageView:create()
    effect_3_img:loadTexture("js_majiang_3d/image/effect/effect_hu03.png")
    effect_3_img:setPosition(position)
    effect_3_img:setName(CHILD_NAME_EFFECT_3)
    img:addChild(effect_3_img)

    --中间字
    local effect_2_img = ccui.ImageView:create()
    effect_2_img:loadTexture("js_majiang_3d/image/effect/effect_hu02.png")
    effect_2_img:setPosition(position)
    effect_2_img:setName(CHILD_NAME_EFFECT_2)
    img:addChild(effect_2_img)

    --顶字
    local effect_1_img = ccui.ImageView:create()
    effect_1_img:loadTexture("js_majiang_3d/image/effect/effect_hu01.png")
    effect_1_img:setPosition(position)
    effect_1_img:setName(CHILD_NAME_EFFECT_1)
    img:addChild(effect_1_img)

	if plane then
		
		--胡按钮
		self.hu_bt = ccui.Button:create()
		self.hu_bt:loadTextureNormal("js_majiang_3d/image/majong_hu_bt_p.png")
		self.hu_bt:setVisible(false)
		plane:addChild(self.hu_bt)

		--杠按钮
		self.gang_bt = ccui.Button:create()
		self.gang_bt:loadTextureNormal("js_majiang_3d/image/majong_gang_bt_p.png")
		self.gang_bt:setVisible(false)
		plane:addChild(self.gang_bt)

		--碰按钮
		self.peng_bt = ccui.Button:create()
		self.peng_bt:loadTextureNormal("js_majiang_3d/image/majong_peng_bt_p.png")
		self.peng_bt:setVisible(false)
		plane:addChild(self.peng_bt)

		--吃按钮
		self.chi_bt = ccui.Button:create()
		self.chi_bt:loadTextureNormal("js_majiang_3d/image/majong_chi_bt_p.png")
		self.chi_bt:setVisible(false)
		plane:addChild(self.chi_bt)

		--过按钮
		self.guo_bt = ccui.Button:create()
		self.guo_bt:loadTextureNormal("js_majiang_3d/image/majong_guo_bt_n.png")
		self.guo_bt:setVisible(true)
		plane:addChild(self.guo_bt)

		--选牌盒
		self.select_bx = plane:getChildByName(CHILD_NAME_SELECT_BOX)
		self.select_bx:setVisible(false)

		--杠选择盒
		self.gang_select_bx = plane:getChildByName(CHILD_NAME_GANG_SELECT_BOX)
		self.gang_select_bx:setVisible(false)

		--吃按钮
		self.left_chi_bt = self.select_bx:getChildByName(CHILD_NAME_LEFT_CHI_BT)
		self.middle_chi_bt = self.select_bx:getChildByName(CHILD_NAME_MIDDLE_CHI_BT)
		self.right_chi_bt = self.select_bx:getChildByName(CHILD_NAME_RIGHT_CHI_BT)

		--亮按钮
		self.liang_bt = ccui.Button:create()
		self.liang_bt:loadTextureNormal("js_majiang_3d/image/majong_liang_bt_p.png")
		self.liang_bt:setVisible(true)
		plane:addChild(self.liang_bt)

		 
		--听按钮
		self.ting_bt = ccui.Button:create()
		self.ting_bt:loadTextureNormal("js_majiang_3d/image/majong_ting_bt_p.png")
		self.ting_bt:setVisible(false)
		plane:addChild(self.ting_bt)

		plane:setVisible(false)

		local bt_callback = function(sender, event)
			if event == TOUCH_EVENT_ENDED then

				local controlType = ZZMJ_CONTROL_TABLE["type"]
				local value = ZZMJ_CONTROL_TABLE["value"]
				local gangCards = ZZMJ_CONTROL_TABLE["gangCards"]
				

				if sender == self.hu_bt then
					--todo
					plane:setVisible(false)
					ZZMJ_CONTROLLER:control(bit.band(controlType, CONTROL_TYPE_HU), value)
				elseif sender == self.gang_bt then
					if gangCards and table.getn(gangCards) == 1 then
						plane:setVisible(false)
						ZZMJ_CONTROLLER:control(bit.band(controlType, CONTROL_TYPE_GANG), gangCards[1])
					end
				elseif sender == self.peng_bt then
					plane:setVisible(false)
					ZZMJ_CONTROLLER:control(bit.band(controlType, CONTROL_TYPE_PENG), value)
				elseif sender == self.left_chi_bt then
					plane:setVisible(false)
					ZZMJ_CONTROLLER:control(CHI_TYPE_LEFT, value)
				elseif sender == self.middle_chi_bt then
					plane:setVisible(false)
					ZZMJ_CONTROLLER:control(CHI_TYPE_MIDDLE, value)
				elseif sender == self.right_chi_bt then
					plane:setVisible(false)
					ZZMJ_CONTROLLER:control(CHI_TYPE_RIGHT, value)
				elseif sender == self.guo_bt then
					plane:setVisible(false)
					ZZMJ_CONTROLLER:control(0, value)
				elseif sender == self.chi_bt then
					local chiType
					local chiCount = 0

					--dump(controlType, "controlType chi test")
					if bit.band(controlType, CHI_TYPE_LEFT) > 0 then
						--todo
						chiType = CHI_TYPE_LEFT
						chiCount = chiCount + 1
					end
					if bit.band(controlType, CHI_TYPE_MIDDLE) > 0 then
						--todo
						chiType = CHI_TYPE_MIDDLE
						chiCount = chiCount + 1
					end
					if bit.band(controlType, CHI_TYPE_RIGHT) > 0 then
						--todo
						chiType = CHI_TYPE_RIGHT
						chiCount = chiCount + 1
					end

					--dump(chiCount, "chiCount chi test")
					if chiCount == 1 then
						--todo
						plane:setVisible(false)
						ZZMJ_CONTROLLER:control(chiType, value)
					end
				elseif sender == self.liang_bt then
					plane:setVisible(false)
					
					if table.getn(ZZMJ_CONTROL_TABLE.gangSeq) > 0 then
						--todo
						ZZMJ_CONTROLLER:showLgSelectBox(ZZMJ_CONTROL_TABLE.gangSeq)
					else
						-- ZZMJ_CONTROLLER:showTingCards(ZZMJ_CONTROL_TABLE.tingSeq)
						ZZMJ_LG_CARDS = {}
						ZZMJ_CONTROLLER:requestLiangGang()
					end
				elseif sender == self.ting_bt then  ---亮倒  （听牌）
					--移除一张牌  ---给服务器消息移除一张牌
					plane:setVisible(false)
				
					--处理移除牌
					-- local tingMoveCards = ZZMJ_CONTROL_TABLE["OpCard"]--@garret 可以丢弃的牌
					-- -- ZZMJ_CONTROLLER:control(0, tingMoveCards)
					ZZMJ_CONTROLLER:control(bit.band(controlType, CONTROL_TYPE_TING), value)
					
						
				end
			end
		end

		self.hu_bt:addTouchEventListener(bt_callback)
		self.gang_bt:addTouchEventListener(bt_callback)
		self.peng_bt:addTouchEventListener(bt_callback)
		self.left_chi_bt:addTouchEventListener(bt_callback)
		self.middle_chi_bt:addTouchEventListener(bt_callback)
		self.right_chi_bt:addTouchEventListener(bt_callback)
		self.guo_bt:addTouchEventListener(bt_callback)
		self.chi_bt:addTouchEventListener(bt_callback)
		self.liang_bt:addTouchEventListener(bt_callback)
		self.ting_bt:addTouchEventListener(bt_callback)
	end

	if lgPlane then
		--todo
		lgPlane:setVisible(false)

		self.lg_select_box = lgPlane:getChildByName(CHILD_NAME_SELECT_BOX)
		self.commit_bt = lgPlane:getChildByName(CHILD_NAME_COMMIT_BT)

		self.commit_bt:addTouchEventListener(function(sender, event)
				if event == TOUCH_EVENT_ENDED then
					lgPlane:setVisible(false)

					ZZMJ_LG_CARDS = {}

					for k,v in pairs(self.lg_select_box:getChildren()) do
						if v:getTag() == 0 then
							--todo
							table.insert(ZZMJ_LG_CARDS, v.m_value)
						end
					end

					ZZMJ_CONTROLLER:requestLiangGang()
					-- for i=table.getn(ZZMJ_CONTROL_TABLE.tingSeq),1,-1 do
					-- 	for k,v in pairs(ZZMJ_LG_CARDS) do
					-- 		if v == ZZMJ_CONTROL_TABLE.tingSeq[i] then
					-- 			--todo
					-- 			table.remove(ZZMJ_CONTROL_TABLE.tingSeq, i)
					-- 			break
					-- 		end
					-- 	end
					-- end
				end
			end)
	end

	if tingHuPlane then
		--todo
		tingHuPlane:setVisible(false)
	end
end

--清理操作界面
function ControlPlaneOperator:clearGameDatas(plane, lgPlane, tingHuPlane)
	if plane then
		--todo
		plane:setVisible(false)
	end

	if lgPlane then
		--todo
		lgPlane:setVisible(false)
	end

	if tingHuPlane then
		--todo
		tingHuPlane:setVisible(false)
	end
end

--显示操作特效
function ControlPlaneOperator:showImage(img, type)

	local img_type = ""

	dump(type, "-----showImage-----")
	dump(CONTROL_TYPE_CAIPIAO, "-----showImage-----")
	dump(bit.band(type, CONTROL_TYPE_CAIPIAO), "-----showImage-----")

	if bit.band(type, CONTROL_TYPE_HU) > 0 then

		img_type = IMAGE_SHOW_TYPE_HU

		if bit.band(type, HU_TYPE_ZM) > 0 then
			img_type = IMAGE_SHOW_TYPE_ZIMO		
		end

	elseif bit.band(type, CONTROL_TYPE_GANG) > 0 then
		img_type = IMAGE_SHOW_TYPE_GANG
	elseif bit.band(type, CONTROL_TYPE_PENG) > 0 then
		img_type = IMAGE_SHOW_TYPE_PENG
	elseif bit.band(type, CONTROL_TYPE_CHI) > 0 then
		img_type = IMAGE_SHOW_TYPE_CHI
	elseif bit.band(type, CONTROL_TYPE_TING) > 0 then
		img_type = IMAGE_SHOW_TYPE_LIANG
	elseif bit.band(type, CONTROL_TYPE_BUHUA) > 0 then
		img_type = IMAGE_SHOW_TYPE_BUHUA
	elseif bit.band(type, CONTROL_TYPE_CAIPIAO) > 0 then
		img_type = IMAGE_SHOW_TYPE_CAIPIAO
	end

	local light_img = img:getChildByName(CHILD_NAME_EFFECT_LIGHT)
	local effect_1_img = img:getChildByName(CHILD_NAME_EFFECT_1)
	local effect_2_img = img:getChildByName(CHILD_NAME_EFFECT_2)
	local effect_3_img = img:getChildByName(CHILD_NAME_EFFECT_3)

	effect_1_img:loadTexture("js_majiang_3d/image/effect/effect_" .. img_type .. "3.png")
	effect_2_img:loadTexture("js_majiang_3d/image/effect/effect_" .. img_type .. "2.png")
	effect_3_img:loadTexture("js_majiang_3d/image/effect/effect_" .. img_type .. "1.png")

	img:setVisible(true)

	light_img:setVisible(true)
	effect_1_img:setVisible(false)
	effect_2_img:setVisible(false)
	effect_3_img:setVisible(true)

	light_img:setOpacity(255 * 0.2)
	effect_3_img:setOpacity(255 * 0.3)
	light_img:setScale(0.8)
	effect_3_img:setScale(1)

	local scale_light = cc.ScaleTo:create(0.2, 1.1, 1.1, 1)
	local opacity_light = cc.FadeTo:create(0.2, 255 * 0.7)
	local scale_light_1 = cc.ScaleTo:create(0.1, 1, 1, 1)
	local opacity_light_1 = cc.FadeTo:create(0.1, 255 * 0.3)
	light_img:runAction(cc.Sequence:create(scale_light, cc.DelayTime:create(0.2), scale_light_1, cc.DelayTime:create(0.0), cc.FadeTo:create(1.2, 0)))
	light_img:runAction(cc.Sequence:create(opacity_light, cc.DelayTime:create(0.2), opacity_light_1, cc.DelayTime:create(0.0), cc.ScaleTo:create(1.2, 0.7, 0.7, 1)))

	local scale_3 = cc.ScaleTo:create(0.2, 1.2, 1.2, 1)
	local opacity_3 = cc.FadeTo:create(0.2, 255)
	local scale_3_1 = cc.ScaleTo:create(0.1, 1, 1, 1)
	local opacity_3_1 = cc.FadeTo:create(0.1, 255 * 0.3)
	effect_3_img:runAction(cc.Sequence:create(scale_3, cc.DelayTime:create(0.2), scale_3_1, cc.DelayTime:create(0.0), cc.FadeTo:create(1.2, 0)))
	effect_3_img:runAction(cc.Sequence:create(opacity_3, cc.DelayTime:create(0.2), opacity_3_1, cc.DelayTime:create(0.0), cc.ScaleTo:create(1.2, 0.7, 0.7, 1)))

	local callFunc_2 = cc.CallFunc:create(function()
			effect_2_img:setVisible(true)
			effect_2_img:setScale(0.8)
			effect_2_img:setOpacity(0)
		end)
	effect_2_img:runAction(cc.Sequence:create(cc.DelayTime:create(0.4), callFunc_2, cc.FadeTo:create(0.1, 255 * 0.5), cc.FadeTo:create(1.2, 0)))
	effect_2_img:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.ScaleTo:create(1.2, 0.7, 0.7, 1)))

	local callFunc_1 = cc.CallFunc:create(function()
			effect_1_img:setVisible(true)
			effect_1_img:setScale(0.7)
			effect_1_img:setOpacity(0)
		end)

	effect_1_img:runAction(cc.Sequence:create(cc.DelayTime:create(0.4), callFunc_1, cc.FadeTo:create(0.3, 255), cc.DelayTime:create(0.5), cc.FadeTo:create(0.5, 0)))

end

--显示碰杠吃亮胡操作界面  加听牌操作
function ControlPlaneOperator:showPlane(plane, controlType)

	if controlType == 0 then
		--todo
		return
	end	

	plane:setVisible(true)

	self.hu_bt:setVisible(false)
	self.gang_bt:setVisible(false)
	self.peng_bt:setVisible(false)
	self.chi_bt:setVisible(false)
	self.liang_bt:setVisible(false)

	self.select_bx:setVisible(false)
	self.gang_select_bx:setVisible(false)
	-- self.guo_bt:setVisible(false)

	local oriX = 20

	if bit.band(controlType, CONTROL_TYPE_HU) > 0 then
		--todo
		self.hu_bt:setVisible(true)
		local size = self.hu_bt:getSize()
		self.hu_bt:setPosition(cc.p(oriX + size.width / 2, size.height / 2))

		oriX = oriX + size.width + CONTROL_BT_SPLIT * boxscale
	end

	if bit.band(controlType, CONTROL_TYPE_GANG) > 0 then

		self.gang_bt:setVisible(true)

		if #ZZMJ_CONTROL_TABLE["gangCards"] > 1 then
			self.gang_select_bx:setVisible(true)
		else
			self.gang_select_bx:setVisible(false)
		end

		local size = self.gang_bt:getSize()
		self.gang_bt:setPosition(cc.p(oriX + size.width / 2, size.height / 2))

		oriX = oriX + size.width * boxscale

		local box_width = self:showGangSelectBox(plane, controlType)

		self.gang_select_bx:setPosition(cc.p(oriX + box_width / 2, self.gang_bt:getPositionY()))
		self.gang_select_bx:setSize(cc.size(box_width, 66.92 * boxscale))

		oriX = oriX + box_width

	end

	if bit.band(controlType, CONTROL_TYPE_PENG) > 0 then
		
		-- if bit.band(controlType, CONTROL_TYPE_GANG) > 0 then     --可以杠的时候延迟碰的显示
		-- 	self.peng_bt:performWithDelay(function()
		--     self.peng_bt:setVisible(true)
		-- 	end,1) 
		-- else                                                     --单独碰的时候不延迟
			self.peng_bt:setVisible(true)
		-- end

		local size = self.peng_bt:getSize()
		self.peng_bt:setPosition(cc.p(oriX + size.width / 2*1.5, size.height / 2))

		oriX = oriX + size.width + CONTROL_BT_SPLIT * boxscale
	end

	if bit.band(controlType, CONTROL_TYPE_CHI) > 0 then

		self.chi_bt:setVisible(true)
		self.select_bx:setVisible(true)

		local size = self.chi_bt:getSize()
		self.chi_bt:setPosition(cc.p(oriX + size.width / 2, size.height / 2))

		oriX = oriX + size.width * boxscale

		local box_width = self:showSelectBox(controlType)

		self.select_bx:setPosition(cc.p(oriX + box_width / 2, self.select_bx:getSize().height / 2))
		self.select_bx:setSize(cc.size(box_width, 66.92 * boxscale))

		oriX = oriX + box_width



	end
	--@garret 听牌
	if bit.band(controlType, CONTROL_TYPE_TING) > 0 then
			self.ting_bt:setVisible(true)
			local size = self.ting_bt:getSize()
			self.ting_bt:setPosition(cc.p(oriX + size.width / 2, size.height / 2))

			oriX = oriX + size.width + CONTROL_BT_SPLIT

			--显示选牌盒子
			-- self.select_bx:setVisible(true)

			--显示可选择项目
			-- if #ZZMJ_CONTROL_TABLE["cardSum"] > 1 then
			-- 	self.gang_select_bx:setVisible(true)
			-- else
			-- 	self.gang_select_bx:setVisible(false)
			-- end

			-- local box_width = self:showSelectBox(controlType)

			-- self.select_bx:setPosition(cc.p(oriX + box_width / 2, self.select_bx:getSize().height / 2))
			-- self.select_bx:setSize(cc.size(box_width, 66.92 * boxscale))
		
		end

	local size = self.guo_bt:getSize()
	
	-- self.guo_bt:performWithDelay(function()
	-- self.guo_bt:setVisible(true)
	-- 	end,1) 
	self.guo_bt:setPosition(cc.p(oriX + size.width / 2 * boxscale, size.height / 2))

	local width = oriX + size.width

	plane:setSize(cc.size(width, plane:getSize().height))
	dump(plane:getPosition(), "PlayerPlaneOperator:controlType")

end

--显示吃选择牌盒子
function ControlPlaneOperator:showSelectBox(controlType)

	self.select_bx:setVisible(true)

	self.left_chi_bt:setVisible(false)
	self.middle_chi_bt:setVisible(false)
	self.right_chi_bt:setVisible(false)

	local value = ZZMJ_CONTROL_TABLE["value"]
	dump(value, "-----ZZMJ_CONTROL_TABLE[value]-----")

	local cardScale = 1.5
	local bx_width = 20
	dump(controlType,"controlType------")
	if bit.band(controlType, CHI_TYPE_LEFT) > 0 then

		dump(value, "-----CHI_TYPE_LEFT-----")

		self.left_chi_bt:setVisible(true)
		self.left_chi_bt:removeAllChildren()

		local bt_width = 0

		--假如是白板替身
		if isbaibantishen == 1 then

			--获取财神牌值
			local caishenCard = JS_CAISHEN[1]
			
			--假如操作牌是白板
			if value == 67 then
				value = caishenCard
			end

			for i = value, value + 2 do

				local card
				if i == caishenCard then
					card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, 67)
				else
					card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, i)
				end

				local size = card:getSize()
				local scale = self.left_chi_bt:getSize().height / size.height * cardScale
				card:setScale(scale)
				card:setPosition(cc.p((i - value) * size.width * scale + size.width * scale / 2, self.left_chi_bt:getSize().height / 2 + 5))

				if value == i then
					--todo
					card:setColor(cc.c3b(140, 140, 140))
				end

				card:setEnabled(false)
				self.left_chi_bt:addChild(card)

				bt_width = bt_width + size.width * scale

			end

		else

			for i = value, value + 2 do

				local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, i)
				local size = card:getSize()
				local scale = self.left_chi_bt:getSize().height / size.height * cardScale
				card:setScale(scale)
				card:setPosition(cc.p((i - value) * size.width * scale + size.width * scale / 2, self.left_chi_bt:getSize().height / 2 + 5))

				if value == i then
					--todo
					card:setColor(cc.c3b(140, 140, 140))
				end

				card:setEnabled(false)
				self.left_chi_bt:addChild(card)

				bt_width = bt_width + size.width * scale

			end

		end

		local position = self.left_chi_bt:getPosition()
		self.left_chi_bt:setPosition(cc.p(bx_width + bt_width / 2, position.y))
		local size = self.left_chi_bt:getSize()
		self.left_chi_bt:setSize(cc.size(bt_width, size.height))

		bx_width = bx_width + bt_width + 20

	end

	if bit.band(controlType, CHI_TYPE_MIDDLE) > 0 then

		dump(value, "-----CHI_TYPE_MIDDLE-----")

		self.middle_chi_bt:setVisible(true)
		self.middle_chi_bt:removeAllChildren()

		local bt_width = 0

		--假如是白板替身
		if isbaibantishen == 1 then

			--获取财神牌值
			local caishenCard = JS_CAISHEN[1]
			
			--假如操作牌是白板
			if value == 67 then
				value = caishenCard
			end

			for i = value - 1, value + 1 do

				local card
				if i == caishenCard then
					card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, 67)
				else
					card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, i)
				end

				local size = card:getSize()
				local scale = self.middle_chi_bt:getSize().height / size.height * cardScale
				card:setScale(scale)
				card:setPosition(cc.p((i - value + 1) * size.width * scale + size.width * scale / 2, self.middle_chi_bt:getSize().height / 2 + 5))

				if value == i then
					--todo
					card:setColor(cc.c3b(140, 140, 140))
				end

				card:setEnabled(false)
				self.middle_chi_bt:addChild(card)

				bt_width = bt_width + size.width * scale

			end

		else

			for i = value - 1, value + 1 do

				local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, i)
				local size = card:getSize()
				local scale = self.middle_chi_bt:getSize().height / size.height * cardScale
				card:setScale(scale)
				card:setPosition(cc.p((i - value + 1) * size.width * scale + size.width * scale / 2, self.middle_chi_bt:getSize().height / 2 + 5))

				if value == i then
					--todo
					card:setColor(cc.c3b(140, 140, 140))
				end

				card:setEnabled(false)
				self.middle_chi_bt:addChild(card)

				bt_width = bt_width + size.width * scale

			end

		end

		local position = self.middle_chi_bt:getPosition()
		self.middle_chi_bt:setPosition(cc.p(bx_width + bt_width / 2, position.y))
		local size = self.middle_chi_bt:getSize()
		self.middle_chi_bt:setSize(cc.size(bt_width, size.height))

		bx_width = bx_width + bt_width + 20

	end

	if bit.band(controlType, CHI_TYPE_RIGHT) > 0 then

		dump(value, "-----CHI_TYPE_RIGHT-----")

		self.right_chi_bt:setVisible(true)
		self.right_chi_bt:removeAllChildren()

		local bt_width = 0

		--假如是白板替身
		if isbaibantishen == 1 then

			--获取财神牌值
			local caishenCard = JS_CAISHEN[1]
			
			--假如操作牌是白板
			if value == 67 then
				value = caishenCard
			end

			for i = value - 2, value do
			
				local card
				if i == caishenCard then
					card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, 67)
				else
					card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, i)
				end

				local size = card:getSize()
				local scale = self.right_chi_bt:getSize().height / size.height * cardScale
				card:setScale(scale)
				card:setPosition(cc.p((i - value + 2) * size.width * scale + size.width * scale / 2, self.right_chi_bt:getSize().height / 2 + 5))

				if value == i then
					--todo
					card:setColor(cc.c3b(140, 140, 140))
				end
				
				card:setEnabled(false)
				self.right_chi_bt:addChild(card)

				bt_width = bt_width + size.width * scale

			end

		else

			for i = value - 2, value do
			
				local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, i)
				local size = card:getSize()
				local scale = self.right_chi_bt:getSize().height / size.height * cardScale
				card:setScale(scale)
				card:setPosition(cc.p((i - value + 2) * size.width * scale + size.width * scale / 2, self.right_chi_bt:getSize().height / 2 + 5))

				if value == i then
					--todo
					card:setColor(cc.c3b(140, 140, 140))
				end
				
				card:setEnabled(false)
				self.right_chi_bt:addChild(card)

				bt_width = bt_width + size.width * scale

			end

		end

		local position = self.right_chi_bt:getPosition()
		self.right_chi_bt:setPosition(cc.p(bx_width + bt_width / 2, position.y))
		local size = self.right_chi_bt:getSize()
		self.right_chi_bt:setSize(cc.size(bt_width, size.height))

		bx_width = bx_width + bt_width + 20
		
	end

	return bx_width

end

function ControlPlaneOperator:showGangSelectBox(plane, controlType)

	self.gang_select_bx:removeAllChildren()

	local gangCards = ZZMJ_CONTROL_TABLE["gangCards"]
    
    local cardScale = 1.5
	local bx_width = 20

	for k,v in pairs(gangCards) do

		local bt = ccui.Button:create()
		local bt_width = 0
		local bt_height = 38.55

		for i=1,4 do

			local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, v)
			local size = card:getSize()
			local scale = bt_height / size.height * cardScale
			card:setScale(scale)
			card:setPosition(cc.p((i - 1) * (size.width+2) * scale-2 + size.width * scale / 2, bt_height / 2+7))

			-- card:setEnabled(false)
			card:setTouchEnabled(true)
			card.noScale = true
			card:addTouchEventListener(function(sender, event)
				if event == TOUCH_EVENT_ENDED then
					-- local value = gangCards[sender:getTag()]

					plane:setVisible(false)
					ZZMJ_CONTROLLER:control(bit.band(controlType, CONTROL_TYPE_GANG), sender.m_value)
				end
			end)

			bt:addChild(card)

			bt_width = bt_width + size.width * scale
		end
		--print("bt_width, bt_height-------------------",bt_width, bt_height)
		bt:setPosition(cc.p(bx_width, (66.92 - bt_height) / 2))
		bt:setSize(cc.size(bt_width, bt_height))

		self.gang_select_bx:addChild(bt)
		-- bt:setEnabled(true)
		-- bt:setTouchEnabled(true)
		bt:setTag(k)

		bx_width = bx_width + bt_width + 20
	end

	if #ZZMJ_CONTROL_TABLE["gangCards"] == 1 then
		bx_width = 0
	end

	return bx_width

end

function ControlPlaneOperator:showLgSelectBox(plane, lgCards)
	self.lg_select_box:removeAllChildren()
	plane:setVisible(true)

	local oriX = 30
	for k,v in pairs(lgCards) do
		local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, v)
		local size = card:getSize()
		local scale = 45.0 / size.height
		card:setScale(scale)
		card:setPosition(cc.p(oriX + size.width * scale / 2, self.lg_select_box:getSize().height / 2))

		self.lg_select_box:addChild(card)

		card:setTag(0)
		card:setEnabled(true)

		card:addTouchEventListener(function(sender, event)
				if event == TOUCH_EVENT_ENDED then
					if sender:getTag() == 999 then
						--todo
						sender:setTag(0)
						sender:setColor(cc.c3b(255, 255, 255))
					else
						sender:setTag(999)
						sender:setColor(cc.c3b(140, 140, 140))
					end
				end
			end)

		oriX = oriX + size.width * scale + 30
	end

	plane:setSize(cc.size(oriX + self.commit_bt:getSize().width, plane:getSize().height))
	self.lg_select_box:setSize(cc.size(oriX, self.lg_select_box:getSize().height))
	self.lg_select_box:setPosition(cc.p(self.lg_select_box:getSize().width / 2, self.lg_select_box:getPosition().y))
	self.commit_bt:setPosition(cc.p(self.lg_select_box:getSize().width + self.commit_bt:getSize().width / 2, self.commit_bt:getPosition().y))
end

function ControlPlaneOperator:showTingHuPlane(plane, tingHuCards)

	for k,v in pairs(plane:getChildren()) do
		if not(v:getName() == "title" or v:getName() =="renyipai") then
			v:removeFromParent()
		end
	end

	local tag = 0
	plane:setVisible(true)
	local title = plane:getChildByName("title")
	local renyipai = plane:getChildByName("renyipai")
	      renyipai:setVisible(false)
	local oriX = title:getPosition().x + title:getSize().width / 2
	local cardHeight = plane:getSize().height - 15
	local oriY = plane:getSize().height / 2

	dump(tingHuCards, "-----tingHuCards-----")

	local aa = {}
	for key,val in pairs(tingHuCards) do
		for k,v in pairs(val.huCards) do
			aa[v]=true
		end
	end

	local newtingHuCards={} 
	for key1,val1 in pairs(aa) do 
		table.insert(newtingHuCards, key1)
	end
    table.sort(newtingHuCards)
    
    local renyipaiFlag

    if #newtingHuCards > 25 then --胡任意牌
    	 renyipai:setVisible(true)

         local size = renyipai:getSize()
         renyipaiFlag = true

         oriX = oriX + size.width

    elseif #newtingHuCards==0  then  --重连没给我发胡的牌的时候
    	 plane:setVisible(false)

    else --不胡任意牌，胡特定牌
	    renyipai:setVisible(false)

		for k,v in pairs(newtingHuCards) do

			local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, v)
			local size = card:getSize()
			local scale = cardHeight / size.height
			card:setScale(scale)
			card:setPosition(cc.p(oriX + size.width * scale / 2, oriY))

			plane:addChild(card)
	     
			card:setTag(0)
			card:setEnabled(true)

			oriX = oriX + size.width * scale

		end

	end
    
	title:addTouchEventListener(
    	function(sender,event)

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
                local width = (plane:getChildByName("title")):getSize().width + 16
                local height = plane:getSize().height
                if tag == 0 then
                   plane:setSize(cc.size(width,height))
					for k,v in pairs(plane:getChildren()) do
						if v:getName() ~= "title"  then
							v:setVisible(false)
						end
					end
					tag =  1

                elseif tag == 1 then

                   plane:setSize(cc.size(oriX+20,height))
                   	for k,v in pairs(plane:getChildren()) do
                   		if v:getName() ~= "renyipai" then
							v:setVisible(true)
						elseif renyipaiFlag==true then
						    v:setVisible(true)
						end
					end
					tag = 0 

                end

            end

        end
    )


	plane:setSize(cc.size(oriX + 20, plane:getSize().height))
	plane:setScale(1.3)

end



-- function ControlPlaneOperator:didSelectOutCard(plane, card)

-- 	if TINGSEQ == nil or next(TINGSEQ) == nil then
-- 		return
-- 	end

--     local tingHuCards
-- 	for k,v in pairs(TINGSEQ) do
-- 		if v.card == card then
-- 			tingHuCards = v.tingHuCards
-- 		break
-- 		end
-- 	end

-- 	if tingHuCards == nil  then
-- 		plane:setVisible(false)
-- 		return
-- 	end
    
-- 	for k,v in pairs(plane:getChildren()) do
-- 		if not (v:getName() == "title" or v:getName() =="renyipai") then
-- 			v:removeFromParent()
-- 		end
-- 	end
    
--     local tag = 0 

--     local title = plane:getChildByName("title")
-- 	plane:setVisible(true)

-- 	local renyipai = plane:getChildByName("renyipai")
-- 	      renyipai:setVisible(false)
-- 	local oriX = title:getPosition().x + title:getSize().width / 2
-- 	local cardHeight = plane:getSize().height - 15
-- 	local oriY = plane:getSize().height / 2
--     local renyipaiFlag

--     if #tingHuCards>25 then --胡任意牌
--     	 renyipai:setVisible(true)
--          local size = renyipai:getSize()
--          renyipaiFlag = true

--          oriX = oriX + size.width

--     elseif  #tingHuCards==0  then  --重连没给我发胡的牌的时候
--     	 plane:setVisible(false)
--     else	--不胡任意牌，胡特定牌
--     renyipai:setVisible(false)
-- 	for k,v in pairs(tingHuCards) do	
-- 		local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, v)
-- 		local size = card:getSize()
-- 		local scale = cardHeight / size.height
-- 		card:setScale(scale)
-- 		card:setPosition(cc.p(oriX + size.width * scale / 2, oriY))

-- 		plane:addChild(card)
     
-- 		card:setTag(0)
-- 		card:setEnabled(true)

-- 		oriX = oriX + size.width * scale
-- 	end

-- 	end
     
-- 	plane:setSize(cc.size(oriX + 20, plane:getSize().height))
-- 	title:addTouchEventListener(
--         function(sender,event)

--             --触摸结束
--             if event == TOUCH_EVENT_ENDED then
--                 local width = (plane:getChildByName("title")):getSize().width + 16
--                 local height = plane:getSize().height
--                 if tag == 0 then
--                    plane:setSize(cc.size(width,height))
-- 					for k,v in pairs(plane:getChildren()) do
-- 						if not (v:getName() == "title") then
-- 							v:setVisible(false)
-- 						end
-- 					end
-- 					tag =  1
--                 elseif tag == 1 then
--                    plane:setSize(cc.size(oriX + 20,height))
--                    	for k,v in pairs(plane:getChildren()) do
--                    		if not (v:getName() == "renyipai") then
-- 							v:setVisible(true)
-- 						elseif renyipaiFlag==true then
-- 						    v:setVisible(true)
-- 						end
-- 					end
-- 					tag = 0 
--                 end
--             end
--         end
--     )
-- end

return ControlPlaneOperator