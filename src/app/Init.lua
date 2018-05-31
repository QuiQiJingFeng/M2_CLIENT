lt = {}
ltMetaTable = {}
setmetatable(lt, ltMetaTable)

ltMetaTable.__index = function(table, name)
    table[name] = require(ltMetaTable[name])
    return table[name]
end

function lt.getClass(name)
    if lt[name] == nil then
        lt[name] = require(ltMetaTable[name])
    end

    return lt[name]
end

-- game
--ltMetaTable["AppGame"] = "app.AppGame"
--common
ltMetaTable["CommonUtil"] = "app.Common.CommonUtil"

ltMetaTable["Constants"] = "app.Common.Constants"
ltMetaTable["LanguageString"] = "app.Common.LanguageString"
ltMetaTable["HeadImage"] = "app.Common.HeadImage"

--manager
ltMetaTable["ActivityPushManager"] = "app.Manager.ActivityPushManager"
ltMetaTable["AudioManager"] = "app.Manager.AudioManager"
ltMetaTable["AudioMsgManager"] = "app.Manager.AudioMsgManager"
ltMetaTable["ConfigManager"] = "app.Manager.ConfigManager"
ltMetaTable["DataManager"] = "app.Manager.DataManager"
ltMetaTable["CacheManager"] = "app.Manager.CacheManager"
ltMetaTable["GameEventManager"] = "app.Manager.GameEventManager"
ltMetaTable["NewFlagManager"] = "app.Manager.NewFlagManager"
ltMetaTable["NoticeManager"] = "app.Manager.NoticeManager"
ltMetaTable["PreferenceManager"] = "app.Manager.PreferenceManager"
ltMetaTable["PushManager"] = "app.Manager.PushManager"
ltMetaTable["StringManager"] = "app.Manager.StringManager"
ltMetaTable["UILayerManager"] = "app.Manager.UILayerManager"
ltMetaTable["ResourceManager"] = "app.Manager.ResourceManager"
ltMetaTable["SceneManager"] = "app.Manager.SceneManager"

--net
ltMetaTable["Protobuf"] = "app.Net.Protobuf"
ltMetaTable["NetWork"] = "app.Net.NetWork"
ltMetaTable["SocketConstants"] = "app.Net.SocketConstants"

--msgbox
ltMetaTable["MsgboxLayer"] = "app.UI.MsgboxLayer"

--luaj
ltMetaTable["Luaj"] = "cocos/cocos2d/luaj"
--luaoc
ltMetaTable["Luaoc"] = "cocos/cocos2d/luaoc"

--Scene
ltMetaTable["Initagreement"] = "app.Scene.InitScene.Initagreement"
ltMetaTable["InitLayer"] = "app.Scene.InitScene.InitLayer"
ltMetaTable["InitScene"] = "app.Scene.InitScene.InitScene"

ltMetaTable["StartLayer"] = "app.Scene.StartScene.StartLayer"
ltMetaTable["StartScene"] = "app.Scene.StartScene.StartScene"

ltMetaTable["WorldLayer"] = "app.Scene.WorldScene.WorldLayer"
ltMetaTable["WorldLoadingLayer"] = "app.Scene.WorldScene.WorldLoadingLayer"
ltMetaTable["WorldMenuLayer"] = "app.Scene.WorldScene.WorldMenuLayer"
ltMetaTable["WorldNoticeLayer"] = "app.Scene.WorldScene.WorldNoticeLayer"
ltMetaTable["WorldResultLayer"] = "app.Scene.WorldScene.WorldResultLayer"
ltMetaTable["WorldUILayer"] = "app.Scene.WorldScene.WorldUILayer"
ltMetaTable["WorldScene"] = "app.Scene.WorldScene.WorldScene"

--layer
ltMetaTable["BaseLayer"]			    = "app.Scene.WorldScene.Common.BaseLayer"
ltMetaTable["KefuLayer"]			    	= "app.Scene.WorldScene.LobbyBtn.KefuLayer"
ltMetaTable["SetLayer"]			    	= "app.Scene.WorldScene.LobbyBtn.SetLayer"
ltMetaTable["WXShareLayer"]			= "app.Scene.WorldScene.LobbyBtn.WXShareLayer"
ltMetaTable["lobbyInfoLayer"]			= "app.Scene.WorldScene.LobbyBtn.infoLayer"
ltMetaTable["ShopLayer"]			= "app.Scene.WorldScene.LobbyBtn.ShopLayer"
ltMetaTable["PaytypeLayer"]			= "app.Scene.WorldScene.LobbyBtn.PaytypeLayer"
ltMetaTable["LobbyNoticeMsgBoxLayer"]			= "app.Scene.WorldScene.LobbyBtn.LobbyNoticeMsgBoxLayer"
ltMetaTable["MergeLayer"]			= "app.Scene.WorldScene.LobbyBtn.MergeLayer"
ltMetaTable["ReplayView"]			= "app.Scene.WorldScene.LobbyBtn.ReplayView"
ltMetaTable["Replayitem"]			= "app.Scene.WorldScene.LobbyBtn.Replayitem"
ltMetaTable["ReplaycodeLayer"]			= "app.Scene.WorldScene.LobbyBtn.ReplaycodeLayer"
ltMetaTable["ReplayWatchLayer"]			= "app.Scene.WorldScene.LobbyBtn.ReplayWatchLayer"
ltMetaTable["ReplayWatchitem"]			= "app.Scene.WorldScene.LobbyBtn.ReplayWatchitem"
ltMetaTable["LobbyHelpLayer"]			= "app.Scene.WorldScene.LobbyBtn.LobbyHelpLayer"


ltMetaTable["JoinRoomLayer"]			= "app.Scene.WorldScene.Room.JoinRoomLayer"
ltMetaTable["CreateRoomLayer"]			= "app.Scene.WorldScene.Room.CreateRoomLayer"


--游戏场景

ltMetaTable["GameScene"] = "app.Scene.GameScene.GameScene"

--麻将引擎
ltMetaTable["MjEngine"] = "app.Scene.GameScene.common.MjEngine"

--麻将
ltMetaTable["ApplyGameOverPanel"] = "app.Scene.GameScene.mj.ApplyGameOverPanel"

ltMetaTable["MjStandFaceItem"] = "app.Scene.GameScene.mj.cardItem.MjStandFaceItem"
ltMetaTable["MjLieCpgItem"] = "app.Scene.GameScene.mj.cardItem.MjLieCpgItem"
ltMetaTable["MjLieOutFaceItem"] = "app.Scene.GameScene.mj.cardItem.MjLieOutFaceItem"

ltMetaTable["GameRoomLayer"] = "app.Scene.GameScene.mj.GameRoomLayer"
ltMetaTable["GameBgPanel"] = "app.Scene.GameScene.mj.GameBgPanel"
ltMetaTable["GameCompassPanel"] = "app.Scene.GameScene.mj.GameCompassPanel"

ltMetaTable["GamePlayCardsPanel"] = "app.Scene.GameScene.mj.GamePlayCardsPanel"
ltMetaTable["GameSelectPosPanel"] = "app.Scene.GameScene.mj.GameSelectPosPanel"
ltMetaTable["GameSetPanel"] = "app.Scene.GameScene.mj.GameSetPanel"
ltMetaTable["GameRoomInfoPanel"] = "app.Scene.GameScene.mj.GameRoomInfoPanel"
ltMetaTable["GameActionBtnsPanel"] = "app.Scene.GameScene.mj.GameActionBtnsPanel"
ltMetaTable["GameResultPanel"] = "app.Scene.GameScene.mj.GameResultPanel"
ltMetaTable["WinAwardCodeLayer"] = "app.Scene.GameScene.mj.WinAwardCodeLayer"
ltMetaTable["ResultTotalEnditems"] = "app.Scene.GameScene.mj.ResultTotalEnditems"
ltMetaTable["GmaeResultTotalEndLayer"] = "app.Scene.GameScene.mj.GmaeResultTotalEndLayer"
ltMetaTable["GameEndExploitsLayer"] = "app.Scene.GameScene.mj.GameEndExploitsLayer"

ltMetaTable["SettingLayer"] = "app.Scene.GameScene.mj.SettingLayer"

-- ddz
ltMetaTable["DDZGameLayer"]			= "app.Scene.GameScene.ddz.DDZGameLayer"
ltMetaTable["DDZGameScene"]			= "app.Scene.GameScene.ddz.DDZGameScene"

-- Widget
ltMetaTable["ScrollNumber"]				= "app.Widget.ScrollNumber"
ltMetaTable["ScrollView"]               = "app.Widget.ScrollView"
ltMetaTable["ScrollViewCell"]           = "app.Widget.ScrollViewCell"

