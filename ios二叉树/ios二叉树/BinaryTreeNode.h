//
//  BinaryTreeNode.h
//  ios二叉树
//
//  Created by Nero on 16/7/20.
//  Copyright © 2016年 zjevil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinaryTreeNode : NSObject

@property (nonatomic,assign) NSInteger value;

@property (nonatomic,strong) BinaryTreeNode *leftNode;
@property (nonatomic,strong) BinaryTreeNode *rightNode;

@end
