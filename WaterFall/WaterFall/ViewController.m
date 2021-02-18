//
//  ViewController.m
//  WaterFall
//
//  Created by zjl on 2021/2/4.
//

#import "ViewController.h"
#import "WaterFallViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArr = @[@"瀑布流",@"瀑布流header悬停",@"普通collection"];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
//        WaterFallViewController *vc = [[WaterFallViewController alloc] initWithNibName:@"WaterFallViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
        [self performSegueWithIdentifier:@"two" sender:self];
    }else if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"three" sender:self];
    }else{
        [self performSegueWithIdentifier:@"fore" sender:self];
    }
}
@end
