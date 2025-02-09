--[[
    item 参数：
    1.gameID
    2.选中态按钮文字
    3.未选中态按钮文字
    4.是否显示新游戏图标（0:不显示  1:显示）
    5.是否显示免费图标（0:不显示  1:显示）
    6.房间规则配置表
    -- 7.字体缩放
    -- 8.未开启
    -- 9.列表ID
    -- 10.默认规则
    11.打折
]]


local PLZConf =
{
    intGameId = "HZMJ",
    intGamePlayer = 4,
    -- tFastInfo = {
    --     "快点啊，都等的我花儿都谢了！",
    --     "别吵了，专心玩游戏！",
    --     "你是妹妹还是哥哥啊？",
    --     "大家好,很高兴见到各位！",
    --     "又断线了，网络怎么这么差！",
    --     "和你合作真是太愉快了",
    --     "下次再玩吧，我要走了。",
    --     "不要走，决战到天亮。",
    --     "我们交个朋友吧，告诉我你的联系方法。",
    --     "各位，真不好意思，我要离开会。", 
    -- },
    tGamesRule = {
        pay = {
            "玩家平摊",
            "房主出资",
            "大赢家出资",
        },
        -- 圈数信息
        round = {
            {
                "4局",
                20,
                5,
                -- 4,
            },
            {
                "8局",
                40,
                10,
                -- 8,
            },
            {
                "16局",
                80,
                20,
                -- 16,
            }
        },   
        -- 底分
        baseScore = {1,2,5,10,20,40,50,100},
        --胡牌信息
        playRule = { 
            {"可胡七对",0},    
        },
        --奖码规则
        winRule = {
            "2个",
            "4个",
            "6个",
        },
        tStartRule = {0,0,1,0,0,0,0,0,0,1},
     },
}


return PLZConf
