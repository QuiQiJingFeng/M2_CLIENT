<GameFile>
  <PropertyGroup Name="mlnnRuleListLayer" Type="Layer" ID="fe46bda1-831f-485d-b5be-0e58dfd5842b" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="3904" ctype="GameLayerObjectData">
        <Size X="900.0000" Y="546.0000" />
        <Children>
          <AbstractNodeData Name="RuleList" ActionTag="1949781716" Tag="3905" IconVisible="False" PositionPercentYEnabled="True" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
            <Size X="900.0000" Y="546.0000" />
            <Children>
              <AbstractNodeData Name="Text_1" ActionTag="1027513037" Tag="3906" IconVisible="False" RightMargin="120.0000" FontSize="26" LabelText="拼十规则&#xA;&#xA;一、牌型规则&#xA;1.牌面数值：10、J、Q、K都为10，其他按牌面数字计算。&#xA;2.取其中3张牌数值相加，如果和是10的倍数，则剩余2张&#xA;牌相加之和取个位数即为十X。如果剩余2张牌相加之和也&#xA;是10的倍数即为双十牌型。&#xA;3. 五小：所有牌均小于等于5，点数总和小于等于10&#xA;  炸弹：有4张相同牌&#xA;  五花：5张牌均为JQK&#xA;4.5张牌中任意3张牌之和都不能为10的倍数，则判定为没十。&#xA;5.牌型大小顺序为：五小&gt;五花&gt;炸弹&gt;双十&gt;十九&gt;十八&#xA;&gt;十七&gt;十六&gt;十五&gt;十四&gt;十三&gt;十二&gt;十一&gt;没十。&#xA;6.如果点数相同，则比较五张手牌中最大的那张牌的大小，&#xA;顺序为：k&gt;Q&gt;J&gt;10&gt;9&gt;8&gt;7&gt;6&gt;5&gt;4&gt;3&gt;2&gt;A。炸弹牌型比较炸弹大小。&#xA;7.如果点数相同，最大那张牌的数字也相同，则比较花色，&#xA;大小顺序为黑红梅方。&#xA;8.创建房间时，可以选择每种牌型的倍数，获胜积分=对应&#xA;牌型的倍数*下注额。&#xA;9.翻倍规则为：十七*2，十八*2，十九*3，双十*4，炸弹*5，&#xA;五花*6，五小*8&#xA;&#xA;二、庄家规则&#xA;1.自由抢庄：每局开始玩家均可以选择是否抢庄，如果只有&#xA;一个玩家抢庄，则抢庄玩家坐庄；如果多人抢庄，则从中随机&#xA;一名玩家坐庄，如果无人抢庄，则从所有玩家中随机一名玩家坐庄。&#xA;2.双十上庄：第一局随机庄家。在玩家抓到双十牌型之后，&#xA;下一局会成为庄家；如果一局中有多个玩家抓到双十牌型，&#xA;则双十最大的玩家下一局成为庄家；如果本局无双十牌型，&#xA;则本局庄家下局连庄。&#xA;3.房主坐庄：房主固定为庄家，在游戏中庄家不可以变更。&#xA;房主在创建房间的时候可以设置上庄底分，当输的分数达&#xA;到上庄底分时，游戏立即结束。&#xA;4.明牌抢庄：玩家根据手中已经亮开的四张牌决定抢庄或者不抢，&#xA;抢庄倍数最大的玩家坐庄；如果多名玩家都选择最大倍数，&#xA;则从中随机一名玩家坐庄；如果无人抢庄，则从所有玩家中&#xA;随机一名玩家坐庄。&#xA;5.通比拼十：无庄家，速度快，牌最大者赢全场。&#xA;6.轮流坐庄：第一局随机庄家。之后逆时针方向依次轮流坐庄。&#xA;&#xA;三、用语解释&#xA;1.庄闲：每局中会有一个庄家，剩余玩家为闲家。闲家在&#xA;游戏中进行下注，庄家不需要下注。&#xA;2.亮牌：玩家将手上的牌面公示给其他玩家。&#xA;3.比牌：庄家跟闲家一一比较牌型大小，按照牌型大小顺序。&#xA;4.结算：闲家和庄家一一结算，根据闲家的下注数额及双方&#xA;牌型计算输赢积分。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="780.0000" Y="1222.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="390.0000" Y="611.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="116" G="61" B="0" />
                <PrePosition X="0.4333" Y="0.5000" />
                <PreSize X="0.8667" Y="1.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="1.0000" />
            <Position Y="546.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition Y="1.0000" />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="150" B="255" />
            <FirstColor A="255" R="150" G="150" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>