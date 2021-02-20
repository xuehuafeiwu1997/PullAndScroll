//
//  Test2ViewController.m
//  Pull And Scroll
//
//  Created by xmy on 2021/2/20.
//

#import "Test2ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface Test2ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //为了测试当UITableView的frame发生改变时，UITableView的contentOffset的变化
    //contentOffset相当于内容对于UITableView的偏移量，可以说在修改UITableView的frame之后，contentOffset并没有发生变化
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"测试UITableView的frame改变时，发生的情况";
    
    [self.view addSubview:self.tableView];
    [self addObserve];
}

- (void)addObserve {
    typeof(self) __weak weakSelf = self;
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        typeof(weakSelf) __strong self = weakSelf;
        NSLog(@"222222222222222");
        NSLog(@"contentOffsetY发生了变化%f",self.tableView.contentOffset.y);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.frame = CGRectMake(0, 300, self.view.bounds.size.width, 200);
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
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个cell",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld个cell",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, 200) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor yellowColor];
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    return _tableView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tableView.frame = CGRectMake(0, 300, self.view.bounds.size.width, 200);
}


@end
