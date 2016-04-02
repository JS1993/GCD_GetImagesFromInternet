//
//  JSTableViewController.m
//  Demo4_JS_GetImagesFromInternet
//
//  Created by  江苏 on 16/3/18.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "JSTableViewController.h"

@interface JSTableViewController ()
@property(nonatomic,strong)NSMutableArray* paths;
@end

@implementation JSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paths=[NSMutableArray array];
    NSString* path=[[NSBundle mainBundle]pathForResource:@"sina" ofType:@"rtf"];
    NSString* sinaString=[[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray* arr=[sinaString componentsSeparatedByString:@"\""];
    for (NSString* s in arr) {
        if ([s hasSuffix:@"jpg"]||[s hasSuffix:@"png"]) {
            [self.paths addObject:s];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.paths.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString* path=self.paths[indexPath.row];
    //开辟一个子线程，执行耗时的代码
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
          UIImage *image=[UIImage imageWithData:data];
        //待子线程里面的图片加载完成，回到主线程更新界面
       dispatch_async(dispatch_get_main_queue(), ^{
           cell.imageView.image=image;
           [cell setNeedsLayout];
       });
    });
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
