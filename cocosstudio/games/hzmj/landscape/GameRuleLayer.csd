<GameFile>
  <PropertyGroup Name="GameRuleLayer" Type="Layer" ID="6a34b9e1-b055-485e-99e1-072fbc5f0f21" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="53" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="Ie_Mark" ActionTag="-1355661779" Tag="3485" IconVisible="False" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" HorizontalEdge="BothEdge" VerticalEdge="BothEdge" LeftEage="17" RightEage="17" TopEage="15" BottomEage="15" Scale9OriginX="17" Scale9OriginY="15" Scale9Width="19" Scale9Height="18" ctype="ImageViewObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="MarkedSubImage" Path="hallcomm/common/img/BG6.png" Plist="hallcomm/common/CommonPlist0.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="Ie_Bg" ActionTag="243452451" Tag="287" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="317.0000" RightMargin="317.0000" TopMargin="150.0000" BottomMargin="150.0000" TouchEnable="True" Scale9Enable="True" LeftEage="27" RightEage="27" TopEage="36" BottomEage="36" Scale9OriginX="27" Scale9OriginY="36" Scale9Width="75" Scale9Height="63" ctype="ImageViewObjectData">
            <Size X="700.0000" Y="450.0000" />
            <Children>
              <AbstractNodeData Name="LV_GameRule" Visible="False" ActionTag="2108382352" Tag="2559" IconVisible="False" LeftMargin="20.0000" RightMargin="20.0000" TopMargin="90.0000" BottomMargin="30.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="Vertical" ctype="ScrollViewObjectData">
                <Size X="660.0000" Y="330.0000" />
                <Children>
                  <AbstractNodeData Name="Text" ActionTag="945753215" ZOrder="2" Tag="2560" IconVisible="False" LeftMargin="0.0002" RightMargin="-0.0002" IsCustomSize="True" FontSize="24" LabelText="简介：&#xA;    红中麻将特色是以红中为万能牌又称‘百搭’牌，胡牌后还可以奖码。红中麻将易上手、节奏快，更具刺激性和技术性，现已被广大麻友接受和喜欢。&#xA;&#xA;牌面：&#xA;    红中麻将共112张牌：包括1-9饼、1-9条、1-9万各4张，外加4张红中。&#xA;&#xA;庄家：&#xA;   开桌后第一局系统随机指定某个玩家坐庄。牌局结束后，上局胡牌的玩家为该局庄家，若本局和牌（流局），则由最后摸牌的人做庄。&#xA;&#xA;基本术语：&#xA;   碰：其他玩家打出的牌，自己手里有两张，则可以碰；&#xA;   一句话：同系列的三张连续的牌；&#xA;   一坎牌：三张一样的牌；&#xA;   明杠：&#xA;        a:先碰的牌，自己又摸到一张该牌，则可选择‘杠’又称公杠（公杠必须第一时间杠）；&#xA;        b:打出一张牌，有玩家手里有一坎相同的牌，则该玩家可以‘接杠’，打出该牌的玩家就是‘放杠’；&#xA;    暗杠：手里有4张相同的牌，可以选择‘杠’（暗杠不需要第一时间杠）。&#xA;&#xA;出牌：&#xA;   1.庄家先出牌，打出的牌，其他玩家可进行碰、杠，下家不能吃；&#xA;   2.红中牌可打出，但不能辅助其他牌来碰、杠；&#xA;   3.根据奖码数量，最后要留对应数量的牌，如：创建房间时选择奖码m个，那么倒数第m+1张被摸后(最后一张不打出)，仍无人胡牌，则流局。&#xA;&#xA;胡牌规则&#xA;    1.胡牌时手里要有一个对子，剩余牌必须是‘一句话’或‘一坎牌’；&#xA;    2.摸到四张红中，自动胡牌，胡牌后可正常奖码；&#xA;    3.胡牌只能通过自摸和抢杠胡两种方式；&#xA;    4.‘抢杠胡’：A玩家选择公杠时，此时B玩家可胡这张牌且手中无红中时，则B玩家才可以选择‘抢杠胡’；&#xA;    5.抢杠胡没有一炮通吃，以杠牌玩家下手顺序优先抢杠胡的玩家胡牌；&#xA;    6.被抢杠胡的玩家包赔，包括胡牌后的奖码，但不包括当局胡牌前杠牌的输赢；&#xA;    7.可胡7对（创建房间时需勾选），胡7对时红中不能作为万能牌使用；&#xA;&#xA;奖码规则：&#xA;    胡牌后，进入奖码环节。如创建房间选择奖码n个:&#xA;    1.当胡牌玩家手中有红中时，奖码数为n；当胡牌玩家手中没有红中时，额外奖励两张码,即奖码数为n+2。（剩余牌数不够时，有几张奖几张）；&#xA;    2.当奖码的牌面为红中,1,5,9时即为中码。&#xA;&#xA;计分规则：&#xA;    1.自摸胡牌，赢每个玩家2*底分；&#xA;    2.摸到四张红中胡牌，赢每个玩家2*底分；&#xA;    3.暗杠，赢每个玩家2*底分；&#xA;    4.明杠分两种情况：&#xA;       a：别人放杠，赢放杠者3*底分；&#xA;       b：自己摸的明杠（公杠），三家出，赢每个玩家1*底分；&#xA;    5.每中一张码，赢每个玩家2*底分；&#xA;    6.胡七对，赢每个玩家2*底分。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="660.0000" Y="1850.0000" />
                    <AnchorPoint />
                    <Position X="0.0002" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition />
                    <PreSize X="1.0000" Y="1.0000" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="20.0000" Y="30.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0286" Y="0.0667" />
                <PreSize X="0.9429" Y="0.7333" />
                <SingleColor A="255" R="255" G="255" B="255" />
                <FirstColor A="255" R="255" G="150" B="100" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
                <InnerNodeSize Width="660" Height="1850" />
              </AbstractNodeData>
              <AbstractNodeData Name="Pl_RoomRule" ActionTag="1019562728" Tag="968" IconVisible="False" LeftMargin="15.0000" RightMargin="15.0000" TopMargin="105.0000" BottomMargin="45.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="670.0000" Y="300.0000" />
                <Children>
                  <AbstractNodeData Name="Tt_KouFei" ActionTag="-1040478816" Tag="253" IconVisible="False" LeftMargin="15.0000" RightMargin="607.0000" TopMargin="8.0000" BottomMargin="268.0000" FontSize="24" LabelText="扣费" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="48.0000" Y="24.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="15.0000" Y="280.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.0224" Y="0.9333" />
                    <PreSize X="0.0716" Y="0.0800" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Pay1" ActionTag="-700750941" Tag="941" IconVisible="False" LeftMargin="92.5000" RightMargin="522.5000" TopMargin="-9.0000" BottomMargin="251.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Pay1" ActionTag="76971753" Tag="948" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-194.0000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="46" LabelText="房主出资" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="184.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="29.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1818" Y="0.5000" />
                        <PreSize X="3.3455" Y="0.7931" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="120.0000" Y="280.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.1791" Y="0.9333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Pay2" ActionTag="1371981876" Tag="942" IconVisible="False" LeftMargin="232.5000" RightMargin="382.5000" TopMargin="-9.0000" BottomMargin="251.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Pay2" ActionTag="239347123" Tag="947" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-194.0000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="46" LabelText="玩家平摊" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="184.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="29.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1818" Y="0.5000" />
                        <PreSize X="3.3455" Y="0.7931" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="260.0000" Y="280.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.3881" Y="0.9333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_PayCheck" ActionTag="-989289763" Tag="940" IconVisible="False" LeftMargin="92.5000" RightMargin="522.5000" TopMargin="-11.0000" BottomMargin="249.0000" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="35" Scale9Height="42" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="120.0000" Y="280.0000" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1791" Y="0.9333" />
                    <PreSize X="0.0821" Y="0.2067" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_QuanShu" ActionTag="-22494888" Tag="252" IconVisible="False" LeftMargin="15.0000" RightMargin="607.0000" TopMargin="68.0000" BottomMargin="208.0000" FontSize="24" LabelText="局数" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="48.0000" Y="24.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="15.0000" Y="220.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.0224" Y="0.7333" />
                    <PreSize X="0.0716" Y="0.0800" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round1" ActionTag="1654963588" Tag="960" IconVisible="False" LeftMargin="92.5000" RightMargin="522.5000" TopMargin="51.0000" BottomMargin="191.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Round1" ActionTag="-1692067872" Tag="962" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-79.0000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="46" LabelText="4局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="69.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="29.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1818" Y="0.5000" />
                        <PreSize X="1.2545" Y="0.7931" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="120.0000" Y="220.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.1791" Y="0.7333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round2" ActionTag="-432641420" Tag="959" IconVisible="False" LeftMargin="212.5000" RightMargin="402.5000" TopMargin="51.0000" BottomMargin="191.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Round2" ActionTag="-1918782559" Tag="946" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-79.0000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="46" LabelText="8局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="69.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="29.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1818" Y="0.5000" />
                        <PreSize X="1.2545" Y="0.7931" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="240.0000" Y="220.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.3582" Y="0.7333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round3" ActionTag="97915086" Tag="961" IconVisible="False" LeftMargin="332.5000" RightMargin="282.5000" TopMargin="51.0000" BottomMargin="191.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Round3" ActionTag="-570383246" Tag="945" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-102.0000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="46" LabelText="16局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="92.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="29.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1818" Y="0.5000" />
                        <PreSize X="1.6727" Y="0.7931" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="360.0000" Y="220.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.5373" Y="0.7333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_RoundCheck" ActionTag="182914496" Tag="957" IconVisible="False" LeftMargin="92.5000" RightMargin="522.5000" TopMargin="49.0000" BottomMargin="189.0000" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="35" Scale9Height="42" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="120.0000" Y="220.0000" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1791" Y="0.7333" />
                    <PreSize X="0.0821" Y="0.2067" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_difen" ActionTag="874036892" Tag="251" IconVisible="False" LeftMargin="15.0000" RightMargin="607.0000" TopMargin="128.0000" BottomMargin="148.0000" FontSize="24" LabelText="底分" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="48.0000" Y="24.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="15.0000" Y="160.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.0224" Y="0.5333" />
                    <PreSize X="0.0716" Y="0.0800" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_buttomDi" ActionTag="-1732390671" Tag="362" IconVisible="False" LeftMargin="100.0000" RightMargin="490.0000" TopMargin="125.0000" BottomMargin="145.0000" Scale9Enable="True" LeftEage="7" RightEage="7" TopEage="13" BottomEage="13" Scale9OriginX="7" Scale9OriginY="13" Scale9Width="16" Scale9Height="18" ctype="ImageViewObjectData">
                    <Size X="80.0000" Y="30.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="140.0000" Y="160.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2090" Y="0.5333" />
                    <PreSize X="0.1194" Y="0.1000" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/BG44.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_DiFen" ActionTag="293333163" Tag="14383" IconVisible="False" LeftMargin="129.0000" RightMargin="519.0000" TopMargin="129.0000" BottomMargin="149.0000" FontSize="22" LabelText="50" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="22.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="140.0000" Y="160.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="165" B="0" />
                    <PrePosition X="0.2090" Y="0.5333" />
                    <PreSize X="0.0328" Y="0.0733" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_JiangMaNum" ActionTag="-244408974" Tag="7671" IconVisible="False" LeftMargin="15.0000" RightMargin="559.0000" TopMargin="188.0000" BottomMargin="88.0000" FontSize="24" LabelText="奖码数量" VerticalAlignmentType="VT_Center" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="96.0000" Y="24.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="15.0000" Y="100.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.0224" Y="0.3333" />
                    <PreSize X="0.1433" Y="0.0800" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_JiangMa1" ActionTag="-1977294262" Tag="254" IconVisible="False" LeftMargin="122.5000" RightMargin="492.5000" TopMargin="171.0000" BottomMargin="71.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_JiangMa1" ActionTag="-267245461" Tag="255" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-79.0000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="46" LabelText="2个" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="69.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="29.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1818" Y="0.5000" />
                        <PreSize X="1.2545" Y="0.7931" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="150.0000" Y="100.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.2239" Y="0.3333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_JiangMa2" ActionTag="990092636" Tag="256" IconVisible="False" LeftMargin="242.5000" RightMargin="372.5000" TopMargin="171.0000" BottomMargin="71.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_JiangMa2" ActionTag="1044683933" Tag="257" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-79.0000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="46" LabelText="4个" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="69.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="29.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1818" Y="0.5000" />
                        <PreSize X="1.2545" Y="0.7931" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="270.0000" Y="100.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.4030" Y="0.3333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_JiangMa3" ActionTag="-146625622" Tag="258" IconVisible="False" LeftMargin="362.5000" RightMargin="252.5000" TopMargin="171.0000" BottomMargin="71.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_JiangMa3" ActionTag="442448750" Tag="259" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-79.0000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="46" LabelText="6个" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="69.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="29.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.1818" Y="0.5000" />
                        <PreSize X="1.2545" Y="0.7931" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="390.0000" Y="100.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.5821" Y="0.3333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_JiangMaCheck" ActionTag="-905395269" Tag="260" IconVisible="False" LeftMargin="122.5000" RightMargin="492.5000" TopMargin="169.0000" BottomMargin="69.0000" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="35" Scale9Height="42" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="150.0000" Y="100.0000" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2239" Y="0.3333" />
                    <PreSize X="0.0821" Y="0.2067" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_b7pairs" ActionTag="-884873283" Tag="7670" IconVisible="False" LeftMargin="15.0000" RightMargin="559.0000" TopMargin="248.0000" BottomMargin="28.0000" FontSize="24" LabelText="可胡七对" VerticalAlignmentType="VT_Center" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="96.0000" Y="24.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="15.0000" Y="40.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="154" G="92" B="42" />
                    <PrePosition X="0.0224" Y="0.1333" />
                    <PreSize X="0.1433" Y="0.0800" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_7pairsBg" ActionTag="639378869" Tag="262" IconVisible="False" LeftMargin="122.5000" RightMargin="492.5000" TopMargin="231.0000" BottomMargin="11.0000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="58.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="150.0000" Y="40.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.2239" Y="0.1333" />
                    <PreSize X="0.0821" Y="0.1933" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_7pairs" ActionTag="453869556" Tag="261" IconVisible="False" LeftMargin="122.5000" RightMargin="492.5000" TopMargin="229.0000" BottomMargin="9.0000" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="35" Scale9Height="42" ctype="ImageViewObjectData">
                    <Size X="55.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="150.0000" Y="40.0000" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2239" Y="0.1333" />
                    <PreSize X="0.0821" Y="0.2067" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check1.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="1.0000" />
                <Position X="15.0000" Y="345.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0214" Y="0.7667" />
                <PreSize X="0.9571" Y="0.6667" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_GameRule" ActionTag="-1395253882" Tag="758" IconVisible="False" LeftMargin="15.0000" RightMargin="350.0000" TopMargin="15.0000" BottomMargin="365.0000" LeftEage="1" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="1" Scale9OriginY="18" Scale9Width="316" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="335.0000" Y="70.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="15.0000" Y="400.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0214" Y="0.8889" />
                <PreSize X="0.4786" Y="0.1556" />
                <FileData Type="MarkedSubImage" Path="games/hzmj/game/btn_ruleTop11.png" Plist="games/hzmj/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckRoomRule" ActionTag="1783918964" Tag="757" IconVisible="False" LeftMargin="15.0000" RightMargin="350.0000" TopMargin="15.0000" BottomMargin="365.0000" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="335.0000" Y="70.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="15.0000" Y="400.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0214" Y="0.8889" />
                <PreSize X="0.4786" Y="0.1556" />
                <FileData Type="MarkedSubImage" Path="games/hzmj/game/btn_ruleTop12.png" Plist="games/hzmj/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_RoomRule" ActionTag="-280127197" Tag="762" IconVisible="False" LeftMargin="350.0000" RightMargin="15.0000" TopMargin="15.0000" BottomMargin="365.0000" Scale9Enable="True" LeftEage="1" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="1" Scale9OriginY="18" Scale9Width="316" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="335.0000" Y="70.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="685.0000" Y="400.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9786" Y="0.8889" />
                <PreSize X="0.4786" Y="0.1556" />
                <FileData Type="MarkedSubImage" Path="games/hzmj/game/btn_ruleTop21.png" Plist="games/hzmj/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckGameRule" ActionTag="1131596904" VisibleForFrame="False" Tag="761" IconVisible="False" LeftMargin="350.0000" RightMargin="15.0000" TopMargin="15.0000" BottomMargin="365.0000" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="335.0000" Y="70.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="685.0000" Y="400.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9786" Y="0.8889" />
                <PreSize X="0.4786" Y="0.1556" />
                <FileData Type="MarkedSubImage" Path="games/hzmj/game/btn_ruleTop22.png" Plist="games/hzmj/game_1.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0000" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.5247" Y="0.6000" />
            <FileData Type="MarkedSubImage" Path="hallcomm/common/img/BG35.png" Plist="hallcomm/common/CommonPlist0.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>