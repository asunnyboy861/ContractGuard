# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | ContractGuard |
| **Git URL** | git@github.com:asunnyboy861/ContractGuard.git |
| **Repo URL** | https://github.com/asunnyboy861/ContractGuard |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/ContractGuard/ | ✅ Active |
| Support | https://asunnyboy861.github.io/ContractGuard/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/ContractGuard/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/ContractGuard/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

```
ContractGuard/
├── ContractGuard/                           # iOS App Source Code
│   ├── ContractGuard.xcodeproj/             # Xcode Project
│   ├── ContractGuard/                       # Swift Source Files
│   │   ├── Views/
│   │   │   ├── Dashboard/
│   │   │   ├── ContractDetail/
│   │   │   ├── Calendar/
│   │   │   ├── Scanner/
│   │   │   ├── Settings/
│   │   │   └── Components/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── ViewModels/
│   │   └── Utilities/
│   └── ...
├── docs/                         # Policy Pages (GitHub Pages source)
│   ├── index.html               # Landing Page
│   ├── support.html             # Support Page
│   ├── privacy.html             # Privacy Policy
│   └── terms.html               # Terms of Use
├── .github/workflows/
│   └── deploy.yml               # GitHub Pages deployment
├── us.md                         # English Development Guide
├── keytext.md                    # App Store Metadata
├── capabilities.md               # Capabilities Configuration
├── icon.md                       # App Icon Details
├── price.md                      # Pricing Configuration
└── nowgit.md                     # This File
```
