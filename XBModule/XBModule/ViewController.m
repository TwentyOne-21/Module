//
//  ViewController.m
//  XBModule
//
//  Created by XB on 2020/11/30.
//

#import "ViewController.h"
#import <mobileffmpeg/MobileFFmpeg.h>

#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define BundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
#define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]

//extern int ffmpeg_main(int argc, char * argv[]);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        char *outPut = (char *)[DocumentPath(@"out.mp4") UTF8String];
//        char *movie1 = (char *)[BundlePath(@"1.mp4") UTF8String];
//        char *movie2 = (char *)[BundlePath(@"1.mp4") UTF8String];
//
//        char* a[] = {
//            "ffmpeg",
//            "-i",
//            movie1,
//            "-i",
//            movie2,
//            "-filter_complex",
//            "[1:v]scale=320:240[ovrl];[0:v][ovrl]overlay=100:100",
//            outPut
//        };
//        ffmpeg_main(sizeof(a)/sizeof(*a), a);
//    });
//    [MobileFFmpegConfig setLogDelegate:self];
//
    
    NSString *command_str1 = [NSString stringWithFormat:@"-i %@ -i %@ -filter_complex [1:v]scale=320:160[ovrl];[0:v][ovrl]overlay=100:100:eof_action=1 %@",BundlePath(@"1.mp4"),BundlePath(@"2.mp4"),DocumentPath(@"out.mp4")];
    [MobileFFmpeg execute:command_str1];

    NSString *command_str2 = [NSString stringWithFormat:@"-i %@ -i %@ -filter_complex amix=inputs=2:duration=longest -strict -2 %@",BundlePath(@"1.mp4"),BundlePath(@"2.mp4"),DocumentPath(@"out.mp3")];
    [MobileFFmpeg execute:command_str2];

    NSString *command_str3 = [NSString stringWithFormat:@"-i %@ -i %@ -c:v copy -c:a copy -map 0:v -map 1:a %@",DocumentPath(@"out.mp4"),DocumentPath(@"out.mp3"),DocumentPath(@"result.mp4")];

    [MobileFFmpeg execute:command_str3];
}

@end
