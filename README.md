# ALOKeyboardAware

自适应键盘的 UIScrollView。

pod 导入：
pod 'ALOKeyboardAware'。

使用时导入头文件 <#import "UIScrollView+ALOKeyboardAware.h">。
alo_autoResizeContent 决定是否自动更改 contentInset。
alo_autoScrollFirstResponder 决定是否自动将当前的第一响应者滚动到可见区域内。

使用时有一定限制，最好用在‘全屏’的 UIScrollView 上。
