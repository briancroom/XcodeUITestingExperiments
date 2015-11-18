#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"App loaded!");

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserTappedButton"];
}

- (IBAction)buttonTapped {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserTappedButton"];
}

@end
