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

--net
ltMetaTable["Protobuf"] = "app.Net.Protobuf"
ltMetaTable["NetWork"] = "app.Net.NetWork"
ltMetaTable["SocketConstants"] = "app.Net.SocketConstants"

--msgbox
ltMetaTable["MsgboxLayer"] = "app.UI.MsgboxLayer"

--Scene
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
ltMetaTable["SetLayer"]			    	= "app.Scene.WorldScene.Setting.SetLayer"

ltMetaTable["JoinRoomLayer"]			= "app.Scene.WorldScene.Room.JoinRoomLayer"
ltMetaTable["CreateRoomLayer"]			= "app.Scene.WorldScene.Room.CreateRoomLayer"


--游戏场景

ltMetaTable["GameScene"] = "app.Scene.GameScene.GameScene"

--麻将
ltMetaTable["GameRoomLayer"] = "app.Scene.GameScene.mj.GameRoomLayer"
ltMetaTable["GameBgPanel"] = "app.Scene.GameScene.mj.GameBgPanel"
ltMetaTable["GamePlayCardsPanel"] = "app.Scene.GameScene.mj.GamePlayCardsPanel"
ltMetaTable["GameSelectPosPanel"] = "app.Scene.GameScene.mj.GameSelectPosPanel"
ltMetaTable["GameSetPanel"] = "app.Scene.GameScene.mj.GameSetPanel"
ltMetaTable["GameRoomInfoPanel"] = "app.Scene.GameScene.mj.GameRoomInfoPanel"
ltMetaTable["GameActionBtnsPanel"] = "app.Scene.GameScene.mj.GameActionBtnsPanel"
ltMetaTable["GameResultPanel"] = "app.Scene.GameScene.mj.GameResultPanel"
ltMetaTable["WinAwardCodeLayer"] = "app.Scene.GameScene.mj.WinAwardCodeLayer"

ltMetaTable["SettingLayer"] = "app.Scene.GameScene.mj.SettingLayer"

-- ddz
ltMetaTable["DDZGameLayer"]			= "app.Scene.GameScene.ddz.DDZGameLayer"
ltMetaTable["DDZGameScene"]			= "app.Scene.GameScene.ddz.DDZGameScene"







-- Widget
ltMetaTable["BigOccupaitonIcon"]		= "app.Widget.BigOccupaitonIcon"
ltMetaTable["BubbleIcon"]				= "app.Widget.BubbleIcon"
ltMetaTable["CharacterItemIcon"]		= "app.Widget.CharacterItemIcon"
ltMetaTable["ChatMessageCell"]			= "app.Widget.ChatMessageCell"
ltMetaTable["ChatIcon"]					= "app.Widget.ChatIcon"
ltMetaTable["ChatInfo"]					= "app.Widget.ChatInfo"
ltMetaTable["CheckBox"]					= "app.Widget.CheckBox"
ltMetaTable["CheckButton"]				= "app.Widget.CheckButton"
ltMetaTable["CommonBg"]				    = "app.Widget.CommonBg"
ltMetaTable["DressIcon"]				= "app.Widget.DressIcon"
ltMetaTable["DropButton"]				= "app.Widget.DropButton"
ltMetaTable["DropDown"]					= "app.Widget.DropDown"
ltMetaTable["DropList"]					= "app.Widget.DropList"
ltMetaTable["Emoji"]					= "app.Widget.Emoji"
ltMetaTable["FigureIcon"]				= "app.Widget.FigureIcon"
ltMetaTable["GameBar"]					= "app.Widget.GameBar"
ltMetaTable["GameButtonInput"]			= "app.Widget.GameButtonInput"
ltMetaTable["GameBMLabel"]				= "app.Widget.GameBMLabel"
ltMetaTable["GameCount"]				= "app.Widget.GameCount"
ltMetaTable["GameIcon"]					= "app.Widget.GameIcon"
ltMetaTable["GemIcon"]					= "app.Widget.GemIcon"
ltMetaTable["GameInfoBg"]				= "app.Widget.GameInfoBg"
ltMetaTable["GameListBg"]				= "app.Widget.GameListBg"
ltMetaTable["GameListCell"]				= "app.Widget.GameListCell"
ltMetaTable["GameLabel"]                = "app.Widget.GameLabel"
ltMetaTable["GameNumberLabel"]          = "app.Widget.GameNumberLabel"
ltMetaTable["GameTitleLabel"]           = "app.Widget.GameTitleLabel"
ltMetaTable["GameLine"]					= "app.Widget.GameLine"
ltMetaTable["GamePageView"]				= "app.Widget.GamePageView"
ltMetaTable["GamePanel"]				= "app.Widget.GamePanel"
ltMetaTable["GameMenuTab"]				= "app.Widget.GameMenuTab"
ltMetaTable["GameNewPanel"]				= "app.Widget.GameNewPanel"
ltMetaTable["GamePlayerIcon"]			= "app.Widget.GamePlayerIcon"
ltMetaTable["GraySprite"]				= "app.Widget.GraySprite"
ltMetaTable["GuildBg"]					= "app.Widget.GuildBg"
ltMetaTable["GamePrompt"]				= "app.Widget.GamePrompt"
ltMetaTable["GamePromptNode"]			= "app.Widget.GamePromptNode"
ltMetaTable["GameInput"]			    = "app.Widget.GameInput"
ltMetaTable["LabelTab"]                 = "app.Widget.LabelTab"
ltMetaTable["ListView"]					= "app.Widget.ListView"
ltMetaTable["MapFrame"]                 = "app.Widget.MapFrame"
ltMetaTable["MessageBoard"]             = "app.Widget.MessageBoard"
ltMetaTable["MessageCell"]              = "app.Widget.MessageCell"
ltMetaTable["MessageNode"]              = "app.Widget.MessageNode"
ltMetaTable["MissionButton"]            = "app.Widget.MissionButton"
ltMetaTable["MissionPanel"]             = "app.Widget.MissionPanel"
ltMetaTable["MultipleDropDown"]         = "app.Widget.MultipleDropDown"
ltMetaTable["NetSprite"]				= "app.Widget.NetSprite"
ltMetaTable["NumberKeyBoard"]           = "app.Widget.NumberKeyBoard"
ltMetaTable["NumberScroll"]           	= "app.Widget.NumberScroll"
ltMetaTable["OccupationIcon"]           = "app.Widget.OccupationIcon"
ltMetaTable["PageControl"]				= "app.Widget.PageControl"
ltMetaTable["PropertyGraphNode"]        = "app.Widget.PropertyGraphNode"
ltMetaTable["PropertyIcon"]        		= "app.Widget.PropertyIcon"
ltMetaTable["PropertyRelationship"]		= "app.Widget.PropertyRelationship"
ltMetaTable["PlayerFace"]				= "app.Widget.PlayerFace"
ltMetaTable["PlayerFaceButton"]			= "app.Widget.PlayerFaceButton"

ltMetaTable["PlayerExp"]				= "app.Widget.PlayerExp"
ltMetaTable["PlayerBattery"]			= "app.Widget.PlayerBattery"
ltMetaTable["RuneIcon"]					= "app.Widget.RuneIcon"
ltMetaTable["RichLabel"]        		= "app.Widget.RichLabel"
ltMetaTable["RichMultiDropDown"]        = "app.Widget.RichMultiDropDown"
ltMetaTable["RichNewLine"]				= "app.Widget.RichNewLine"
ltMetaTable["RichText"]            		= "app.Widget.RichText"
ltMetaTable["RichTextImage"]            = "app.Widget.RichTextImage"
ltMetaTable["RichTextNode"]             = "app.Widget.RichTextNode"
ltMetaTable["RichTextText"]             = "app.Widget.RichTextText"
ltMetaTable["RichTextScaleNode"]        = "app.Widget.RichTextScaleNode"
ltMetaTable["RollingLabel"]				= "app.Widget.RollingLabel"
ltMetaTable["RollingChatNode"]			= "app.Widget.RollingChatNode"
ltMetaTable["PushButton"]				= "app.Widget.PushButton"
ltMetaTable["ScaleBMLabelButton"]		= "app.Widget.ScaleBMLabelButton"
ltMetaTable["ScaleButton"]              = "app.Widget.ScaleButton"
ltMetaTable["ScaleLabelButton"]			= "app.Widget.ScaleLabelButton"
ltMetaTable["SceneManager"]			    = "app.Widget.SceneManager"
ltMetaTable["ScrollNumber"]				= "app.Widget.ScrollNumber"
ltMetaTable["ScrollView"]               = "app.Widget.ScrollView"
ltMetaTable["ScrollViewCell"]           = "app.Widget.ScrollViewCell"
ltMetaTable["ServantCardL"]				= "app.Widget.ServantCardL"
ltMetaTable["ServantCardM"]				= "app.Widget.ServantCardM"
ltMetaTable["ServantCardS"]				= "app.Widget.ServantCardS"
ltMetaTable["ServantCharacterIcon"]		= "app.Widget.ServantCharacterIcon"
ltMetaTable["ServantIcon"]		        = "app.Widget.ServantIcon"
ltMetaTable["SkeletonAnimation"]		= "app.Widget.SkeletonAnimation"
ltMetaTable["SkillMonsterIcon"]			= "app.Widget.SkillMonsterIcon"
ltMetaTable["SkillServantIcon"]			= "app.Widget.SkillServantIcon"
ltMetaTable["SmallOccupationIcon"]		= "app.Widget.SmallOccupationIcon"
ltMetaTable["SpSkeletonAnimation"]		= "app.Widget.SpSkeletonAnimation"
ltMetaTable["StarItemNode"]             = "app.Widget.StarItemNode"
ltMetaTable["StarNode"]                 = "app.Widget.StarNode"
ltMetaTable["StateTalk"]                = "app.Widget.StateTalk"
ltMetaTable["SwitchButton"]				= "app.Widget.SwitchButton"
ltMetaTable["SwitchButtonGroup"]		= "app.Widget.SwitchButtonGroup"
ltMetaTable["SkillIcon"]				= "app.Widget.SkillIcon"
ltMetaTable["TopBanner"]				= "app.Widget.TopBanner"
ltMetaTable["UIGamePageView"]			= "app.Widget.UIGamePageView"
ltMetaTable["UIManager"]			    = "app.Widget.UIManager"
ltMetaTable["VoiceCell"]			    = "app.Widget.VoiceCell"
ltMetaTable["VoicingNode"]			    = "app.Widget.VoicingNode"
ltMetaTable["WeaponIcon"]			    = "app.Widget.WeaponIcon"




