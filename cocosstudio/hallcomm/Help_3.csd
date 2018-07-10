<GameFile>
  <PropertyGroup Name="Help_3" Type="Layer" ID="673179de-9f90-47ae-b204-1daf4047038c" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="3904" ctype="GameLayerObjectData">
        <Size X="900.0000" Y="546.0000" />
        <Children>
          <AbstractNodeData Name="RuleList" ActionTag="1949781716" Tag="3905" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="10.0000" RightMargin="-30.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
            <Size X="920.0000" Y="546.0000" />
            <Children>
              <AbstractNodeData Name="Text_1" ActionTag="1027513037" Tag="3906" IconVisible="False" RightMargin="40.0000" IsCustomSize="True" FontSize="26" LabelText="红中麻将&#xA;&#xA;&#xA;简介：&#xA;    红中麻将特色是以红中为万能牌又称‘百搭’牌，胡牌后还可以奖码。红中麻将易上手、节奏快，更具刺激性和技术性，现已被广大麻友接受和喜欢。&#xA;&#xA;牌面：&#xA;    红中麻将共112张牌：包括1-9饼、1-9条、1-9万各4张，外加4张红中。&#xA;&#xA;庄家：&#xA;   开桌后第一局系统随机指定某个玩家坐庄。牌局结束后，上局胡牌的玩家为该局庄家，若本局和牌（流局），则由最后摸牌的人做庄。&#xA;&#xA;基本术语：&#xA;   碰：其他玩家打出的牌，自己手里有两张，则可以碰；&#xA;   一句话：同系列的三张连续的牌；&#xA;   一坎牌：三张一样的牌；&#xA;   明杠：&#xA;        a:先碰的牌，自己又摸到一张该牌，则可选择‘杠’又称公杠（公杠必须第一时间杠）；&#xA;        b:打出一张牌，有玩家手里有一坎相同的牌，则该玩家可以‘接杠’，打出该牌的玩家就是‘放杠’；&#xA;    暗杠：手里有4张相同的牌，可以选择‘杠’（暗杠不需要第一时间杠）。&#xA;&#xA;出牌：&#xA;   1.庄家先出牌，打出的牌，其他玩家可进行碰、杠，下家不能吃；&#xA;   2.红中牌可打出，但不能辅助其他牌来碰、杠；&#xA;   3.根据奖码数量，最后要留对应数量的牌，如：创建房间时选择奖码m个，那么倒数第m+1张被摸后(最后一张不打出)，仍无人胡牌，则流局。&#xA;&#xA;胡牌规则&#xA;    1.胡牌时手里要有一个对子，剩余牌必须是‘一句话’或‘一坎牌’；&#xA;    2.摸到四张红中，自动胡牌，胡牌后可正常奖码；&#xA;    3.胡牌只能通过自摸和抢杠胡两种方式；&#xA;    4.‘抢杠胡’：A玩家选择公杠时，此时B玩家可胡这张牌且手中无红中时，则B玩家才可以选择‘抢杠胡’；&#xA;    5.抢杠胡没有一炮通吃，以杠牌玩家下手顺序优先抢杠胡的玩家胡牌；&#xA;    6.被抢杠胡的玩家包赔，包括胡牌后的奖码，但不包括当局胡牌前杠牌的输赢；&#xA;    7.可胡7对（创建房间时需勾选），胡7对时红中不能作为万能牌使用；&#xA;&#xA;奖码规则：&#xA;    胡牌后，进入奖码环节。如创建房间选择奖码n个:&#xA;    1.当胡牌玩家手中有红中时，奖码数为n；当胡牌玩家手中没有红中时，额外奖励两张码,即奖码数为n+2。（剩余牌数不够时，有几张奖几张）；&#xA;    2.当奖码的牌面为红中,1,5,9时即为中码。&#xA;&#xA;计分规则：&#xA;    1.自摸胡牌，赢每个玩家2*底分；&#xA;    2.摸到四张红中胡牌，赢每个玩家2*底分；&#xA;    3.暗杠，赢每个玩家2*底分；&#xA;    4.明杠分两种情况：&#xA;       a：别人放杠，赢放杠者3*底分；&#xA;       b：自己摸的明杠（公杠），三家出，赢每个玩家1*底分；&#xA;    5.每中一张码，赢每个玩家2*底分；&#xA;    6.胡七对，赢每个玩家2*底分。&#xA;&#xA;新增规则：&#xA;    1.  增加四红中胡牌喜分：&#xA;玩家胡牌时，手中有4张红中时，额外赢另外三家每家5*底分&#xA;注：创建房间时给出可选项，默认勾选&#xA;    2.	不中当全中：&#xA;玩家胡牌后进入奖码环节，如果一个都没中，则当全中处理&#xA;注：创建房间时给出可选项，默认勾选" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="880.0000" Y="1762.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="440.0000" Y="881.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="116" G="61" B="0" />
                <PrePosition X="0.4783" Y="0.5000" />
                <PreSize X="0.9565" Y="1.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="1.0000" />
            <Position X="10.0000" Y="546.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0111" Y="1.0000" />
            <PreSize X="1.0222" Y="1.0000" />
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