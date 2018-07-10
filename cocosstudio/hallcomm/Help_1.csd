<GameFile>
  <PropertyGroup Name="Help_1" Type="Layer" ID="2b355f8a-1532-4c5e-8900-d9e55c7141fa" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="3904" ctype="GameLayerObjectData">
        <Size X="900.0000" Y="546.0000" />
        <Children>
          <AbstractNodeData Name="RuleList" ActionTag="1949781716" Tag="3905" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="10.0000" RightMargin="-30.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
            <Size X="920.0000" Y="546.0000" />
            <Children>
              <AbstractNodeData Name="Text_1" ActionTag="1027513037" Tag="3906" IconVisible="False" RightMargin="40.0000" IsCustomSize="True" FontSize="26" LabelText="商丘麻将规则&#xA;&#xA;一、玩法介绍&#xA;商丘麻将是商丘地区的主要玩法， 共有万饼条风，中发白 共144张牌。游戏打牌过程中可以碰、杠、不允许吃牌，需要报停之后才能胡牌，拥有硬扣， 亮四打一，暗卡，暗杠锁死等特色玩法。&#xA;二、术语解释&#xA;1，坐庄：&#xA;创建房间后，第一句为房主坐庄（或者随机），庄家胡牌后，则庄家继续坐庄。荒庄时，当前庄家继续坐庄&#xA;2，下跑&#xA;勾选下跑后，玩家可以在每局发牌之前选择是否下跑，下跑则底分增加一分，不跑则不加分（闲家对自己有效，庄家对所有人生效）&#xA;3 荒庄&#xA;摸到剩余14张牌的时候，还没有玩家胡牌，则荒庄。&#xA;当第一次开杠或者补花时候，摸走最后一摞牌的第一张，且荒庄数再往前移两张，第二次开杠或者补花时候，则摸走刚刚摸走后剩下那一摞的第二张，此时荒庄不往前移动张数，第三次则开始重复第一次的动作。补花按照同类处理，叠加计算。&#xA;4 硬扣&#xA;玩家听牌后，在点炮时，出现两个按钮：硬扣和胡，若玩家不想胡牌，则可选择硬扣，硬扣后胡牌只能是自摸，不能点炮和抢杠胡。 此后再摸到可胡的牌的时候显示 胡和过，胡则加一分，过，继续摸牌&#xA;5，报听&#xA;需要报听后才能胡牌，报听之后不能换牌，系统自动打出，直到胡牌， 听牌过程中可以杠牌，但是杠完之后必须还能听牌，不然不能够杠牌，胡牌之后默认加报听的一分&#xA;6， 掐张&#xA;我们常说的卡 吊， 如果13 胡2， 46 胡 5、或者单吊一张牌胡牌。加一分&#xA;7，边张&#xA;我们常说的边指 12胡3成为边3， 89胡7 成为边7、 胡牌加一分&#xA;8， 缺门&#xA;勾选后万条筒， 当胡牌时缺一门，就算缺一门。 每缺一门加一分。 勾选后，没有缺门也能胡牌， 只是过不加分。&#xA;9．门清&#xA;玩家不碰不杠，最后胡牌算门清。（自摸胡点炮胡都可以）加一分。 暗杠之后不算门清&#xA;10 暗卡。&#xA;三个相同花色，相同的牌数组成的为一个暗卡（刻字）。还有自己摸到的才算暗卡。 碰杠都不算暗卡（暗杠也不算暗卡）。每一个暗卡加一分&#xA;11，嘴&#xA;硬扣、报听、掐张、边张、缺门、门清、暗卡、共有7个嘴。有一个嘴， 则最后胡牌加1分。 &#xA;12 花牌&#xA;默认带花牌，玩家有花牌的时候需手动打出，打出之后进行补花操作。补花分只有胡牌后才算分。一个花牌算一分&#xA;13 亮四打一&#xA;选择后，发牌顺序改为先发4张，再发剩余的牌。先发的4张全部亮出来， 第一轮必须从4张明牌中选择一张打出。剩余的3张牌 可碰可杠。 但是玩家不能打出&#xA;14 暗杠锁死&#xA;每一句的牌局中，一家开暗杠后，则本局的胡牌方式改为自摸胡牌。则就没有硬扣了、&#xA;15 截胡。&#xA;没有一炮多响。按摸排顺序只能一家胡牌&#xA;&#xA;三、胡牌规则&#xA;1，胡牌牌型如下（11代表对子。 111代表一坎。123代表一个顺子）&#xA;11、 111、 111、 111、 123&#xA;11、 111、 111、 123、 123&#xA;11、 111、 123、 123、 123&#xA;11、 123、 123、 123、 123&#xA;11、 111、 111、 111、 111&#xA;11、 11、 11、 11、 11、 11、 11（对对胡勾选后，胡牌加一分）&#xA;&#xA;四、 分数计算&#xA;1．杠分&#xA;明杠：直杠1分由点杠玩家给。碰杠1分由点碰玩家给&#xA;暗杠：三家每家给2分&#xA;2， 胡分=底分+双方下跑分+嘴分(包含报听) + 对对胡1分(点炮胡收一家、自摸胡收三家)&#xA;3， 补花分&#xA;勾选补花后，胡牌玩家摸到几张花牌，算几分&#xA;4 总分 = 杠分 + 胡分 +  补花分&#xA;5 荒庄所有分都不算。" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="880.0000" Y="2005.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="440.0000" Y="1002.5000" />
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