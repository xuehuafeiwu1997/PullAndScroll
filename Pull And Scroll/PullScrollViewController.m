//
//  PullScrollViewController.m
//  Pull And Scroll
//
//  Created by 许明洋 on 2021/1/19.
//

#import "PullScrollViewController.h"
#import "Masonry.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface PullScrollViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *myView;
@property (nonatomic, assign) CGFloat maxViewHeight;
@property (nonatomic, assign) CGFloat minViewHeight;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGPoint scrollBeginDraggingOffset;

@end

@implementation PullScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"pull scrollView Demo  使用frame来改变";
    
    //初始化高度
    self.minViewHeight = 211;
    self.maxViewHeight = 422;
    
    [self.view addSubview:self.myView];
    [self.view addSubview:self.tableView];
    [self addObserve];
}

- (void)addObserve {
    
    typeof(self) __weak weakSelf = self;
    [RACObserve(self.myView, frame) subscribeNext:^(id  _Nullable x) {
        typeof(weakSelf) __strong self = weakSelf;
        NSLog(@"--------------");
        NSLog(@"height高度发生了变化%f",self.myView.frame.size.height);
    }];
    [RACObserve(self, scrollBeginDraggingOffset) subscribeNext:^(id  _Nullable x) {
        typeof(weakSelf) __strong self = weakSelf;
        NSLog(@"1111111111111111");
        NSLog(@"scrollBeginDraggingOffSet发生了变化%f",self.scrollBeginDraggingOffset.y);
    }];
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        typeof(weakSelf) __strong self = weakSelf;
        NSLog(@"222222222222222");
        NSLog(@"contentOffsetY发生了变化%f",self.tableView.contentOffset.y);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.myView.frame), self.view.bounds.size.height, self.view.bounds.size.height - CGRectGetMaxY(self.myView.frame));
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll...");
    CGFloat originOffsetY = MAX(0, self.scrollBeginDraggingOffset.y);
    NSLog(@"当前的初始便宜量为%f",originOffsetY);
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.contentInset.top - scrollView.contentInset.bottom - scrollView.frame.size.height;
    if (offsetY > 0) {
        NSLog(@"向上滑动offsetY为正值,值的大小为%f",offsetY);
    } else {
        NSLog(@"向下滑动offsetY为负值,值的大小为%f",offsetY);
    }
    offsetY = MIN(offsetY, maxOffsetY) - originOffsetY;
    CGFloat height = self.myView.bounds.size.height;
    CGFloat currentHeight = self.myView.bounds.size.height;
    if (offsetY > 0) {
        //表示向上滑动
        if (currentHeight > self.minViewHeight) {
            height = height - offsetY;
        }
    } else {
        //表示向下滑动
        if (currentHeight < self.maxViewHeight) {
            height = height - offsetY;
        }
    }
    if (height < self.minViewHeight) {
        height = self.minViewHeight;
    } else if (height > self.maxViewHeight) {
        height = self.maxViewHeight;
    }
    if (height != currentHeight) {
        self.myView.frame = CGRectMake(0, CGRectGetMinY(self.myView.frame), CGRectGetWidth(self.view.frame), height);
        NSLog(@"myView的frame为%f,%f",self.myView.frame.origin.y,height);
        [scrollView setContentOffset:CGPointMake(0, originOffsetY)];
        //添加这个主要是为了判断什么时候originOffsetY才会大于0
        if (originOffsetY > 0) {
            NSLog(@"终于大于0了，哈哈哈哈哈哈哈哈哈哈哈哈哈哈，值为%f",originOffsetY);
        }
        //这样的话在下滑的过程中会直接恢复原状
//        [scrollView setContentOffset:CGPointMake(0, 0)];
        NSLog(@"当前的offsetY为%f",offsetY);
        [self.view setNeedsLayout];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidZoom...");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging...");
    CGPoint p = scrollView.contentOffset;
    CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.contentInset.bottom - scrollView.contentInset.top - scrollView.frame.size.height;
    if (p.y >= maxOffsetY) {
        p.y = maxOffsetY;
    }
    self.scrollBeginDraggingOffset = p;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewWillEndDragging...");
    if (decelerate) {
        return;
    }
//    self.scrollBeginDraggingOffset = CGPointMake(0, 1);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDecelerating...");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating...");
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个cell",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld个cell",indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - lazy load
- (UIView *)myView {
    if (_myView) {
        return _myView;
    }
    _myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 422)];
    _myView.backgroundColor = [UIColor yellowColor];
    return _myView;
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 422, self.view.bounds.size.width, 200) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = YES;
//    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    return _tableView;
}

@end
