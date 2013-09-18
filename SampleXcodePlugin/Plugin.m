//
//  Plugin.m
//  SampleXcodePlugin
//
//  Created by Oleksiy Radyvanyuk on 9/18/13.
//  Copyright (c) 2013 Oleksiy Radyvanyuk. All rights reserved.
//

#import "Plugin.h"

@implementation Plugin {
    NSString *selectedText;
}

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];

    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (editMenuItem) {
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];

        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"Sample Plugin" action:@selector(showHello:) keyEquivalent:@"c"];
        [newMenuItem setTarget:self];
        [newMenuItem setKeyEquivalentModifierMask:NSAlternateKeyMask];
        [[editMenuItem submenu] addItem:newMenuItem];
    }
}

- (void)selectionDidChange:(NSNotification *)notification {
    if ([[notification object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)[notification object];

        NSArray *selectedRanges = [textView selectedRanges];
        if (0 == [selectedRanges count]) {
            return;
        }

        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        NSString *text = textView.textStorage.string;
        selectedText = [text substringWithRange:selectedRange];
    }
}

- (void)showHello:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:[NSString stringWithFormat:@"%@: Hello, World!", selectedText]];
    [alert runModal];
}

@end
