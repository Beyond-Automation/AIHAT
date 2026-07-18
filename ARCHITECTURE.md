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
      ├── Console (Show-AIHATDashboard)
      ├── JSON (planned)
      └── HTML (New-AIHATReport)
```

## Reporting Engine

`New-AIHATReport` (`src/Core/New-AIHATReport.ps1`) consumes the completed result object and produces a timestamped, self-contained HTML report (`Reports\AIHAT_yyyy-MM-dd_HHmmss.html`, embedded CSS, HTML-encoded dynamic values). `Invoke-AIHAT` calls it after aggregating results and before displaying the console dashboard; failure is non-fatal — it is logged as an `ERROR` and the run continues with `ReportFilePath` left as `$null`.

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