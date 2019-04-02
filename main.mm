@interface AppWirelessDataUsageManager
+(void)setAppCellularDataEnabled:(id)arg1 forBundleIdentifier:(id)arg2 completionHandler:(/*^block*/id)arg3 ;
+(void)setAppWirelessDataOption:(id)arg1 forBundleIdentifier:(id)arg2 completionHandler:(/*^block*/id)arg3 ;
@end

@interface PSAppDataUsagePolicyCache
+ (id)sharedInstance;
- (bool)setUsagePoliciesForBundle:(id)arg1 cellular:(bool)arg2 wifi:(bool)arg3;
@end

void bypassDataPermissions(NSString *bundleId) {
	float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	NSLog(@"当前系统版本：%.1f", systemVersion);
	NSLog(@"Bundle ID: %@", bundleId);
	if(systemVersion < 12.0f)
	{
		[NSClassFromString(@"AppWirelessDataUsageManager") setAppWirelessDataOption:[NSNumber numberWithInt:3] 
										forBundleIdentifier:bundleId completionHandler:nil];
		[NSClassFromString(@"AppWirelessDataUsageManager") setAppCellularDataEnabled:[NSNumber numberWithInt:1] 
										forBundleIdentifier:bundleId completionHandler:nil];
	} else {
		[[NSClassFromString(@"PSAppDataUsagePolicyCache") sharedInstance] setUsagePoliciesForBundle:bundleId cellular:true wifi:true];
	}
	NSLog(@"权限修复成功");
}

int main(int argc, char **argv, char **envp) {
	if(argc > 2)
	{
		printf("usage: %s com.example.bundleid\n", argv[0]);
		return -1;
	} else if(argc == 1)
	{
		bypassDataPermissions(@"devs.nactro.achelper");
	} else {
		NSString *bundleId = [NSString stringWithFormat:@"%s", argv[1]];
		if ([[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MobileContainerManager.framework"] load]) {
			id contentApp = [NSClassFromString(@"MCMAppDataContainer") performSelector:@selector(containerWithIdentifier:error:) withObject:bundleId withObject:nil];
			if(contentApp == nil)
			{
				printf("Cannot found bundle id: %s\n", argv[1]);
				return -1;
			} else
				bypassDataPermissions(bundleId);
		}
	}
	return 0;
}

// vim:ft=objc
