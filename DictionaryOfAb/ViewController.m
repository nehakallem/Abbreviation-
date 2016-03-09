//
//  ViewController.m
//  DictionaryOfAb
//
//  Created by ivcmbp022adm on 3/8/16.
//  Copyright © 2016 NehaKallem. All rights reserved.
//

#import "ViewController.h"
#import "Webservice.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *overlay;

@property (strong, nonatomic) NSArray<NSString*>* fullForms;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonTapped:(id)sender {
    NSString* query = self.textField.text;
    [self search:query];
}

- (void)search: (NSString*) query {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.overlay.hidden = false;
    [[Webservice sharedInstance] fetchAbbreviation:query completionHandler:^(NSError *error, NSArray<NSString *> *fullForms) {
        [self stopHUD];
        self.fullForms = fullForms;
        [self.tableView reloadData];
    }];
}

- (void) stopHUD {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.overlay.hidden = true;
        });
    });
}
//
//- (IBAction)overlayTapped:(id)sender {
//    NSLog(@"Tapped");
//    [self.view endEditing:true];
//}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    if (self.fullForms){
        return self.fullForms.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.fullForms[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
