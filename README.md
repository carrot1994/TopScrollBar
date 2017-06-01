# TopScrollBar

TopScrollBar 导航栏下方的标签分页控件，可滑动、点击切换页面。常见于新闻软件和视频软件


<p><p>

## Usage

使用标签分页控件，在`ViewController`import`TopScrollBar.h`,按照以下方法使用
method:

```
UIViewController *ctr1 =  [[UIViewController alloc]init];
ctr1.view.backgroundColor = [UIColor orangeColor];

UIViewController *ctr2 =  [[UIViewController alloc]init];
ctr2.view.backgroundColor = [UIColor purpleColor];

UIViewController *ctr3 =  [[UIViewController alloc]init];
ctr3.view.backgroundColor = [UIColor yellowColor];

UIViewController *ctr4 =  [[UIViewController alloc]init];
ctr4.view.backgroundColor = [UIColor blueColor];

UIViewController *ctr5 =  [[UIViewController alloc]init];
ctr5.view.backgroundColor = [UIColor darkGrayColor];
UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action)];
[ctr5.view addGestureRecognizer:ges];



NSArray *arr = @[ctr1,ctr2,ctr3,ctr4,ctr5];
[arr enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {

[self addChildViewController:obj];

}];



NSArray *titleArr = @[@"推荐",@"精选",@"热点",@"就是要很长很长哼！",@"嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻"];


TopScrollBar *top = [TopScrollBar topViewWithTitleArr:titleArr];
top.controller = arr;
top.frame = self.view.bounds;
top.y = 64;
top.height = self.view.height;
[self.view addSubview:top];

/******************有默认值可不填************************/
//    top.labelMargin = 20;
//    top.titleFont = [UIFont systemFontOfSize:10];
//    top.underLineHeight = 2;
//    top.topScorllBarHeight = 50;
//    top.topScrollBarTransformScale = 1.3f;

```

<p><p>


