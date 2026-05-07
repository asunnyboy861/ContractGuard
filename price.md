# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: ContractGuard Premium
- **Group ID**: Auto-generated

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Premium
- **Product ID**: `com.zzoutuo.ContractGuard.monthly`
- **Price**: $4.99 per month
- **Display Name**: ContractGuard Monthly
- **Description**: Full access to AI extraction and reminders
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Premium
- **Product ID**: `com.zzoutuo.ContractGuard.yearly`
- **Price**: $29.99 per year (50% savings vs monthly)
- **Display Name**: ContractGuard Yearly
- **Description**: Best value - save 50% with annual plan
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.ContractGuard.lifetime`
- **Price**: $79.99 one-time
- **Display Name**: ContractGuard Lifetime
- **Description**: One-time purchase, yours forever
- **Note**: Available since AI API costs are per-use and can be managed

## Free Tier
- Track up to 3 contracts
- Basic push notifications (7-day and 1-day before)
- Manual contract entry
- No AI extraction
- No document scanning

## Premium Features
- Unlimited contract tracking
- AI contract clause extraction (Claude API)
- Document scanning (VisionKit)
- Multi-timepoint reminders (90/60/30/7/1 days)
- Calendar integration (EventKit)
- iCloud sync across devices
- Priority support

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to paid monthly)

## Policy Pages Required
- Support Page: ✅ (Must include subscription management info)
- Privacy Policy: ✅
- Terms of Use: ✅ (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented
