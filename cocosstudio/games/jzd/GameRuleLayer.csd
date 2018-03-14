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
            <FileData Type="MarkedSubImage" Path="games/jzd/game/BG6.png" Plist="games/jzd/game_1.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="Ie_RuleBg" ActionTag="464316746" Tag="1789" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="367.0000" RightMargin="367.0000" TopMargin="145.0000" BottomMargin="145.0000" Scale9Enable="True" LeftEage="50" RightEage="50" TopEage="50" BottomEage="50" Scale9OriginX="50" Scale9OriginY="50" Scale9Width="29" Scale9Height="35" ctype="ImageViewObjectData">
            <Size X="600.0000" Y="460.0000" />
            <Children>
              <AbstractNodeData Name="LV_GameRule" ActionTag="665750761" VisibleForFrame="False" Tag="1790" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="20.0000" RightMargin="20.0000" TopMargin="69.0000" BottomMargin="31.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="560.0000" Y="360.0000" />
                <Children>
                  <AbstractNodeData Name="text1" ActionTag="1117206178" Tag="287" IconVisible="False" IsCustomSize="True" FontSize="24" LabelText="棋牌名称：黄骅尖子顶&#xA;棋牌简介：黄骅尖子顶棋牌流行于黄骅市地区扑克牌玩法&#xA;游戏人数：3个人&#xA;游戏用牌：扑克牌一副&#xA;玩法介绍：三人用一副牌共 54 张牌。拿底牌（3张）者为地主，其余两家为另一方（农民），双方对战，拿底牌者先出完牌获胜，其余两家全出完获胜。出完一家另一家未出完平局。&#xA;出牌：黑桃4首先出牌，然后按逆时针顺序依次出牌，某一组出完牌时结束本局。 &#xA;&#xA;打牌牌型：&#xA;对红五：最大的牌（红桃5+方块5）&#xA;对红四：特殊牌型，可以启炸（既把对方出的三张炸拿回手里来）&#xA;双王：大王和小王。&#xA;轰炸：四张同数值牌（如四个6为轰）。&#xA;三张同数值牌（如三个6为炸弹）。&#xA;单牌：单个牌（如红桃5）。&#xA;对牌：数值相同的两张牌（比如梅花4+方块4）。&#xA;单顺：三张或更多的连续单牌（如：456或78910JQK）不包括2,3或双王。&#xA;双顺：三对或更多的连续对牌（如：445566,7788991010）不包括2,3或双王。&#xA;&#xA;胜负规则：胜负判定：地主方先出完牌则地主获胜。农民方两人全出完获胜，出完一个另一个未出去平局。如果踹牌后则农民方出去一人即获胜。&#xA;牌型大小：&#xA;1.对红五最大，可以打任意其他的牌。（555三个一起出没有这个特殊效果，和普通炸弹一样，666就可以管上）&#xA;2.双王为火箭仅次与对红五。 &#xA;3.轰炸仅次与对红五和双王，按牌型大小3333&gt;2222&gt;AAAA&gt;KKKK&gt;QQQQ依次排列，4444在轰炸里最小。 &#xA;4.炸弹比轰炸小，比其他牌大。都是炸弹时按牌的分值比大小。 &#xA;5.除轰炸和炸弹外，其他牌必须要牌型相同且总张数相同才能比大小。相同牌型按牌的分值比大小。 &#xA;6.依次是 大王 &gt; 小王 3&gt;2&gt;A&gt;K&gt;Q&gt;J&gt;10&gt;9&gt;8&gt;7&gt;6&gt;5&gt;4&gt; ，不分花色。 &#xA;7.顺牌按最大的一张牌的分值来比大小。。&#xA;&#xA;积分计算：要到底牌的承担另外两人的分数 &#xA;底分：叫牌的分数可叫1 2 3分或不叫，如3家都不叫，则重新开局。&#xA;一局结束后： &#xA;地主胜：地主得分为 2* 底分 其余玩家各得：底分 * 倍数 &#xA;地主败：地主得分为 -2* 底分 其余玩家各得：底分 * 倍数&#xA;地主要3分，农民可以踹牌，要到底牌的承担另外两人的分数 &#xA;踹牌后，输赢×2，对方反踹，输赢再×2，最多踹两次。（地主要3分，农民踹了之后变6分，地主在反踹一次则变12分）" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="560.0000" Y="1600.0000" />
                    <AnchorPoint ScaleY="1.0000" />
                    <Position Y="1600.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition Y="1.0000" />
                    <PreSize X="1.0000" Y="1.0000" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="300.0000" Y="391.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.8500" />
                <PreSize X="0.9333" Y="0.7826" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="LV_GameRule2" ActionTag="2049192918" VisibleForFrame="False" Tag="562" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="20.0000" RightMargin="20.0000" TopMargin="69.0000" BottomMargin="31.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="560.0000" Y="360.0000" />
                <Children>
                  <AbstractNodeData Name="text1" ActionTag="-640287276" Tag="563" IconVisible="False" IsCustomSize="True" FontSize="24" LabelText="棋牌名称：黄骅尖子顶五人玩法&#xA;游戏人数：五个人&#xA;游戏用牌：扑克牌一副&#xA;玩法介绍：五人用一副牌共 54 张牌。第一局从建房者逆时针开始发牌，前4位每人11张牌，第5位（最后一位）为10张牌.下局从上一局第一个胜出者开始发牌.&#xA;一. 两组互相PK玩法，下面介绍哪种情况下各分2组&#xA;1.分别拿大猫和小猫者为一组，其余3位没有拿到猫牌者为令一组.&#xA;2.如果2个猫在一位玩家手中，这位玩家为一组，其余4位玩家为令一组.&#xA;3.选择喊，喊的玩家自己为一组，其余4位为一组.&#xA;4.选择明撩，明撩的玩家自己为一组，其余4位为一组.&#xA;5.选择蔫溜，蔫溜的玩家自己为一组，其余4位为一组.&#xA;二.胜负介绍：&#xA;1.选择蔫溜、喊、明撩、某一组一位玩家胜出，则为赢方.&#xA;2.选择亮猫、揪猫.另一方选择踹或者反踹，某一组一位玩家胜出，则为赢方&#xA;3.选择亮猫、揪猫.没有踹的情况下，按顺序先后顺序定胜负.&#xA;举例A组为猫B组为没拿猫者（字母后面数字为排名）&#xA;A1 B2 A3      这种情况下，B组2人走最后，A组胜利（虽然胜利，算分不同）&#xA;A1 B2 B3 A4 B5这种情况下，B组1人走最后，A组胜利（虽然胜利，算分不同）&#xA;B1 A2 B3 B4 A5这种情况下，A组1人走最后，B组胜利（虽然胜利，算分不同）&#xA;A1 B2 B3 B4 A5这种情况下，为平局&#xA;B1 B2 A3 A4 B5这种情况下，为平局&#xA;第一轮：提示（没事、喊、明撂）（蔫溜、喊、明撂，要朋友）双猫者&#xA;1..起始牌后，5位玩家出提示：没事、喊、明撂…牌型中有双猫者则出提示：蔫溜、喊、明撂，要朋友&#xA;2.选择喊，则其余4位为一个组，喊的人为一组，互相PK&#xA;3.选择明撂，则其余4位为一个组，明撩的人为一个组，互相PK  &#xA;4、选择蔫溜，还可以选择没事和亮猫，如果不选择亮猫，其他人还可以选择揪猫；&#xA;注：选择明撂者手里的牌要摊开，放在桌面，其余四位玩家可以查看.也就是其余4位玩家看着明撂玩家的牌出牌&#xA;4.双猫者选择蔫溜，则所有玩家直接进入第二轮提示（没事、亮猫）其余玩家什么都不提示），双猫者选择没事，其余4位玩家提示 没事、揪猫&#xA;6.双猫者选择要朋友，则屏幕弹出一个小方框（系统自动出8张牌，从KKKK QQQQ 依次开始，，8张牌里面不能有玩家手中的牌）&#xA;以上玩家选择 喊、明撂 其余4位玩家分别出提示：没事、踹&#xA;选择没事，黑桃四出牌，&#xA;选择踹，另外一组玩家提示（没事，反踹）这两项选择什么，下一步都是玩家亮黑桃四出牌&#xA;第二轮：提示（没事、亮猫）&#xA;第二轮提示，只有手中有猫者提示（10秒钟没选择，默认没事）进入第三轮&#xA;双猫如果在一家，选择没事进入第三轮，选择亮王，等于4人PK亮猫者&#xA;大小猫分别在2家，2位玩家选择没事则进入第三轮提示，如果选择亮猫，其余三位玩家则提示（没事，踹）选择没事，玩家亮黑桃四出牌，选择踹，两位亮猫者提示（没事、反踹）&#xA;第三轮：提示（没事、揪猫）&#xA;第三轮提示只有手中没有猫的玩家提示,玩家亮黑桃四出牌;&#xA;选择没事，玩家亮黑桃四出牌&#xA;选择揪猫，拿猫方，出提示（没事，踹）选择没事，玩家亮黑桃四出牌..选择踹，没猫方提示（没事，反踹）选择什么下一步都是玩家亮黑桃四出牌&#xA;积分结算：&#xA;算分按人头算，一个人头一分，抓到一个1分，抓到2个一人2分，踹了，翻一倍，反踹在翻一倍的基础上在翻一倍&#xA;喊：在4个人头的基础上加一个人头;&#xA;明撂：在喊的基础上分数乘2倍;&#xA;五人剪子顶跟三人剪子顶玩法除了5个人外，玩法是一样的，3张可以成顺子，3个是炸，4个是轰，对红五最大，对红四可起炸，黑桃四先出." ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="560.0000" Y="2500.0000" />
                    <AnchorPoint ScaleY="1.0000" />
                    <Position Y="2500.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition Y="1.0000" />
                    <PreSize X="1.0000" Y="1.0000" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="300.0000" Y="391.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.8500" />
                <PreSize X="0.9333" Y="0.7826" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Pl_RoomRule" ActionTag="-881895844" Tag="1871" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="17.4600" RightMargin="22.5400" TopMargin="74.0003" BottomMargin="28.9513" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="560.0000" Y="357.0484" />
                <Children>
                  <AbstractNodeData Name="Tt_Pay" ActionTag="-1453004661" Tag="216" IconVisible="False" LeftMargin="24.5000" RightMargin="444.5000" TopMargin="14.0484" BottomMargin="317.0000" FontSize="26" LabelText="扣 费：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="70.0000" Y="330.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.1250" Y="0.9242" />
                    <PreSize X="0.1625" Y="0.0728" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Pay1" ActionTag="1199344755" Tag="1872" IconVisible="False" LeftMargin="130.0000" RightMargin="384.0000" TopMargin="3.5484" BottomMargin="306.5000" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="130.0000" Y="330.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.2321" Y="0.9242" />
                    <PreSize X="0.0821" Y="0.1316" />
                    <FileData Type="MarkedSubImage" Path="games/jzd/game/CheckBg.png" Plist="games/jzd/game_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Pay2" ActionTag="-1159513323" Tag="1873" IconVisible="False" LeftMargin="340.0000" RightMargin="174.0000" TopMargin="3.5484" BottomMargin="306.5000" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="340.0000" Y="330.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.6071" Y="0.9242" />
                    <PreSize X="0.0821" Y="0.1316" />
                    <FileData Type="MarkedSubImage" Path="games/jzd/game/CheckBg.png" Plist="games/jzd/game_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Pay1" ActionTag="-1276662552" Tag="1878" IconVisible="False" LeftMargin="183.0000" RightMargin="273.0000" TopMargin="14.0484" BottomMargin="317.0000" FontSize="26" LabelText="房主扣费" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="104.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="235.0000" Y="330.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.4196" Y="0.9242" />
                    <PreSize X="0.1857" Y="0.0728" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Pay2" ActionTag="681717077" Tag="1877" IconVisible="False" LeftMargin="388.0000" RightMargin="68.0000" TopMargin="14.0484" BottomMargin="317.0000" FontSize="26" LabelText="玩家平摊" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="104.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="440.0000" Y="330.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.7857" Y="0.9242" />
                    <PreSize X="0.1857" Y="0.0728" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_PayCheck" ActionTag="1478917643" Tag="1895" IconVisible="False" LeftMargin="131.0000" RightMargin="390.0000" TopMargin="8.0484" BottomMargin="307.0000" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="131.0000" Y="328.0000" />
                    <Scale ScaleX="0.9000" ScaleY="0.9000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2339" Y="0.9186" />
                    <PreSize X="0.0696" Y="0.1176" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Round" ActionTag="2006534562" Tag="217" IconVisible="False" LeftMargin="24.5000" RightMargin="444.5000" TopMargin="64.0484" BottomMargin="267.0000" FontSize="26" LabelText="圈 数：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="70.0000" Y="280.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.1250" Y="0.7842" />
                    <PreSize X="0.1625" Y="0.0728" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round1" ActionTag="1040426693" Tag="1887" IconVisible="False" LeftMargin="130.0000" RightMargin="384.0000" TopMargin="54.2534" BottomMargin="255.7950" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <AnchorPoint ScaleY="0.5150" />
                    <Position X="130.0000" Y="280.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.2321" Y="0.7842" />
                    <PreSize X="0.0821" Y="0.1316" />
                    <FileData Type="MarkedSubImage" Path="games/jzd/game/CheckBg.png" Plist="games/jzd/game_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Round1" ActionTag="120966867" Tag="1889" IconVisible="False" LeftMargin="180.5000" RightMargin="340.5000" TopMargin="64.0484" BottomMargin="267.0000" FontSize="26" LabelText="5局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="39.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="200.0000" Y="280.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.3571" Y="0.7842" />
                    <PreSize X="0.0696" Y="0.0728" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round2" ActionTag="481460579" Tag="1886" IconVisible="False" LeftMargin="260.0000" RightMargin="254.0000" TopMargin="53.5484" BottomMargin="256.5000" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="260.0000" Y="280.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.4643" Y="0.7842" />
                    <PreSize X="0.0821" Y="0.1316" />
                    <FileData Type="MarkedSubImage" Path="games/jzd/game/CheckBg.png" Plist="games/jzd/game_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Round2" ActionTag="1550138607" Tag="1876" IconVisible="False" LeftMargin="309.0000" RightMargin="199.0000" TopMargin="64.0484" BottomMargin="267.0000" FontSize="26" LabelText="10局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="52.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="335.0000" Y="280.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.5982" Y="0.7842" />
                    <PreSize X="0.0929" Y="0.0728" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_Round3" ActionTag="753150152" Tag="1888" IconVisible="False" LeftMargin="395.0000" RightMargin="119.0000" TopMargin="54.2534" BottomMargin="255.7950" Scale9Enable="True" LeftEage="9" RightEage="9" TopEage="10" BottomEage="10" Scale9OriginX="9" Scale9OriginY="10" Scale9Width="28" Scale9Height="27" ctype="ImageViewObjectData">
                    <Size X="46.0000" Y="47.0000" />
                    <AnchorPoint ScaleY="0.5150" />
                    <Position X="395.0000" Y="280.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="191" G="191" B="191" />
                    <PrePosition X="0.7054" Y="0.7842" />
                    <PreSize X="0.0821" Y="0.1316" />
                    <FileData Type="MarkedSubImage" Path="games/jzd/game/CheckBg.png" Plist="games/jzd/game_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Round3" ActionTag="1189290481" Tag="1875" IconVisible="False" LeftMargin="444.0000" RightMargin="64.0000" TopMargin="64.0484" BottomMargin="267.0000" FontSize="26" LabelText="15局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="52.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="470.0000" Y="280.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.8393" Y="0.7842" />
                    <PreSize X="0.0929" Y="0.0728" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Ie_RoundCheck" ActionTag="-509392614" Tag="1896" IconVisible="False" LeftMargin="131.0000" RightMargin="390.0000" TopMargin="58.0484" BottomMargin="257.0000" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="19" Scale9Height="22" ctype="ImageViewObjectData">
                    <Size X="39.0000" Y="42.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="131.0000" Y="278.0000" />
                    <Scale ScaleX="0.9000" ScaleY="0.9000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2339" Y="0.7786" />
                    <PreSize X="0.0696" Y="0.1176" />
                    <FileData Type="MarkedSubImage" Path="hallcomm/common/img/CheckGreen.png" Plist="hallcomm/common/CommonPlist0.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_64" ActionTag="245859507" Tag="364" IconVisible="False" LeftMargin="130.0000" RightMargin="330.0000" TopMargin="107.0484" BottomMargin="210.0000" Scale9Enable="True" LeftEage="7" RightEage="7" TopEage="13" BottomEage="13" Scale9OriginX="7" Scale9OriginY="13" Scale9Width="8" Scale9Height="14" ctype="ImageViewObjectData">
                    <Size X="100.0000" Y="40.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="180.0000" Y="230.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3214" Y="0.6442" />
                    <PreSize X="0.1786" Y="0.1120" />
                    <FileData Type="MarkedSubImage" Path="games/jzd/game/bg_frame3.png" Plist="games/jzd/game_1.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Tt_Base" ActionTag="59330727" Tag="218" IconVisible="False" LeftMargin="24.5000" RightMargin="444.5000" TopMargin="114.0484" BottomMargin="217.0000" FontSize="26" LabelText="底 分：" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="91.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="70.0000" Y="230.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="116" G="61" B="0" />
                    <PrePosition X="0.1250" Y="0.6442" />
                    <PreSize X="0.1625" Y="0.0728" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_BaseScore" ActionTag="-2027084097" Tag="356" IconVisible="False" LeftMargin="171.0000" RightMargin="371.0000" TopMargin="109.0484" BottomMargin="212.0000" FontSize="36" LabelText="1" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="18.0000" Y="36.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="180.0000" Y="230.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="213" B="132" />
                    <PrePosition X="0.3214" Y="0.6442" />
                    <PreSize X="0.0321" Y="0.1008" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5010" ScaleY="1.0000" />
                <Position X="298.0200" Y="385.9997" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4967" Y="0.8391" />
                <PreSize X="0.9333" Y="0.7762" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_RoomRule" ActionTag="-1275680154" Tag="1899" IconVisible="False" LeftMargin="15.0000" RightMargin="248.0000" TopMargin="8.0000" BottomMargin="382.0000" Scale9Enable="True" LeftEage="1" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="1" Scale9OriginY="18" Scale9Width="316" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="15.0000" Y="417.0000" />
                <Scale ScaleX="0.8500" ScaleY="0.8000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0250" Y="0.9065" />
                <PreSize X="0.5617" Y="0.1522" />
                <FileData Type="MarkedSubImage" Path="games/jzd/game/Button_Rule1N.png" Plist="games/jzd/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckRoomRule" ActionTag="2086471165" Tag="1903" IconVisible="False" LeftMargin="15.0000" RightMargin="248.0000" TopMargin="8.0000" BottomMargin="382.0000" Scale9Enable="True" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="15.0000" Y="417.0000" />
                <Scale ScaleX="0.8500" ScaleY="0.8000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0250" Y="0.9065" />
                <PreSize X="0.5617" Y="0.1522" />
                <FileData Type="MarkedSubImage" Path="games/jzd/game/Button_Rule1S.png" Plist="games/jzd/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Bn_GameRule" ActionTag="1480033052" Tag="1901" IconVisible="False" HorizontalEdge="RightEdge" LeftMargin="248.0000" RightMargin="15.0000" TopMargin="8.0000" BottomMargin="382.0000" Scale9Enable="True" LeftEage="40" RightEage="40" TopEage="14" BottomEage="40" Scale9OriginX="40" Scale9OriginY="14" Scale9Width="257" Scale9Height="16" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="585.0000" Y="417.0000" />
                <Scale ScaleX="0.8500" ScaleY="0.8000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9750" Y="0.9065" />
                <PreSize X="0.5617" Y="0.1522" />
                <FileData Type="MarkedSubImage" Path="games/jzd/game/Button_Rule2N.png" Plist="games/jzd/game_1.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Ie_CheckGameRule" ActionTag="2105570875" VisibleForFrame="False" Tag="1905" IconVisible="False" LeftMargin="248.0000" RightMargin="15.0000" TopMargin="8.0000" BottomMargin="382.0000" Scale9Enable="True" LeftEage="20" RightEage="20" TopEage="18" BottomEage="18" Scale9OriginX="20" Scale9OriginY="18" Scale9Width="297" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="337.0000" Y="70.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="585.0000" Y="417.0000" />
                <Scale ScaleX="0.8500" ScaleY="0.8000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9750" Y="0.9065" />
                <PreSize X="0.5617" Y="0.1522" />
                <FileData Type="MarkedSubImage" Path="games/jzd/game/Button_Rule2S.png" Plist="games/jzd/game_1.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0000" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.4498" Y="0.6133" />
            <FileData Type="MarkedSubImage" Path="games/jzd/game/bg_fram.png" Plist="games/jzd/game_1.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>