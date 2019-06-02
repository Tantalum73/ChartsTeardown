# ChartsTeardown
Teardown of charts in TradeRepublic App

## This is the compound project to [this blogpost](https://anerma.de/blog/tear-down-trade-republic-charts).
I wanted to know how [TradeRepublic](https://www.traderepublic.com) made their charts and so I replicated it.

**Original:**<br>
![Animated image showing the charts of TradeRepublic app.](Media/TradeRepublicSmaller.gif)

**Replicated:**<br>
![Animated image showing my replicated version of the chart view.](Media/MyVersionAnimation.gif)

I came real close and even was able to improve the original, my key takeaways are:
* A chart is nothing more than scaled points connected by a line.
* Using a `CABasicAnimation` to morph a `CGPath` is very smooth. By doing so almost the entire animation comes for free.
* The animation benefits a lot from start drawing the chart from the right combined with proportional numbers of points.
* Interaction can be broken down into three steps. The most complicated part is to get the point next to the users finger and even that is straight foreward.
* Accessibility is nothing that takes care of itself! This entire demo is missing accessibility adjustments in order to focus on the main visuals.
* UIKit and CoreAnimation are just awsome frameworks 💯

### License
```
MIT License

Copyright (c) 2019 Andreas Neusuess

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
