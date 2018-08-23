//
//  YYShareHttpRequest.h
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 16/1/5.
//  Copyright © 2016年 POSUN-MAC. All rights reserved.
//
//#import "YYLonginModel.h"
#define uploadPicture @"img"
#define uploadPictureNmae @"imageName"

@class YYShareHttpRequest;
/**
 object:返回的数据
 error:返回error
 shareHttpRequest:请求对象本身
 **/
typedef void(^RequestResponseBlack)(id object,NSError *error,YYShareHttpRequest *shareHttpRequest);

@protocol YYShareHttpRequestDelegate <NSObject>
@optional
/**
 object:返回的数据
 error:返回error
 shareHttpRequest:请求对象本身
 **/
-(void)requestResponse:(id)object andError:(NSError*)error and:(YYShareHttpRequest *)shareHttpRequest;

@end
static CGFloat timeoutInterval=30.0f;//15.0f;
#import <Foundation/Foundation.h>
//#import "YYHttpRequestAPI.h"
#import "YYHTTPHeaderFieldModel.h"
#import "AFHTTPSessionManager+Add.h"

#define yyHost [YYShareHttpRequest share].host

#define YYShareHttpRequestError  error||([object isKindOfClass:[NSDictionary class]]&&object[@"errorMsg"])
/**
 创建ShareHttpRequest请求对象
 **/
#define ShareHttpRequest [[YYShareHttpRequest alloc] init]
/**
 地址拼接
 **/
#define URL(url) [NSString stringWithFormat:@"%@%@",yyHost,url]


#define PictureQuality_Auto @"Auto"
#define PictureQuality_High @"High"
#define PictureQuality_Medium @"Medium"
#define PictureQuality_Low @"Low"


@interface YYShareHttpRequest : NSObject
//@property(nonatomic,strong)YYHTTPHeaderFieldModel *HTTPHeaderFieldModel;

@property(nonatomic,retain)NSMutableArray *currentViewControllers;

@property(nonatomic,copy)NSString *host;
@property(nonatomic,copy)NSString *pictureCompressionRatioTpye;


@property(nonatomic,weak)id<YYShareHttpRequestDelegate> delegate;
@property(nonatomic,retain)NSMutableDictionary *expandDic;
@property(nonatomic,assign)NSString *flag;
//@property(nonatomic,retain)YYHttpRequestAPI *api;
@property(nonatomic,retain)NSDictionary *isNoJsonFlagDictionary;
@property(nonatomic,retain)NSDictionary *isNoShowLoadDictionary;
@property (nonatomic,assign,getter=isAutoShowErrorMsg) BOOL autoShowErrorMsg;//是否自动显示错误信息
@property(nonatomic,retain)id rawData;//data解析得到的原始数据
@property(nonatomic,retain)NSData *data;//data解析得到的原始数据

/**
 字典拼接成字符串
 **/
+(NSString *)doWithParams:(NSDictionary *)paramDic;
/**
 网络监测
 **/
@property(nonatomic,assign)BOOL NetBool;

#pragma mark -  Get请求
/**
 url:请求地址
 paramDic:请求参数
 modelName:json解析Model类的类名
 **/
-(void)httpGetRequestWrithUrl:(NSString *)url andParam:(NSDictionary *)paramDic andModelName:(NSString *)modelName;
/**
 url:请求地址
 paramDic:请求参数
 modelName:json解析Model类的类名
 requestResponseBlack:请求结果放回快
 **/
-(void)httpGetRequestWrithUrl:(NSString *)url andParam:(NSDictionary *)paramDic andModelName:(NSString *)modelName andRequestResponseBlack:(RequestResponseBlack)requestResponseBlack;

#pragma mark -  Post请求
/**
 url:请求地址
 paramDic:请求参数
 modelName:json解析Model类的类名
 **/
-(void)httpPostRequestWrithUrl:(NSString *)url andParam:(NSDictionary *)paramDic andModelName:(NSString *)modelName;
/**
 url:请求地址
 paramDic:请求参数
 modelName:json解析Model类的类名
  requestResponseBlack:请求结果返回快
 **/
-(void)httpPostRequestWrithUrl:(NSString *)url andParam:(NSDictionary *)paramDic andModelName:(NSString *)modelName andRequestResponseBlack:(RequestResponseBlack)requestResponseBlack;

#pragma mark - 上传图片
/**
 array:上传的图片数组数组里装的元素是字典类型(@{uploadPicture:image,uploadPictureNmae:imageNmae})
 fileName:上传到服务器的文件名
 url:请求地址
 **/
-(void)httpUploadPictures:(NSArray *)array fileName:(NSString*)fileName andUrl:(NSString *)url;
/**
 array:上传的图片数组数组里装的元素是字典类型(@{uploadPicture:image,uploadPictureNmae:imageNmae})
 fileName:上传到服务器的文件名
 url:请求地址
 requestResponseBlack:请求结果返回快
 **/
-(void)httpUploadPictures:(NSArray *)array fileName:(NSString*)fileName andUrl:(NSString *)url andRequestResponseBlack:(RequestResponseBlack)requestResponseBlack;
+(YYShareHttpRequest *)share;
/**
 创建一个GET请求对像
 **/
-(NSMutableURLRequest*)getHTTPRequestURL:(NSString *)url aneParam:(NSDictionary *)paramDic;
/**
 创建一个POST请求对像
 **/
-(NSMutableURLRequest*)postJSONHTTPRequestURL:(NSString *)url andJsonDic:(NSDictionary *)jsonDic;
@end
