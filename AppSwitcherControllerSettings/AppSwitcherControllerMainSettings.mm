#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

//typedef enum {
//	None					= 0,
//	RestartRenderServer		= (1 << 0), // 1 in decimal, also relaunch backboardd
//	SnapshotTransition		= (1 << 1), // 2 in decimal
//	FadeToBlackTransition	= (1 << 2), // 4 in decimal
//} SBSRelaunchActionStyle;

NSString *const domainString = @"com.tomaszpoliszuk.appswitchercontroller";

@interface BSAction : NSObject
@end
@interface SBSRelaunchAction : BSAction
+ (id)actionWithReason:(id)arg1 options:(unsigned long long)arg2 targetURL:(id)arg3;
@end

@interface FBSSystemService : NSObject
+ (id)sharedService;
- (void)sendActions:(id)arg1 withResult:(id /* block */)arg2;
@end

@interface AppSwitcherControllerMainSettings : PSListController
@end

@implementation AppSwitcherControllerMainSettings
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}
- (instancetype)init {
	self = [super init];
	if (self) {
		UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respringDevice)];
		self.navigationItem.rightBarButtonItem = applyButton;
	}
	return self;
}
- (void)loadView {
	[super loadView];
	((UITableView *)[self table]).keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}
-(void)respringDevice {
	UIAlertController *confirmRespringAlert = [UIAlertController alertControllerWithTitle:@"Respring Device" message:@"Do you want to respring device?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		SBSRelaunchAction *respringAction = [NSClassFromString(@"SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:4 targetURL:[NSURL URLWithString:@"prefs:root=App%20Switcher%20Controller"]];
		FBSSystemService *frontBoardService = [NSClassFromString(@"FBSSystemService") sharedService];
		NSSet *actions = [NSSet setWithObject:respringAction];
		[frontBoardService sendActions:actions withResult:nil];
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[confirmRespringAlert addAction:cancel];
	[confirmRespringAlert addAction:confirm];
	[self presentViewController:confirmRespringAlert animated:YES completion:nil];
}
- (void)resetSettings {
	NSUserDefaults *tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:domainString];
	UIAlertController *resetSettingsAlert = [UIAlertController alertControllerWithTitle:@"Reset App Switcher Controller Settings" message:@"Do you want to reset settings?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		for(NSString* key in [[tweakSettings dictionaryRepresentation] allKeys]) {
			[tweakSettings removeObjectForKey:key];
		}
		[tweakSettings synchronize];
		[self reloadSpecifiers];
		[self respringDevice];
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[resetSettingsAlert addAction:cancel];
	[resetSettingsAlert addAction:confirm];
	[self presentViewController:resetSettingsAlert animated:YES completion:nil];
}
-(void)sourceCode {
	NSURL *sourceCode = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/AppSwitcherController"];
	[[UIApplication sharedApplication] openURL:sourceCode options:@{} completionHandler:nil];
}
-(void)knownIssues {
	NSURL *knownIssues = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/AppSwitcherController/issues"];
	[[UIApplication sharedApplication] openURL:knownIssues options:@{} completionHandler:nil];
}
-(void)TomaszPoliszukAtBigBoss {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *tweakName = @"App+Switcher+Controller";
	NSURL *twitterWebsite = [NSURL URLWithString:[@"http://apt.thebigboss.org/developer-packages.php?name=" stringByAppendingString:tweakName]];
	[application openURL:twitterWebsite options:@{} completionHandler:nil];
}
-(void)TomaszPoliszukAtGithub {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *githubWebsite = [NSURL URLWithString:[@"https://github.com/" stringByAppendingString:username]];
	[application openURL:githubWebsite options:@{} completionHandler:nil];
}
-(void)TomaszPoliszukAtTwitter {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *twitterWebsite = [NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:username]];
	[application openURL:twitterWebsite options:@{} completionHandler:nil];
}
@end
