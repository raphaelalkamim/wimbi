# Wimbi — Architecture Reference

## Overview

**Wimbi** (Xcode target: `macroChallengeApp`) is a native iOS travel itinerary planner. Users create roadmaps (trips), add daily activities, browse public roadmaps from other users, and interact via likes.

- Platform: iOS (native Swift + UIKit — **no SwiftUI anywhere in the codebase**)
- Localization: Portuguese Brazil (`pt-BR`) and Spanish Latin America (`es-419`)

## Tech Stack

| Area | Choice |
|---|---|
| Language | Swift |
| UI | UIKit — programmatic layout via SnapKit (SPM requirement: 5.6.0+, resolved: 5.7.1) |
| Dependency manager | Swift Package Manager |
| Backend | REST — `https://macroptrip-api.herokuapp.com/` |
| Images / Analytics | Firebase Storage + Firebase Analytics |
| Local persistence | Core Data (SQLite) |
| Simple preferences | UserDefaults via `UserDefaultManager` |
| Auth secrets | Keychain via `KeychainManager` |

## Architecture

### Navigation — Coordinator Pattern

Four coordinators manage navigation stacks; each owns a `UINavigationController` and instantiates/pushes its own ViewControllers:

- `ExploreCoordinator` — browse and search public roadmaps
- `CurrentCoordinator` — active trip view and detail screens
- `ProfileCoordinator` — user profile and settings
- `NewRoadmapCoordinator` — multi-step roadmap creation/editing

New screens must be wired into the relevant coordinator — do **not** present or push from a ViewController directly.

### Presentation — MVVM-adjacent

Each flow folder contains a ViewController (UIKit), a View (layout), and optionally a ViewModel (business/data logic). Example: `WeatherViewModel` fetches WeatherKit data; the ViewController observes it.

### Data Layer

**REST — `DataManager.shared`**
Single entry point for all network calls. Split into extensions by domain:
- `DataManager+Roadmaps.swift`
- `DataManager+Days.swift`
- `DataManager+Activity.swift`
- `DataManager+User.swift`
- `DataManager+Likes.swift`

Never call `URLSession` directly from a ViewController. Add new endpoints as a new extension or inside the matching existing one.

**Core Data — Repository singletons**
- `RoadmapRepository.shared`
- `UserRepository.shared`
- `ActivityRepository.shared`
- `DayRepository.shared`

Never write to the Core Data context directly from a ViewController. Always go through the repository.

**DTO pattern**
API responses → DTOs (`RoadmapDTO`, `DayDTO`) → local models (`Roadmaps`, `Day`) → Core Data entities (`RoadmapLocal`, `DayLocal`). Conversion happens inside the repository layer.

### Design System

All colors, typography, spacing, and images are centralised:

| Token file | What it owns |
|---|---|
| `DesignPalette` | Colors |
| `DesignSpacing` | Padding / margin constants |
| `DesignText` | Font styles |
| `DesignImages` / `DesignImagesActivities` / `DesignImagesWeather` | Image assets |

Access via `DefaultDesignSystem.shared`. Never hardcode hex values or raw point sizes in views.

## Folder Structure

```
macroChallengeApp/macroChallengeApp/
├── Delegates/            # AppDelegate (Firebase init), SceneDelegate, NotificationManager
├── Coordinator/          # Coordinator protocol + 4 feature coordinators
├── Flows/                # Feature screens, one folder per flow
│   ├── Current/          #   ViewController/, View/, ViewModel/, UIViewCell/, Extensions/
│   ├── Explore/
│   ├── Profile/
│   ├── NewRoadmap/
│   ├── NewActivity/
│   ├── Login/            #   SignInWithAppleManager, KeychainManager, LoginViewController
│   └── TabBar/
├── Controller/           # DataManager + FirebaseManager + NetworkMonitor + UserDefaultManager
│   └── DataManager/      # Domain extensions (+Roadmaps, +Days, +Activity, +User, +Likes)
├── CoreData/
│   ├── Class/            # Repository class implementations
│   └── Propierties/      # Entity property definitions
├── Models/               # Codable structs: API models + DTOs
├── DesignSystem/         # Protocols/, Implementations/, token files
├── Components/           # Reusable UIKit components (Alerts, ImagePickerButton, etc.)
├── Extensions/           # Swift type extensions
└── Localization/         # .lproj string tables

WimbWidget/               # iOS widget extension — countdown + empty state views
```

## Authentication

1. **Sign in with Apple** — `SignInWithAppleManager` in `Flows/Login/`
2. JWT returned from `/login` stored in `UserDefaults` key `"authorization"`; injected as `Authorization` header on every request inside `DataManager`
3. Sensitive data (Apple credential) stored in Keychain via `KeychainManager.shared`
4. Session state: `UserDefaults.standard.bool(forKey: "isUserLoggedIn")`

## Environment & Configuration

- **Production API**: `https://macroptrip-api.herokuapp.com/`
- **Dev API** (commented out in `DataManager.swift`): `https://macrotrip-dev.herokuapp.com/`
- No `.env` files — switch the base URL constant in `DataManager.swift` manually when targeting dev
- Firebase config: `GoogleService-Info.plist` (Firebase project `wimbi-a3243`, Storage bucket `wimbi-a3243.appspot.com`)
- External currency API: `https://economia.awesomeapi.com.br/last/{currency}` (called from `CurrencyController`)

## External Integrations

| Integration | Where |
|---|---|
| WeatherKit (iOS 16+) | `Flows/Current/ViewModel/WeatherViewModel.swift` |
| Firebase Analytics | `FirebaseManager.shared.createAnalyticsEvent()` |
| Firebase Storage | `FirebaseManager.shared` (roadmap covers, profile photos) |
| Waze / Google Maps deep links | URL schemes declared in `Info.plist` |
| Push notifications | `NotificationManager` + Firebase Cloud Messaging |
| iOS Widgets | `WimbWidget/` target, shares data via App Group `group.wimbiApp` |

## Conventions

- All new screens use **UIKit + SnapKit** — do not introduce SwiftUI.
- New feature screens belong in a **`Flows/<FeatureName>/`** folder and must be wired through a coordinator.
- All REST calls go through **`DataManager` extensions** — no direct `URLSession` in ViewControllers.
- All Core Data reads/writes go through **Repository singletons**.
- All styling uses **`DefaultDesignSystem.shared`** — no hardcoded colors or font sizes.
- Firebase Analytics events go through **`FirebaseManager.shared.createAnalyticsEvent()`**.
- **SwiftLint** runs on every build. Fix all enabled-rule warnings before opening a PR. Rules are configured in `macroChallengeApp/.swiftlint.yml`.
- PRs must follow the checklist in `.github/pull_request_template.md` (update from dev, SwiftLint clean, issue linked, board updated).

## Testing

- Framework: XCTest
- Tests are currently stub-only (`macroChallengeAppTests/`, `macroChallengeAppUITests/`) — no meaningful coverage
- No CI/CD pipelines — all validation is manual via the PR checklist
