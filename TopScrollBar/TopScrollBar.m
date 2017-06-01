//
//  TopView.m
//  TopScrollBar
//
//  Created by 周恩慧 on 2017/5/31.
//  Copyright © 2017年 周恩慧. All rights reserved.
//

#import "TopScrollBar.h"
#import "UIView+Frame.h"

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

// 默认标题字体
#define KTitleFont [UIFont systemFontOfSize:15]
#define KTitleNormalColor  [UIColor darkGrayColor]
#define KTitleSelectedColor  [UIColor orangeColor]

// 标题滚动视图的高度
static CGFloat const KTitleScrollViewH = 44;
// 标题缩放比例
static CGFloat const KTitleTransformScale = 1.3f;
// 下划线默认高度
static CGFloat const KUnderLineH = 2;

// 默认标题间距
static CGFloat const KMargin = 20;



@interface TopScrollBar ()<UIScrollViewDelegate>

/** 标题Title*/
@property (nonatomic, strong) NSArray *titleArr;
/** 内容滑动区域*/
@property (nonatomic,strong)  UIScrollView * contentScroll;
/** 标题滑动区域*/
@property (nonatomic,strong)  UIScrollView * titleScroll;
/** 标题labelWidth*/
@property (nonatomic,strong)  NSMutableArray  *titleWidths;
/** label数组*/
@property (nonatomic,strong)  NSMutableArray * titleLableArr;



/** 下标视图 */
@property (nonatomic, strong) UIView *underLine;
/** 记录上一次内容滚动视图偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;


@end
@implementation TopScrollBar


+ (instancetype)topViewWithTitleArr:(NSArray *)arr {
    
    return [[self alloc]initWithTitleArr:arr];
}

- (instancetype)initWithTitleArr:(NSArray *)arr
{
    self = [super init];
    if (self) {
        
        self.labelMargin = KMargin;
        self.titleFont = KTitleFont;
        self.underLineHeight = KUnderLineH;
        self.topScorllBarHeight = KTitleScrollViewH;
        self.topScrollBarTransformScale = KTitleTransformScale;
        self.titleNormalColor = KTitleNormalColor;
        self.titleSelectColor = KTitleSelectedColor;
        
        self.titleArr = arr;
        
        [self setupUI];
        
        
    }
    return self;
}


-(void)setupUI {
    [self addSubview:self.titleScroll];
    [self addSubview:self.contentScroll];
    
    [self setUpTitleWidth];
    [self setUpAllTitle];
    
    
}



// 设置所有标题
- (void)setUpAllTitle
{
    
    // 遍历所有的子控制器
    NSUInteger count = self.titleArr.count;
    NSUInteger labelCount = self.titleLableArr.count;
    BOOL equal = count == labelCount;
    
    
    // 添加所有的标题
    CGFloat labelW = 0;
    CGFloat labelH = 20;
    CGFloat labelX = 0;
    CGFloat labelY = (self.topScorllBarHeight - labelH)/2;
    
    if (!self.titleScroll.width) {
        return;
    }
    
    for (int i = 0; i < count; i++) {
        UILabel *label = equal?[self.titleLableArr objectAtIndex:i]:[[UILabel alloc] init];
        
        
        label.tag = i;
        
        label.userInteractionEnabled = true;
        
        // 设置按钮的文字颜色
        label.textColor = self.titleNormalColor;
        
        label.font = self.titleFont;
        
        label.textAlignment = NSTextAlignmentCenter;
        // 设置按钮标题
        label.text = self.titleArr[i];
        
        // 设置按钮位置
        UILabel *lastLabel = [self.titleLableArr lastObject];
        //如果标题栏只有两个的话,则设置屏幕各占一半
        if (count < 3) {
            
            labelW = self.width / 2;
            labelX = i * labelW;
        }else {
            labelW = [self.titleWidths[i] floatValue];
            labelX = self.labelMargin + CGRectGetMaxX(lastLabel.frame);
            
        }
        
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 监听标题的点击
        UITapGestureRecognizer *tap = equal?label.gestureRecognizers.firstObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        
        [label addGestureRecognizer:tap];
        
        // 保存到数组
        if (!equal) {
            [self.titleLableArr addObject:label];
        }
        
        [self.titleScroll addSubview:label];
        
        
        //设置第一个
        if (i == 0 && !equal) {
            [self titleClick:tap];
        }
        
        
        
    }
    
    // 设置标题滚动视图的内容范围
    UILabel *lastLabel = self.titleLableArr.lastObject;
    _titleScroll.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    _titleScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.contentSize = CGSizeMake(count * self.width, 0);
    
}

// 标题按钮点击
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    
    for (UILabel * lable in self.titleLableArr) {
        lable.textColor = self.titleNormalColor;
        lable.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                 1,1
                                            );
        
    }
    
    // 获取对应标题label
    UILabel *label = (UILabel *)tap.view;
    label.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                             self.topScrollBarTransformScale,self.topScrollBarTransformScale
                                             //设置文字跟随滚动
                                             );
    [self setLabelTitleCenter:label];
    //设置下表跟随滚动
    [self setUpUnderLine:label];
    // 获取当前角标
    NSInteger i = label.tag;
    
    // 选中label
    label.textColor = self.titleSelectColor;
    // 内容滚动视图滚动到对应位置
    CGFloat offsetX = i * self.width;
    
    self.contentScroll.contentOffset = CGPointMake(offsetX, 0);
    
    UIView *view;
    {
        UIViewController *ctr = [self.controller objectAtIndex:i];
        
        UIView *views = ctr?ctr.view:[self.views objectAtIndex:i];
        
        view = views;
    }
    
    view.frame = self.contentScroll.bounds;
    
    [self.contentScroll addSubview:view];
    
    

    // 记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
    _lastOffsetX = offsetX;
    
    
}
// 设置下标的位置
- (void)setUpUnderLine:(UILabel *)label
{
    
    
    
    self.underLine.y = self.topScorllBarHeight - self.underLineHeight;
    self.underLine.height = self.underLineHeight;
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        
        if (self.titleArr.count  < 3) {
            self.underLine.width = self.width / 2;
            
        }else {
            self.underLine.width = label.width;
            
        }
        self.underLine.centerX = label.centerX;
        
    }];
    
}


// 让选中的按钮居中显示
- (void)setLabelTitleCenter:(UILabel *)label
{
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = label.center.x - self.width * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScroll.contentSize.width - self.width + self.labelMargin;
    if (self.titleArr.count < 3) { //有两个标题情况,不设置
        maxOffsetX = self.titleScroll.contentSize.width - self.width ;
        
    }
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self.titleScroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
/// MARK: ---- scrollViewDidEndDecelerating
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = self.width;
    
    NSInteger extre = offsetXInt % screenWInt;
    if (extre > self.width * 0.5) {
        // 往右边移动
        offsetX = offsetX + (self.width - extre);
        [self.contentScroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else if (extre < self.width * 0.5 && extre > 0){
        // 往左边移动
        offsetX =  offsetX - extre;
        [self.contentScroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    // 获取角标
    NSInteger i = offsetX / self.width;
    UILabel * currentLable = self.titleLableArr[i];
    // 选中标题
    [self titleClick:currentLable.gestureRecognizers.firstObject ];
    
}

#pragma mark - 计算所有标题宽度
// 计算所有标题宽度
- (void)setUpTitleWidth
{
    // 判断是否能占据整个屏幕
    NSUInteger count = self.titleArr.count;
    
    CGFloat totalWidth = 0;
    
    // 计算所有标题的宽度
    [self.titleWidths removeAllObjects];
    
    for (NSString *title in self.titleArr) {
        
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        
        CGFloat width = titleBounds.size.width + self.labelMargin;
        
        [self.titleWidths addObject:@(width)];
        
        totalWidth += width;
    }
    
    if (totalWidth > self.width) {
        
        
        self.titleScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, self.labelMargin);
        
        return;
    }
    
    CGFloat titleMargin = (self.width - totalWidth) / (count + 1);
    
    _labelMargin = titleMargin < KMargin? KMargin: titleMargin;
    
    self.titleScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, _labelMargin );
}



/// MARK: ----  懒加载方法

- (NSMutableArray *)titleWidths {
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}
-(UIScrollView *)titleScroll {
    if (_titleScroll == nil) {
        _titleScroll = [[UIScrollView alloc]init];
    }
    return _titleScroll;
}
-(UIScrollView *)contentScroll {
    if (_contentScroll == nil) {
        _contentScroll = [[UIScrollView alloc]init];
        _contentScroll.delegate = self;
        _contentScroll.pagingEnabled = true;
    }
   _contentScroll.frame = CGRectMake(0, CGRectGetMaxY(self.titleScroll.frame), self.width, self.height  - self.topScorllBarHeight);

    
    return _contentScroll;
    
}

-(NSMutableArray *)titleLableArr {
    if (_titleLableArr == nil) {
        _titleLableArr = [NSMutableArray array];
    }
    return _titleLableArr;
}

- (UIView *)underLine
{
    if (_underLine == nil) {
        
        _underLine = [[UIView alloc] init];
        
        _underLine.backgroundColor = [UIColor redColor];
        
        [self.titleScroll addSubview:_underLine];
        
        
    }
    return _underLine ;
}

- (void)setController:(NSArray *)controller {
    
    _controller = controller;
    
    [controller enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        obj.view.frame = self.contentScroll.bounds;
        obj.view.x = idx * self.width;
        
        [self.contentScroll addSubview:obj.view];
        
    }];

    
}

- (void)setViews:(NSArray *)views {
    
    _views = views;
    
    [views enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        obj.frame = self.contentScroll.bounds;
        obj.x = idx * self.width;
        
        [self.contentScroll addSubview:obj];
        
    }];

}

- (void)setLabelMargin:(CGFloat)labelMargin {
    
    _labelMargin = labelMargin;
    
    [self setNeedsLayout];
    
}

- (void)setTitleFont:(UIFont *)titleFont {
    
    _titleFont = titleFont;
     [self setNeedsLayout];
}

- (void)setUnderLineHeight:(CGFloat)underLineHeight {
    
    _underLineHeight = underLineHeight;
     [self setNeedsLayout];
}

- (void)setTopScorllBarHeight:(CGFloat)topScorllBarHeight {
    
    _topScorllBarHeight = topScorllBarHeight;
     [self setNeedsLayout];
}

- (void)setTopScrollBarTransformScale:(CGFloat)topScrollBarTransformScale {
    
    _topScrollBarTransformScale = topScrollBarTransformScale;
     [self setNeedsLayout];
    
}

- (void)setUnderLineColor:(UIColor *)underLineColor {
    
    _underLineColor = underLineColor;
    
     self.underLine.backgroundColor = self.underLineColor;
    
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    
    _titleNormalColor = titleNormalColor;
     [self setNeedsLayout];
    
    
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor {
    
    _titleSelectColor = titleSelectColor;
     [self setNeedsLayout];
}
- (void)layoutSubviews {
    
    if (![NSValue valueWithCGRect:self.frame]) {
        return;
    }
    self.titleScroll.frame =  CGRectMake(0, 0, self.width, self.topScorllBarHeight);
    
    [super layoutSubviews];
    
    [self setupUI];
    
}


@end

