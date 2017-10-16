//
//  FileUtility.h
//  FxCore
//
//  Created by hejinbo on 12-2-22.
//  Copyright (c) 2012年 Hejinbo. All rights reserved.
//

@interface FileUtility : NSObject {

}

+ (NSString *)sandboxHomePath;

/**
 *功能: 判断文件或文件夹是否已存在
 *参数:  
 filePath: 文件或文件夹的全路径
 *返回:
 TRUE : 已经存在
 FALSE: 不存在
 **/
+ (BOOL)isFileExist:(NSString *)filePath;

/**
 *功能: 创建文件夹目录
 *参数:  
 filePath: 文件夹的全路径；不存在就自动创建
 *返回:
 TRUE : 已经存在或不存在就创建
 FALSE: 创建失败
 **/
+ (BOOL)createDirectoryPath:(NSString *)DirectoryPath;

/**
 *功能: 创建文件
 *参数:
 filePath: 文件的全路径；不存在就自动创建
 *返回:
 TRUE : 已经存在或不存在就创建
 FALSE: 创建失败
 **/
+ (BOOL)createFilePath:(NSString *)filePath;

/**
 *功能: 写入数据字符串
 *参数:
 object :写入内容对象
 filePath: 文件的全路径；不存在就自动创建
 *返回:
 TRUE : 写入成功
 FALSE: 写入失败
 **/
+ (BOOL)writeFileString:(id)object filePath:(NSString *)filePath;

+ (BOOL)writeFileData:(NSData *)object filePath:(NSString *)filePath;

+ (BOOL)writeFileDictionary:(NSDictionary *)object filePath:(NSString *)filePath;

/**
 *功能: 读取文件数据
 *参数:
 filePath: 文件的全路径；不存在就自动创建
 *返回:
NSString : 读取返回的是字符串
 **/
+ (NSString *)readFilePathForString:(NSString *)filePath;

/**
 *功能: 读取文件数据
 *参数:
 filePath: 文件的全路径；不存在就自动创建
 *返回:
 NSString : 读取返回的Data二进制数据
 **/
+ (NSData *)readFilePathForData:(NSString *)filePath;


/**
 *功能: 读取文件数据 仅限于读取plist文件
 *参数:
 filePath: 文件的全路径；不存在就自动创建
 *返回:
 NSString : 读取返回的的是个字典
 **/
+ (NSDictionary *)readFilePathForDictionary:(NSString *)filePath;

/**
 *功能: 重命名文件
 TRUE : 成功
 FALSE: 创建失败
 **/
+ (BOOL)renameFile:(NSString *)filePath toFile:(NSString *)toPath;

/**
 *功能: 删除文件或文件夹
 *参数:  
 filePath: 文件或文件夹的全路径
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)deleteFile:(NSString *)filePath;

/**
 *功能: 将文件或文件夹从一个目录拷贝到另一个目录
 *参数:  
 fromPath   : 原始目录,如/Library/11
 toPath     : 目标目录,如/Documents/11
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)copyFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath 
           isReplace:(BOOL)isReplace;

/**
 *功能: 将文件夹中的内容拷贝到另一个目录中,
 *参数:  
 fromPath   : 原始目录,如/Library/11,其中有1.jpg
 toPath     : 目标目录,如/Documents/,执行成功后,/Documents/1.jpg
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)copyContentsFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath 
           isReplace:(BOOL)isReplace;


/**
 *功能: 将文件或文件夹从一个目录移动到另一个目录
 *参数:  
 fromPath   : 原始目录,如/Library/11
 toPath     : 目标目录,如/Documents/11
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)moveFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath 
           isReplace:(BOOL)isReplace;

/**
 *功能: 将文件夹中的内容移动到另一个目录中,
 *参数:  
 fromPath   : 原始目录,如/Library/11,其中有1.jpg
 toPath     : 目标目录,如/Documents/,执行成功后,/Documents/1.jpg
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)moveContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath 
                   isReplace:(BOOL)isReplace;

/**
 *功能: 计算一个文件或文件夹大小,
 *参数:  
 filePath   : 文件或文件夹路径
 *返回: 文件或文件夹所占字节数
 **/
+ (double)calculteFileSzie:(NSString *)filePath;

/**
 *功能: 计算一个文件夹大小,该方法效率更高
 *参数:  
 filePath   : 文件或文件夹路径
 *返回: 文件或文件夹所占字节数
 **/
+ (double)calculteFileSzieEx:(NSString *)filePath;


/**
 *功能：递归删除某个目录下的指定文件
 **/
+ (void)deleteFiles:(NSArray *)fileNames inPath:(NSString *)path;
@end