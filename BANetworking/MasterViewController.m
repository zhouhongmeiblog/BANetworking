//
//  MasterViewController.m
//  BANetworking
//
//  Created by abel on 15/9/6.
//  Copyright (c) 2015年 abel. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "BARequest.h"
#import "BAClient.h"
#import "BAAsyncTask.h"
#import "BAModel.h"
#import "BANetworking.h"

@interface BAUser : BAModel

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString *userName;

@end

@implementation BAUser

@end


@interface MasterViewController ()

@property NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;

    // 配置开启网络调试模式
    [BANetworking setDebugEnabled:YES];
    
    BARequest *request = [BARequest POSTRequestWithPath:@"decode_info" parameters:@{@"info" : @"13328cb5f2be95b4ce5ee500679305cf", @"username" : @"abel"}];
//    BARequest *request = [BARequest POSTRequestWithURL:[NSURL URLWithString:@"http://pan.baidu.com/s/1geqCiWj"] parameters:nil];
//
//    BARequest *request = [BARequest GETRequestWithPath:@"hello" parameters:@{@"username" : @"abel"}];
    [[[[BAClient currentClient] performRequest:request] onComplete:^(BAResponse *result, NSError *error) {
//        NSLog(@"help_background = %@", [[NSString alloc]initWithData:result.body encoding:NSUTF8StringEncoding]);
        NSLog(@" = %@",result.body);
    }] onProgress:^(float progress) {
        NSLog(@"progress = %f",progress);
    }];
    
    
//    UIWebView *webview = nil;
//    
//    BARequest *baRequest = [BARequest GETRequestWithURL:[NSURL URLWithString:@"http://www.baidu.com"] parameters:nil];
//    NSURLRequest *request = [[BAClient currentClient] URLRequestForRequest:baRequest];
//    UIWebView *webView = nil;
//    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
