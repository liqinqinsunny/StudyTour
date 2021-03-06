//
//  FileUtility.m
//  FxCore
//
//  Created by hejinbo on 12-2-22.
//  Copyright (c) 2012年 Hejinbo. All rights reserved.
//

#import "FileUtility.h"
#import <sys/stat.h>
#import <dirent.h>
 
@implementation FileUtility

+ (NSString *)sandboxHomePath
{
    return NSHomeDirectory();
}

+ (BOOL)isFileExist:(NSString *)filePath
{
    //文件管理器 判断是否存在该路径
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

+ (BOOL)createDirectoryPath:(NSString *)DirectoryPath
{
    if ([FileUtility isFileExist:DirectoryPath]) {
        return YES;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    [fm createDirectoryAtPath:DirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)createFilePath:(NSString *)filePath
{
    NSString *directoryPath = [filePath stringByDeletingLastPathComponent];
    if (![FileUtility isFileExist:directoryPath]) {
        BOOL iscreate = [FileUtility createDirectoryPath:directoryPath];
        if (!iscreate) {
            return NO;
        }
    }
    if ([FileUtility isFileExist:filePath]) {
        return YES;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
//    NSData *data = [@"" dataUsingEncoding: NSUTF8StringEncoding];
    BOOL sucess = [fm createFileAtPath:filePath contents:nil attributes:nil];
    if (sucess) {
        NSLog(@"文件创建成功");
        return YES;
    }
    return NO;
}

+ (BOOL)writeFileString:(id)object filePath:(NSString *)filePath
{
    if (![FileUtility isFileExist:filePath]) {
        [FileUtility createFilePath:filePath];
    }
    NSError *error = nil;
    //atomically 是否保持文件的原子性  YES会先创建一个临时文件,直到文件内容写入成功再导入到目标文件里.
    //如果为NO,则直接写入目标文件里.
    BOOL sucess = [object writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    if (sucess) {
        return YES;
    }
    return NO;
}

+ (BOOL)writeFileData:(NSData *)object filePath:(NSString *)filePath
{
    if (![FileUtility isFileExist:filePath]) {
        [FileUtility createFilePath:filePath];
    }
    NSError *error = nil;

    BOOL sucess = [object writeToFile:filePath atomically:YES];
    
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    if (sucess) {
        return YES;
    }
    return NO;
}

+ (BOOL)writeFileDictionary:(NSDictionary *)object filePath:(NSString *)filePath
{
    if (![FileUtility isFileExist:filePath]) {
        [FileUtility createFilePath:filePath];
    }
    NSError *error = nil;

    BOOL sucess = [object writeToFile:filePath atomically:YES];
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    if (sucess) {
        return YES;
    }
    return NO;
}

+ (NSString *)readFilePathForString:(NSString *)filePath
{
    if (![FileUtility isFileExist:filePath]) {
        return @"";
    }
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return @"";
    }
    return content;
    

//     NSFileManager *fm = [NSFileManager defaultManager];
//     NSData * data = [fm contentsAtPath:filePath];
    
//     NSData->String
//     NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//     return aString;
    
//     String->NSData
//       NSData *aData = [aString dataUsingEncoding: NSUTF8StringEncoding];
    

//     NSData *data = [NSData dataWithContentsOfFile:filePath];
}

+ (NSData *)readFilePathForData:(NSString *)filePath
{
    if (![FileUtility isFileExist:filePath]) {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

+ (NSDictionary *)readFilePathForDictionary:(NSString *)filePath
{
    if (![FileUtility isFileExist:filePath]) {
        return nil;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}


+ (BOOL)renameFile:(NSString *)filePath toFile:(NSString *)toPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([FileUtility isFileExist:toPath]) {
        [fm removeItemAtPath:filePath error:&error];
        if (error!=nil) {
            BASE_ERROR_FUN([error localizedDescription]);
        }
    }
    
    [fm moveItemAtPath:filePath toPath:toPath error:&error];
    if (error != nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteFile:(NSString *)filePath
{
    if (![FileUtility isFileExist:filePath]) {
        return YES;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    [fm removeItemAtPath:filePath error:&error];
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    
    return YES;
}
 
+ (BOOL)copyFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath 
           isReplace:(BOOL)isReplace
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([FileUtility isFileExist:toPath] && isReplace) {
        [FileUtility deleteFile:toPath];
    }
    
    [fm copyItemAtPath:fromPath toPath:toPath error:&error];
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)copyContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath 
                   isReplace:(BOOL)isReplace
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;

    NSArray *contents = [fm contentsOfDirectoryAtPath:fromPath error:&error];
    if (error != nil) {
        BASE_ERROR_FUN([error localizedDescription]);
    }
    
    NSString *toFilePath = nil, *fromFilePath = nil;
    for (NSString *path in contents) {
        
        toFilePath = [toPath stringByAppendingPathComponent:path];
        fromFilePath = [fromPath stringByAppendingPathComponent:path];
        
        if ([FileUtility isFileExist:toFilePath] && isReplace) {
            [FileUtility deleteFile:toFilePath];
        }
        
        [fm copyItemAtPath:fromFilePath toPath:toFilePath error:&error];
        if (error != nil) {
            BASE_ERROR_FUN([error localizedDescription]);
        }
    }
    
    return YES;
}

+ (BOOL)moveFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath 
           isReplace:(BOOL)isReplace
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([FileUtility isFileExist:toPath] && isReplace) {
        [FileUtility deleteFile:toPath];
    }
    
    [fm moveItemAtPath:fromPath toPath:toPath error:&error];
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    
    return YES;
}


+ (BOOL)moveContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath 
                   isReplace:(BOOL)isReplace
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSArray *contents = [fm contentsOfDirectoryAtPath:fromPath error:&error];
    if (error != nil) {
        BASE_ERROR_FUN([error localizedDescription]);
    }
    
    NSString *toFilePath = nil, *fromFilePath = nil;
    for (NSString *path in contents) {
        
        toFilePath = [toPath stringByAppendingPathComponent:path];
        fromFilePath = [fromPath stringByAppendingPathComponent:path];
        
        if ([FileUtility isFileExist:toFilePath] && isReplace) {
            [FileUtility deleteFile:toFilePath];
        }
        
        [fm moveItemAtPath:fromFilePath toPath:toFilePath error:&error];
        if (error != nil) {
            BASE_ERROR_FUN([error localizedDescription]);
        }
    }
    
    return YES;
}

+ (double)calculteFileSzie:(NSString *)filePath
{
    double fSize = 0.0f;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:filePath error:nil];
    
    if (dirContents == nil) {//文件夹为空时,dirContents不为nil但数目count为0,path为文件时,dirContents=nil
        NSDictionary* dirAttr = [fm attributesOfItemAtPath:filePath error: nil]; //path为文件夹时获得的文件夹大小不准确
        fSize += [[dirAttr objectForKey:NSFileSize] floatValue];
    }
    else {
        for (NSString *dirName in dirContents) {
            fSize +=  [FileUtility calculteFileSzie:[filePath stringByAppendingPathComponent:dirName]] ;
        }
    }
    
    return fSize;
}

+ (double)calculteFileSizeAtPath:(const char*)folderPath
{
    double folderSize = 0;
    DIR* dir = opendir(folderPath);
    
    if (dir != NULL) { 
        struct dirent* child;
        struct stat st;
        NSInteger folderPathLength = 0;
        char childPath[1024] = {0};
        
        while ((child = readdir(dir))!=NULL) {
            // 忽略目录 .
            if (child->d_type == DT_DIR && (child->d_name[0] == '.' && child->d_name[1] == 0)) { 
                continue;
            }
            
            // 忽略目录 ..
            if (child->d_type == DT_DIR && (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0)) 
                continue;
            
            folderPathLength = strlen(folderPath);
            stpcpy(childPath, folderPath);
            
            if (folderPath[folderPathLength-1] != '/'){
                childPath[folderPathLength] = '/';
                folderPathLength++;
            }
            
            stpcpy(childPath+folderPathLength, child->d_name);
            childPath[folderPathLength + child->d_namlen] = 0;
            
            // 递归计算子目录
            if (child->d_type == DT_DIR) { 
                folderSize += [FileUtility calculteFileSizeAtPath:childPath]; 
                // 把目录本身所占的空间也加上
                if(lstat(childPath, &st) == 0) 
                    folderSize += st.st_size;
            }
            else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
                if(lstat(childPath, &st) == 0) {
                    folderSize += st.st_size;
                }
            }
        }
    
    }
         
    closedir(dir);
    return folderSize;
}

+ (double)calculteFileSzieEx:(NSString *)filePath
{
    if (![FileUtility isFileExist:filePath]) {
        return 0.0f;
    }
    
    return [FileUtility calculteFileSizeAtPath:[filePath cStringUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)deleteFiles:(NSArray *)fileNames inPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:path error:nil];
    
    if (dirContents == nil) {//文件夹为空时,dirContents不为nil但数目count为0,path为文件时,dirContents=nil
        if ([fileNames containsObject:[path lastPathComponent]]) {
            [FileUtility deleteFile:path];
        }
    }
    else {
        for (NSString *dirName in dirContents) {
            if ([fileNames containsObject:dirName]) {
                [FileUtility deleteFile:[path stringByAppendingPathComponent:dirName]];
            }
            else {
                [FileUtility deleteFiles:fileNames inPath: [path stringByAppendingPathComponent:dirName]];
            }
        }
    }
}

@end