//
//  ResultViewController.m
//  SearchDemo
//
//  Created by xfq on 2020/12/8.
//  Copyright © 2020 xfq. All rights reserved.
//

#import "ResultViewController.h"
#import "Masonry.h"
@interface ResultViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    self.view.backgroundColor = [UIColor redColor];
}

- (void)ssssssss:(NSString * )searchText{
    _searchText = [searchText copy];
    searchText = searchText.lowercaseString;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];
    self.results = [@[@"1",@"2",@"3",@"4"] mutableCopy];
    [self.results addObject:searchText];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellID = @"searchResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *city = self.results[indexPath.row];
    cell.textLabel.text = city;
    return cell;
}


@end
