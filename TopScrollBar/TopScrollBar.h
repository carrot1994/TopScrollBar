//
//  TopView.h
//  TopScrollBar
//
//  Created by 周恩慧 on 2017/5/31.
//  Copyright © 2017年 周恩慧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopScrollBar;

@interface TopScrollBar : UIView


+ (instancetype)topViewWithTitleArr:(NSArray *)arr;


#warning controller和Views只能二选一
/** 传过来控制器*/
@property (nonatomic, strong) NSArray *controller;

/** 传过来自子视图*/
@property (nonatomic, strong) NSArray *views;

/** 默认标题间距 */
@property (nonatomic, assign) CGFloat labelMargin;

/** 默认标题字体*/
@property (nonatomic, strong) UIFont *titleFont;

/** 下划线默认高度*/
@property (nonatomic, assign) CGFloat underLineHeight;

// 标题滚动视图的高度
@property (nonatomic, assign) CGFloat topScorllBarHeight;

/** 标题缩放比例*/
@property (nonatomic, assign) CGFloat topScrollBarTransformScale;

/** 下划线颜色*/
@property (nonatomic, strong) UIColor *underLineColor;

/** 标题选中颜色*/
@property (nonatomic, strong) UIColor *titleSelectColor;

/** 标题未选中颜色*/
@property (nonatomic, strong) UIColor *titleNormalColor;




@end
