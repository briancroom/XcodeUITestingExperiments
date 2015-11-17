#import "ViewController.h"
#import "EnvironmentKeys.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[[NSURLSession sharedSession] dataTaskWithURL:[self URLWithPath:@"hello"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        });
    }] resume];
}

- (IBAction)checkInTapped {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self URLWithPath:@"checkin"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"Checking in" dataUsingEncoding:NSUTF8StringEncoding];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }] resume];
}

- (NSURL *)URLWithPath:(NSString *)path {
    NSString *baseURLString = [NSProcessInfo processInfo].environment[kServerURLEnvironmentKey] ?: @"http://mycoolwebservice.com";
    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:baseURLString]];
}

@end
