//
//  CMTableViewController.h
//  CM
//
//  Created by Duke on 1/14/16.
//  Copyright © 2016 DU. All rights reserved.
//

#import "CMViewController.h"

@interface CMTableViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak,readonly) IBOutlet UITableView *tableView;


-(void)reloadData;
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
