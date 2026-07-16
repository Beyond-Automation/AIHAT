# AIHAT Architecture

## High-Level Flow

```text
Invoke-AIHAT
      │
      ▼
Load Configuration
      │
      ▼
Initialize Logging
      │
      ▼
Execute Modules
      │
      ├── Get-SystemHealth
      ├── Get-WindowsUpdateHealth
      ├── Get-DefenderHealth
      ├── Get-DiskHealth
      ├── Get-NetworkHealth
      └── Get-ServiceHealth
      │
      ▼
Aggregate Results
      │
      ▼
Generate Output
      │
      ├── Console
      ├── JSON
      └── HTML (planned)
```

## Project Structure

```text
AIHAT
├── Logs
├── src
│   ├── Core
│   ├── Modules
│   └── Reports
├── docs (planned)
├── tests (planned)
├── ROADMAP.md
├── PROJECT.md
└── ARCHITECTURE.md
```

## Design Principles

- Single Responsibility
- Modular
- Reusable
- Testable
- Enterprise Ready
- AI Friendly