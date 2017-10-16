//
//  Downloader.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#define NoticeReloadData @"RELOAD_DATA"

#import "Downloader.h"
#import "FileUtility.h"

#import "JPDownloadManager.h"

@interface Downloader ()

@property (nonatomic,assign) BOOL downloading; //是否正在加载
@property (nonatomic,copy) NSString * cachPath;
@property (nonatomic,strong) id parameters;
@property (nonatomic,copy) void (^successBlock)(NSDictionary *originData);
@property (nonatomic,copy) void (^failBlock)();
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) void (^waitBlock)();
@property (nonatomic,strong) UIView *errorView;

@end

@implementation Downloader

- initWithController:(UIViewController *)viewController
{
    if(self = [super init]){
        self.viewController = viewController;
        
        //        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //        [center addObserver:self selector:@selector(reloadData:) name:NoticeReloadData object:nil];
    }
    
    return self;
}

#pragma mark -- POST 请求数据

/**
 *  不带缓存 的 POST请求
 *
 *  @param url         请求地址
 *  @param parameters  请求参数 - body
 *  @param waitBlock   等待操作
 *  @param failBlock   失败操作
 *  @param decodeBlock 成功操作 - 解析json
 *  @param refresh     是否刷新
 */
- (void) POST:(NSString *)url
        param:(id)parameters
       wating:(void (^)())waitBlock
         fail:(void (^)())failBlock
      success:(void (^)(NSDictionary *))decodeBlock
      refresh:(BOOL)refresh
{
    //正在下载则直接返回
    if(self.downloading){
        NSLog(@"Downloader is downloading");
        return;
    }
    self.downloading = YES;
    self.url = url;
    self.parameters = parameters;
    self.waitBlock = waitBlock;
    self.successBlock = decodeBlock;
    self.failBlock = failBlock;
    //不需要刷新 且文件存在 则从缓存加载数据
    if(!refresh){
        self.downloading = NO;
    }
    else{
        waitBlock();
//        AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
        JPDownloadManager *manage = [JPDownloadManager sharedManager];
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        manage.requestSerializer.timeoutInterval = 30;
        //        ((AFJSONResponseSerializer *)manage.responseSerializer).removesKeysWithNullValues = YES;
        [manage POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject){
                //存储数据到缓存
                self.downloading = NO;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if(!dict){
                    return;
                }
                //具体的解析逻辑，把字典解析成一个个model数据存储起来
                self.successBlock(dict);
                
                [self hideNetErrorView];
                return;
            }
            
            [self doFail];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络请求失败start:\n%@\nend", error);
            [self doFail];
        }];
//        [manage POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            if(responseObject){
//                //存储数据到缓存
//                self.downloading = NO;
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                if(!dict){
//                    return;
//                }
//                //具体的解析逻辑，把字典解析成一个个model数据存储起来
//                self.successBlock(dict);
//                
//                [self hideNetErrorView];
//                return;
//            }
//            
//            [self doFail];
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //[NSThread sleepForTimeInterval:5];
//            NSLog(@"网络请求失败start:\n%@\nend", error);
//            [self doFail];
//        }];
        //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //            if(responseObject){
        //                //存储数据到缓存
        //                self.downloading = NO;
        //                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //                if(!dict){
        //                    return;
        //                }
        //                //具体的解析逻辑，把字典解析成一个个model数据存储起来
        //                self.successBlock(dict);
        //
        //                [self hideNetErrorView];
        //                return;
        //            }
        //
        //            [self doFail];
        //
        //        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //
        //            //[NSThread sleepForTimeInterval:5];
        //            [self doFail];
        //        }];
    }
}

/**
 *  带缓存 的 POST请求
 *
 *  @param url         请求地址
 *  @param path        缓存地址
 *  @param parameters  请求参数
 *  @param waitBlock   等待操作
 *  @param failBlock   失败操作
 *  @param decodeBlock 成功操作 - 解析json
 *  @param refresh     是否刷新
 */
- (void) POST:(NSString *)url
    cachePath:(NSString *)path
        param:(id)parameters
       wating:(void (^)())waitBlock
         fail:(void (^)())failBlock
      success:(void (^)(NSDictionary *))decodeBlock
      refresh:(BOOL)refresh
{
    //正在下载则直接返回
    
    if(self.downloading){
        NSLog(@"Downloader is downloading");
        return;
    }
    
    self.downloading = YES;
    self.url = url;
    self.parameters = parameters;
    self.waitBlock = waitBlock;
    self.cachPath = path;
    self.successBlock = decodeBlock;
    self.failBlock = failBlock;
    
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:self.cachPath];
    //不需要刷新 且文件存在 则从缓存加载数据
    if(!refresh && fileExist){
        dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(myQueue, ^{
            [self loadDataFromFileDecodeData];
            self.downloading = NO;
        });
    }
    else{
        waitBlock();
        
//        AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
        JPDownloadManager *manage = [JPDownloadManager sharedManager];
        
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        manage.requestSerializer.timeoutInterval = 30;
        //        ((AFJSONResponseSerializer *)manage.responseSerializer).removesKeysWithNullValues = YES;
        [manage POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject){
                //存储数据到缓存
                self.downloading = NO;
                
                //如果有地址，则存储对应的数据
                if(self.cachPath){
                    [FileUtility writeFileData:responseObject filePath:self.cachPath];
                    //                        [responseObject writeToFile:self.cachPath atomically:YES];
                    //从缓存加载数据
                    [self loadDataFromFileDecodeData];
                    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:self.cachPath];
                    NSLog(@"fileExist%d", fileExist);
                }
                
                [self hideNetErrorView];
                return;
            }
            
            
            [self doFail];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error-%@-------", error);
            [self doFail];
        }];
//        [manage POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            if(responseObject){
//                //存储数据到缓存
//                self.downloading = NO;
//                
//                //如果有地址，则存储对应的数据
//                if(self.cachPath){
//                    [FileUtility writeFileData:responseObject filePath:self.cachPath];
//                    //                        [responseObject writeToFile:self.cachPath atomically:YES];
//                    //从缓存加载数据
//                    [self loadDataFromFileDecodeData];
//                    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:self.cachPath];
//                    NSLog(@"fileExist%d", fileExist);
//                }
//                
//                [self hideNetErrorView];
//                return;
//            }
//            
//            
//            [self doFail];
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //[NSThread sleepForTimeInterval:5];
//            NSLog(@"error-%@-------", error);
//            [self doFail];
//        }];
        //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //            if(responseObject){
        //                //存储数据到缓存
        //                self.downloading = NO;
        //
        //                //如果有地址，则存储对应的数据
        //                if(self.cachPath){
        //                    [responseObject writeToFile:self.cachPath atomically:YES];
        //                    //从缓存加载数据
        //                    [self loadDataFromFileDecodeData];
        //                }
        //
        //                [self hideNetErrorView];
        //                return;
        //            }
        //
        //            [self doFail];
        //
        //
        //        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //
        //            //[NSThread sleepForTimeInterval:5];
        //            [self doFail];
        //        }];
    }
}


#pragma mark - GET请求数据 -

/**
 *  带缓存 的 GET请求
 *
 *  @param url         请求地址
 *  @param waitBlock   等待操作
 *  @param failBlock   失败操作
 *  @param decodeBlock 成功操作 - 解析json
 *  @param refresh     是否刷新
 */
/*
- (void) GET:(NSString *)url
     success:(void (^)(NSDictionary *))decodeBlock
      wating:(void (^)())waitBlock
        fail:(void (^)())failBlock
     refresh:(BOOL)refresh
{
    //正在下载则直接返回
    if(self.downloading){
        NSLog(@"Downloader is downloading");
        return;
    }
    self.downloading = YES;
    self.url = url;
    self.waitBlock = waitBlock;
    self.successBlock = decodeBlock;
    self.failBlock = failBlock;
    //不需要刷新 且文件存在 则从缓存加载数据
    if(!refresh){
        self.downloading = NO;
    }
    else{
        waitBlock();
        AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manage GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if(responseObject){
                //存储数据到缓存
                self.downloading = NO;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if(!dict){
                    return;
                }
                
                //具体的解析逻辑，把字典解析成一个个model数据存储起来
                self.successBlock(dict);
                
                [self hideNetErrorView];
                return;
            }
            
            [self doFail];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //[NSThread sleepForTimeInterval:5];
            [self doFail];
        }];
        //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //
        //            if(responseObject){
        //                //存储数据到缓存
        //                self.downloading = NO;
        //                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //                if(!dict){
        //                    return;
        //                }
        //
        //                //具体的解析逻辑，把字典解析成一个个model数据存储起来
        //                self.successBlock(dict);
        //
        //                [self hideNetErrorView];
        //                return;
        //            }
        //
        //            [self doFail];
        //        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //            //[NSThread sleepForTimeInterval:5];
        //            [self doFail];
        //        }];
    }
    
}
*/

/**
 *  带缓存 的 GET请求
 *
 *  @param url         请求地址
 *  @param path        缓存地址
 *  @param waitBlock   等待操作
 *  @param failBlock   失败操作
 *  @param decodeBlock 成功操作 - 解析json
 *  @param refresh     是否刷新
 */
/*
- (void) GET:(NSString *)url
   cachePath:(NSString *)path
     success:(void (^)(NSDictionary *))decodeBlock
      wating:(void (^)())waitBlock
        fail:(void (^)())failBlock
     refresh:(BOOL)refresh
{
    
    //正在下载则直接返回
    
    if(self.downloading){
        NSLog(@"Downloader is downloading");
        return;
    }
    
    self.downloading = YES;
    self.url = url;
    self.waitBlock = waitBlock;
    self.cachPath = path;
    self.successBlock = decodeBlock;
    self.failBlock = failBlock;
    
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:self.cachPath];
    //不需要刷新 且文件存在 则从缓存加载数据
    if(!refresh && fileExist){
        dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(myQueue, ^{
            [self loadDataFromFileDecodeData];
            self.downloading = NO;
        });
    }
    else{
        waitBlock();
        
        AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manage GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if(responseObject){
                //存储数据到缓存
                self.downloading = NO;
                
                //如果有地址，则存储对应的数据
                if(self.cachPath){
                    [FileUtility writeFileData:responseObject filePath:self.cachPath];
                    //                    [responseObject writeToFile:self.cachPath atomically:YES];
                    //从缓存加载数据
                    [self loadDataFromFileDecodeData];
                }
                
                [self hideNetErrorView];
                return;
            }
            
            [self doFail];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self doFail];
        }];
        
        //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        //            if(responseObject){
        //                //存储数据到缓存
        //                self.downloading = NO;
        //
        //                //如果有地址，则存储对应的数据
        //                if(self.cachPath){
        //                    [responseObject writeToFile:self.cachPath atomically:YES];
        //                    //从缓存加载数据
        //                    [self loadDataFromFileDecodeData];
        //                }
        //
        //                [self hideNetErrorView];
        //                return;
        //            }
        //
        //            [self doFail];
        //
        //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //            //[NSThread sleepForTimeInterval:5];
        //            [self doFail];
        //        }];
        
        
    }
}
*/

//从缓存加载数据 然后解析数据后进行赋值
- (void) loadDataFromFileDecodeData
{
    //加载数据
    NSData *data = [NSData dataWithContentsOfFile:self.cachPath];
    if (!data) {
        return;
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if(!dict){
        return;
    }
    
    //具体的解析逻辑，把字典解析成一个个model数据存储起来
    self.successBlock(dict);
}


#pragma mark - 网路请求错误处理 -
- (void)doFail
{
    self.downloading = NO;
    self.failBlock();
    [self showNetErrorView];
}

- (UIView *)errorView
{
    if (!_errorView) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reDownloadData:)];
        //加载错误时显示的界面的底板
        UIView *errorView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        errorView.backgroundColor = [UIColor redColor];
        [errorView addGestureRecognizer:tap];
        [self.viewController.view addSubview:errorView];
        if (!_customErrorView) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
            label.text = @"加载失败!点击界面重新加载";
            label.center = self.viewController.view.center;
            [label sizeToFit];
            [errorView addSubview:label];
        }
        _errorView = errorView;
    }
    return _errorView;
}

- (void)showNetErrorView
{
    if (_customErrorView) {
        [self.errorView addSubview:_customErrorView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reDownloadData:)];
        [_customErrorView addGestureRecognizer:tap];
    }
    [self errorView];
}

- (void)hideNetErrorView
{
    [self.errorView removeFromSuperview];
}

//重新请求数据
//- (void)reDownloadData:(UIGestureRecognizer *)gesture
//{
//    if(self.cachPath)
//    {
//        if(self.parameters)
//        {
//            [self POST:self.url cachePath:self.cachPath param:self.parameters wating:self.waitBlock fail:self.failBlock success:self.successBlock refresh:YES];
//        }
//        else
//        {
//            [self GET:self.url cachePath:self.cachPath success:self.successBlock wating:self.waitBlock fail:self.failBlock refresh:YES];
//        }
//    }
//    else
//    {
//        if(self.parameters)
//        {
//            [self POST:self.url param:self.parameters wating:self.waitBlock fail:self.failBlock success:self.successBlock refresh:YES];
//        }
//        else
//        {
//            [self GET:self.url success:self.successBlock wating:self.waitBlock fail:self.failBlock refresh:YES];
//        }
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NoticeReloadData object:nil];
}

/**
 *  @author WJP
 *
 *  @brief  下载文件
 *
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
//- (void)downloadFileWithOption:(NSDictionary *)paramDic
//                 withInferface:(NSString*)requestURL
//                     savedPath:(NSString*)savedPath
//               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//                      progress:(void (^)(float progress))progress
//
//{
//
//    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:requestURL parameters:paramDic error:nil];
//
//    //以下是手动创建request方法 AFQueryStringFromParametersWithEncoding有时候会保存
//    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
//    //   NSMutableURLRequest *request =[[[AFHTTPRequestOperationManager manager]requestSerializer]requestWithMethod:@"POST" URLString:requestURL parameters:paramaterDic error:nil];
//    //
//    //    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    //
//    //    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
//    //    [request setHTTPMethod:@"POST"];
//    //
//    //    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(paramaterDic, NSASCIIStringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
//
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float p = (float)totalBytesRead / totalBytesExpectedToRead;
//        progress(p);
//        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
//
//    }];
//
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(operation,responseObject);
//        NSLog(@"下载成功");
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure(operation,error);
//
//        NSLog(@"下载失败");
//
//    }];
//
//    [operation start];
//}

- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withURLString:(NSString *)requestURL
                     savedPath:(NSString *)savedPath
               downloadSuccess:(void (^)(NSString *))success
               downloadFailure:(void (^)(NSError *))failure
                      progress:(void (^)(float))progress
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float p = 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
            progress(p);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!savedPath) {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        }else{
            return [NSURL fileURLWithPath:savedPath];
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error == nil) {
            if (success) {
                success([filePath path]);//返回完整路径
            }
        } else {
            if (failure) {
                failure(error);
            }
        }
    }];
    [downloadTask resume];
}

- (void)uploadSingleFileWithOption:(NSDictionary *)paramDic
                     withURLString:(NSString*)requestURL
                          fileName:(NSString*)fileName
                          fileData:(NSData*)fileData
                   downloadSuccess:(void (^)(id responseObject))success
                   downloadFailure:(void (^)(NSError *error))failure
                          progress:(void (^)(float progress))progress
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestURL parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:fileName fileName:@"xdf.png" mimeType:@"image/png"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      //                      dispatch_async(dispatch_get_main_queue(), ^{
                      //                          //Update the progress view
                      //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      //                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          if (failure) {
                              failure(error);
                          }
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          if (success) {
                              success(responseObject);
                          }
                      }
                  }];
    
    [uploadTask resume];
    
}

- (void)uploadMultiPartFileWithOption:(NSDictionary *)paramDic
                        withURLString:(NSString*)requestURL
                             fileName:(NSString*)fileName
                            filePaths:(NSArray*)filePathArray
                      downloadSuccess:(void (^)(id responseObject))success
                      downloadFailure:(void (^)(NSError *error))failure
                             progress:(void (^)(float progress))progress
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestURL parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (filePathArray.count > 0) {
            for (NSInteger i = 0; i < filePathArray.count; ++i) {
                NSData *data = [[NSData alloc] initWithContentsOfFile:filePathArray[i]];
                NSString *name = [NSString stringWithFormat:@"%@%ld", fileName, i];
                [formData appendPartWithFileData:data name:name fileName:@"xdf.png" mimeType:@"image/png"];
            }
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          if (failure) {
                              failure(error);
                          }
                      } else {
                          if (success) {
                              success(responseObject);
                          }
                      }
                  }];
    
    [uploadTask resume];
}

@end
