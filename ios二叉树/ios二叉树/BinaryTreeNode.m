//
//  BinaryTreeNode.m
//  ios二叉树
//
//  Created by Nero on 16/7/20.
//  Copyright © 2016年 zjevil. All rights reserved.
//

#import "BinaryTreeNode.h"

@implementation BinaryTreeNode


+(BinaryTreeNode *)creatTreeWithValues:(NSArray *)values {
    BinaryTreeNode *root = nil;
    for (NSInteger i = 0; i < values.count; i++) {
        NSInteger value = [(NSNumber *)[values objectAtIndex:i] integerValue];
        root = [BinaryTreeNode addTreeNodeL:root value:value];
    }
    return root;
}

+(BinaryTreeNode *)addTreeNodeL:(BinaryTreeNode *)treeNode value:(NSInteger)value{
    if(!treeNode){
        treeNode = [BinaryTreeNode new];
        treeNode.value = value;
    }
    else if (value <= treeNode.value){
        treeNode.leftNode = [BinaryTreeNode addTreeNodeL:treeNode value:value];
    }else{
        treeNode.rightNode = [BinaryTreeNode addTreeNodeL:treeNode value:value];
    }
    return treeNode;
}

+(BinaryTreeNode *)treeNodeAtIndex:(NSInteger)index tree:(BinaryTreeNode *)rootNode{

    if(!rootNode || index<0){
        return nil;
    }
    NSMutableArray *queueArray = [NSMutableArray array];
    [queueArray addObject:rootNode];
    while (queueArray.count > 0) {
        BinaryTreeNode *node = [queueArray firstObject];
        if(index == 0) return node;
        [queueArray removeObjectAtIndex:0];
        index -- ;
        if(node.leftNode) {
            [queueArray addObject:node.leftNode];
        }
        if(node.rightNode){
            [queueArray addObject:node.rightNode];
        }
    }
    return nil;
}

+(void)preOrderTraver:(BinaryTreeNode *)rootNode handle:(void(^)(BinaryTreeNode *))handler{
    if(rootNode){
        if(handler){
            handler(rootNode);
        }
        [self preOrderTraver:rootNode.leftNode handle:handler];
        [self preOrderTraver:rootNode.rightNode handle:handler];
    }
}

+(void)inOrderTraver:(BinaryTreeNode *)rootNode handle:(void(^)(BinaryTreeNode *))handler{
    
    if(rootNode){
        [self inOrderTraver:rootNode.leftNode handle:handler];
        if(handler){
            handler(rootNode);
        }
        [self inOrderTraver:rootNode.rightNode handle:handler];
    }
}

+(void)levelTravelTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *))handler{
    if(!rootNode) return;
    NSMutableArray *queueArray = [NSMutableArray array];
    [queueArray addObject:rootNode];
    while (queueArray.count > 0) {
        handler(rootNode);
        [queueArray removeObjectAtIndex:0];
        if(rootNode.leftNode){
            [queueArray addObject:rootNode.leftNode];
        }
        if(rootNode.rightNode){
            [queueArray addObject:rootNode.rightNode];
        }
    }
}

+(NSInteger)deepOfTree:(BinaryTreeNode *)rootNode{
    if(!rootNode){
        return 0;
    }
    if(rootNode && !rootNode.leftNode && !rootNode.rightNode){
        return 1;
    }
    NSInteger leftDepth  = [BinaryTreeNode deepOfTree:rootNode.leftNode];
    NSInteger rightDepth = [BinaryTreeNode deepOfTree:rootNode.rightNode];
    return  MAX(leftDepth, rightDepth) + 1;
}

+(BOOL)isCompleteBinaryTree:(BinaryTreeNode *)rootNode{
    if(!rootNode.leftNode && !rootNode.rightNode) return YES;
    if(!rootNode.leftNode && rootNode.rightNode) return NO;
    NSMutableArray *queue = [NSMutableArray array];
    [queue addObject:rootNode];
    BOOL isComplete = NO;
    while(queue.count >0 ){
        BinaryTreeNode *node = [queue firstObject];
        [queue removeObjectAtIndex:0];
        if(!node.leftNode && node.rightNode){
            return NO;
        }
        if(isComplete && (node.leftNode || node.rightNode)){
            return NO;
        }
        if(!node.rightNode){
            isComplete = YES;
        }
        if(node.leftNode){
            [queue addObject:node.leftNode];
        }
        if(node.rightNode){
            [queue addObject:node.rightNode];
        }
    }
    return isComplete;
}

+(BOOL)isAVLBinaryTree:(BinaryTreeNode *)rootNode{
    static NSInteger height;
    if(!rootNode){
        height = 0;
        return YES;
    }
    if(!rootNode.leftNode && !rootNode.leftNode){
        height = 1;
        return YES;
    }
    BOOL isAVLLeft = [self isAVLBinaryTree:rootNode.leftNode];
    NSInteger leftHeight = height;
    BOOL isAVLRight = [self isAVLBinaryTree:rootNode.rightNode];
    NSInteger rightHeight = height;
    height = MAX(leftHeight, rightHeight)+1;
    if(isAVLLeft && isAVLRight && ABS(rightHeight - leftHeight) <= 1){
        return YES;
    }
    return NO;
}

+(NSInteger)maxDistanceOfTree:(BinaryTreeNode *)rootNode{
    if(!rootNode){
        return 0;
    }
    NSInteger distance = [self deepOfTree:rootNode.leftNode] + [self deepOfTree:rootNode.rightNode];
    NSInteger distanceRight = [self maxDistanceOfTree:rootNode.rightNode];
    NSInteger distanceLeft = [self maxDistanceOfTree:rootNode.leftNode];
    return MAX(distance, MAX(distanceRight, distanceLeft));
}

+(NSArray *)pathOfTreeNode:(BinaryTreeNode *)treeNode inTree:(BinaryTreeNode *)rootNode{
    NSMutableArray *pathArray = [NSMutableArray array];
    [self isFoundTreeNode:treeNode inTree:rootNode routePath:pathArray];
    return pathArray;
}

+(BOOL)isFoundTreeNode:(BinaryTreeNode *)treeNode inTree:(BinaryTreeNode*)rootNode routePath:(NSMutableArray *)path{
    if(!rootNode || !treeNode){
        return NO;
    }
    if(rootNode == treeNode){
        [path addObject:treeNode];
        return YES;
    }
    [path addObject:rootNode];
    BOOL find = [self isFoundTreeNode:treeNode inTree:rootNode.leftNode routePath:path];
    if(!find){
        find = [self isFoundTreeNode:treeNode inTree:rootNode.rightNode routePath:path];
    }
    if(!find){
        [path removeLastObject];
    }
    return find;
}

+(BinaryTreeNode *)parentOfNode:(BinaryTreeNode *)nodeA andNodeB:(BinaryTreeNode *)nodeB inTree:(BinaryTreeNode *) rootNode{
    if(!nodeA || !nodeB) return nil;
    if(nodeA == nodeB) return nodeA;
    NSArray *pathA = [self pathOfTreeNode:nodeA inTree:rootNode];
    NSArray *pathB = [self pathOfTreeNode:nodeB inTree:rootNode];
    
    for(NSInteger i = pathA.count -1;i>=0;i--){
        for(NSInteger j = pathB.count -1;j>=0;j--){
            if(pathA[i] == pathB[j]){
                return pathA[i];
            }
        }
    }
    return nil;
}

+(NSArray *)pathFromNode:(BinaryTreeNode *)nodeA toNode:(BinaryTreeNode *)nodeB inTree:(BinaryTreeNode *)rootNode{
    if(!rootNode || !nodeA || !nodeB){
        return nil;
    }
    NSMutableArray *path = [NSMutableArray array];
    if(nodeB == nodeA){
        [path addObject:nodeA];
        return path;
    }
    NSArray *pathA = [self pathOfTreeNode:nodeA inTree:rootNode];
    NSArray *pathB = [self pathOfTreeNode:nodeB inTree:rootNode];
    if(pathA.count == 0 || pathB.count == 0) return nil;
    for(NSInteger i = pathA.count-1;i>= 0;i--){
        [path addObject:[pathA objectAtIndex:i]];
        for(NSInteger j = pathB.count - 1;j>= 0;j--){
            if([pathA objectAtIndex:i] == [pathB objectAtIndex:j]){
                j++;
                while (j < pathB.count) {
                    [path addObject:[pathB objectAtIndex:j]];
                }
                return path;
            }
        }
    }
    return nil;
}

@end
