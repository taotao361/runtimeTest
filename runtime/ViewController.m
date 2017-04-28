//
//  ViewController.m
//  runtime
//
//  Created by yangxutao on 16/8/23.
//  Copyright © 2016年 yangxutao. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import "People1.h"
#import "Car.h"
#import <objc/runtime.h>
#import "TestView.h"
#import "TestScrollView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <CoreMedia/CoreMedia.h>

#import "albumInfo.h"

@interface ViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,AVCaptureFileOutputRecordingDelegate,UITableViewDelegate,UITableViewDataSource,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) TestView *test;
@property (nonatomic, strong) UIScrollView *imageScroll;


@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong)  AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *fileOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray *videosArray;
@property (nonatomic, strong) MPMoviePlayerController *playerController;

@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;

@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, assign) CGSize outputSize;
@property (nonatomic, strong) NSDictionary *videoCompressionSettings;
@property (nonatomic, strong) NSDictionary *audioCompressionSettings;

@property (nonatomic) CMFormatDescriptionRef audioTrackSourceFormatDescription;
@property (nonatomic) CMFormatDescriptionRef videoTrackSourceFormatDescription;

@property (nonatomic) NSDictionary *audioTrackSettings;
@property (nonatomic) NSDictionary *videoTrackSettings;

@property (nonatomic, strong) AVAssetWriter *writer;
@property (nonatomic) AVAssetWriterInput *audioInput;
@property (nonatomic) AVAssetWriterInput *videoInput;

@property (nonatomic) CGAffineTransform videoTrackTransform;

@property (nonatomic, strong) dispatch_queue_t  audioDataOutputQueue;
@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    CADisplayLink
//    NSLog(@"-------- %@",[NSRunLoop mainRunLoop]);
    
    
    /* Run Loop Observer Activities
    typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
        kCFRunLoopEntry = (1UL << 0),
        kCFRunLoopBeforeTimers = (1UL << 1),
        kCFRunLoopBeforeSources = (1UL << 2),
        kCFRunLoopBeforeWaiting = (1UL << 5),
        kCFRunLoopAfterWaiting = (1UL << 6),
        kCFRunLoopExit = (1UL << 7),
        kCFRunLoopAllActivities = 0x0FFFFFFFU
    };
    
    CF_EXPORT const CFRunLoopMode kCFRunLoopDefaultMode;
    CF_EXPORT const CFRunLoopMode kCFRunLoopCommonModes;
*/
    
    
    
    
//    UIScrollView *imageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
//    imageScroll.contentSize = CGSizeMake(320*4, 200);
//    imageScroll.pagingEnabled = YES;
//    [self.view addSubview:imageScroll];
//    for (int i = 0; i < 4; i++) {
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * 320, 0, 320, 200)];
//        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]]];
//        [imageScroll addSubview:imageView];
//    }
//    _imageScroll = imageScroll;
////    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(repeat) userInfo:nil repeats:YES];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(repeat) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    [timer fire];
    
//    CFRunLoopRef
//    CFRunLoopMode
//UIEvent
    
//    UIEvent *event = [[UIEvent alloc]init];
//    NSLog(@"----%@",[event allTouches]);
    
//    TestScrollView *scrollView = [[TestScrollView alloc]initWithFrame:CGRectMake(0, 200, 200, 300)];
//    scrollView.backgroundColor = [UIColor purpleColor];
//    scrollView.delegate = self;
//    scrollView.contentSize = CGSizeMake(200, 2000);
//    [self.view addSubview:scrollView];
    
    
    
    
    
    UIButton *videoBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 40, 40)];
    [videoBtn setTitle:@"点击" forState:UIControlStateNormal];
    videoBtn.backgroundColor = [UIColor redColor];
    [videoBtn addTarget:self action:@selector(bbbbb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoBtn];
    
    
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 40, 40)];
    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor redColor];
    [startBtn addTarget:self action:@selector(ccccc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *stopBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 50, 40, 40)];
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    stopBtn.backgroundColor = [UIColor redColor];
    [stopBtn addTarget:self action:@selector(stopRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];

    //获取相册中的所有视频
    [self getAllVideo];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, 320, 500) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadState) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    
    
    [self initCapture];
    
}

- (void)loadState {
    NSLog(@"======%ld",_playerController.loadState);
    switch (_playerController.loadState) {
        case MPMovieLoadStateUnknown:
            
            break;
        case MPMovieLoadStateStalled:
            
            break;
        case MPMovieLoadStatePlayable:
            break;
        case MPMovieLoadStatePlaythroughOK:
            break;
        
        default:
            break;
    }
}


- (void)getAllVideo {
   
    if (!_videosArray) {
        _videosArray = [NSMutableArray array];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ALAssetsLibrary *assets = [[ALAssetsLibrary alloc]init];
        [assets enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(group){
                    [group setAssetsFilter:[ALAssetsFilter allVideos]];
                    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if (result) {
                            albumInfo *info = [[albumInfo alloc]init];
                            info.thumbnail = [UIImage imageWithCGImage:result.thumbnail];
                            info.videoUrl = result.defaultRepresentation.url;
                            [_videosArray addObject:info];
                        }
                    }];
                }else {
                    //加载完
                    [_tableView reloadData];
                }
            });
        } failureBlock:^(NSError *error) {
            NSLog(@"--------%@",error.description);
        }];
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    albumInfo *info = [_videosArray objectAtIndex:indexPath.row];
    if (info) {
        [cell.imageView setImage:info.thumbnail];
        [cell.textLabel setText:[info.videoUrl description]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    albumInfo *info = [_videosArray objectAtIndex:indexPath.row];
    if(!info) return;
    
   //9.0建议使用AVPlayerViewController
    
//     MPMoviePlayerController *playerController = [[MPMoviePlayerController alloc]initWithContentURL:info.videoUrl];
//    NSLog(@"-----path= %@",info.videoUrl);
//    [playerController prepareToPlay];
//    playerController.view.frame = CGRectMake(0, 200, 320, 200);
//    [self.view addSubview:playerController.view];
//    playerController.controlStyle = MPMovieControlStyleDefault;//进度条等
//    playerController.shouldAutoplay = YES;
//    playerController.repeatMode = MPMovieRepeatModeOne;
//    playerController.scalingMode = MPMovieScalingModeAspectFit;
//    [playerController setFullscreen:YES animated:YES];
//    playerController.movieSourceType = MPMovieSourceTypeFile;
//    playerController.view.backgroundColor = [UIColor purpleColor];
//    if (_playerController.playbackState != MPMoviePlaybackStatePlaying) {
//         [playerController prepareToPlay];
//    }

//    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:info.videoUrl];
//    [movie.moviePlayer prepareToPlay];
//    movie.moviePlayer.view.frame = CGRectMake(0, 100, 320, 200);
//    movie.moviePlayer.shouldAutoplay = YES;
//    movie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    [self presentMoviePlayerViewControllerAnimated:movie];
    
//    AVPlayer
//    AVPlayerLayer
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:info.videoUrl options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.view.frame;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:playerLayer];
    [player play];
    NSLog(@"---%@",NSStringFromCGRect(playerLayer.videoRect));
    
}

#pragma mark 视频通知




- (void)stopRecording {
    [_session stopRunning];
    [_videosArray removeAllObjects];
    _videosArray = nil;
}

- (void)bbbbb {
//    _session = [[AVCaptureSession alloc]init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _deviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:_device error:nil];
    if([_session canAddInput:_deviceInput]) {
        [_session addInput:_deviceInput];
    }
//    _fileOutput = [[AVCaptureMovieFileOutput alloc]init];
//    if ([_session canAddOutput:_fileOutput]) {
//        [_session addOutput:_fileOutput];
//    }
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.frame = CGRectMake(0, 90, 320, 320*0.75);;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [self.view.layer addSublayer:_previewLayer];
    [_session startRunning];

}

- (void)ccccc {
    //根据设备输出获取链接
    AVCaptureConnection *connection = [_fileOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据链接获取设备输出的数据
    if (![_fileOutput isRecording]) {
        //预览图层和视频的方向保持一致
        connection.videoOrientation = _previewLayer.connection.videoOrientation;
    }
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"movie.mp4"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path1] options:0 error:nil];
    NSLog(@"----------%ld",data.length);
      [_fileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:path1] recordingDelegate:self];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"----开始录制");
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *videoPath = [path stringByAppendingPathComponent:@"video.mp4"];
    NSError *error = nil;
    //这个类可以方便的将图像和音频写成一个完整的视频文件
    _writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:videoPath] fileType:AVFileTypeMPEG4 error:&error];
    
    //创建添加输入
    if (!error  && _videoTrackSourceFormatDescription) {
        [self setupAssetWriterVideoInputWithSourceFormatDescription:self.videoTrackSourceFormatDescription transform:self.videoTrackTransform settings:self.videoTrackSettings error:&error];
    } //
    if (!error && _audioTrackSourceFormatDescription ) {
        [self setupAssetWriterAudioInputWithSourceFormatDescription:self.audioTrackSourceFormatDescription settings:self.audioTrackSettings error:&error];
    }
    //开始
    if (!error) {
        BOOL success = [self.writer startWriting];
        if (!success) {
            error = self.writer.error;
        }
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
        NSLog(@"----录制结束");
//    保存到相册
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *videoPath = [path stringByAppendingPathComponent:@"video.mp4"];
    [self saveToLibraryWithURL:[NSURL fileURLWithPath:videoPath]];

}


- (BOOL)setupAssetWriterVideoInputWithSourceFormatDescription:(CMFormatDescriptionRef)videoFormatDescription transform:(CGAffineTransform)transform settings:(NSDictionary *)videoSettings error:(NSError **)errorOut {
    if ([self.writer canApplyOutputSettings:videoSettings forMediaType:AVMediaTypeVideo]){
        self.videoInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:videoSettings sourceFormatHint:videoFormatDescription];
        self.videoInput.expectsMediaDataInRealTime = YES;
        self.videoInput.transform = transform;
        
        if ([self.writer canAddInput:self.videoInput]){
            [self.writer addInput:self.videoInput];
        } else {
            if (errorOut) {
//                *errorOut = [self cannotSetupInputError];
            }
            return NO;
        }
    } else {
        if (errorOut) {
//            *errorOut = [self cannotSetupInputError];
        }
        return NO;
    }
    return YES;
}

- (BOOL)setupAssetWriterAudioInputWithSourceFormatDescription:(CMFormatDescriptionRef)audioFormatDescription settings:(NSDictionary *)audioSettings error:(NSError **)errorOut {
    if ([self.writer canApplyOutputSettings:audioSettings forMediaType:AVMediaTypeAudio]){
        self.audioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:audioSettings sourceFormatHint:audioFormatDescription];
        self.audioInput.expectsMediaDataInRealTime = YES;
        
        if ([self.writer canAddInput:self.audioInput]){
            [self.writer addInput:self.audioInput];
        } else {
            if (errorOut) {
//                *errorOut = [self cannotSetupInputError];
            }
            return NO;
        }
    }
    else {
        if (errorOut) {
//            *errorOut = [self cannotSetupInputError];
        }
        return NO;
    }
    
    return YES;
}


- (void)initCapture {
    
    [self setCompressionSettings];
    
    _session = [[AVCaptureSession alloc]init];
    
    _outputSize = CGSizeMake(320, 240);
    
    _videoTrackTransform = CGAffineTransformMakeRotation(M_PI_2);//人像方向
    
    _audioDataOutputQueue = dispatch_queue_create("com.PKShortVideoWriter.audioOutput", DISPATCH_QUEUE_SERIAL );
     _videoDataOutputQueue = dispatch_queue_create("com.PKShortVideoWriter.videoOutput", DISPATCH_QUEUE_SERIAL );
    
    dispatch_set_target_queue(_videoDataOutputQueue, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0 ) );
    
    _videoDataOutput = [[AVCaptureVideoDataOutput alloc]init];
    _videoDataOutput.videoSettings = nil;
    _videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    if ([_session canAddOutput:_videoDataOutput]) {
        [_session addOutput:_videoDataOutput];
    }
    [_videoDataOutput setSampleBufferDelegate:self queue:_videoDataOutputQueue];
    _videoConnection = [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    _audioDataOutput = [[AVCaptureAudioDataOutput alloc]init];
    [_audioDataOutput setSampleBufferDelegate:self queue:_audioDataOutputQueue];
    if ([_session canAddOutput:_audioDataOutput]) {
        [_session addOutput:_audioDataOutput];
    }
    _audioConnection = [_audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    
    [self addVideoTrackWithSourceFormatDescription:self.outputVideoFormatDescription settings:self.videoCompressionSettings];
    [self addAudioTrackWithSourceFormatDescription:self.outputAudioFormatDescription settings:self.audioCompressionSettings];
    
}


- (void)setCompressionSettings {
    NSInteger numPixels = self.outputSize.width * self.outputSize.height;
    //每像素比特
    CGFloat bitsPerPixel = 6.0;
    NSInteger bitsPerSecond = numPixels * bitsPerPixel;
    
    // 码率和帧率设置
    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
                                             AVVideoExpectedSourceFrameRateKey : @(30),
                                             AVVideoMaxKeyFrameIntervalKey : @(30),
                                             AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel };
    
    self.videoCompressionSettings = [self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4];
    
    self.videoCompressionSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
                                       AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                       AVVideoWidthKey : @(self.outputSize.height),
                                       AVVideoHeightKey : @(self.outputSize.width),
                                       AVVideoCompressionPropertiesKey : compressionProperties };
    
    // 音频设置
    self.audioCompressionSettings = @{ AVEncoderBitRatePerChannelKey : @(28000),
                                       AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                       AVNumberOfChannelsKey : @(1),
                                       AVSampleRateKey : @(22050) };
}




#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == self.videoConnection){
        if (!self.outputVideoFormatDescription) {
            @synchronized(self) {
                CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                self.outputVideoFormatDescription = formatDescription;
            }
        } else {
            @synchronized(self) {
//                if (self.recordingStatus == PKRecordingStatusRecording){
//                    [self.assetSession appendVideoSampleBuffer:sampleBuffer];
//                }
            }
        }
    } else if (connection == self.audioConnection ){
        if (!self.outputAudioFormatDescription) {
            @synchronized(self) {
                CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                self.outputAudioFormatDescription = formatDescription;
            }
        }
        @synchronized(self) {
//            if (self.recordingStatus == PKRecordingStatusRecording){
//                [self.assetSession appendAudioSampleBuffer:sampleBuffer];
//            }
        }
    }
}


- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)videoSettings {
    @synchronized(self) {
        self.videoTrackSourceFormatDescription = (formatDescription);
        self.videoTrackSettings = [videoSettings copy];
    }
}

- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings {
    @synchronized(self) {
        self.audioTrackSourceFormatDescription = (formatDescription);
        self.audioTrackSettings = [audioSettings copy];
    }
}


- (void)saveToLibraryWithURL:(NSURL *)url {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"error:----%@",error.description);
            }else {
                NSLog(@"保存成功");
//                [self getAllVideo];
            }
        }];
}







- (void)repeat {
    CGPoint offsize = self.imageScroll.contentOffset;
    if (offsize.x < 320*4) {
        offsize.x += 320;
    }
    self.imageScroll.contentOffset = offsize;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"--------%@",[NSRunLoop currentRunLoop]);
    
}




- (void)aaaaa {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    pickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
    pickerController.delegate = self;
    pickerController.videoQuality = UIImagePickerControllerQualityType640x480;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
}


- (void)click {
//    [_test setFrame:CGRectMake(100, 100, 150, 150)];
    _test.image = [UIImage imageNamed:@"22.png"];
    [_test drawRect:self.view.frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ddddd  {
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:nil];
    
    AVAssetTrack *assetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [urlAsset duration])
                              ofTrack:assetTrack
                               atTime:kCMTimeZero error:nil];
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:assetTrack];
    CGAffineTransform transform = CGAffineTransformMake(0, 8/9.0, -8/9.0, 0, 320, -93.3333333);
    [videoCompositionLayerInstruction setTransform:transform atTime:kCMTimeZero];
    
    AVMutableVideoCompositionInstruction *videoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [videoCompositionInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, [composition duration])];
    videoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:videoCompositionLayerInstruction];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = CGSizeMake(320, 320*0.75);
    videoComposition.renderScale = 1.0;
    double seconds = CMTimeGetSeconds([urlAsset duration]);
    videoComposition.frameDuration = CMTimeMake(1, 24);
    videoComposition.instructions = [NSArray arrayWithObject:videoCompositionInstruction];
    
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:urlAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:urlAsset presetName:AVAssetExportPreset640x480];
        session.videoComposition = videoComposition;
        session.shouldOptimizeForNetworkUse = YES;
        session.outputFileType = AVFileTypeMPEG4;//输出文件类型  AVFileTypeQuickTimeMovie
//        session.outputURL = [NSURL fileURLWithPath:videoPath];//输出文件的地址
        [session exportAsynchronouslyWithCompletionHandler:^{
            switch (session.status) {
                case AVAssetExportSessionStatusCompleted:{
                    NSLog(@"AVAssetExportSessionStatusCompleted");
//                    [self saveToLibraryWithURL:[NSURL fileURLWithPath:videoPath]];
                }
                    break;
                case AVAssetExportSessionStatusUnknown:{
                    
                }
                    break;
                case AVAssetExportSessionStatusWaiting:{
                    
                }
                    break;
                case AVAssetExportSessionStatusCancelled:{
                    
                }
                    break;
                case AVAssetExportSessionStatusFailed:{
                    NSLog(@"----AVAssetExportSessionStatusFailed----%@",[session.error description]);
                    
                }
                    break;
                    
                case AVAssetExportSessionStatusExporting:{
                    NSLog(@"AVAssetExportSessionStatusExporting");
                }
                    break;
                default:
                    break;
            }
        }];
    }

}

- (void)aaa {
    //    TestView *testV = [[TestView alloc]initWithFrame:CGRectMake(20, 20, 100, 100)];
    //    testV.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:testV];
    //    _test = testV;
    //    _test.image = [UIImage imageNamed:@"11.png"];
    //
    //    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    //    btn.backgroundColor = [UIColor purpleColor];
    //    [btn setTitle:@"haha" forState:UIControlStateNormal];
    //    [self.view addSubview:btn];
    //    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    //
    //    NSString *str = @"haha";
    //    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //    NSString *pp = [NSString stringWithFormat:@"%@/haha",path];
    //    BOOL isSuceess =  [str writeToFile:pp atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //    if (isSuceess) {
    //        NSLog(@"success");
    //    }
    
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}


@end
