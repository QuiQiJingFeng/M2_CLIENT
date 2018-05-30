<GameFile>
  <PropertyGroup Name="GameRuleLayer" Type="Layer" ID="29102667-d301-4d43-b8bc-9c491706ac4f" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="1785" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="Ie_Mark" ActionTag="-168028847" Tag="1907" IconVisible="False" HorizontalEdge="BothEdge" VerticalEdge="BothEdge" LeftMargin="0.0001" TopMargin="-2.3561" BottomMargin="2.3561" TouchEnable="True" StretchWidthEnable="True" StretchHeightEnable="True" LeftEage="17" RightEage="17" TopEage="15" BottomEage="15" Scale9OriginX="17" Scale9OriginY="15" Scale9Width="19" Scale9Height="18" ctype="ImageViewObjectData">
            <Size X="1333.9999" Y="750.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0001" Y="377.3561" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5031" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="MarkedSubImage" Path="games/pdk/game/BG6.png" Plist="games/pdk/game_1.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="Ie_Bg" ActionTag="1327518847" Tag="1786" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="1388.1052" RightMargin="-100.1052" TopMargin="368.8750" BottomMargin="335.1250" TouchEnable="True" Scale9Enable="True" LeftEage="22" RightEage="22" TopEage="19" BottomEage="19" Scale9OriginX="22" Scale9OriginY="19" Scale9Width="2" Scale9Height="8" ctype="ImageViewObjectData">
            <Size X="46.0000" Y="46.0000" />
            <Children>
              <AbstractNodeData Name="Ie_RuleBg" ActionTag="464316746" Tag="1789" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-1021.7124" RightMargin="467.7124" TopMargin="-242.3210" BottomMargin="-211.7954" Scale9Enable="True" LeftEage="50" RightEage="50" TopEage="50" BottomEage="50" Scale9OriginX="50" Scale9OriginY="50" Scale9Width="29" Scale9Height="35" ctype="ImageViewObjectData">
                <Size X="600.0000" Y="500.1164" />
                <Children>
                  <AbstractNodeData Name="LV_GameRule" ActionTag="665750761" VisibleForFrame="False" Tag="1790" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="18.0200" RightMargin="21.9800" TopMargin="73.2509" BottomMargin="26.7406" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
                    <Size X="560.0000" Y="400.1249" />
                    <Children>
                      <AbstractNodeData Name="Tt_Part1" ActionTag="1671210672" Tag="1791" IconVisible="False" RightMargin="-12.0000" BottomMargin="1378.0000" FontSize="26" LabelText="一、游戏人数：3人（2人）&#xA;二、游戏牌数：经典玩法：一副牌去掉大小王、&#xA;去掉1个A、去掉3个2 ,共 剰48张牌，每人16&#xA;张牌；十五张玩法：在经典玩法的基础上再去&#xA;掉2个A、1个K。&#xA;三、出牌順序&#xA;每局首出都由玩家创建房间时选中方式进行出&#xA;牌，可以出任意的牌型，然后其他玩家依次出牌。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="572.0000" Y="208.0000" />
                        <AnchorPoint ScaleY="1.0000" />
                        <Position Y="1586.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition Y="1.0000" />
                        <PreSize X="1.0214" Y="0.1311" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Part2" ActionTag="1117206178" ZOrder="1" Tag="287" IconVisible="False" RightMargin="1.0000" TopMargin="208.0000" FontSize="26" LabelText="四、牌型&#xA;1、单张：任意1张单牌&#xA;2、顺子：任意5张或者5张以上点数相连的牌。&#xA;特殊：2是最大的单牌，不能当順子出！&#xA;3、对子：可以打单对，如：44&#xA;4、连对：2对或2对以上点数相连的牌，如：5566&#xA;5、三带二：点数相同的3张牌+ —对牌或者点&#xA;数相同的3张牌+ 2张不同的单牌，如：55577&#xA;或者55567&#xA;6、三带一：打到最后剰4张牌的时候，才可以&#xA;3带1&#xA;7、没打完的情况下，不可以出3张点数相同的&#xA;牌！最后只剩3张牌的时候可以不带&#xA;8、飞机：两順或以上+数量相同的对牌，如:&#xA;555666+99JJ;也可以带4张单牌，&#xA;如：555666+78910&#xA;9、在有牌情况下，出555666必須带4张牌，除&#xA;非牌不够不带或者带少牌&#xA;10、炸弹：4张点数相同的牌，如6666,7777&#xA;11、关门：有一家牌已经出完，另一家或者两&#xA;家1张牌都没出，此时的状态称为关门&#xA;12、报单放走包赔&#xA;13、牌型的比较点数大小，从大到小依次为:&#xA;2、A、K、Q、J、10、9、8、7、6、5、4、3 &#xA;五、积分规则：&#xA;   一张牌1分 &#xA;   1个炸10分 &#xA;   报单不出不进&#xA;   关门：被关门者剰余牌的张数*2 &#xA;(和炸弹可累加）&#xA;创建房间功能说明：&#xA;1、	3人玩：这次玩家参与人数为3人。&#xA;2、	2人玩：这次玩家参与人数为2人。&#xA;3、	显示牌：游戏开始后，显示全部玩家还有&#xA;多少手牌。&#xA;4、	不显示牌：游戏开始后，不显示玩家还有&#xA;多少手牌。&#xA;5、	黑桃3先出：游戏由手牌存在黑桃3的玩家&#xA;幵始第一轮手牌。牌型可自由搭配。&#xA;6、	赢家先出：首局拿到黑桃三的先出，&#xA;以后每局赢家先出。&#xA;7、小必出：上家打出的牌型下家能压下的必&#xA;需压下，游戏中也不存在【不出】技纽。&#xA;8、可不要：上家打出的牌型下家能压下的可以&#xA;选择【不出】该牌。&#xA;七、注意项&#xA;1、黑桃3先出&amp;黑桃3必出为绑定关系，只有在&#xA;选择黑桃3先出的情况下才可以选择黑桃3必出。&#xA;八、红桃10扎鸟玩法&#xA;在湖南地区比较流行的一种打法，也就是红桃&#xA;10叫做鸟，拿到鸟牌(红桃10 )的玩家，这时&#xA;候不管输贏还是关门都将是所输贏积分的2倍&#xA;（乘2 )。炸弹则不翻倍。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="559.0000" Y="1378.0000" />
                        <AnchorPoint ScaleY="1.0000" />
                        <Position Y="1378.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition Y="0.8689" />
                        <PreSize X="0.9982" Y="0.8689" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                    <Position X="298.0200" Y="426.8655" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4967" Y="0.8535" />
                    <PreSize X="0.9333" Y="0.8001" />
                    <SingleColor A="255" R="150" G="150" B="255" />
                    <FirstColor A="255" R="150" G="150" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Pl_RoomRule" ActionTag="-881895844" Tag="1871" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="17.4600" RightMargin="22.5400" TopMargin="69.6605" BottomMargin="73.4075" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="560.0000" Y="357.0484" />
                    <Children>
                      <AbstractNodeData Name="Tt_Pay" ActionTag="-1453004661" Tag="216" IconVisible="False" LeftMargin="26.5372" RightMargin="442.4628" TopMargin="12.5898" BottomMargin="318.4586" FontSize="26" LabelText="扣 费：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="91.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.0372" Y="331.4586" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.1286" Y="0.9283" />
                        <PreSize X="0.1625" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Pay1" ActionTag="1199344755" Tag="1872" IconVisible="False" LeftMargin="130.9832" RightMargin="383.0168" TopMargin="3.3183" BottomMargin="306.7301" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="130.9832" Y="330.2301" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.2339" Y="0.9249" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Pay2" ActionTag="-1159513323" Tag="1873" IconVisible="False" LeftMargin="339.0677" RightMargin="174.9323" TopMargin="2.5482" BottomMargin="307.5002" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="339.0677" Y="331.0002" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.6055" Y="0.9270" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Pay1" ActionTag="-1276662552" Tag="1878" IconVisible="False" LeftMargin="182.7991" RightMargin="273.2009" TopMargin="13.2810" BottomMargin="317.7674" FontSize="26" LabelText="房主扣费" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="104.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="234.7991" Y="330.7674" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.4193" Y="0.9264" />
                        <PreSize X="0.1857" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Pay2" ActionTag="681717077" Tag="1877" IconVisible="False" LeftMargin="388.3212" RightMargin="67.6788" TopMargin="12.2811" BottomMargin="318.7673" FontSize="26" LabelText="玩家平摊" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="104.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="440.3212" Y="331.7673" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.7863" Y="0.9292" />
                        <PreSize X="0.1857" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_PayCheck" ActionTag="1478917643" Tag="1895" IconVisible="False" LeftMargin="132.1397" RightMargin="388.8603" TopMargin="7.6097" BottomMargin="307.4387" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="39.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="132.1397" Y="328.4387" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2360" Y="0.9199" />
                        <PreSize X="0.0696" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/CheckGreen.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Round" ActionTag="2006534562" Tag="217" IconVisible="False" LeftMargin="26.1370" RightMargin="442.8630" TopMargin="63.2806" BottomMargin="267.7678" FontSize="26" LabelText="圈 数：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="91.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="71.6370" Y="280.7678" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.1279" Y="0.7864" />
                        <PreSize X="0.1625" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Round1" ActionTag="1040426693" Tag="1887" IconVisible="False" LeftMargin="130.5234" RightMargin="383.4766" TopMargin="52.2534" BottomMargin="257.7950" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="130.5234" Y="282.0000" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.2331" Y="0.7898" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Round1" ActionTag="120966867" Tag="1889" IconVisible="False" LeftMargin="184.5387" RightMargin="336.4613" TopMargin="63.8549" BottomMargin="267.1935" FontSize="26" LabelText="6局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="39.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="204.0387" Y="280.1935" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.3644" Y="0.7847" />
                        <PreSize X="0.0696" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Round2" ActionTag="481460579" Tag="1886" IconVisible="False" LeftMargin="263.6018" RightMargin="250.3982" TopMargin="51.5484" BottomMargin="258.5000" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="263.6018" Y="282.0000" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.4707" Y="0.7898" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Round2" ActionTag="1550138607" Tag="1876" IconVisible="False" LeftMargin="311.6460" RightMargin="196.3540" TopMargin="62.6655" BottomMargin="268.3829" FontSize="26" LabelText="12局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="52.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="337.6460" Y="281.3829" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.6029" Y="0.7881" />
                        <PreSize X="0.0929" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Round3" ActionTag="753150152" Tag="1888" IconVisible="False" LeftMargin="394.9466" RightMargin="119.0534" TopMargin="52.2534" BottomMargin="257.7950" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="394.9466" Y="282.0000" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.7053" Y="0.7898" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Round3" ActionTag="1189290481" Tag="1875" IconVisible="False" LeftMargin="443.8897" RightMargin="64.1103" TopMargin="62.5579" BottomMargin="268.4905" FontSize="26" LabelText="20局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="52.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="469.8897" Y="281.4905" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.8391" Y="0.7884" />
                        <PreSize X="0.0929" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_RoundCheck" ActionTag="-509392614" Tag="1896" IconVisible="False" LeftMargin="131.6619" RightMargin="389.3381" TopMargin="56.4803" BottomMargin="258.5681" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="39.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="131.6619" Y="279.5681" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2351" Y="0.7830" />
                        <PreSize X="0.0696" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/CheckGreen.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_64" ActionTag="245859507" Tag="364" IconVisible="False" LeftMargin="131.2863" RightMargin="328.7137" TopMargin="105.1563" BottomMargin="211.8921" Scale9Enable="True" LeftEage="7" RightEage="7" TopEage="13" BottomEage="13" Scale9OriginX="7" Scale9OriginY="13" Scale9Width="8" Scale9Height="14" ctype="ImageViewObjectData">
                        <Size X="100.0000" Y="40.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="181.2863" Y="231.8921" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.3237" Y="0.6495" />
                        <PreSize X="0.1786" Y="0.1120" />
                        <FileData Type="MarkedSubImage" Path="game/zpcomm/img/BG26.png" Plist="game/zpcomm/zpcommPlist_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Base" ActionTag="59330727" Tag="218" IconVisible="False" LeftMargin="26.6083" RightMargin="442.3917" TopMargin="112.8300" BottomMargin="218.2184" FontSize="26" LabelText="底 分：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="91.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.1083" Y="231.2184" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.1288" Y="0.6476" />
                        <PreSize X="0.1625" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_BaseScore" ActionTag="-2027084097" Tag="356" IconVisible="False" LeftMargin="170.2170" RightMargin="371.7830" TopMargin="106.7097" BottomMargin="214.3387" FontSize="36" LabelText="1" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="18.0000" Y="36.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="179.2170" Y="232.3387" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="213" B="132" />
                        <PrePosition X="0.3200" Y="0.6507" />
                        <PreSize X="0.0321" Y="0.1008" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Func" ActionTag="-449824265" Tag="205" IconVisible="False" LeftMargin="26.9828" RightMargin="442.0172" TopMargin="363.0436" BottomMargin="-31.9952" FontSize="26" LabelText="功 能：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="91.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.4828" Y="-18.9952" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.1294" Y="-0.0532" />
                        <PreSize X="0.1625" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_WinRule1" ActionTag="-1439870579" Tag="1890" IconVisible="False" LeftMargin="130.0511" RightMargin="383.9489" TopMargin="354.7343" BottomMargin="-44.6859" Scale9Enable="True" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="130.0511" Y="-21.1859" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.2322" Y="-0.0593" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_WinRule1" ActionTag="210878450" Tag="1882" IconVisible="False" LeftMargin="178.1307" RightMargin="277.8693" TopMargin="364.1481" BottomMargin="-33.0997" FontSize="26" LabelText="显示牌数" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="104.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="178.1307" Y="-20.0997" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.3181" Y="-0.0563" />
                        <PreSize X="0.1857" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_WinRule2" ActionTag="1003382938" Tag="1880" IconVisible="False" LeftMargin="288.0471" RightMargin="225.9529" TopMargin="354.7343" BottomMargin="-44.6859" Scale9Enable="True" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="288.0471" Y="-21.1859" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.5144" Y="-0.0593" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_WinRule2" ActionTag="402780092" Tag="1883" IconVisible="False" LeftMargin="337.0842" RightMargin="92.9158" TopMargin="366.9314" BottomMargin="-35.8830" FontSize="26" LabelText="不显示牌数" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="130.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="337.0842" Y="-22.8830" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.6019" Y="-0.0641" />
                        <PreSize X="0.2321" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_WinRuleCheck" ActionTag="-1174693286" Tag="1897" IconVisible="False" LeftMargin="130.4231" RightMargin="390.5769" TopMargin="358.3843" BottomMargin="-43.3359" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="39.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="130.4231" Y="-22.3359" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2329" Y="-0.0626" />
                        <PreSize X="0.0696" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/CheckGreen.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play" ActionTag="1131107102" Tag="219" IconVisible="False" LeftMargin="24.4512" RightMargin="444.5488" TopMargin="163.5283" BottomMargin="167.5201" FontSize="26" LabelText="玩 法：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="91.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="69.9512" Y="180.5201" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.1249" Y="0.5056" />
                        <PreSize X="0.1625" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play1" ActionTag="1716121106" Tag="1395" IconVisible="False" LeftMargin="130.7711" RightMargin="383.2289" TopMargin="151.5034" BottomMargin="158.5450" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="130.7711" Y="182.7500" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.2335" Y="0.5118" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play1" ActionTag="1713607377" Tag="1396" IconVisible="False" LeftMargin="181.0500" RightMargin="313.9500" TopMargin="163.1270" BottomMargin="167.9214" FontSize="26" LabelText="3人玩" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="65.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="181.0500" Y="180.9214" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.3233" Y="0.5067" />
                        <PreSize X="0.1161" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play2" ActionTag="953361977" Tag="1397" IconVisible="False" LeftMargin="264.5520" RightMargin="249.4480" TopMargin="151.5034" BottomMargin="158.5450" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="264.5520" Y="182.7500" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.4724" Y="0.5118" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play2" ActionTag="810174078" Tag="1398" IconVisible="False" LeftMargin="314.8311" RightMargin="180.1689" TopMargin="161.7801" BottomMargin="169.2683" FontSize="26" LabelText="2人玩" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="65.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="314.8311" Y="182.2683" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.5622" Y="0.5105" />
                        <PreSize X="0.1161" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_PlayCheck1" ActionTag="-1182240416" Tag="1394" IconVisible="False" LeftMargin="131.1264" RightMargin="389.8736" TopMargin="155.9720" BottomMargin="159.0764" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="39.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="131.1264" Y="180.0764" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2342" Y="0.5043" />
                        <PreSize X="0.0696" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/CheckGreen.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play3" ActionTag="626137132" Tag="1399" IconVisible="False" LeftMargin="130.8582" RightMargin="383.1418" TopMargin="192.5334" BottomMargin="117.5150" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="130.8582" Y="141.7200" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.2337" Y="0.3969" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play3" ActionTag="518554924" Tag="1400" IconVisible="False" LeftMargin="178.5475" RightMargin="277.4525" TopMargin="202.7913" BottomMargin="128.2571" FontSize="26" LabelText="经典玩法" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="104.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="178.5475" Y="141.2571" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.3188" Y="0.3956" />
                        <PreSize X="0.1857" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play4" ActionTag="-1110110499" Tag="206" IconVisible="False" LeftMargin="302.7924" RightMargin="211.2076" TopMargin="192.5334" BottomMargin="117.5150" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="302.7924" Y="141.7200" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.5407" Y="0.3969" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play4" ActionTag="-681942315" Tag="207" IconVisible="False" LeftMargin="350.4819" RightMargin="79.5181" TopMargin="202.0378" BottomMargin="129.0106" FontSize="26" LabelText="十五张玩法" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="130.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="350.4819" Y="142.0106" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.6259" Y="0.3977" />
                        <PreSize X="0.2321" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_PlayCheck2" ActionTag="-1539255835" Tag="208" IconVisible="False" LeftMargin="131.1480" RightMargin="389.8520" TopMargin="196.2739" BottomMargin="118.7745" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="39.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="131.1480" Y="139.7745" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2342" Y="0.3915" />
                        <PreSize X="0.0696" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/CheckGreen.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play5" ActionTag="-1761429766" Tag="209" IconVisible="False" LeftMargin="131.3701" RightMargin="382.6299" TopMargin="233.8034" BottomMargin="76.2450" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="131.3701" Y="100.4500" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.2346" Y="0.2813" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play5" ActionTag="956663718" Tag="210" IconVisible="False" LeftMargin="179.0597" RightMargin="302.9403" TopMargin="244.0548" BottomMargin="86.9936" FontSize="26" LabelText="必须管" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="78.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="179.0597" Y="99.9936" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.3197" Y="0.2801" />
                        <PreSize X="0.1393" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play6" ActionTag="-1814357996" Tag="211" IconVisible="False" LeftMargin="303.3048" RightMargin="210.6952" TopMargin="233.8034" BottomMargin="76.2450" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="303.3048" Y="100.4500" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.5416" Y="0.2813" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/Check0.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play6" ActionTag="-1449432127" Tag="212" IconVisible="False" LeftMargin="350.9952" RightMargin="131.0048" TopMargin="243.3012" BottomMargin="87.7472" FontSize="26" LabelText="可不要" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="78.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="350.9952" Y="100.7472" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.6268" Y="0.2822" />
                        <PreSize X="0.1393" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_PlayCheck3" ActionTag="-1002046525" Tag="213" IconVisible="False" LeftMargin="131.6600" RightMargin="389.3400" TopMargin="237.7850" BottomMargin="77.2634" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="39.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="131.6600" Y="98.2634" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2351" Y="0.2752" />
                        <PreSize X="0.0696" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/CheckGreen.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play7" ActionTag="411134867" Tag="214" IconVisible="False" LeftMargin="134.5952" RightMargin="385.4048" TopMargin="318.8482" BottomMargin="-3.7998" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="22" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="40.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="134.5952" Y="17.8302" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.2403" Y="0.0499" />
                        <PreSize X="0.0714" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/CheckBox_Bg.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play7" ActionTag="-173537733" Tag="215" IconVisible="False" LeftMargin="178.2848" RightMargin="251.7152" TopMargin="325.6787" BottomMargin="5.3697" FontSize="26" LabelText="红桃10扎鸟" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="130.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="178.2848" Y="18.3697" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.3184" Y="0.0514" />
                        <PreSize X="0.2321" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_PlayCheck4" ActionTag="-1489190067" VisibleForFrame="False" Tag="218" IconVisible="False" LeftMargin="134.2098" RightMargin="383.7902" TopMargin="316.0451" BottomMargin="2.0033" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="22" Scale9Height="19" ctype="ImageViewObjectData">
                        <Size X="42.0000" Y="39.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="134.2098" Y="21.5033" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2397" Y="0.0602" />
                        <PreSize X="0.0750" Y="0.1092" />
                        <FileData Type="MarkedSubImage" Path="games/pdk/game/CheckBox_Gou.png" Plist="games/pdk/game_1.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play8" ActionTag="2041706829" Tag="216" IconVisible="False" LeftMargin="132.0179" RightMargin="381.9821" TopMargin="272.6697" BottomMargin="37.3787" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="132.0179" Y="61.5837" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.2357" Y="0.1725" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play8" ActionTag="-343200806" Tag="217" IconVisible="False" LeftMargin="179.7083" RightMargin="263.2917" TopMargin="282.9251" BottomMargin="48.1233" FontSize="26" LabelText="黑桃3先出" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="117.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="179.7083" Y="61.1233" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.3209" Y="0.1712" />
                        <PreSize X="0.2089" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_PlayCheck5" ActionTag="-1499218938" Tag="219" IconVisible="False" LeftMargin="132.6984" RightMargin="388.3016" TopMargin="277.3202" BottomMargin="37.7282" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="39.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="132.6984" Y="58.7282" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2370" Y="0.1645" />
                        <PreSize X="0.0696" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_Play9" ActionTag="-1088648072" Tag="427" IconVisible="False" LeftMargin="307.6290" RightMargin="206.3710" TopMargin="275.2569" BottomMargin="34.7915" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="46.0000" Y="47.0000" />
                        <AnchorPoint ScaleY="0.5150" />
                        <Position X="307.6290" Y="58.9965" />
                        <Scale ScaleX="0.8000" ScaleY="0.8000" />
                        <CColor A="255" R="191" G="191" B="191" />
                        <PrePosition X="0.5493" Y="0.1652" />
                        <PreSize X="0.0821" Y="0.1316" />
                        <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Tt_Play9" ActionTag="1418632572" Tag="428" IconVisible="False" LeftMargin="355.3187" RightMargin="100.6813" TopMargin="285.5123" BottomMargin="45.5361" FontSize="26" LabelText="赢家先出" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="104.0000" Y="26.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="355.3187" Y="58.5361" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="116" G="61" B="0" />
                        <PrePosition X="0.6345" Y="0.1639" />
                        <PreSize X="0.1857" Y="0.0728" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Ie_PlayCheck6" ActionTag="-630437870" VisibleForFrame="False" Tag="429" IconVisible="False" LeftMargin="309.3088" RightMargin="211.6912" TopMargin="280.9075" BottomMargin="34.1409" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="39.0000" Y="42.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="309.3088" Y="55.1409" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5523" Y="0.1544" />
                        <PreSize X="0.0696" Y="0.1176" />
                        <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5010" ScaleY="1.0000" />
                    <Position X="298.0200" Y="430.4559" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4967" Y="0.8607" />
                    <PreSize X="0.9333" Y="0.7139" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Bn_RoomRule" ActionTag="-1275680154" Tag="1899" IconVisible="False" LeftMargin="12.2360" RightMargin="250.7640" TopMargin="5.4920" BottomMargin="424.6244" Scale9Enable="True" LeftEage="1" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="1" Scale9OriginY="18" Scale9Width="316" Scale9Height="34" ctype="ImageViewObjectData">
                    <Size X="337.0000" Y="70.0000" />
                    <Children>
                      <AbstractNodeData Name="ImageText31" ActionTag="-767332059" VisibleForFrame="False" Tag="1900" IconVisible="False" LeftMargin="181.3629" RightMargin="109.6371" TopMargin="17.2798" BottomMargin="6.7202" FlipX="True" ctype="SpriteObjectData">
                        <Size X="46.0000" Y="46.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="204.3629" Y="29.7202" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6064" Y="0.4246" />
                        <PreSize X="0.1365" Y="0.6571" />
                        <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="12.2360" Y="459.6244" />
                    <Scale ScaleX="0.8500" ScaleY="0.8000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0204" Y="0.9190" />
                    <PreSize X="0.5617" Y="0.1400" />
                    <FileData Type="MarkedSubImage" Path="game/zpcomm/img/btn_ruleTop11.png" Plist="game/zpcomm/zpcommPlist_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_CheckRoomRule" ActionTag="2086471165" Tag="1903" IconVisible="False" LeftMargin="13.7959" RightMargin="249.2041" TopMargin="5.9854" BottomMargin="424.1310" Scale9Enable="True" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                    <Size X="337.0000" Y="70.0000" />
                    <Children>
                      <AbstractNodeData Name="ImageText32" ActionTag="1135110711" VisibleForFrame="False" Tag="1904" IconVisible="False" LeftMargin="153.5901" RightMargin="137.4099" TopMargin="16.6198" BottomMargin="7.3802" ctype="SpriteObjectData">
                        <Size X="46.0000" Y="46.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="176.5901" Y="30.3802" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5240" Y="0.4340" />
                        <PreSize X="0.1365" Y="0.6571" />
                        <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="13.7959" Y="459.1310" />
                    <Scale ScaleX="0.8500" ScaleY="0.8000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0230" Y="0.9180" />
                    <PreSize X="0.5617" Y="0.1400" />
                    <FileData Type="MarkedSubImage" Path="game/zpcomm/img/btn_ruleTop12.png" Plist="game/zpcomm/zpcommPlist_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Bn_GameRule" ActionTag="1480033052" Tag="1901" IconVisible="False" HorizontalEdge="RightEdge" LeftMargin="246.7032" RightMargin="16.2968" TopMargin="6.4280" BottomMargin="423.6884" Scale9Enable="True" LeftEage="40" RightEage="40" TopEage="14" BottomEage="40" Scale9OriginX="40" Scale9OriginY="14" Scale9Width="257" Scale9Height="16" ctype="ImageViewObjectData">
                    <Size X="337.0000" Y="70.0000" />
                    <Children>
                      <AbstractNodeData Name="ImageText33" ActionTag="-1787554432" VisibleForFrame="False" Tag="1902" IconVisible="False" LeftMargin="168.0468" RightMargin="122.9532" TopMargin="17.3951" BottomMargin="6.6049" ctype="SpriteObjectData">
                        <Size X="46.0000" Y="46.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="191.0468" Y="29.6049" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5669" Y="0.4229" />
                        <PreSize X="0.1365" Y="0.6571" />
                        <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="583.7032" Y="458.6884" />
                    <Scale ScaleX="0.8500" ScaleY="0.8000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.9728" Y="0.9172" />
                    <PreSize X="0.5617" Y="0.1400" />
                    <FileData Type="MarkedSubImage" Path="game/zpcomm/img/btn_ruleTop21.png" Plist="game/zpcomm/zpcommPlist_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_CheckGameRule" ActionTag="2105570875" VisibleForFrame="False" Tag="1905" IconVisible="False" LeftMargin="247.6189" RightMargin="15.3811" TopMargin="5.7567" BottomMargin="424.3597" Scale9Enable="True" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                    <Size X="337.0000" Y="70.0000" />
                    <Children>
                      <AbstractNodeData Name="ImageText34" ActionTag="1952398809" VisibleForFrame="False" Tag="1906" IconVisible="False" LeftMargin="163.8629" RightMargin="127.1371" TopMargin="15.3362" BottomMargin="8.6638" FlipX="True" ctype="SpriteObjectData">
                        <Size X="46.0000" Y="46.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="186.8629" Y="31.6638" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5545" Y="0.4523" />
                        <PreSize X="0.1365" Y="0.6571" />
                        <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="584.6189" Y="459.3597" />
                    <Scale ScaleX="0.8500" ScaleY="0.8000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.9744" Y="0.9185" />
                    <PreSize X="0.5617" Y="0.1400" />
                    <FileData Type="MarkedSubImage" Path="game/zpcomm/img/btn_ruleTop22.png" Plist="game/zpcomm/zpcommPlist_1.plist" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-721.7124" Y="38.2628" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-15.6894" Y="0.8318" />
                <PreSize X="13.0435" Y="10.8721" />
                <FileData Type="MarkedSubImage" Path="game/zpcomm/img/BG24.png" Plist="game/zpcomm/zpcommPlist_1.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1411.1052" Y="358.1250" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="1.0578" Y="0.4775" />
            <PreSize X="0.0345" Y="0.0613" />
            <FileData Type="Default" Path="Default/ImageFile.png" Plist="" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>