# ContractGuard - iOS Development Guide

## Executive Summary

ContractGuard is a native iOS app designed for small business owners, freelancers, procurement managers, and legal professionals who need to track contract expiration dates, notice periods, and auto-renewal clauses. The app solves a critical pain point: 56% of businesses miss contract deadlines monthly, and 92% of errors are human errors, often resulting in costly auto-renewals (e.g., $55K+ losses documented on Reddit).

**Key Differentiators**:
- **Notice Period Countdown**: Automatically calculates backwards from expiration to notice deadline (90/60/30 days) - the #1 requested feature competitors lack
- **AI Contract Extraction**: Uses Claude API to extract renewal terms, notice periods, and auto-renewal clauses from uploaded PDFs
- **Urgency-Based Dashboard**: Color-coded urgency levels (expired/critical/warning/caution/safe) inspired by ExSpire's Spire view
- **Native Apple Experience**: Built with SwiftUI + SwiftData + VisionKit + CloudKit for seamless Apple ecosystem integration
- **Local-First Privacy**: All data stored locally with optional iCloud sync - no server dependency

**Target Market**: United States
**Target Users**: Small business owners, freelancers, procurement managers, legal professionals
**Business Rating**: Gold (88/100)

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Contractly | Document scanning, smart notifications, dark mode, multi-language | No AI extraction, no notice period calculation, no urgency dashboard, limited to simple tracking | AI extraction + notice period countdown + urgency visualization |
| Expiration Reminder | Web+mobile sync, category filtering, attachment support | Requires web account, outdated UI (iOS 10+), 3.0 rating, no AI, no native iOS feel | No account required, modern SwiftUI, AI extraction, native notifications |
| Agreelium: AI Contract Manager | AI analysis, template library, 4.6 rating, contract creation | Focus on creation not tracking, no renewal reminders, no notice period alerts, no urgency dashboard | Focus on deadline tracking + notice periods + renewal alerts |
| Contract (Vlad UMRYKHIN) | OCR, text comparison, AI assistant, iCloud sync | Document-focused not deadline-focused, no renewal tracking, no notification system | Purpose-built for contract deadline management |
| Subscription-Reminder Tracker | Apple ecosystem sync, spending charts, privacy-focused | Only tracks subscriptions not contracts, no document upload, no AI, no notice periods | Full contract lifecycle + AI extraction + document management |

## Apple Design Guidelines Compliance

- **Navigation**: Tab-based navigation with sidebar adaptation for iPad, following HIG Navigation Patterns
- **Color System**: Uses semantic colors with urgency-based color coding that adapts to light/dark mode
- **Typography**: SF Pro system font with Dynamic Type support for accessibility
- **Haptics**: UIImpactFeedbackGenerator for urgency state changes
- **Notifications**: UserNotifications framework with time-sensitive notification support
- **Privacy**: Local-first data storage, optional CloudKit sync, no third-party analytics
- **Accessibility**: VoiceOver labels, Dynamic Type, high contrast support
- **iPad**: Regular width layout with sidebar navigation, max content width 720pt

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (VisionKit document scanning)
- **Data**: SwiftData with optional CloudKit sync
- **Document Scanning**: VisionKit (VNDocumentCameraViewController)
- **PDF Processing**: PDFKit for rendering and text extraction
- **OCR**: Vision Framework (VNRecognizeTextRequest) for offline text recognition
- **AI Extraction**: Claude API (Anthropic) for contract clause extraction
- **Notifications**: UserNotifications + Background Tasks for multi-timepoint reminders
- **Calendar**: EventKit integration for syncing deadlines to Apple Calendar
- **Cloud Sync**: CloudKit via SwiftData container

## Module Structure

```
ContractGuard/
├── ContractGuardApp.swift
├── Views/
│   ├── Dashboard/
│   │   ├── DashboardView.swift
│   │   ├── ContractCardView.swift
│   │   └── UrgencyFilterView.swift
│   ├── ContractDetail/
│   │   ├── ContractDetailView.swift
│   │   ├── ContractFormView.swift
│   │   └── DocumentViewer.swift
│   ├── Scanner/
│   │   └── DocumentScannerView.swift
│   ├── Calendar/
│   │   └── CalendarView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── ContactSupportView.swift
│   │   └── PaywallView.swift
│   └── Components/
│       ├── UrgencyBadge.swift
│       ├── CountdownView.swift
│       └── SearchBar.swift
├── Models/
│   ├── Contract.swift
│   ├── ContractReminder.swift
│   ├── ExtractedClause.swift
│   └── Enums.swift
├── ViewModels/
│   ├── DashboardViewModel.swift
│   ├── ContractFormViewModel.swift
│   ├── ScannerViewModel.swift
│   └── SettingsViewModel.swift
├── Services/
│   ├── NotificationService.swift
│   ├── AIExtractionService.swift
│   ├── OCRService.swift
│   ├── CalendarService.swift
│   └── PurchaseManager.swift
└── Utilities/
    ├── DateExtensions.swift
    └── ColorExtensions.swift
```

## Implementation Flow

1. Set up SwiftData models (Contract, ContractReminder, ExtractedClause)
2. Build Dashboard view with urgency-based sorting and filtering
3. Implement Contract CRUD (Create, Read, Update, Delete) with form validation
4. Add VisionKit document scanning integration
5. Implement PDFKit document viewer with text extraction
6. Build Vision OCR service for offline text recognition
7. Integrate Claude API for AI contract clause extraction
8. Implement UserNotifications with multi-timepoint reminders (90/60/30/7/1 days)
9. Add EventKit calendar integration
10. Build Settings with iCloud sync toggle, notification preferences
11. Implement StoreKit 2 subscription management
12. Add Contact Support with feedback backend
13. Create Paywall view for subscription conversion
14. Test on iPhone and iPad simulators
15. Polish UI animations and haptics

## UI/UX Design Specifications

- **Color Scheme**:
  - Primary: #007AFF (iOS Blue)
  - Safe: #34C759 (Green)
  - Caution: #FFCC00 (Yellow)
  - Warning: #FF9500 (Orange)
  - Critical: #FF3B30 (Red)
  - Expired: #8E8E93 (Gray)
  - Background: System backgrounds (adaptive light/dark)

- **Typography**: SF Pro, Dynamic Type compliant
  - Title: .largeTitle
  - Section Header: .title2
  - Body: .body
  - Caption: .caption

- **Layout**:
  - Tab Bar: Dashboard, Add Contract, Calendar, Settings
  - Dashboard: LazyVGrid with contract cards sorted by urgency
  - iPad: SidebarAdaptive navigation with detail pane
  - Content max width: 720pt on iPad
  - Card corner radius: 12pt
  - Standard padding: 16pt

- **Animations**:
  - Card appear: .spring(duration: 0.4, bounce: 0.2)
  - Urgency pulse: .easeInOut repeating for critical items
  - Tab transition: .slide
  - Delete: .slide with opacity fade

## Code Generation Rules

- Single responsibility: One feature per module
- MVVM pattern with @Observable ViewModels
- SwiftData for persistence with @Model classes
- All SwiftData attributes must be optional or have default values
- All SwiftData relationships must have inverse relationships
- No comments in code unless explicitly requested
- Use Apple native frameworks first
- Local-first architecture with optional CloudKit sync
- iPad layout must use .frame(maxWidth: 720).frame(maxWidth: .infinity) for ScrollView content

## Build & Deployment Checklist

- [ ] Verify Bundle ID: com.zzoutuo.ContractGuard
- [ ] Verify Deployment Target: iOS 17.0
- [ ] Configure App Icon in Asset Catalog
- [ ] Enable Push Notifications capability
- [ ] Enable iCloud (CloudKit) capability
- [ ] Create StoreKit Configuration file for IAP testing
- [ ] Add NSCameraUsageDescription for document scanning
- [ ] Add NSPhotoLibraryUsageDescription for document import
- [ ] Test on iPhone XS Max simulator
- [ ] Test on iPad Pro 13-inch (M4) simulator
- [ ] Push to GitHub repository
- [ ] Deploy policy pages to GitHub Pages
- [ ] Create App Store Connect metadata
