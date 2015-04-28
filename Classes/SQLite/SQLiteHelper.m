////
////  SQLiteHelper.m
////  Goods
////
////  Created by yuda on 15/3/15.
////  Copyright (c) 2015年 yuda. All rights reserved.
////  参考：http://blog.csdn.net/totogo2010/article/details/7702207
//
//#import "SQLiteHelper.h"
//
//@interface SQLiteHelper()
//{
//    sqlite3 *db;
//}
//@end
//
//@implementation SQLiteHelper
//static SQLiteHelper *instance = nil;
//#pragma mark - interface
//+ (SQLiteHelper *)shareSQLiteHelper
//{
//    if (!instance) {
//        instance = [[SQLiteHelper alloc] init];
//    }
//    return instance;
//}
//+ (BOOL)addItem:(GoodsInfo *)gi
//{
//    return [SQLiteHelper addItemWithName:gi.name spec:gi.spec buyPrice:gi.buyPrice sellPrice:gi.sellPrice];
//}
//+ (BOOL)addItemWithName:(NSString *)nm spec:(NSString *)spec buyPrice:(float)bp sellPrice:(float)sp
//{
//    SQLiteHelper *instance = [SQLiteHelper shareSQLiteHelper];
//    return [instance trueAddItemWithName:nm spec:spec buyPrice:bp sellPrice:sp];
//}
//+ (BOOL)deleteAllData
//{
//    SQLiteHelper *instance = [SQLiteHelper shareSQLiteHelper];
//    return [instance trueDeleteAllData];
//}
//+ (BOOL)deleteGoodsInfo:(GoodsInfo *)gi
//{
//    SQLiteHelper *instance = [SQLiteHelper shareSQLiteHelper];
//    return [instance trueDeleteGoodsInfo:gi];
//}
//+ (BOOL)updateGoodsInfo:(GoodsInfo *)gi withNew:(GoodsInfo *)newgi
//{
//    SQLiteHelper *instance = [SQLiteHelper shareSQLiteHelper];
//    return [instance trueUpdateGoodsInfo:gi withNew:newgi];
//}
//+ (NSMutableArray *)selectItemsWithName:(NSString *)nm spec:(NSString *)spec
//{
//    SQLiteHelper *instance = [SQLiteHelper shareSQLiteHelper];
//    return [instance trueSeleteItemsWithName:nm spec:spec];
//}
//+ (void)initTable
//{
//    SQLiteHelper *instance = [SQLiteHelper shareSQLiteHelper];
//    [instance trueInitTable];
//}
//
//#pragma mark - function
//- (void)trueOpenDB
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
////    NSLog(@"documents path:%@", documents);
//    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
//    
//    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSLog(@"数据库打开失败");
//    } else {
//        NSLog(@"数据库打开成功");
//    }
//}
//- (void)trueCloseDB
//{
//    sqlite3_close(db);
//}
//- (BOOL)execSql:(NSString *)sql
//{
//    [self trueOpenDB];
//    char *err;
//    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSLog(@"数据库操作数据失败!");
//        return NO;
//    }
//    [self trueCloseDB];
//    return YES;
//}
//- (void)trueInitTable
//{
//    // create table xxx (xxxauto auto_increment,xxx,xxx,xxx,xxx) primary key(xxxauto, xxx,xxx)
////    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ %@, %@ %@, %@ %@, %@ %@)", TABLENAME, NAME, TEXT, SPEC, INTEGER, BUYPRICE, FLOAT, SELLPRICE, FLOAT];
//    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ %@, %@ %@(20), %@ %@, %@ %@, primary key(%@, %@))", TABLENAME, NAME, TEXT, SPEC, TEXT, BUYPRICE, FLOAT, SELLPRICE, FLOAT, NAME, SPEC];
//    if (![self execSql:sqlCreateTable])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据表不能正常打开" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
//}
//- (BOOL)trueAddItemWithName:(NSString *)nm spec:(NSString *)spec buyPrice:(float)bp sellPrice:(float)sp
//{
////    if (!nm || nm.length == 0 || spec < 0) {
//    if (!nm || nm.length == 0) {
//        return NO;
//    }
//    NSString *sql1 = [NSString stringWithFormat:
//                      @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%.2f', '%.2f')",
//                      TABLENAME, NAME, SPEC, BUYPRICE, SELLPRICE, nm, spec, bp, sp];
//    return [self execSql:sql1];
//}
//- (BOOL)trueDeleteGoodsInfo:(GoodsInfo *)gi
//{
//    NSString *name = gi.name;
//    NSString *spec = gi.spec ? gi.spec : SPEC_IS_NULL;
//    NSString *sql1 = [NSString stringWithFormat:
//                      @"delete from '%@' where %@='%@' and %@='%@'",
//                      TABLENAME, NAME, name, SPEC, spec];
//    return [self execSql:sql1];
//}
//- (BOOL)trueDeleteAllData
//{
//    NSString *sql1 = [NSString stringWithFormat:
//                      @"delete from '%@'",
//                      TABLENAME];
//    return [self execSql:sql1];
//}
//- (BOOL)trueUpdateGoodsInfo:(GoodsInfo *)gi withNew:(GoodsInfo *)newgi
//{
//    if ([gi isEqualToAnother:newgi]) {
//        return YES;
//    }
//    NSString *sql1 = [NSString stringWithFormat:
//                      @"update '%@' set %@='%@', %@='%@', %@=%.2f, %@=%.2f where %@='%@' and %@='%@'",
//                      TABLENAME, NAME, newgi.name, SPEC, newgi.spec, BUYPRICE, newgi.buyPrice, SELLPRICE, newgi.sellPrice, NAME, gi.name, SPEC, gi.spec];
//    return [self execSql:sql1];
//}
//- (NSMutableArray *)trueSeleteItemsWithName:(NSString *)nm spec:(NSString *)spec
//{
//    // select * from PERSONINFO where name='张三' and age=23
//    NSMutableArray *result = nil;
//    NSString *opWhere = @"where";
//    NSString *opName = @"";
//    NSString *opAnd = @"and";
//    NSString *opSpec = @"";
//    // 将nil变成空字符串
//    if (!nm) {
//        nm = @"";
//    }
//    if (!spec) {
//        spec = @"";
//    }
//    if (nm.length > 0)
//    {
//        // 之前搜索 我们，可以搜索到‘我们’，但是搜索不到‘我们的’,好尴尬
////        opName = [NSString stringWithFormat:@"name='%@'", nm];
//        opName = [NSString stringWithFormat:@"name like '%%%@%%'", nm];
//        NSLog(@"opName is %@", opName);
//    }
//    
//    if (spec.length > 0)
//    {
//        opSpec = [NSString stringWithFormat:@"spec like '%%%@%%'", spec];
//        NSLog(@"opSpec is %@", opSpec);
//    }
//    if (opName.length == 0 && opSpec.length == 0) {
//        opWhere = @"";
//        opAnd = @"";
//    } else if (opName.length == 0 || opSpec.length == 0) {
//        opAnd = @"";
//    }
//    [self trueOpenDB];
//    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ %@ %@ %@ %@", TABLENAME, opWhere, opName, opAnd, opSpec];
//    sqlite3_stmt * statement;
//    
//    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            char *name = (char*)sqlite3_column_text(statement, 0);
//            NSString *nsNameStr = [[NSString alloc] initWithUTF8String:name];
//            
//            char *spec = (char*)sqlite3_column_text(statement, 1);
//            NSString *nsSpecStr = [NSString stringWithUTF8String:spec];
//            
//            double buyprice = sqlite3_column_double(statement, 2);
//            
//            double sellprice = sqlite3_column_double(statement, 3);
//            if (!result) {
//                result = [NSMutableArray array];
//            }
//            
//            GoodsInfo *gi = [[GoodsInfo alloc] initWithName:nsNameStr Spec:nsSpecStr buyPrice:buyprice sellPrice:sellprice];
//            [result addObject:gi];
//            
//            NSLog(@"%@, %@, %.2f, %.2f", nsNameStr, nsSpecStr, buyprice, sellprice);
//        }
//    }
//    [self trueCloseDB];
//    return result;
//}
//@end
