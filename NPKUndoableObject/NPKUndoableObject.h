//
//  NPKUndoableObject.h
//  Typesetter
//
//  Created by Brent Royal-Gordon on 12/19/11.
//  Copyright (c) 2011 Groundbreaking Software LLC. All rights reserved.
//

@interface NPKUndoableObject: NSObject

/// Subclasses *must* call -[NPKObject init] in all circumstances, even if they plan to throw away self and return a different instance.
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// Returns key paths whose changes should be automatically registered with the object's undo manager. Subclasses should override this and return a set of NSString key paths.
+ (NSSet*)keyPathsForUndoRegistration;

/// Returns the undo manager to be used for automatic change registration.
/// 
/// This is an abstract property. Subclasses *must* override or synthesize it.
@property (nonatomic, readonly, strong) NSUndoManager *undoManager;

/// Called immediately before an undoable key path changes. Can be overridden, but you must call super.
- (void)willChangeUndoableKeyPath:(NSString*)keyPath;
/// Called immediately after an undoable key path changes. Can be overridden, but you must call super.
- (void)didChangeUndoableKeyPath:(NSString*)keyPath;

@end
