<GameFile>
  <PropertyGroup Name="GameRuleLayer" Type="Layer" ID="6a34b9e1-b055-485e-99e1-072fbc5f0f21" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="53" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="Ie_Mark" ActionTag="-1108098364" Tag="134" IconVisible="False" HorizontalEdge="BothEdge" VerticalEdge="BothEdge" LeftMargin="-0.0200" RightMargin="0.0200" StretchWidthEnable="True" StretchHeightEnable="True" LeftEage="17" RightEage="17" TopEage="15" BottomEage="15" Scale9OriginX="17" Scale9OriginY="15" Scale9Width="19" Scale9Height="18" ctype="ImageViewObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="666.9800" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/bgMask.png" Plist="games/mlnn/game_2.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="Ie_Bg" ActionTag="243452451" Tag="287" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="305.0000" RightMargin="309.0000" TopMargin="150.0000" BottomMargin="150.0000" TouchEnable="True" Scale9Enable="True" LeftEage="27" RightEage="27" TopEage="36" BottomEage="36" Scale9OriginX="27" Scale9OriginY="36" Scale9Width="494" Scale9Height="296" ctype="ImageViewObjectData">
            <Size X="720.0000" Y="450.0000" />
            <Children>
              <AbstractNodeData Name="LV_GameRule" ActionTag="-1103254868" VisibleForFrame="False" Tag="906" IconVisible="False" LeftMargin="20.5742" RightMargin="18.1049" TopMargin="84.9289" BottomMargin="24.8929" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" ItemMargin="20" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="681.3209" Y="340.1782" />
                <Children>
                  <AbstractNodeData Name="Text_1" ActionTag="179052607" Tag="3217" IconVisible="False" RightMargin="9.3209" FontSize="24" LabelText="牛牛规则&#xA;&#xA;一、牌型规则&#xA;1.牌面数值：10、J、Q、K都为10，其他按牌面数字计算。&#xA;2.取其中3张牌数值相加，如果和是10的倍数，则剩余2&#xA;张牌相加只和取个位数即为牛X。如果剩余2张牌相加之&#xA;和也是10的倍数即为牛牛牌型。&#xA;3.五小牛：所有牌均小于等于5，点数总和小于等于10&#xA;  炸弹牛：有4张相同牌&#xA;  五花牛：5张牌均为JQK&#xA;4.5张牌中任意3张牌之和都不能为10的倍数，则判定&#xA;为无牛。&#xA;5.牌型大小顺序为：五小牛&gt;五花牛&gt;炸弹牛&gt;牛牛&gt;牛九&#xA;&gt;牛八&gt;牛七&gt;牛六&gt;牛五&gt;牛四&gt;牛三&gt;牛二&gt;牛一&gt;无牛。&#xA;6.如果牛数相同，则比较五张手牌中最大&#xA;的那张牌的大小，顺序为：k&gt;Q&gt;J&gt;10&gt;9&gt;8&gt;7&gt;6&gt;5&gt;4&gt;3&gt;&#xA;2&gt;A。炸弹牛比较炸弹大小。&#xA;7.如果牛数相同，最大那张牌的数字也相同，则比较花&#xA;色，大小顺序为黑红梅方。&#xA;8.创建房间时，可以选择每种牌型的倍数，获胜积分=&#xA;对应牌型的倍数*下注额。&#xA;9.翻倍规则为：牛七*2，牛八*2，牛九*3，牛牛*4，&#xA;炸弹牛*5，五花牛*6，五小牛*8&#xA;&#xA;二、庄家规则&#xA;1.自由抢庄：每局开始玩家均可以选择是否抢庄，如果&#xA;只有一个玩家抢庄，则抢庄玩家坐庄；如果多人抢庄，&#xA;则从中随机一名玩家坐庄，如果无人抢庄，则从所有玩&#xA;家中随机一名玩家坐庄。&#xA;2.牛牛上庄：第一局随机庄家。在玩家抓到牛牛牌型之&#xA;后，下一局会成为庄家；如果一局中有多个玩家抓到&#xA;牛牛牌型，则牛牛最大的玩家下一局成为庄家；如果本&#xA;局无牛牛牌型，则本局庄家下局连庄。&#xA;3.房主坐庄：房主固定为庄家，在游戏中庄家不可以变&#xA;更。房主在创建房间的时候可以设置上庄底分，当输的&#xA;分数达到上庄底分时，游戏立即结束。&#xA;4.明牌抢庄：玩家根据手中已经亮开的四张牌决定抢庄&#xA;或者不抢，抢庄倍数最大的玩家坐庄；如果多名玩家都&#xA;选择最大倍数，则从中随机一名玩家坐庄；如果无人抢&#xA;庄，则从所有玩家中随机一名玩家坐庄。&#xA;5.通比牛牛：无庄家，速度快，牌最大者赢全场。&#xA;6.轮流坐庄：第一局随机庄家。之后逆时针方向依次轮流坐庄。&#xA;&#xA;三、用语解释&#xA;1.庄闲：每局中会有一个庄家，剩余玩家为闲家。闲家在&#xA;游戏中进行下注，庄家不需要下注。&#xA;2.亮牌：玩家将手上的牌面公示给其他玩家。&#xA;3.比牌：庄家跟闲家一一比较牌型大小，按照&#xA;牌型大小顺序。&#xA;4.结算：闲家和庄家一一结算，根据闲家的下&#xA;注数额及双方牌型计算输赢积分。&#xA;&#xA;" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="672.0000" Y="1272.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="336.0000" Y="636.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="151" G="175" B="211" />
                    <PrePosition X="0.4932" Y="0.5000" />
                    <PreSize X="0.9863" Y="1.0000" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="20.5742" Y="24.8929" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0286" Y="0.0553" />
                <PreSize X="0.9463" Y="0.7560" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Pl_RoomRule" ActionTag="1019562728" Tag="968" IconVisible="False" LeftMargin="4.9360" RightMargin="5.3736" TopMargin="73.4867" BottomMargin="19.4361" TouchEnable="True" ClipAble="True" BackColorAlpha="0" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="709.6904" Y="357.0772" />
                <Children>
                  <AbstractNodeData Name="Pl_Common" ActionTag="-1127372855" Tag="582" IconVisible="False" LeftMargin="39.9285" RightMargin="2.6487" TopMargin="8.2871" BottomMargin="222.9481" TouchEnable="True" ClipAble="False" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="667.1132" Y="125.8420" />
                    <Children>
                      <AbstractNodeData Name="Text_Title1" ActionTag="-1556458710" Tag="583" IconVisible="False" LeftMargin="-22.2823" RightMargin="585.3955" TopMargin="18.3089" BottomMargin="81.5331" FontSize="26" LabelText="扣    费" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="104.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="-22.2823" Y="94.5331" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="224" G="220" B="255" />
                        <PrePosition X="-0.0334" Y="0.7512" />
                        <PreSize X="0.1559" Y="0.2066" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Bn_Pay1" ActionTag="1440190051" Tag="584" IconVisible="False" LeftMargin="121.9994" RightMargin="496.1138" TopMargin="7.0772" BottomMargin="69.7648" Scale9Enable="True" LeftEage="38" TopEage="10" BottomEage="10" Scale9OriginX="38" Scale9OriginY="10" Scale9Width="11" Scale9Height="29" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="121.9994" Y="94.9998" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1829" Y="0.7549" />
                        <PreSize X="0.0735" Y="0.3894" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Pay1" ActionTag="865377407" Tag="585" IconVisible="False" LeftMargin="176.2719" RightMargin="402.8413" TopMargin="19.8422" BottomMargin="83.9998" FontSize="22" LabelText="房主出资" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="88.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="176.2719" Y="94.9998" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2642" Y="0.7549" />
                        <PreSize X="0.1319" Y="0.1748" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Bn_Pay2" ActionTag="-2143984142" Tag="586" IconVisible="False" LeftMargin="289.9955" RightMargin="328.1177" TopMargin="6.3423" BottomMargin="70.4997" LeftEage="35" TopEage="35" Scale9OriginX="35" Scale9OriginY="35" Scale9Width="14" Scale9Height="14" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="289.9955" Y="94.9997" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4347" Y="0.7549" />
                        <PreSize X="0.0735" Y="0.3894" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Pay2" ActionTag="-473381569" Tag="587" IconVisible="False" LeftMargin="346.4426" RightMargin="232.6706" TopMargin="19.8422" BottomMargin="83.9998" FontSize="22" LabelText="玩家平摊" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="88.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="346.4426" Y="94.9998" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5193" Y="0.7549" />
                        <PreSize X="0.1319" Y="0.1748" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_PayCheck" ActionTag="-791568237" Tag="588" IconVisible="False" LeftMargin="121.9994" RightMargin="496.1138" TopMargin="6.3423" BottomMargin="70.4997" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="29" Scale9Height="29" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="121.9994" Y="94.9997" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1829" Y="0.7549" />
                        <PreSize X="0.0735" Y="0.3894" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_Title2" ActionTag="-976303785" Tag="589" IconVisible="False" LeftMargin="-22.2817" RightMargin="585.3949" TopMargin="77.3085" BottomMargin="22.5335" FontSize="26" LabelText="局    数" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="104.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="-22.2817" Y="35.5335" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="224" G="220" B="255" />
                        <PrePosition X="-0.0334" Y="0.2824" />
                        <PreSize X="0.1559" Y="0.2066" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Bn_Round1" ActionTag="1368012560" Tag="590" IconVisible="False" LeftMargin="121.9996" RightMargin="496.1136" TopMargin="66.0772" BottomMargin="10.7648" Scale9Enable="True" LeftEage="55" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="6" Scale9Height="29" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="121.9996" Y="35.9998" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1829" Y="0.2861" />
                        <PreSize X="0.0735" Y="0.3894" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Round1" ActionTag="766493038" Tag="591" IconVisible="False" LeftMargin="177.7159" RightMargin="445.3973" TopMargin="78.8422" BottomMargin="24.9998" FontSize="22" LabelText="10局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="44.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="177.7159" Y="35.9998" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2664" Y="0.2861" />
                        <PreSize X="0.0660" Y="0.1748" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Bn_Round2" ActionTag="-735717482" Tag="592" IconVisible="False" LeftMargin="289.9955" RightMargin="328.1177" TopMargin="65.3428" BottomMargin="11.4992" Scale9Enable="True" LeftEage="55" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="6" Scale9Height="29" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="289.9955" Y="35.9992" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4347" Y="0.2861" />
                        <PreSize X="0.0735" Y="0.3894" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Round2" ActionTag="-778459989" Tag="593" IconVisible="False" LeftMargin="347.4426" RightMargin="275.6706" TopMargin="78.8422" BottomMargin="24.9998" FontSize="22" LabelText="20局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="44.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="347.4426" Y="35.9998" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5208" Y="0.2861" />
                        <PreSize X="0.0660" Y="0.1748" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_RoundCheck" ActionTag="-1752466620" Tag="594" IconVisible="False" LeftMargin="121.9996" RightMargin="496.1136" TopMargin="65.3428" BottomMargin="11.4992" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="29" Scale9Height="29" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="121.9996" Y="35.9992" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1829" Y="0.2861" />
                        <PreSize X="0.0735" Y="0.3894" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="1.0000" />
                    <Position X="39.9285" Y="348.7901" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0563" Y="0.9768" />
                    <PreSize X="0.9400" Y="0.3524" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Pl_MLNN" ActionTag="-1826575626" Tag="549" IconVisible="False" LeftMargin="39.5035" RightMargin="1.2275" TopMargin="144.0085" BottomMargin="-19.5319" ClipAble="False" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="668.9594" Y="232.6006" />
                    <Children>
                      <AbstractNodeData Name="Text_Title1" ActionTag="-2064852241" Alpha="0" Tag="550" IconVisible="False" LeftMargin="-18.5617" RightMargin="583.5211" TopMargin="-12.9675" BottomMargin="219.5681" FontSize="26" LabelText="翻倍规则" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="104.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="-18.5617" Y="232.5681" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="224" G="220" B="255" />
                        <PrePosition X="-0.0277" Y="0.9999" />
                        <PreSize X="0.1555" Y="0.1118" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Bn_WinRule1" ActionTag="36139313" Alpha="0" Tag="551" IconVisible="False" LeftMargin="121.0008" RightMargin="498.9586" TopMargin="-25.9011" BottomMargin="209.5017" TouchEnable="True" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="121.0008" Y="234.0017" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1809" Y="1.0060" />
                        <PreSize X="0.0732" Y="0.2107" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_WinRule1" ActionTag="-1511450172" Alpha="0" Tag="552" IconVisible="False" LeftMargin="172.1464" RightMargin="155.8130" TopMargin="-12.4026" BottomMargin="223.0032" FontSize="22" LabelText="牛牛×4 牛九×3 牛八×2 牛七×2" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="341.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="172.1464" Y="234.0032" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2573" Y="1.0060" />
                        <PreSize X="0.5097" Y="0.0946" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Bn_WinRule2" ActionTag="147797297" Alpha="0" Tag="553" IconVisible="False" LeftMargin="121.0008" RightMargin="498.9586" TopMargin="26.0991" BottomMargin="157.5015" TouchEnable="True" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="121.0008" Y="182.0015" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1809" Y="0.7825" />
                        <PreSize X="0.0732" Y="0.2107" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_WinRule2" ActionTag="-117260844" Alpha="0" Tag="554" IconVisible="False" LeftMargin="174.1427" RightMargin="241.8167" TopMargin="37.5970" BottomMargin="173.0036" FontSize="22" LabelText="牛牛×3 牛九×2 牛八×2" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="253.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="174.1427" Y="184.0036" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2603" Y="0.7911" />
                        <PreSize X="0.3782" Y="0.0946" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_WinRuleCheck" ActionTag="1533521758" Alpha="0" Tag="555" IconVisible="False" LeftMargin="121.0008" RightMargin="498.9586" TopMargin="-25.9010" BottomMargin="209.5016" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="29" Scale9Height="29" ctype="ImageViewObjectData">
                        <Size X="49.0000" Y="49.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="121.0008" Y="234.0016" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1809" Y="1.0060" />
                        <PreSize X="0.0732" Y="0.2107" />
                        <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_1.png" Plist="games/mlnn/game_2.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Node_BankerPanel" ActionTag="-1448719402" Tag="556" IconVisible="True" LeftMargin="3.0000" RightMargin="665.9594" TopMargin="125.5974" BottomMargin="107.0032" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_Title1" ActionTag="-2129389534" Tag="557" IconVisible="False" LeftMargin="-19.4373" RightMargin="-84.5627" TopMargin="7.9993" BottomMargin="-33.9993" FontSize="26" LabelText="最大抢庄" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="104.0000" Y="26.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="-19.4373" Y="-20.9993" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="224" G="220" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule1" ActionTag="-693318268" Tag="558" IconVisible="False" LeftMargin="121.0002" RightMargin="-170.0002" TopMargin="-3.5013" BottomMargin="-45.4987" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="121.0002" Y="-20.9987" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule1" ActionTag="1916244405" Tag="559" IconVisible="False" LeftMargin="176.1408" RightMargin="-209.1408" TopMargin="10.3475" BottomMargin="-32.3475" FontSize="22" LabelText="1倍" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="33.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="176.1408" Y="-21.3475" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule2" ActionTag="1883899924" Tag="560" IconVisible="False" LeftMargin="250.9749" RightMargin="-299.9749" TopMargin="-3.5006" BottomMargin="-45.4994" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="250.9749" Y="-20.9994" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule2" ActionTag="1233676237" Tag="561" IconVisible="False" LeftMargin="307.0354" RightMargin="-340.0354" TopMargin="9.9966" BottomMargin="-31.9966" FontSize="22" LabelText="2倍" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="33.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="307.0354" Y="-20.9966" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule3" ActionTag="1046785282" Tag="562" IconVisible="False" LeftMargin="387.5167" RightMargin="-436.5167" TopMargin="-3.5013" BottomMargin="-45.4987" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="387.5167" Y="-20.9987" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule3" ActionTag="-1687455756" Tag="563" IconVisible="False" LeftMargin="442.5787" RightMargin="-475.5787" TopMargin="9.9960" BottomMargin="-31.9960" FontSize="22" LabelText="3倍" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="33.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="442.5787" Y="-20.9960" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule4" ActionTag="-1281610833" Tag="564" IconVisible="False" LeftMargin="517.6866" RightMargin="-566.6866" TopMargin="-3.5013" BottomMargin="-45.4987" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="517.6866" Y="-20.9987" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule4" ActionTag="-2138963288" Tag="565" IconVisible="False" LeftMargin="571.7449" RightMargin="-604.7449" TopMargin="9.9959" BottomMargin="-31.9959" FontSize="22" LabelText="4倍" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="33.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="571.7449" Y="-20.9959" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Ie_BankerBaseRuleCheck" ActionTag="1872228859" Tag="566" IconVisible="False" LeftMargin="121.0002" RightMargin="-170.0002" TopMargin="-3.5001" BottomMargin="-45.4999" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="29" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="121.0002" Y="-20.9999" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position X="3.0000" Y="107.0032" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0045" Y="0.4600" />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Node_NormalPanel" ActionTag="1758872210" Alpha="0" Tag="567" IconVisible="True" LeftMargin="-0.9989" RightMargin="669.9583" TopMargin="138.5975" BottomMargin="94.0031" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_Title1" ActionTag="-2011620626" Tag="568" IconVisible="False" LeftMargin="-17.6689" RightMargin="-86.3311" TopMargin="4.9878" BottomMargin="-30.9878" FontSize="26" LabelText="特殊牌型" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="104.0000" Y="26.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="-17.6689" Y="-17.9878" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="224" G="220" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule1" ActionTag="-155198198" Tag="569" IconVisible="False" LeftMargin="310.4401" RightMargin="-354.4401" TopMargin="-4.0119" BottomMargin="-39.9881" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="1" Scale9Height="24" ctype="ImageViewObjectData">
                            <Size X="44.0000" Y="44.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="310.4401" Y="-17.9881" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_2.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule1" ActionTag="2118849112" Tag="570" IconVisible="False" LeftMargin="358.5190" RightMargin="-479.5190" TopMargin="5.5347" BottomMargin="-27.5347" FontSize="22" LabelText="五花牛(6倍)" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="121.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="358.5190" Y="-16.5347" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Ie_PlayRuleCheck1" ActionTag="1789123868" Tag="571" IconVisible="False" LeftMargin="302.4409" RightMargin="-355.4409" TopMargin="-0.0119" BottomMargin="-45.9881" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="33" Scale9Height="26" ctype="ImageViewObjectData">
                            <Size X="53.0000" Y="46.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="302.4409" Y="-22.9881" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_2.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule2" ActionTag="701399394" Tag="572" IconVisible="False" LeftMargin="124.4373" RightMargin="-168.4373" TopMargin="-4.0119" BottomMargin="-39.9881" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="1" Scale9Height="24" ctype="ImageViewObjectData">
                            <Size X="44.0000" Y="44.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="124.4373" Y="-17.9881" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_2.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule2" ActionTag="-480502367" Tag="573" IconVisible="False" LeftMargin="172.4381" RightMargin="-293.4381" TopMargin="6.9885" BottomMargin="-28.9885" FontSize="22" LabelText="炸弹牛(5倍)" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="121.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="172.4381" Y="-17.9885" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Ie_PlayRuleCheck2" ActionTag="-126415012" Tag="574" IconVisible="False" LeftMargin="117.4374" RightMargin="-170.4374" TopMargin="-0.0119" BottomMargin="-45.9881" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="33" Scale9Height="26" ctype="ImageViewObjectData">
                            <Size X="53.0000" Y="46.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="117.4374" Y="-22.9881" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_2.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule3" ActionTag="1390795447" Tag="575" IconVisible="False" LeftMargin="497.4515" RightMargin="-541.4515" TopMargin="-4.0130" BottomMargin="-39.9870" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="1" Scale9Height="24" ctype="ImageViewObjectData">
                            <Size X="44.0000" Y="44.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="497.4515" Y="-17.9870" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_2.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule3" ActionTag="1202633116" Tag="576" IconVisible="False" LeftMargin="542.4497" RightMargin="-663.4497" TopMargin="6.9874" BottomMargin="-28.9874" FontSize="22" LabelText="五小牛(8倍)" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="121.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="542.4497" Y="-17.9874" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Ie_PlayRuleCheck3" ActionTag="1625324058" Tag="577" IconVisible="False" LeftMargin="490.4509" RightMargin="-543.4509" TopMargin="-0.0129" BottomMargin="-45.9871" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="33" Scale9Height="26" ctype="ImageViewObjectData">
                            <Size X="53.0000" Y="46.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="490.4509" Y="-22.9871" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_2.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Text_Title2" ActionTag="-2088312156" Tag="578" IconVisible="False" LeftMargin="-17.6707" RightMargin="-86.3293" TopMargin="54.9869" BottomMargin="-80.9869" FontSize="26" LabelText="高级选项" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="104.0000" Y="26.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="-17.6707" Y="-67.9869" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="224" G="220" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule4" ActionTag="1513305188" Tag="579" IconVisible="False" LeftMargin="124.3922" RightMargin="-168.3922" TopMargin="47.7906" BottomMargin="-91.7906" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="1" Scale9Height="24" ctype="ImageViewObjectData">
                            <Size X="44.0000" Y="44.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="124.3922" Y="-69.7906" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_2.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule4" ActionTag="-1953139697" Tag="580" IconVisible="False" LeftMargin="175.4712" RightMargin="-373.4712" TopMargin="57.3375" BottomMargin="-79.3375" FontSize="22" LabelText="游戏开始后禁止加入" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="198.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="175.4712" Y="-68.3375" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Ie_PlayRuleCheck4" ActionTag="182214009" Tag="581" IconVisible="False" LeftMargin="116.3923" RightMargin="-169.3923" TopMargin="52.7912" BottomMargin="-98.7912" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="33" Scale9Height="26" ctype="ImageViewObjectData">
                            <Size X="53.0000" Y="46.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="116.3923" Y="-75.7912" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_2.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position X="-0.9989" Y="94.0031" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="-0.0015" Y="0.4041" />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Node_GDZJPanel" ActionTag="455193462" Tag="1638" IconVisible="True" LeftMargin="2.9999" RightMargin="665.9595" TopMargin="125.6000" BottomMargin="107.0006" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_Title1" ActionTag="908234187" Tag="1639" IconVisible="False" LeftMargin="-19.4373" RightMargin="-84.5627" TopMargin="7.9993" BottomMargin="-33.9993" FontSize="26" LabelText="上庄底分" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="104.0000" Y="26.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="-19.4373" Y="-20.9993" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="224" G="220" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule1" ActionTag="-770821044" Tag="1640" IconVisible="False" LeftMargin="121.0002" RightMargin="-170.0002" TopMargin="-3.5013" BottomMargin="-45.4987" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="121.0002" Y="-20.9987" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule1" ActionTag="1337399737" Tag="1641" IconVisible="False" LeftMargin="176.1408" RightMargin="-198.1408" TopMargin="10.3475" BottomMargin="-32.3475" FontSize="22" LabelText="无" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="22.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="176.1408" Y="-21.3475" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule2" ActionTag="1884055207" Tag="1642" IconVisible="False" LeftMargin="250.9749" RightMargin="-299.9749" TopMargin="-3.5006" BottomMargin="-45.4994" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="250.9749" Y="-20.9994" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule2" ActionTag="-1565015467" Tag="1643" IconVisible="False" LeftMargin="307.0354" RightMargin="-340.0354" TopMargin="9.9966" BottomMargin="-31.9966" FontSize="22" LabelText="100" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="33.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="307.0354" Y="-20.9966" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule3" ActionTag="-461149179" Tag="1644" IconVisible="False" LeftMargin="387.5167" RightMargin="-436.5167" TopMargin="-3.5013" BottomMargin="-45.4987" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="387.5167" Y="-20.9987" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule3" ActionTag="-1006511930" Tag="1645" IconVisible="False" LeftMargin="442.5787" RightMargin="-475.5787" TopMargin="9.9960" BottomMargin="-31.9960" FontSize="22" LabelText="150" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="33.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="442.5787" Y="-20.9960" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule4" ActionTag="490446485" Tag="1646" IconVisible="False" LeftMargin="517.6866" RightMargin="-566.6866" TopMargin="-3.5013" BottomMargin="-45.4987" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="517.6866" Y="-20.9987" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule4" ActionTag="463587889" Tag="1647" IconVisible="False" LeftMargin="571.7449" RightMargin="-604.7449" TopMargin="9.9959" BottomMargin="-31.9959" FontSize="22" LabelText="200" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="33.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="571.7449" Y="-20.9959" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Ie_BankerBaseRuleCheck" ActionTag="-1884975732" Tag="1648" IconVisible="False" LeftMargin="121.0002" RightMargin="-170.0002" TopMargin="-3.5001" BottomMargin="-45.4999" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="29" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="121.0002" Y="-20.9999" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position X="2.9999" Y="107.0006" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0045" Y="0.4600" />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Node_TBNNPanel" ActionTag="-464007883" Tag="1653" IconVisible="True" LeftMargin="2.9999" RightMargin="665.9595" TopMargin="125.6000" BottomMargin="107.0006" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_Title1" ActionTag="-1531930378" Tag="1654" IconVisible="False" LeftMargin="-19.4373" RightMargin="-84.5627" TopMargin="7.9993" BottomMargin="-33.9993" FontSize="26" LabelText="底    分" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="104.0000" Y="26.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="-19.4373" Y="-20.9993" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="224" G="220" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule1" ActionTag="-1281743075" Tag="1655" IconVisible="False" LeftMargin="121.0002" RightMargin="-170.0002" TopMargin="-3.5013" BottomMargin="-45.4987" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="121.0002" Y="-20.9987" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule1" ActionTag="-397849" Tag="1656" IconVisible="False" LeftMargin="176.1408" RightMargin="-187.1408" TopMargin="10.3475" BottomMargin="-32.3475" FontSize="22" LabelText="1" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="11.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="176.1408" Y="-21.3475" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule2" ActionTag="-1229916641" Tag="1657" IconVisible="False" LeftMargin="250.9749" RightMargin="-299.9749" TopMargin="-3.5006" BottomMargin="-45.4994" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="250.9749" Y="-20.9994" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule2" ActionTag="-1488938868" Tag="1658" IconVisible="False" LeftMargin="307.0354" RightMargin="-318.0354" TopMargin="9.9966" BottomMargin="-31.9966" FontSize="22" LabelText="2" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="11.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="307.0354" Y="-20.9966" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_BankerBaseRule3" ActionTag="1328249316" Tag="1659" IconVisible="False" LeftMargin="387.5167" RightMargin="-436.5167" TopMargin="-3.5013" BottomMargin="-45.4987" Scale9Enable="True" LeftEage="49" TopEage="10" BottomEage="10" Scale9OriginX="49" Scale9OriginY="10" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="387.5167" Y="-20.9987" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_BankerBaseRule3" ActionTag="566216548" Tag="1660" IconVisible="False" LeftMargin="442.5787" RightMargin="-453.5787" TopMargin="9.9960" BottomMargin="-31.9960" FontSize="22" LabelText="4" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="11.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="442.5787" Y="-20.9960" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Ie_BankerBaseRuleCheck" ActionTag="-1286448617" Tag="1663" IconVisible="False" LeftMargin="121.0002" RightMargin="-170.0002" TopMargin="-3.5001" BottomMargin="-45.4999" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="29" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="121.0002" Y="-20.9999" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position X="2.9999" Y="107.0006" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0045" Y="0.4600" />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Node_PlayerPanel" ActionTag="1071883529" Tag="1540" IconVisible="True" LeftMargin="-1.0000" RightMargin="669.9594" TopMargin="10.6006" BottomMargin="222.0000" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_Title1" ActionTag="-775142133" Tag="1541" IconVisible="False" LeftMargin="-17.6689" RightMargin="-86.3311" TopMargin="4.9878" BottomMargin="-30.9878" FontSize="26" LabelText="玩    法" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="104.0000" Y="26.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="-17.6689" Y="-17.9878" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="224" G="220" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule1" ActionTag="1027588134" Tag="1542" IconVisible="False" LeftMargin="124.0000" RightMargin="-173.0000" TopMargin="-6.5119" BottomMargin="-42.4881" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="5" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="124.0000" Y="-17.9881" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule1" ActionTag="1754482695" Tag="1543" IconVisible="False" LeftMargin="172.0000" RightMargin="-260.0000" TopMargin="5.5347" BottomMargin="-27.5347" FontSize="22" LabelText="双十上庄" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="88.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="172.0000" Y="-16.5347" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule2" ActionTag="1466538130" Tag="1545" IconVisible="False" LeftMargin="310.0000" RightMargin="-359.0000" TopMargin="-6.5119" BottomMargin="-42.4881" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="5" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="310.0000" Y="-17.9881" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule2" ActionTag="1809354096" Tag="1546" IconVisible="False" LeftMargin="358.0000" RightMargin="-446.0000" TopMargin="6.9885" BottomMargin="-28.9885" FontSize="22" LabelText="房主坐庄" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="88.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="358.0000" Y="-17.9885" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule3" ActionTag="-1170377840" Tag="1548" IconVisible="False" LeftMargin="497.4515" RightMargin="-546.4515" TopMargin="-6.5130" BottomMargin="-42.4870" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="5" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="497.4515" Y="-17.9870" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule3" ActionTag="-739241488" Tag="1549" IconVisible="False" LeftMargin="542.4497" RightMargin="-630.4497" TopMargin="6.9874" BottomMargin="-28.9874" FontSize="22" LabelText="轮流坐庄" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="88.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="542.4497" Y="-17.9874" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule4" ActionTag="-404880877" Tag="1555" IconVisible="False" LeftMargin="124.4438" RightMargin="-173.4438" TopMargin="51.4866" BottomMargin="-100.4866" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="5" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="124.4438" Y="-75.9866" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule4" ActionTag="1397350677" Tag="1556" IconVisible="False" LeftMargin="172.5232" RightMargin="-260.5232" TopMargin="63.5338" BottomMargin="-85.5338" FontSize="22" LabelText="自由抢庄" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="88.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="172.5232" Y="-74.5338" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule5" ActionTag="2001418427" Tag="1557" IconVisible="False" LeftMargin="309.4429" RightMargin="-358.4429" TopMargin="51.4866" BottomMargin="-100.4866" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="5" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="309.4429" Y="-75.9866" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule5" ActionTag="-1695072865" Tag="1558" IconVisible="False" LeftMargin="357.4395" RightMargin="-445.4395" TopMargin="64.9872" BottomMargin="-86.9872" FontSize="22" LabelText="明牌抢庄" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="88.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="357.4395" Y="-75.9872" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Bn_PlayRule6" ActionTag="-1319412176" Tag="1559" IconVisible="False" LeftMargin="497.4518" RightMargin="-546.4518" TopMargin="51.4855" BottomMargin="-100.4855" Scale9Enable="True" LeftEage="44" TopEage="10" BottomEage="10" Scale9OriginX="44" Scale9OriginY="10" Scale9Width="5" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="497.4518" Y="-75.9855" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_bg_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Tt_PlayRule6" ActionTag="1733806802" Tag="1560" IconVisible="False" LeftMargin="542.4500" RightMargin="-630.4500" TopMargin="64.9862" BottomMargin="-86.9862" FontSize="22" LabelText="通比拼十" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="88.0000" Y="22.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="542.4500" Y="-75.9862" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Ie_PlayRuleCheck" ActionTag="-1852110365" Tag="1550" IconVisible="False" LeftMargin="124.4400" RightMargin="-173.4400" TopMargin="-6.5100" BottomMargin="-42.4900" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="29" Scale9Height="29" ctype="ImageViewObjectData">
                            <Size X="49.0000" Y="49.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="124.4400" Y="-17.9900" />
                            <Scale ScaleX="0.8000" ScaleY="0.8000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="games/mlnn/comm/image_box_select_1.png" Plist="games/mlnn/game_2.plist" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position X="-1.0000" Y="222.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="-0.0015" Y="0.9544" />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="1.0000" />
                    <Position X="39.5035" Y="213.0687" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0557" Y="0.5967" />
                    <PreSize X="0.9426" Y="0.6514" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="1.0000" />
                <Position X="4.9360" Y="376.5133" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0069" Y="0.8367" />
                <PreSize X="0.9857" Y="0.7935" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_RoomRule" ActionTag="-852450812" Tag="600" IconVisible="False" LeftMargin="-0.5000" RightMargin="355.5000" TopMargin="3.0000" BottomMargin="381.0000" TouchEnable="True" FlipX="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="257" Scale9Height="44" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="365.0000" Y="66.0000" />
                <Children>
                  <AbstractNodeData Name="Sprite_18" ActionTag="-6535509" Tag="604" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="115.0000" RightMargin="115.0000" TopMargin="13.2000" BottomMargin="19.8000" FlipX="True" ctype="SpriteObjectData">
                    <Size X="135.0000" Y="33.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="182.5000" Y="36.3000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5500" />
                    <PreSize X="0.3699" Y="0.5000" />
                    <FileData Type="MarkedSubImage" Path="games/mlnn/game/rule_room_2.png" Plist="games/mlnn/game_2.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="182.0000" Y="414.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2528" Y="0.9200" />
                <PreSize X="0.5069" Y="0.1467" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                <PressedFileData Type="MarkedSubImage" Path="games/mlnn/game/rule_title_bg.png" Plist="games/mlnn/game_2.plist" />
                <NormalFileData Type="MarkedSubImage" Path="games/mlnn/game/rule_title_bg.png" Plist="games/mlnn/game_2.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_GameRule" ActionTag="-1700498912" Tag="601" IconVisible="False" LeftMargin="355.5000" RightMargin="-0.5000" TopMargin="2.9999" BottomMargin="381.0001" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="257" Scale9Height="44" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="365.0000" Y="66.0000" />
                <Children>
                  <AbstractNodeData Name="Sprite_19" ActionTag="-1591422383" Tag="605" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="148.5000" RightMargin="148.5000" TopMargin="13.2000" BottomMargin="19.8000" ctype="SpriteObjectData">
                    <Size X="68.0000" Y="33.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="182.5000" Y="36.3000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5500" />
                    <PreSize X="0.1863" Y="0.5000" />
                    <FileData Type="MarkedSubImage" Path="games/mlnn/game/rule_play_2.png" Plist="games/mlnn/game_2.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="538.0000" Y="414.0001" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7472" Y="0.9200" />
                <PreSize X="0.5069" Y="0.1467" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                <PressedFileData Type="MarkedSubImage" Path="games/mlnn/game/rule_title_bg.png" Plist="games/mlnn/game_2.plist" />
                <NormalFileData Type="MarkedSubImage" Path="games/mlnn/game/rule_title_bg.png" Plist="games/mlnn/game_2.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckRoomRule" ActionTag="-501116823" Tag="602" IconVisible="False" LeftMargin="-1.5000" RightMargin="356.5000" TopMargin="4.0000" BottomMargin="384.0000" LeftEage="94" RightEage="94" TopEage="21" BottomEage="21" Scale9OriginX="94" Scale9OriginY="21" Scale9Width="99" Scale9Height="24" ctype="ImageViewObjectData">
                <Size X="365.0000" Y="62.0000" />
                <Children>
                  <AbstractNodeData Name="Sprite_20" ActionTag="168590367" Tag="606" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="115.0000" RightMargin="115.0000" TopMargin="12.0200" BottomMargin="16.9800" ctype="SpriteObjectData">
                    <Size X="135.0000" Y="33.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="182.5000" Y="33.4800" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5400" />
                    <PreSize X="0.3699" Y="0.5323" />
                    <FileData Type="MarkedSubImage" Path="games/mlnn/game/rule_room_1.png" Plist="games/mlnn/game_2.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="181.0000" Y="415.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2514" Y="0.9222" />
                <PreSize X="0.5069" Y="0.1378" />
                <FileData Type="MarkedSubImage" Path="games/mlnn/game/rule_title_select.png" Plist="games/mlnn/game_2.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckGameRule" ActionTag="1991242450" VisibleForFrame="False" Tag="603" IconVisible="False" LeftMargin="356.4999" RightMargin="-1.4999" TopMargin="4.0000" BottomMargin="384.0000" FlipX="True" LeftEage="94" RightEage="94" TopEage="21" BottomEage="21" Scale9OriginX="94" Scale9OriginY="21" Scale9Width="99" Scale9Height="24" ctype="ImageViewObjectData">
                <Size X="365.0000" Y="62.0000" />
                <Children>
                  <AbstractNodeData Name="Sprite_21" ActionTag="124176828" Tag="607" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="148.5000" RightMargin="148.5000" TopMargin="12.0200" BottomMargin="16.9800" FlipX="True" ctype="SpriteObjectData">
                    <Size X="68.0000" Y="33.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="182.5000" Y="33.4800" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5400" />
                    <PreSize X="0.1863" Y="0.5323" />
                    <FileData Type="MarkedSubImage" Path="games/mlnn/game/rule_play_1.png" Plist="games/mlnn/game_2.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="538.9999" Y="415.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7486" Y="0.9222" />
                <PreSize X="0.5069" Y="0.1378" />
                <FileData Type="MarkedSubImage" Path="games/mlnn/game/rule_title_select.png" Plist="games/mlnn/game_2.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="665.0000" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4985" Y="0.5000" />
            <PreSize X="0.5397" Y="0.6000" />
            <FileData Type="Normal" Path="games/mlnn/comm/image_bg_1.png" Plist="" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>