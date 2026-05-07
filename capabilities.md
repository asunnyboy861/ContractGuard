# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- Contract document scanning (VisionKit) -> Camera access required
- Document import from photo library -> Photo Library access required
- Push notifications for contract reminders -> Push Notifications capability
- iCloud sync for multi-device -> iCloud (CloudKit) capability
- Background notification scheduling -> Background Modes
- Calendar integration -> EventKit
- Subscription IAP -> StoreKit

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Push Notifications | ✅ Configured | Xcode project settings |
| Background Modes | ✅ Configured | Xcode project settings |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| iCloud (CloudKit) | ⏳ Pending | 1. Open Xcode > Signing & Capabilities > + Capability > iCloud 2. Check CloudKit 3. Create container: iCloud.com.zzoutuo.ContractGuard |
| Camera Access | ⏳ Pending | NSCameraUsageDescription added to Info.plist automatically by VisionKit |
| Photo Library Access | ⏳ Pending | NSPhotoLibraryUsageDescription added to Info.plist |
| EventKit | ⏳ Pending | No special capability needed, just import EventKit |

## No Configuration Needed
- StoreKit 2: No capability needed, just import StoreKit framework
- Vision Framework: Built-in, no capability needed
- PDFKit: Built-in, no capability needed
- UserNotifications: Built-in, no capability needed

## Verification
- Build succeeded after configuration: ✅
- All entitlements correct: ⏳ (Pending iCloud manual setup)
