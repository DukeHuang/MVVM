//
//  CMTableViewController.m
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMTableViewController.h"
#import "CMTableViewModel.h"
@interface CMTableViewController ()

@property(nonatomic,weak,readwrite) IBOutlet UITableView *tableView;
@property(nonatomic,strong,readonly) CMTableViewModel *viewModel;

@end



@implementation CMTableViewController

@dynamic viewModel;

-(instancetype)initWithViewModel:(CMViewModel *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel  shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)]
             subscribeNext:^(id x) {
                 @strongify(self)
                 [self.viewModel.requestRemoteDataCommand execute:@1];
             }];
        }
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
             
    [[[RACObserve(self.viewModel,dataSource)
    distinctUntilChanged]
    deliverOnMainThread]
    subscribeNext:^(id x) {
        @strongify(self)
        [self reloadData];
    }];
    
    if (self.viewModel.shouldPullToRefresh) {
        [self.tableView addPullToRefreshWithActionHandler:^{
            @strongify(self)
            [[[self.viewModel.requestRemoteDataCommand execute:@1]
              deliverOnMainThread]
             subscribeNext:^(NSArray *results) {
                 @strongify(self)
                 self.viewModel.page = 1;
             }
             error:^(NSError *error) {
                 @strongify(self)
                 [self.tableView.pullToRefreshView stopAnimating];
             } completed:^{
                 @strongify(self)
                 [self.tableView.pullToRefreshView stopAnimating];
             }];
        }];
    }
    
    if (self.viewModel.shouldInfiniteScrolling) {
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            @strongify(self)
            [[[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page + 1)]
              deliverOnMainThread]
             subscribeNext:^(NSArray *results) {
                 @strongify(self)
                 self.viewModel.page += 1;
             }
             error:^(NSError *error) {
                 @strongify(self)
                 [self.tableView.infiniteScrollingView stopAnimating];
             } completed:^{
                 @strongify(self)
                 [self.tableView.infiniteScrollingView stopAnimating];
             }];
        }];
    }
    
    RAC(self.tableView, showsInfiniteScrolling) = [[RACObserve(self.viewModel, dataSource)
                                                    deliverOnMainThread]
                                                   map:^(NSArray *dataSource) {
                                                       @strongify(self)
                                                       NSUInteger count = 0;
                                                       for (NSArray *array in dataSource) {
                                                           count += array.count;
                                                       }
                                                       return @(count >= self.viewModel.perPage);
                                                   }];
}


-(void)reloadData {
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource ? self.viewModel.dataSource.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"MRCTableViewCellStyleValue1" forIndexPath:indexPath];
    
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.didSelectCommand execute:indexPath];
}
@end
