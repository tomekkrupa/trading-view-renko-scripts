//@version=3
//Simple Renko strategy, very profitable. Thanks to vacalo69 for the idea.
//Rules when the strategy opens order at market as follows:
//- Buy when previous brick (-1) was bearish and previous brick (-2) was bearish too and actual brick close is bullish
//- Sell when previous brick (-1) was bullish and previous brick (-2) was bullish too and actual brick close is bearish
//Rules when the strategy send stop order are the same but this time a stop buy or stop sell is placed (better overall results).
//Note that strategy open an order only after that condition is met, at the beginning of next candle, so the actual close is not the actual price.
//Only input is the brick size multiplier for stop loss and take profit: SL and TP are placed at (brick size)x(multiplier) Or put it very high if you want startegy to close order on opposite signal.
//Adjust brick size considering: 
//- Strategy works well if there are three or more consecutive bricks of same "color"
//- Expected Profit
//- Drawdown
//- Time on trade
//
//

strategy("Renko Strategy Open_Close", overlay=true, calc_on_every_tick=true, pyramiding=0,default_qty_type=strategy.percent_of_equity,default_qty_value=100,currency=currency.USD)

//INPUTS
Multiplier=input(1,minval=0, title='Brick size multiplier: use high value to avoid SL and TP')
UseStopOrders=input(true,title='Use stop orders instead of market orders')

//CALCULATIONS
BrickSize=abs(open[1]-close[1])
targetProfit = 0
targetSL = 0

//STRATEGY CONDITIONS
longCondition = open[1]>close[1] and close>open and open[1]<open[2]
shortCondition = open[1]<close[1] and close<open and open[1]>open[2] and open[2]>open[4]

//STRATEGY
if (longCondition and not UseStopOrders)
    strategy.entry("LongBrick", strategy.long)
    targetProfit=close+BrickSize*Multiplier
    targetSL=close-BrickSize
    strategy.exit("CloseLong","LongBrick", limit=targetProfit, stop=targetSL)
    
if (shortCondition and not UseStopOrders)
    strategy.entry("ShortBrick", strategy.short)
    targetProfit = close-BrickSize*Multiplier
    targetSL = close+BrickSize*Multiplier
    strategy.exit("CloseShort","ShortBrick", limit=targetProfit, stop=targetSL)

if (longCondition and UseStopOrders)
    strategy.entry("LongBrick_Stop", strategy.long, stop=open[2])
    targetProfit=close+BrickSize*Multiplier
    targetSL=close-BrickSize
    strategy.exit("CloseLong","LongBrick_Stop", limit=targetProfit, stop=targetSL)
    
if (shortCondition and UseStopOrders)
    strategy.entry("ShortBrick_Stop", strategy.short, stop=open[2])
    targetProfit = close-BrickSize*Multiplier
    targetSL = close+BrickSize*Multiplier
    strategy.exit("CloseShort","ShortBrick_Stop", limit=targetProfit, stop=targetSL)
