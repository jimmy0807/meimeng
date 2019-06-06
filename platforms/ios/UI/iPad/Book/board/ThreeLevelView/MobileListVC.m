//
//  MobileListVC.m
//  meim
//
//  Created by 波恩公司 on 2017/11/6.
//

#import "MobileListVC.h"

@interface MobileListVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MobileListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"MobileListVC =%f,%f,%d",self.view.frame.size.width,self.view.frame.size.height,self.mobileArray.count);
    //self.mobileArray = @[@"18856425363",@"18856425363",@"18856425363",@"18856425363",@"18856425363",@"18856425363",@"18856425363"];
    self.mobileArray = [NSMutableArray array];
    for (CDMember *member in self.members) {
        //NSLog(@"member.memberName=%@",member.mobile);
        [self.mobileArray  addObject:member.mobile];
    }
    
    self.mobileTableView.delegate = self;
    self.mobileTableView.dataSource = self;
    
    self.headerView.layer.shadowOffset=CGSizeMake(3, 3);
    self.headerView.layer.shadowRadius=5;
    self.headerView.layer.shadowOpacity=0.1;
    self.headerView.layer.shadowColor=[UIColor blackColor].CGColor;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(20, 20, 40, 40);
    [self.headerView addSubview:cancel];
    [cancel addTarget:self action:@selector(cancelButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    [cancel setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n@2x.png"] forState:UIControlStateNormal];
   
}

-(void)cancelButtonDidPress{
    [self.view removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.members.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"MobileCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    //NSLog(@"~~~%@",self.mobileArray[indexPath.row]);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CDMember *member = self.members[indexPath.row];
    ///手机号码 + 名字
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",member.mobile,member.memberName];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"选中的号码=%@",cell.textLabel.text);
    CDMember *member = self.members[indexPath.row];
    self.returnTextBlock(member.mobile,member);
    [self.view removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
