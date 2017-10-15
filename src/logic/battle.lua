Game.logic.battle = { handler = {} }

local manager = Game.manager
local network = manager.network

local BATTLE_STATE = {
    NONE = 1,
    INIT = 2,
    SHOW_DIALOG = 3,

    SHOW_BATTLE_ROUND = 4,
    SHOW_SKILL = 5,
    BUFF_SETTLEMENT = 6,
    SWITCH_PLAYER = 7,

    RESULT = 8,
    FINISH = 9,
}

local battle = Game.logic.battle
local handler = battle.handler

function battle:init(battle_data)
    self.battle_layer = nil
    self.state = BATTLE_STATE.NONE
    self.next_state = BATTLE_STATE.NONE

    self.battle_data = battle_data
    self.round_num = 1
    self.player_index = 1
end

function battle:setState(state)
    self.next_state = state
end

function battle:nextState()
    self.next_state = self.state + 1
end

function battle:onUpdate(dt)
    if self.state ~= self.next_state then
        self.state = self.next_state

        if self.state == BATTLE_STATE.NONE then
        elseif self.state == BATTLE_STATE.INIT then
            printLog("BATTLE", "初始化")

            local scene = display.getRunningScene()
            self.battle_layer = scene:showLayer("battle", self.battle_data.player1, self.battle_data.player2)

        elseif self.state == BATTLE_STATE.SHOW_DIALOG then
            printLog("BATTLE", "对话")
            self.battle_layer:showDialog()
        elseif self.state == BATTLE_STATE.SHOW_BATTLE_ROUND then
            printLog("BATTLE", "第%d回合", self.round_num)
            self.battle_layer:showBattleRound()
        elseif self.state == BATTLE_STATE.SHOW_SKILL then
            printLog("BATTLE", "攻击阶段")
            self.battle_layer:showSkill(self:getActionList())
        elseif self.state == BATTLE_STATE.BUFF_SETTLEMENT then
            printLog("BATTLE", "BUFF结算")
            self.battle_layer:showBuffSettlement(self:getBuffSettlementList())
        elseif self.state == BATTLE_STATE.SWITCH_PLAYER then
            if self.player_index < 2 then
                printLog("BATTLE", "交换出手方")
                self.player_index = self.player_index + 1
                self:setState(BATTLE_STATE.SHOW_SKILL)
            elseif self.round_num < #self:getRoundList() then
                self.round_num = self.round_num + 1
                self.player_index = 1
                self:setState(BATTLE_STATE.SHOW_BATTLE_ROUND)
            else
                self:nextState()
            end
        elseif self.state == BATTLE_STATE.RESULT then
            printLog("BATTLE", "结算")

            self:nextState()
        elseif self.state == BATTLE_STATE.FINISH then
            printLog("BATTLE", "完成")

            self:nextState()
        end
    end
end

function battle:getRoundList()
    return checktable(self.battle_data.round_list)
end
function battle:getRoundData()
    return checktable(self:getRoundList()[self.round_num])
end
function battle:getActionList()
    return checktable(checktable(self:getRoundData()[self.player_index]).action_list)
end
function battle:getBuffSettlementList()
    return checktable(checktable(self:getRoundData()[self.player_index]).buff_settlement_list)
end