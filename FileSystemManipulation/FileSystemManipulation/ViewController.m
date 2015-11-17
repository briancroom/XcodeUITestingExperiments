#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *filename = @"data.txt";
    NSURL *dataURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject URLByAppendingPathComponent:filename];
    NSString *text = [NSString stringWithContentsOfURL:dataURL encoding:NSUTF8StringEncoding error:NULL];

    self.label.text = text ?: @"No data found!";
}

@end
