<GameFile>
  <PropertyGroup Name="GameRuleLayer" Type="Layer" ID="6a34b9e1-b055-485e-99e1-072fbc5f0f21" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="53" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="Ie_Mark" ActionTag="845190451" Tag="127" IconVisible="False" HorizontalEdge="BothEdge" VerticalEdge="BothEdge" LeftMargin="5.6146" RightMargin="-5.6145" TopMargin="-6.7372" BottomMargin="6.7372" TouchEnable="True" StretchWidthEnable="True" StretchHeightEnable="True" LeftEage="17" RightEage="17" TopEage="15" BottomEage="15" Scale9OriginX="17" Scale9OriginY="15" Scale9Width="19" Scale9Height="18" ctype="ImageViewObjectData">
            <Size X="1333.9999" Y="750.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="672.6146" Y="381.7372" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5042" Y="0.5090" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="MarkedSubImage" Path="games/tdh/game/mask_bg.png" Plist="games/tdh/game_1.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="Ie_Bg" ActionTag="243452451" Tag="287" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="312.5070" RightMargin="315.8400" TopMargin="150.7051" BottomMargin="150.7051" TouchEnable="True" Scale9Enable="True" LeftEage="27" RightEage="27" TopEage="36" BottomEage="36" Scale9OriginX="27" Scale9OriginY="36" Scale9Width="75" Scale9Height="63" ctype="ImageViewObjectData">
            <Size X="705.6531" Y="448.5898" />
            <Children>
              <AbstractNodeData Name="LV_GameRule" ActionTag="-1103254868" VisibleForFrame="False" Tag="906" IconVisible="False" LeftMargin="20.5743" RightMargin="20.0950" TopMargin="92.0871" BottomMargin="36.8927" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ScrollDirectionType="0" ItemMargin="20" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="664.9838" Y="319.6100" />
                <Children>
                  <AbstractNodeData Name="Text_1" ActionTag="-1387775368" Tag="1558" IconVisible="False" RightMargin="-3.0162" FontSize="29" LabelText="&#xA;游戏人数：只有同时准备的玩家达到4人,游戏才能&#xA;开始。&#xA;游戏牌数：推倒胡麻将使用无花牌的136张麻将。&#xA;&#xA;庄家：第一局，为创建房间的玩家为庄，之后将由&#xA;本局胡牌的玩家下局坐庄，如庄家胡牌，则继续坐&#xA;庄。&#xA;若荒庄则摸到最后一张牌的人坐庄。&#xA;&#xA;可碰，可杠，不可吃。&#xA;&#xA;杠后补牌：&#xA;杠牌后将在牌对中补上一张牌。&#xA;&#xA;听牌：&#xA;1.玩家听牌时会将报听的牌倒扣，听牌后不能换牌。&#xA;2.听牌后仍可杠牌，前提是杠完后听口不变。&#xA;3.听牌后遇到胡，玩家可以自行选择。&#xA;&#xA;胡牌的特殊牌型：&#xA;七小对，一条龙，清一色&#xA;豪华七小对：满足七对且牌型中有一副及以上4张一&#xA;样的牌。&#xA;十三幺：东南西北中发白，一万九万，一筒九筒，&#xA;一条九条，加其中任意一张牌作将。&#xA;&#xA;过胡：&#xA;过胡后，直至过胡玩家打出一张牌，才可以正常胡&#xA;牌。&#xA;&#xA;荒庄：游戏过程中，牌抓完后没有玩家胡牌，则该&#xA;局为荒庄。&#xA;&#xA;各动作优先级：胡牌&gt;碰牌(杠牌)。&#xA;&#xA;积分计算&#xA;明杠：1&#xA;暗杠：2&#xA;平胡：3&#xA;清一色，七小对，一条龙：均为9&#xA;豪华七小对：18&#xA;十三幺：27&#xA;&#xA;备注：&#xA;&#xA;大胡：&#xA;同时胡多个类型的时候按最大倍数胡算，不能叠加;&#xA;不报听点炮，点炮人给胡牌人最大牌型相对分数;&#xA;报听点炮，三人平分最大牌型的分数;自摸没人给胡&#xA;家最大牌型相对的分数。&#xA;平胡：不报听点炮，点炮人给胡家3分;报听点炮，&#xA;三人每人1分;&#xA;平胡自摸，胡家得6分，每人扣2分。&#xA;不报听包胡包杠，报听点炮点杠三家扣分;抢杠算点&#xA;炮;平胡玩法只结算明杠暗杠和平胡分数;" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="668.0000" Y="1624.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="334.0000" Y="812.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.5023" Y="0.5000" />
                    <PreSize X="1.0045" Y="1.0000" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="20.5743" Y="36.8927" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0292" Y="0.0822" />
                <PreSize X="0.9424" Y="0.7125" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Pl_RoomRule" ActionTag="1019562728" Tag="968" IconVisible="False" LeftMargin="51.0872" RightMargin="47.5659" TopMargin="121.5750" BottomMargin="33.0148" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="607.0000" Y="294.0000" />
                <Children>
                  <AbstractNodeData Name="Image_KouFei" ActionTag="222663942" Tag="967" IconVisible="False" LeftMargin="5.0034" RightMargin="513.9966" TopMargin="-2.5049" BottomMargin="259.5049" ctype="SpriteObjectData">
                    <Size X="88.0000" Y="37.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="49.0034" Y="278.0049" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0807" Y="0.9456" />
                    <PreSize X="0.1450" Y="0.1259" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/ImageText27.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_QuanShu" ActionTag="-1134920991" Tag="966" IconVisible="False" LeftMargin="4.5055" RightMargin="513.4945" TopMargin="58.2588" BottomMargin="198.7412" ctype="SpriteObjectData">
                    <Size X="89.0000" Y="37.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="49.0055" Y="217.2412" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0807" Y="0.7389" />
                    <PreSize X="0.1466" Y="0.1259" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/ImageText29.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_WanFa" ActionTag="543026570" Tag="349" IconVisible="False" LeftMargin="3.6931" RightMargin="514.3069" TopMargin="179.0631" BottomMargin="77.9369" ctype="SpriteObjectData">
                    <Size X="89.0000" Y="37.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="48.1931" Y="96.4369" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0794" Y="0.3280" />
                    <PreSize X="0.1466" Y="0.1259" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/ImageText28.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_buttomDi" ActionTag="-1732390671" Tag="362" IconVisible="False" LeftMargin="130.0000" RightMargin="373.0000" TopMargin="123.0000" BottomMargin="131.0000" Scale9Enable="True" LeftEage="7" RightEage="7" TopEage="13" BottomEage="13" Scale9OriginX="7" Scale9OriginY="13" Scale9Width="16" Scale9Height="18" ctype="ImageViewObjectData">
                    <Size X="104.0000" Y="40.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="182.0000" Y="151.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2998" Y="0.5136" />
                    <PreSize X="0.1713" Y="0.1361" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/BG44.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_55" ActionTag="129706499" Tag="14382" IconVisible="False" LeftMargin="3.4494" RightMargin="514.5506" TopMargin="120.4563" BottomMargin="135.5437" LeftEage="29" RightEage="29" TopEage="12" BottomEage="12" Scale9OriginX="29" Scale9OriginY="12" Scale9Width="31" Scale9Height="14" ctype="ImageViewObjectData">
                    <Size X="89.0000" Y="38.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="47.9494" Y="154.5437" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0790" Y="0.5257" />
                    <PreSize X="0.1466" Y="0.1293" />
                    <FileData Type="MarkedSubImage" Path="games/tdh/game/img_DiFen.png" Plist="games/tdh/game_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Pay1" ActionTag="-700750941" Tag="941" IconVisible="False" LeftMargin="126.9999" RightMargin="449.0001" TopMargin="-0.5004" BottomMargin="263.5004" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="31.0000" Y="31.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="126.9999" Y="279.0004" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.2092" Y="0.9490" />
                    <PreSize X="0.0511" Y="0.1054" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Pay1" ActionTag="76971753" Tag="948" IconVisible="False" LeftMargin="168.0000" RightMargin="319.0000" TopMargin="-0.0040" BottomMargin="264.0040" FontSize="30" LabelText="房主出资" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                    <Size X="120.0000" Y="30.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="168.0000" Y="279.0040" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.2768" Y="0.9490" />
                    <PreSize X="0.1977" Y="0.1020" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Pay2" ActionTag="1371981876" Tag="942" IconVisible="False" LeftMargin="316.0000" RightMargin="260.0000" TopMargin="-1.5009" BottomMargin="264.5009" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="31.0000" Y="31.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="316.0000" Y="280.0009" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.5206" Y="0.9524" />
                    <PreSize X="0.0511" Y="0.1054" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Pay2" ActionTag="239347123" Tag="947" IconVisible="False" LeftMargin="360.0000" RightMargin="127.0000" TopMargin="-1.0028" BottomMargin="265.0028" FontSize="30" LabelText="玩家平摊" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                    <Size X="120.0000" Y="30.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="360.0000" Y="280.0028" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.5931" Y="0.9524" />
                    <PreSize X="0.1977" Y="0.1020" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_PayCheck" ActionTag="-989289763" Tag="940" IconVisible="False" LeftMargin="127.1034" RightMargin="448.8966" TopMargin="-1.2115" BottomMargin="263.2115" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="35" Scale9Height="42" ctype="ImageViewObjectData">
                    <Size X="31.0000" Y="32.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="127.1034" Y="279.2115" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2094" Y="0.9497" />
                    <PreSize X="0.0511" Y="0.1088" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Round1" ActionTag="-1692067872" Tag="962" IconVisible="False" LeftMargin="168.0000" RightMargin="394.0000" TopMargin="61.7557" BottomMargin="202.2443" FontSize="30" LabelText="4局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                    <Size X="45.0000" Y="30.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="168.0000" Y="217.2443" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.2768" Y="0.7389" />
                    <PreSize X="0.0741" Y="0.1020" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Round2" ActionTag="-1918782559" Tag="946" IconVisible="False" LeftMargin="360.0000" RightMargin="202.0000" TopMargin="61.9925" BottomMargin="202.0075" FontSize="30" LabelText="8局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                    <Size X="45.0000" Y="30.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="360.0000" Y="217.0075" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.5931" Y="0.7381" />
                    <PreSize X="0.0741" Y="0.1020" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Round3" ActionTag="-570383246" Tag="945" IconVisible="False" LeftMargin="530.0000" RightMargin="17.0000" TopMargin="61.7564" BottomMargin="202.2436" FontSize="30" LabelText="16局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                    <Size X="60.0000" Y="30.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="530.0000" Y="217.2436" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.8731" Y="0.7389" />
                    <PreSize X="0.0988" Y="0.1020" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round1" ActionTag="1654963588" Tag="960" IconVisible="False" LeftMargin="127.2585" RightMargin="448.7415" TopMargin="59.9026" BottomMargin="203.0974" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="31.0000" Y="31.0000" />
                    <AnchorPoint ScaleY="0.5150" />
                    <Position X="127.2585" Y="219.0624" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.2097" Y="0.7451" />
                    <PreSize X="0.0511" Y="0.1054" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round2" ActionTag="-432641420" Tag="959" IconVisible="False" LeftMargin="316.0000" RightMargin="260.0000" TopMargin="60.1764" BottomMargin="201.8236" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="31.0000" Y="32.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="316.0000" Y="217.8236" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.5206" Y="0.7409" />
                    <PreSize X="0.0511" Y="0.1088" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round3" ActionTag="97915086" Tag="961" IconVisible="False" LeftMargin="490.0000" RightMargin="86.0000" TopMargin="59.9362" BottomMargin="202.0638" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="31.0000" Y="32.0000" />
                    <AnchorPoint ScaleY="0.5150" />
                    <Position X="490.0000" Y="218.5438" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.8072" Y="0.7433" />
                    <PreSize X="0.0511" Y="0.1088" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_RoundCheck" ActionTag="182914496" Tag="957" IconVisible="False" LeftMargin="127.5839" RightMargin="448.4161" TopMargin="59.2979" BottomMargin="202.7021" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="35" Scale9Height="42" ctype="ImageViewObjectData">
                    <Size X="31.0000" Y="32.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="127.5839" Y="218.7021" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2102" Y="0.7439" />
                    <PreSize X="0.0511" Y="0.1088" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_1" ActionTag="-1156542757" Tag="348" IconVisible="False" LeftMargin="126.1409" RightMargin="450.8591" TopMargin="181.9525" BottomMargin="82.0475" LeftEage="46" TopEage="9" BottomEage="9" Scale9OriginX="46" Scale9OriginY="9" Scale9Width="1" Scale9Height="29" ctype="ImageViewObjectData">
                    <Size X="30.0000" Y="30.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="-444961403" Tag="351" IconVisible="False" LeftMargin="34.0026" RightMargin="-64.0026" TopMargin="1.4900" BottomMargin="-1.4900" FontSize="30" LabelText="大胡" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                        <Size X="60.0000" Y="30.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="34.0026" Y="13.5100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1334" Y="0.4503" />
                        <PreSize X="2.0000" Y="1.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="141.1409" Y="97.0475" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.2325" Y="0.3301" />
                    <PreSize X="0.0494" Y="0.1020" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_2" ActionTag="-316136514" Tag="352" IconVisible="False" LeftMargin="270.1418" RightMargin="306.8582" TopMargin="180.9517" BottomMargin="83.0483" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="28" Scale9Height="29" ctype="ImageViewObjectData">
                    <Size X="30.0000" Y="30.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="23821084" Tag="354" IconVisible="False" LeftMargin="35.0026" RightMargin="-65.0026" TopMargin="1.4900" BottomMargin="-1.4900" FontSize="30" LabelText="平胡" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                        <Size X="60.0000" Y="30.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="35.0026" Y="13.5100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1668" Y="0.4503" />
                        <PreSize X="2.0000" Y="1.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="285.1418" Y="98.0483" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.4698" Y="0.3335" />
                    <PreSize X="0.0494" Y="0.1020" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_3" ActionTag="-968509756" Tag="6064" IconVisible="False" LeftMargin="126.2146" RightMargin="450.7854" TopMargin="244.0996" BottomMargin="19.9004" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="28" Scale9Height="29" ctype="ImageViewObjectData">
                    <Size X="30.0000" Y="30.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="1516227781" Tag="6065" IconVisible="False" LeftMargin="35.0026" RightMargin="-65.0026" TopMargin="1.4900" BottomMargin="-1.4900" FontSize="30" LabelText="报听" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                        <Size X="60.0000" Y="30.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="35.0026" Y="13.5100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1668" Y="0.4503" />
                        <PreSize X="2.0000" Y="1.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="141.2146" Y="34.9004" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.2326" Y="0.1187" />
                    <PreSize X="0.0494" Y="0.1020" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_4" ActionTag="-1953113174" Tag="6066" IconVisible="False" LeftMargin="268.9743" RightMargin="308.0257" TopMargin="244.0996" BottomMargin="19.9004" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="28" Scale9Height="29" ctype="ImageViewObjectData">
                    <Size X="30.0000" Y="30.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="1958416472" Tag="6067" IconVisible="False" LeftMargin="35.0026" RightMargin="-65.0026" TopMargin="1.4900" BottomMargin="-1.4900" FontSize="30" LabelText="带风" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                        <Size X="60.0000" Y="30.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="35.0026" Y="13.5100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1668" Y="0.4503" />
                        <PreSize X="2.0000" Y="1.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="283.9743" Y="34.9004" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.4678" Y="0.1187" />
                    <PreSize X="0.0494" Y="0.1020" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_5" ActionTag="-117403145" Tag="6068" IconVisible="False" LeftMargin="412.7282" RightMargin="164.2718" TopMargin="244.0996" BottomMargin="19.9004" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="28" Scale9Height="29" ctype="ImageViewObjectData">
                    <Size X="30.0000" Y="30.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="1427118297" Tag="6069" IconVisible="False" LeftMargin="35.0026" RightMargin="-155.0026" TopMargin="1.4900" BottomMargin="-1.4900" FontSize="30" LabelText="只可自摸胡" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ctype="TextObjectData">
                        <Size X="150.0000" Y="30.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="35.0026" Y="13.5100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1668" Y="0.4503" />
                        <PreSize X="5.0000" Y="1.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="427.7282" Y="34.9004" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.7047" Y="0.1187" />
                    <PreSize X="0.0494" Y="0.1020" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check1" ActionTag="1161289" Tag="350" IconVisible="False" LeftMargin="113.4308" RightMargin="438.5692" TopMargin="165.5964" BottomMargin="66.4036" ctype="SpriteObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="140.9308" Y="97.4036" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2322" Y="0.3313" />
                    <PreSize X="0.0906" Y="0.2109" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check2" ActionTag="715569925" Tag="353" IconVisible="False" LeftMargin="257.2594" RightMargin="294.7406" TopMargin="164.7729" BottomMargin="67.2271" ctype="SpriteObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="284.7594" Y="98.2271" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4691" Y="0.3341" />
                    <PreSize X="0.0906" Y="0.2109" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check3" ActionTag="1372409683" Tag="6070" IconVisible="False" LeftMargin="114.1663" RightMargin="437.8337" TopMargin="228.2741" BottomMargin="3.7259" ctype="SpriteObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="141.6663" Y="34.7259" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2334" Y="0.1181" />
                    <PreSize X="0.0906" Y="0.2109" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check4" ActionTag="-697413288" Tag="6071" IconVisible="False" LeftMargin="256.1550" RightMargin="295.8450" TopMargin="228.3378" BottomMargin="3.6622" ctype="SpriteObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="283.6550" Y="34.6622" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4673" Y="0.1179" />
                    <PreSize X="0.0906" Y="0.2109" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check5" ActionTag="141873722" Tag="6072" IconVisible="False" LeftMargin="399.9149" RightMargin="152.0851" TopMargin="227.6370" BottomMargin="4.3630" ctype="SpriteObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="427.4149" Y="35.3630" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.7041" Y="0.1203" />
                    <PreSize X="0.0906" Y="0.2109" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_DiFen" ActionTag="293333163" Tag="14383" IconVisible="False" LeftMargin="166.9794" RightMargin="412.0206" TopMargin="127.5748" BottomMargin="138.4252" FontSize="28" LabelText="50" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="28.0000" Y="28.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="180.9794" Y="152.4252" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="165" B="0" />
                    <PrePosition X="0.2982" Y="0.5185" />
                    <PreSize X="0.0461" Y="0.0952" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5010" ScaleY="1.0000" />
                <Position X="355.1942" Y="327.0148" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5034" Y="0.7290" />
                <PreSize X="0.8602" Y="0.6554" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_GameRule" ActionTag="-1395253882" Tag="758" IconVisible="False" HorizontalEdge="RightEdge" LeftMargin="13.4331" RightMargin="355.2200" TopMargin="14.3498" BottomMargin="364.2400" LeftEage="1" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="1" Scale9OriginY="18" Scale9Width="316" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="181.9331" Y="399.2400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2578" Y="0.8900" />
                <PreSize X="0.4776" Y="0.1560" />
                <FileData Type="MarkedSubImage" Path="games/tdh/game/btn_ruleTop11.png" Plist="games/tdh/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_RoomRule" ActionTag="-280127197" Tag="762" IconVisible="False" LeftMargin="352.3301" RightMargin="16.3230" TopMargin="14.3498" BottomMargin="364.2400" Scale9Enable="True" LeftEage="1" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="1" Scale9OriginY="18" Scale9Width="316" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="520.8301" Y="399.2400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7381" Y="0.8900" />
                <PreSize X="0.4776" Y="0.1560" />
                <FileData Type="MarkedSubImage" Path="games/tdh/game/btn_ruleTop21.png" Plist="games/tdh/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckGameRule" Visible="False" ActionTag="1131596904" VisibleForFrame="False" Tag="761" IconVisible="False" LeftMargin="352.7900" RightMargin="15.8631" TopMargin="14.3498" BottomMargin="364.2400" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="521.2900" Y="399.2400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7387" Y="0.8900" />
                <PreSize X="0.4776" Y="0.1560" />
                <FileData Type="MarkedSubImage" Path="games/tdh/game/btn_ruleTop22.png" Plist="games/tdh/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckRoomRule" ActionTag="1783918964" Tag="757" IconVisible="False" LeftMargin="13.7800" RightMargin="354.8731" TopMargin="14.3498" BottomMargin="364.2400" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="182.2800" Y="399.2400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2583" Y="0.8900" />
                <PreSize X="0.4776" Y="0.1560" />
                <FileData Type="MarkedSubImage" Path="games/tdh/game/btn_ruleTop12.png" Plist="games/tdh/game_1.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="665.3335" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4988" Y="0.5000" />
            <PreSize X="0.5290" Y="0.5981" />
            <FileData Type="MarkedSubImage" Path="game/mjcomm/part/bgMsgBox.png" Plist="game/mjcomm/mjPartUi.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>