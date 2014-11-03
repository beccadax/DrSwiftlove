//
//  NPKUndoableObject.m
//  Typesetter
//
//  Created by Brent Royal-Gordon on 12/19/11.
//  Copyright (c) 2011 Groundbreaking Software LLC. All rights reserved.
//

#import "NPKUndoableObject.h"

static void * const KVO = (void*)&KVO;

@implementation NPKUndoableObject

@dynamic undoManager;

+ (NSSet *)keyPathsForUndoRegistration {
    return [NSSet set];
}

- (instancetype)init {
    if((self = [super init])) {
        for(NSString * keyPath in [[self class] keyPathsForUndoRegistration]) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionPrior context:KVO];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != KVO) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
        [self willChangeUndoableKeyPath:keyPath];
    }
    else {
        [self didChangeUndoableKeyPath:keyPath];
    }
}

- (void)willChangeUndoableKeyPath:(NSString*)keyPath {
    [[self.undoManager prepareWithInvocationTarget:self] setValue:[self valueForKey:keyPath] forKeyPath:keyPath];
}

- (void)didChangeUndoableKeyPath:(NSString*)keyPath {
    
}

- (void)dealloc {
    [self.undoManager removeAllActionsWithTarget:self];
    
    for(NSString * keyPath in [[self class] keyPathsForUndoRegistration]) {
        [self removeObserver:self forKeyPath:keyPath context:KVO];
    }
}

@end
