<GameFile>
  <PropertyGroup Name="GameRuleLayer" Type="Layer" ID="6a34b9e1-b055-485e-99e1-072fbc5f0f21" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="53" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="Ie_Bg" CanEdit="False" ActionTag="243452451" Tag="287" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="313.3335" RightMargin="316.6665" TopMargin="150.0000" BottomMargin="150.0000" TouchEnable="True" Scale9Enable="True" LeftEage="48" RightEage="48" TopEage="36" BottomEage="36" Scale9OriginX="48" Scale9OriginY="36" Scale9Width="33" Scale9Height="63" ctype="ImageViewObjectData">
            <Size X="704.0000" Y="450.0000" />
            <Children>
              <AbstractNodeData Name="LV_GameRule" ActionTag="-1103254868" VisibleForFrame="False" Tag="906" IconVisible="False" LeftMargin="25.5748" RightMargin="28.4252" TopMargin="104.1099" BottomMargin="45.8901" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" ItemMargin="20" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="650.0000" Y="300.0000" />
                <Children>
                  <AbstractNodeData Name="Text_1" ActionTag="179052607" Tag="3217" IconVisible="False" BottomMargin="476.0000" IsCustomSize="True" FontSize="24" LabelText="&#xA;血流成河&#xA;&#xA;一、基本规则&#xA;1、用牌：1-9筒、1-9万、1-9条，共108张牌。&#xA;2、可以碰、杠，不可以吃。&#xA;3、缺一门才可胡，即和牌的时候不能有三种花色的牌。&#xA;4、和牌后可以再次胡。&#xA;5、【刮风下雨】：直杠收取引杠者2倍游戏积分，补杠收取其他玩家1倍游戏积分，暗杠收取其他玩家2倍游戏积分。&#xA;6、【退税】：牌局结束时s玩家未听牌，则退回全部刮风下雨所得。&#xA;7、【查花猪】：牌局结束时手牌有三种花色的玩家为花猪，花猪赔给非花猪玩家封顶倍数（x64）。&#xA;8、【查大叫】：牌局结束时未听牌玩家（花猪不用）赔给听牌玩家最大可能倍数。&#xA;9、【呼叫转移】：玩家杠牌后杠上炮，需将自己所有的杠牌所得转给被点炮的玩家。&#xA;10、【一炮多响】：点炮后可多个玩家和牌，点炮者与每个被点炮者单独结算。&#xA;&#xA;二、基本番型&#xA;基本番：不重复计算，只计最大番型。&#xA;【平胡】x1，四坎牌加一对将。&#xA;【对对胡】x2，四副刻字加一对将。&#xA;【清一色】x4，玩家和牌的手牌全部都是一门花色。&#xA;【带幺九】x4，玩家手牌中，全部是用1的连牌或者9的连牌组成的牌。&#xA;【七对】x4，玩家的手牌全部是两张一对的，没有碰过和杠过。&#xA;【金钩钓】x4，玩家和牌时，其他牌都被用作碰牌、杠牌；手牌只剩下唯一的一张牌，不计对对胡。&#xA;【清对】x8，清一色的对对胡。&#xA;【龙七对】x16，玩家手牌为暗七对牌型，没有碰或者杠过，并且有四张牌是一样的，叫龙七对。不再计七对，同时减1根。&#xA;【清七对】x16，玩家手上的牌是清一色的七对。不计清一色、七对。&#xA;【清幺九】x16，清一色的幺九。&#xA;【将金钩钓】x16，指金钩钓里手牌、碰牌、杠牌的牌必现是2、5、8。不计将对、金钩钓、对对胡。&#xA;【清金钩钓】x16，指金钩钓听牌时，胡牌时的牌型都为同一花色。不计清一色、金钩钓、对对胡。&#xA;【天胡】x32，打牌的过程中，庄家第一次摸完牌后，就胡牌，叫天胡。&#xA;【地胡】x32，打牌的过程中，非庄家第一次摸完牌后就可以下叫，第一轮摸牌后就胡牌，叫地胡。&#xA;【清龙七对】x32，玩家手牌是清一色的龙七时，叫清龙七对。算番时减1根。&#xA;【十八罗汉】x64，在金钩钓里，若有四个杠，此时所有的牌有18张，所以称之为十八罗汉。不计4根、金钩钓、对对胡。&#xA;【清十八罗汉】x256，清一色的十八罗汉。不计清一色、金钩钓、对对胡、4根。&#xA;&#xA;&#xA;另加番：&#xA;杠上花，1番，杠了之后补牌而胡。&#xA;杠上炮，1番，玩家在杠牌时，先杠一张牌，再打掉一张牌，而打出的这张牌正好是其他玩家胡牌所需要的叫牌时，这种情况叫 杠上炮。即玩家杠了后补牌，打出，然后给其他玩家胡了。&#xA;抢杠胡，1番，玩家面下杠时，他家可以抢杠而胡，且刮风下雨无效。&#xA;根，1番，手牌中有4张一样的牌即为1根。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="650.0000" Y="984.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="325.0000" Y="968.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.5000" Y="0.6630" />
                    <PreSize X="1.0000" Y="0.6740" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_2" ActionTag="423991779" ZOrder="1" Tag="3216" IconVisible="False" TopMargin="1004.0000" IsCustomSize="True" FontSize="24" LabelText="&#xA;三、特殊规则&#xA;换三张：第一步，每人选3张同花色手牌（不足3张的同花色不能换）。第二步，换牌，随机选择一个换牌顺序，顺时针、逆时针或对象互换。第三步，完成。&#xA;&#xA;四、房间规则&#xA;(1)、模式选择：&#xA;1、可选择是否开房换三张和呼叫转移。&#xA;2、可选择自摸模式：自摸不加倍、自摸+1倍或自摸乘2倍。&#xA;3、可选择点杠花的模式（玩家A点杠玩家B，B在补张时自摸，则为点杠花）：点杠花当自摸，则B按照自摸赢三家。点杠花当炮，则B按照点炮赢一家。&#xA;(2)、额外番型：&#xA;1、【带幺九】开放番型幺九、清幺九。&#xA;带幺九：每副刻字/顺子/将都包含1或9，x4&#xA;清幺九：清一色+幺九x16&#xA;2、【将对】开放番型将对、将金钩钓。&#xA;将对：由2/5/8组成的对对胡，x8（不计对对胡）&#xA;将金钩：金钩钓+将对。x16（不计对对胡）&#xA;3、【门清】胡牌时没有碰杠，自摸胡牌，则额外x2倍。&#xA;4、【断幺九】胡牌时，没有1、9，则额外x2倍。&#xA;5、【天地胡】开放天胡、地胡。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="650.0000" Y="456.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="325.0000" Y="228.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.5000" Y="0.1562" />
                    <PreSize X="1.0000" Y="0.3123" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="25.5748" Y="45.8901" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0363" Y="0.1020" />
                <PreSize X="0.9233" Y="0.6667" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="LV_GameRule_xzdd" ActionTag="-1462927262" VisibleForFrame="False" Tag="73" IconVisible="False" LeftMargin="24.5700" RightMargin="29.4300" TopMargin="105.1100" BottomMargin="44.8900" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" ItemMargin="20" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="650.0000" Y="300.0000" />
                <Children>
                  <AbstractNodeData Name="Text_1" ActionTag="723777537" Tag="74" IconVisible="False" BottomMargin="476.0000" IsCustomSize="True" FontSize="24" LabelText="&#xA;血战到底&#xA;&#xA;一、基本规则&#xA;1、用牌：1-9筒、1-9万、1-9条，共108张牌。&#xA;2、可以碰、杠，不可以吃。&#xA;3、缺一门才可胡，即和牌的时候不能有三种花色的牌。&#xA;4、和牌后可以再次胡。&#xA;5、【刮风下雨】：直杠收取引杠者2倍游戏积分，补杠收取其他玩家1倍游戏积分，暗杠收取其他玩家2倍游戏积分。&#xA;6、【退税】：牌局结束时s玩家未听牌，则退回全部刮风下雨所得。&#xA;7、【查花猪】：牌局结束时手牌有三种花色的玩家为花猪，花猪赔给非花猪玩家封顶倍数（x64）。&#xA;8、【查大叫】：牌局结束时未听牌玩家（花猪不用）赔给听牌玩家最大可能倍数。&#xA;9、【呼叫转移】：玩家杠牌后杠上炮，需将自己所有的杠牌所得转给被点炮的玩家。&#xA;10、【一炮多响】：点炮后可多个玩家和牌，点炮者与每个被点炮者单独结算。&#xA;&#xA;二、基本番型&#xA;基本番：不重复计算，只计最大番型。&#xA;【平胡】x1，四坎牌加一对将。&#xA;【对对胡】x2，四副刻字加一对将。&#xA;【清一色】x4，玩家和牌的手牌全部都是一门花色。&#xA;【带幺九】x4，玩家手牌中，全部是用1的连牌或者9的连牌组成的牌。&#xA;【七对】x4，玩家的手牌全部是两张一对的，没有碰过和杠过。&#xA;【金钩钓】x4，玩家和牌时，其他牌都被用作碰牌、杠牌；手牌只剩下唯一的一张牌，不计对对胡。&#xA;【清对】x8，清一色的对对胡。&#xA;【龙七对】x16，玩家手牌为暗七对牌型，没有碰或者杠过，并且有四张牌是一样的，叫龙七对。不再计七对，同时减1根。&#xA;【清七对】x16，玩家手上的牌是清一色的七对。不计清一色、七对。&#xA;【清幺九】x16，清一色的幺九。&#xA;【将金钩钓】x16，指金钩钓里手牌、碰牌、杠牌的牌必现是2、5、8。不计将对、金钩钓、对对胡。&#xA;【清金钩钓】x16，指金钩钓听牌时，胡牌时的牌型都为同一花色。不计清一色、金钩钓、对对胡。&#xA;【天胡】x32，打牌的过程中，庄家第一次摸完牌后，就胡牌，叫天胡。&#xA;【地胡】x32，打牌的过程中，非庄家第一次摸完牌后就可以下叫，第一轮摸牌后就胡牌，叫地胡。&#xA;【清龙七对】x32，玩家手牌是清一色的龙七时，叫清龙七对。算番时减1根。&#xA;【十八罗汉】x64，在金钩钓里，若有四个杠，此时所有的牌有18张，所以称之为十八罗汉。不计4根、金钩钓、对对胡。&#xA;【清十八罗汉】x256，清一色的十八罗汉。不计清一色、金钩钓、对对胡、4根。&#xA;&#xA;&#xA;另加番：&#xA;杠上花，1番，杠了之后补牌而胡。&#xA;杠上炮，1番，玩家在杠牌时，先杠一张牌，再打掉一张牌，而打出的这张牌正好是其他玩家胡牌所需要的叫牌时，这种情况叫 杠上炮。即玩家杠了后补牌，打出，然后给其他玩家胡了。&#xA;抢杠胡，1番，玩家面下杠时，他家可以抢杠而胡，且刮风下雨无效。&#xA;根，1番，手牌中有4张一样的牌即为1根。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="650.0000" Y="984.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="325.0000" Y="968.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.5000" Y="0.6630" />
                    <PreSize X="1.0000" Y="0.6740" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_2" CanEdit="False" ActionTag="1542838189" ZOrder="1" Tag="75" IconVisible="False" TopMargin="1004.0000" IsCustomSize="True" FontSize="24" LabelText="&#xA;三、特殊规则&#xA;换三张：第一步，每人选3张同花色手牌（不足3张的同花色不能换）。第二步，换牌，随机选择一个换牌顺序，顺时针、逆时针或对象互换。第三步，完成。&#xA;&#xA;四、房间规则&#xA;(1)、模式选择：&#xA;1、可选择是否开房换三张和呼叫转移。&#xA;2、可选择自摸模式：自摸不加倍、自摸+1倍或自摸乘2倍。&#xA;3、可选择点杠花的模式（玩家A点杠玩家B，B在补张时自摸，则为点杠花）：点杠花当自摸，则B按照自摸赢三家。点杠花当炮，则B按照点炮赢一家。&#xA;(2)、额外番型：&#xA;1、【带幺九】开放番型幺九、清幺九。&#xA;带幺九：每副刻字/顺子/将都包含1或9，x4&#xA;清幺九：清一色+幺九x16&#xA;2、【将对】开放番型将对、将金钩钓。&#xA;将对：由2/5/8组成的对对胡，x8（不计对对胡）&#xA;将金钩：金钩钓+将对。x16（不计对对胡）&#xA;3、【门清】胡牌时没有碰杠，自摸胡牌，则额外x2倍。&#xA;4、【断幺九】胡牌时，没有1、9，则额外x2倍。&#xA;5、【天地胡】开放天胡、地胡。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="650.0000" Y="456.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="325.0000" Y="228.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.5000" Y="0.1562" />
                    <PreSize X="1.0000" Y="0.3123" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="24.5700" Y="44.8900" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0349" Y="0.0998" />
                <PreSize X="0.9233" Y="0.6667" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Pl_RoomRule" ActionTag="1019562728" Tag="968" IconVisible="False" LeftMargin="16.3946" RightMargin="18.2075" TopMargin="108.6964" BottomMargin="47.3036" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="669.3979" Y="294.0000" />
                <Children>
                  <AbstractNodeData Name="Tt_Pay" ActionTag="-542162749" Tag="18291" IconVisible="False" LeftMargin="21.3867" RightMargin="557.0112" TopMargin="-3.5827" BottomMargin="271.5827" FontSize="26" LabelText="扣 费：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.8867" Y="284.5827" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.0999" Y="0.9680" />
                    <PreSize X="0.1359" Y="0.0884" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_buttomDi" ActionTag="-1732390671" Tag="362" IconVisible="False" LeftMargin="111.0002" RightMargin="458.3977" TopMargin="75.0002" BottomMargin="174.9998" Scale9Enable="True" LeftEage="7" RightEage="7" TopEage="13" BottomEage="13" Scale9OriginX="7" Scale9OriginY="13" Scale9Width="16" Scale9Height="18" ctype="ImageViewObjectData">
                    <Size X="100.0000" Y="44.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="111.0002" Y="196.9998" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1658" Y="0.6701" />
                    <PreSize X="0.1494" Y="0.1497" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/BG44.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Pay1" ActionTag="-700750941" Tag="941" IconVisible="False" LeftMargin="110.0000" RightMargin="513.3979" TopMargin="-17.5000" BottomMargin="264.5000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Pay1" ActionTag="76971753" Tag="948" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-203.0000" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="房主出资" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="184.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.4130" Y="0.5000" />
                        <PreSize X="4.0000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="110.0000" Y="288.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.1643" Y="0.9796" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Pay2" ActionTag="1371981876" Tag="942" IconVisible="False" LeftMargin="240.0000" RightMargin="383.3979" TopMargin="-17.5000" BottomMargin="264.5000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Pay2" ActionTag="239347123" Tag="947" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-203.0000" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="玩家平摊" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="184.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.4130" Y="0.5000" />
                        <PreSize X="4.0000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="240.0000" Y="288.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.3585" Y="0.9796" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_PayCheck" ActionTag="-989289763" Tag="940" IconVisible="False" LeftMargin="111.0004" RightMargin="519.3975" TopMargin="-14.5001" BottomMargin="266.5001" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="111.0004" Y="287.5001" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1658" Y="0.9779" />
                    <PreSize X="0.0583" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round1" ActionTag="1654963588" Tag="960" IconVisible="False" LeftMargin="110.0000" RightMargin="513.3979" TopMargin="25.5000" BottomMargin="221.5000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Round1" ActionTag="-1692067872" Tag="962" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-88.0000" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="4局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="69.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.4130" Y="0.5000" />
                        <PreSize X="1.5000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="110.0000" Y="245.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.1643" Y="0.8333" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round2" ActionTag="-432641420" Tag="959" IconVisible="False" LeftMargin="240.0001" RightMargin="383.3978" TopMargin="25.5000" BottomMargin="221.5000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Round2" ActionTag="-1918782559" Tag="946" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-88.0000" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="8局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="69.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.4130" Y="0.5000" />
                        <PreSize X="1.5000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="240.0001" Y="245.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.3585" Y="0.8333" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round3" ActionTag="97915086" Tag="961" IconVisible="False" LeftMargin="370.0001" RightMargin="253.3978" TopMargin="25.5000" BottomMargin="221.5000" LeftEage="32" RightEage="1" TopEage="10" BottomEage="10" Scale9OriginX="32" Scale9OriginY="10" Scale9Width="13" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Tt_Round3" ActionTag="-570383246" Tag="945" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-111.0000" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="16局" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="92.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.4130" Y="0.5000" />
                        <PreSize X="2.0000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="370.0001" Y="245.0000" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.5527" Y="0.8333" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_RoundCheck" ActionTag="182914496" Tag="957" IconVisible="False" LeftMargin="111.0000" RightMargin="519.3979" TopMargin="28.4999" BottomMargin="223.5001" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="111.0000" Y="244.5001" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1658" Y="0.8316" />
                    <PreSize X="0.0583" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_1" ActionTag="-1156542757" Tag="348" IconVisible="False" LeftMargin="109.9999" RightMargin="513.3979" TopMargin="123.5545" BottomMargin="123.4455" LeftEage="15" RightEage="15" TopEage="15" BottomEage="15" Scale9OriginX="15" Scale9OriginY="15" Scale9Width="16" Scale9Height="17" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="-444961403" Tag="351" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0008" RightMargin="-88.0008" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="8倍" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="69.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0008" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.4131" Y="0.5000" />
                        <PreSize X="1.5000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="109.9999" Y="146.9455" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.1643" Y="0.4998" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_2" ActionTag="-316136514" Tag="352" IconVisible="False" LeftMargin="240.0000" RightMargin="383.3979" TopMargin="123.5545" BottomMargin="123.4455" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="28" Scale9Height="29" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="23821084" Tag="354" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="62.9990" RightMargin="-108.9990" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="16倍" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="92.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="62.9990" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.3695" Y="0.5000" />
                        <PreSize X="2.0000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="240.0000" Y="146.9455" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.3585" Y="0.4998" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_3" ActionTag="2112884316" Tag="2886" IconVisible="False" LeftMargin="369.9998" RightMargin="253.3981" TopMargin="123.5545" BottomMargin="123.4455" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="28" Scale9Height="29" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="360715149" Tag="2887" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="62.9990" RightMargin="-108.9990" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="32倍" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="92.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="62.9990" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.3695" Y="0.5000" />
                        <PreSize X="2.0000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="369.9998" Y="146.9455" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.5527" Y="0.4998" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_4" ActionTag="-1953113174" Tag="6066" IconVisible="False" LeftMargin="109.9999" RightMargin="519.3979" TopMargin="178.0001" BottomMargin="73.9999" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="22" Scale9Height="24" ctype="ImageViewObjectData">
                    <Size X="40.0000" Y="42.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="1958416472" Tag="6067" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-163.0000" TopMargin="-2.0000" BottomMargin="-2.0000" FontSize="46" LabelText="换三张" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="138.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="21.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.6250" Y="0.5000" />
                        <PreSize X="3.4500" Y="1.0952" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="109.9999" Y="94.9999" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.1643" Y="0.3231" />
                    <PreSize X="0.0598" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckBox_Bg.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_5" ActionTag="-117403145" Tag="6068" IconVisible="False" LeftMargin="293.9999" RightMargin="335.3980" TopMargin="178.0001" BottomMargin="73.9999" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="22" Scale9Height="24" ctype="ImageViewObjectData">
                    <Size X="40.0000" Y="42.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="1427118297" Tag="6069" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-163.0000" TopMargin="-2.0000" BottomMargin="-2.0000" FontSize="46" LabelText="天地胡" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="138.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="21.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.6250" Y="0.5000" />
                        <PreSize X="3.4500" Y="1.0952" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="293.9999" Y="94.9999" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.4392" Y="0.3231" />
                    <PreSize X="0.0598" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckBox_Bg.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_6" ActionTag="-414073594" Tag="3197" IconVisible="False" LeftMargin="448.0000" RightMargin="181.3979" TopMargin="178.0001" BottomMargin="73.9999" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="22" Scale9Height="24" ctype="ImageViewObjectData">
                    <Size X="40.0000" Y="42.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="-1110698474" Tag="3198" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-209.0000" TopMargin="-3.3566" BottomMargin="-0.6434" FontSize="46" LabelText="门清中张" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="184.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="22.3566" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.6250" Y="0.5323" />
                        <PreSize X="4.6000" Y="1.0952" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="448.0000" Y="94.9999" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.6693" Y="0.3231" />
                    <PreSize X="0.0598" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckBox_Bg.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check1" ActionTag="1161289" Tag="350" IconVisible="False" LeftMargin="110.5970" RightMargin="519.8009" TopMargin="126.4921" BottomMargin="125.5079" ctype="SpriteObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="110.5970" Y="146.5079" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1652" Y="0.4983" />
                    <PreSize X="0.0583" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check2" ActionTag="715569925" Tag="353" IconVisible="False" LeftMargin="240.6351" RightMargin="389.7628" TopMargin="126.7729" BottomMargin="125.2271" ctype="SpriteObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="240.6351" Y="146.2271" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3595" Y="0.4974" />
                    <PreSize X="0.0583" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check3" ActionTag="-2037958077" Tag="2888" IconVisible="False" LeftMargin="370.8515" RightMargin="259.5464" TopMargin="126.5994" BottomMargin="125.4006" ctype="SpriteObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="370.8515" Y="146.4006" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5540" Y="0.4980" />
                    <PreSize X="0.0583" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check4" ActionTag="-697413288" Tag="6071" IconVisible="False" LeftMargin="109.0000" RightMargin="518.3979" TopMargin="178.8380" BottomMargin="76.1620" ctype="SpriteObjectData">
                    <Size X="42.0000" Y="39.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="109.0000" Y="95.6620" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1628" Y="0.3254" />
                    <PreSize X="0.0627" Y="0.1327" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckBox_Gou.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check5" ActionTag="141873722" Tag="6072" IconVisible="False" LeftMargin="292.9998" RightMargin="334.3981" TopMargin="179.1372" BottomMargin="75.8628" ctype="SpriteObjectData">
                    <Size X="42.0000" Y="39.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="292.9998" Y="95.3628" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4377" Y="0.3244" />
                    <PreSize X="0.0627" Y="0.1327" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckBox_Gou.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check6" ActionTag="-1329605652" Tag="3199" IconVisible="False" LeftMargin="446.9991" RightMargin="180.3988" TopMargin="179.1370" BottomMargin="75.8630" ctype="SpriteObjectData">
                    <Size X="42.0000" Y="39.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="446.9991" Y="95.3630" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.6678" Y="0.3244" />
                    <PreSize X="0.0627" Y="0.1327" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckBox_Gou.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_DiFen" ActionTag="293333163" Tag="14383" IconVisible="False" LeftMargin="148.9795" RightMargin="498.4184" TopMargin="84.0000" BottomMargin="188.0000" FontSize="22" LabelText="50" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="22.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="159.9795" Y="199.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="165" B="0" />
                    <PrePosition X="0.2390" Y="0.6769" />
                    <PreSize X="0.0329" Y="0.0748" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="154" G="92" B="42" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_rule_1" ActionTag="600113235" Tag="2898" IconVisible="False" LeftMargin="354.0853" RightMargin="269.3126" TopMargin="235.6963" BottomMargin="11.3037" LeftEage="15" RightEage="15" TopEage="15" BottomEage="15" Scale9OriginX="15" Scale9OriginY="15" Scale9Width="16" Scale9Height="17" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="1547953965" Tag="2899" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0008" RightMargin="-295.0008" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="点杠花(自摸)" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="276.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0008" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.4131" Y="0.5000" />
                        <PreSize X="6.0000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="354.0853" Y="34.8037" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.5290" Y="0.1184" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_rule_2" ActionTag="-1849205283" Tag="2896" IconVisible="False" LeftMargin="109.0001" RightMargin="514.3978" TopMargin="235.6963" BottomMargin="11.3037" LeftEage="15" RightEage="15" TopEage="15" BottomEage="15" Scale9OriginX="15" Scale9OriginY="15" Scale9Width="16" Scale9Height="17" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="2143450139" Tag="2897" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0008" RightMargin="-295.0008" TopMargin="0.5000" BottomMargin="0.5000" FontSize="46" LabelText="点杠花(点炮)" VerticalAlignmentType="VT_Center" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="276.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0008" Y="23.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.4131" Y="0.5000" />
                        <PreSize X="6.0000" Y="0.9787" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="109.0001" Y="34.8037" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.1628" Y="0.1184" />
                    <PreSize X="0.0687" Y="0.1599" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/Check0.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_RuleCheck_1" ActionTag="-1468624077" Tag="2902" IconVisible="False" LeftMargin="109.5502" RightMargin="520.8477" TopMargin="239.0495" BottomMargin="12.9505" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="109.5502" Y="33.9505" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1637" Y="0.1155" />
                    <PreSize X="0.0583" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_RuleCheck_2" ActionTag="1623004370" Tag="2903" IconVisible="False" LeftMargin="354.7665" RightMargin="275.6314" TopMargin="239.2032" BottomMargin="12.7968" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="354.7665" Y="33.7968" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5300" Y="0.1150" />
                    <PreSize X="0.0583" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="CheckBox_7" ActionTag="684681092" Tag="10381" IconVisible="False" LeftMargin="597.9995" RightMargin="31.3984" TopMargin="178.0001" BottomMargin="73.9999" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="22" Scale9Height="24" ctype="ImageViewObjectData">
                    <Size X="40.0000" Y="42.0000" />
                    <Children>
                      <AbstractNodeData Name="Text" ActionTag="986510392" Tag="10382" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.0000" RightMargin="-209.0000" TopMargin="-3.3566" BottomMargin="-0.6434" FontSize="46" LabelText="幺九将对" ShadowOffsetX="-0.5000" ShadowOffsetY="-0.5000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="184.0000" Y="46.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="65.0000" Y="22.3566" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="154" G="92" B="42" />
                        <PrePosition X="1.6250" Y="0.5323" />
                        <PreSize X="4.6000" Y="1.0952" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="154" G="92" B="42" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="597.9995" Y="94.9999" />
                    <Scale ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.8933" Y="0.3231" />
                    <PreSize X="0.0598" Y="0.1429" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckBox_Bg.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Se_Check7" ActionTag="-1633264372" Tag="10383" IconVisible="False" LeftMargin="596.9988" RightMargin="30.3991" TopMargin="179.1370" BottomMargin="75.8630" ctype="SpriteObjectData">
                    <Size X="42.0000" Y="39.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="596.9988" Y="95.3630" />
                    <Scale ScaleX="0.5500" ScaleY="0.5500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.8918" Y="0.3244" />
                    <PreSize X="0.0627" Y="0.1327" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckBox_Gou.png" Plist="hallcomm/common/CommonPlist0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Round" ActionTag="-1915201146" Tag="18292" IconVisible="False" LeftMargin="21.3867" RightMargin="557.0112" TopMargin="37.5285" BottomMargin="230.4715" FontSize="26" LabelText="圈 数：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.8867" Y="243.4715" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.0999" Y="0.8281" />
                    <PreSize X="0.1359" Y="0.0884" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_difen" ActionTag="635676202" Tag="18293" IconVisible="False" LeftMargin="21.3867" RightMargin="557.0112" TopMargin="88.6397" BottomMargin="179.3603" FontSize="26" LabelText="底 分：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.8867" Y="192.3603" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.0999" Y="0.6543" />
                    <PreSize X="0.1359" Y="0.0884" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_fengding" ActionTag="-984129161" Tag="18294" IconVisible="False" LeftMargin="21.3867" RightMargin="557.0112" TopMargin="132.7509" BottomMargin="135.2491" FontSize="26" LabelText="封 顶：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.8867" Y="148.2491" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.0999" Y="0.5042" />
                    <PreSize X="0.1359" Y="0.0884" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_wanfa" ActionTag="1070946118" Tag="18295" IconVisible="False" LeftMargin="21.3867" RightMargin="557.0112" TopMargin="183.8620" BottomMargin="84.1380" FontSize="26" LabelText="玩 法：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.8867" Y="97.1380" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.0999" Y="0.3304" />
                    <PreSize X="0.1359" Y="0.0884" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_wanfa1" ActionTag="-1408895971" Tag="18296" IconVisible="False" LeftMargin="21.3867" RightMargin="557.0112" TopMargin="244.9731" BottomMargin="23.0269" FontSize="26" LabelText="玩 法：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.8867" Y="36.0269" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.0999" Y="0.1225" />
                    <PreSize X="0.1359" Y="0.0884" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="1.0000" />
                <Position X="16.3946" Y="341.3036" />
                <Scale ScaleX="0.9000" ScaleY="0.9000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0233" Y="0.7585" />
                <PreSize X="0.9508" Y="0.6533" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_GameRule" ActionTag="-1395253882" Tag="758" IconVisible="False" HorizontalEdge="RightEdge" LeftMargin="13.5000" RightMargin="353.5000" TopMargin="14.0000" BottomMargin="366.0000" LeftEage="1" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="1" Scale9OriginY="18" Scale9Width="316" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="182.0000" Y="401.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2585" Y="0.8911" />
                <PreSize X="0.4787" Y="0.1556" />
                <FileData Type="MarkedSubImage" Path="games/scmj/game/btn_ruleTop11.png" Plist="games/scmj/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_RoomRule" ActionTag="-280127197" Tag="762" IconVisible="False" LeftMargin="351.5000" RightMargin="15.5000" TopMargin="14.0000" BottomMargin="366.0000" Scale9Enable="True" LeftEage="1" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="1" Scale9OriginY="18" Scale9Width="316" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="520.0000" Y="401.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7386" Y="0.8911" />
                <PreSize X="0.4787" Y="0.1556" />
                <FileData Type="MarkedSubImage" Path="games/scmj/game/btn_ruleTop21.png" Plist="games/scmj/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckGameRule" ActionTag="1131596904" VisibleForFrame="False" Tag="761" IconVisible="False" LeftMargin="351.5000" RightMargin="15.5000" TopMargin="14.0000" BottomMargin="366.0000" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="520.0000" Y="401.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7386" Y="0.8911" />
                <PreSize X="0.4787" Y="0.1556" />
                <FileData Type="MarkedSubImage" Path="games/scmj/game/btn_ruleTop22.png" Plist="games/scmj/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckRoomRule" ActionTag="1783918964" Tag="757" IconVisible="False" LeftMargin="14.5000" RightMargin="352.5000" TopMargin="14.0000" BottomMargin="366.0000" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="183.0000" Y="401.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2599" Y="0.8911" />
                <PreSize X="0.4787" Y="0.1556" />
                <FileData Type="MarkedSubImage" Path="games/scmj/game/btn_ruleTop12.png" Plist="games/scmj/game_1.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="665.3335" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4988" Y="0.5000" />
            <PreSize X="0.5277" Y="0.6000" />
            <FileData Type="MarkedSubImage" Path="games/scmj/game/msgBox_bg.png" Plist="games/scmj/game_2.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>