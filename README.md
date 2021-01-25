# HiScrollGesture
引用来自: http://www.martinrgb.com/blog/#/HOW_UIScrollView_Works
解决 scroll 嵌套 scroll 滑动冲突。<br/>
在最底层的 scroll 添加滑动手势, 最底层的 scroll 控制相应的 scroll 来滑动。<br/>
scroll 的 scrollenable = false. 不能滑动。<br/>
兼容了 mjrefresh. 可以正常使用刷新。<br/>
