# AIHAT

> AI Infrastructure Health Audit Toolkit

![PowerShell](https://img.shields.io/badge/PowerShell-7+-5391FE)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-In%20Development-blue)
![CI](https://github.com/Beyond-Automation/AIHAT/actions/workflows/powershell-ci.yml/badge.svg)

---

> **Project Status**
>
> AIHAT is an actively developed open-source project focused on Windows infrastructure health auditing.
>
> Current Highlights:
> - ✅ Modular PowerShell architecture
> - ✅ HTML reporting
> - ✅ Automated testing with Pester
> - ✅ Static analysis with PSScriptAnalyzer
> - 🚧 Additional health modules under active development

---

## What is AIHAT?

**Help administrators determine whether a Windows computer is healthy in under five minutes.**

AIHAT is an open-source PowerShell toolkit built for Windows System Administrators. Instead of collecting information manually, it gathers health data, identifies issues, and provides clear recommendations.

Under the hood, `Invoke-AIHAT` loads a configuration, runs a set of independent health-collection modules (System Health, Windows Update Health, and more as they land), aggregates the results into a single object, and produces both a live console dashboard and a timestamped HTML report — all from one command.

---

## Why AIHAT?

Checking whether a Windows machine is healthy usually means running the same handful of commands by hand every time: uptime, disk space, memory pressure, Windows Update status, pending reboots. It's repetitive, easy to skip under pressure, and hard to hand off consistently across a team.

AIHAT exists so infrastructure engineers and system administrators can run one command, get a consistent audit every time, and walk away with both an at-a-glance console view and a shareable HTML report — without writing ad hoc scripts per engagement.

---

## Why I Built AIHAT

As an Infrastructure Engineer, I wanted a repeatable way to assess Windows system health instead of relying on a different ad hoc checklist every time. AIHAT is my answer: a modular PowerShell toolkit that standardizes the audit, while also serving as a demonstration of modern engineering practices — modular design, automated testing, static analysis, and clear documentation — applied to a real infrastructure problem.

---

## Engineering Principles

- Modular PowerShell architecture
- Test-driven validation with Pester
- Static analysis using PSScriptAnalyzer
- Clear documentation
- Git-based development workflow
- AI-assisted development with human review

---

## Table of Contents

- [Why I Built AIHAT](#why-i-built-aihat)
- [Engineering Principles](#engineering-principles)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Example Output](#example-output)
- [HTML Reporting](#html-reporting)
- [Documentation](#documentation)
- [Project Goals](#project-goals)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Security](#security)
- [Known Limitations](#known-limitations)
- [Built By](#built-by)

---

## Features

### ✅ Implemented

- System Health (OS, uptime, CPU, memory, disk)
- Windows Update Health (service status, pending reboot, last installed update, WSUS policy)
- Console Dashboard
- HTML Reporting
- Logging
- Modular Architecture
- Pester Tests
- PSScriptAnalyzer Validation

### 🗺 Planned

- JSON Reporting
- Defender Health
- BitLocker
- Network Health
- Service Health
- Event Logs
- Health Scoring

---

## Requirements

- Windows
- PowerShell 7+
- Administrator privileges recommended (some health checks read protected registry keys and services)
- Git

---

## Installation

```powershell
git clone https://github.com/Beyond-Automation/AIHAT.git
cd AIHAT
```

Load the entry point function into your session:

```powershell
. .\src\Invoke-AIHAT.ps1
```

---

## Quick Start

```powershell
$result = Invoke-AIHAT -PassThru
```

This runs a full health audit, displays the console dashboard, and returns the aggregated result object.

- **Logs** are written to `Logs\AIHAT_<timestamp>.log` in the project root.
- **HTML reports** are written to `Reports\AIHAT_<timestamp>.html` in the project root (see [HTML Reporting](#html-reporting)).

```powershell
$result.ReportFilePath
# C:\AIHAT\Reports\AIHAT_2026-07-18_134441.html
```

---

## Example Output

### Console Dashboard

> Screenshot coming soon

### HTML Report

> Screenshot coming soon

---

## HTML Reporting

Every run of `Invoke-AIHAT` generates a self-contained HTML report summarizing the health audit — executive summary, System Health, Windows Update Health, and execution details — styled with embedded CSS (no external assets required).

| | |
|---|---|
| **Output directory** | `Reports\` (created automatically if it doesn't exist) |
| **Filename pattern** | `AIHAT_yyyy-MM-dd_HHmmss.html` |
| **Result property** | `-PassThru` returns `ReportFilePath`, the full path to the generated report. If report generation fails, the run continues and `ReportFilePath` is `$null`. |

```powershell
. .\src\Invoke-AIHAT.ps1

$result = Invoke-AIHAT -PassThru

$result.ReportFilePath
# C:\AIHAT\Reports\AIHAT_2026-07-18_134441.html
```

---

## Documentation

| Document | Purpose |
|---|---|
| [README.md](README.md) | Project overview, installation, and usage |
| [ARCHITECTURE.md](ARCHITECTURE.md) | System design, execution flow, and project structure |
| [ROADMAP.md](ROADMAP.md) | Version history and planned work |
| [PROJECT.md](PROJECT.md) | Project background and objectives |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute |
| [SECURITY.md](SECURITY.md) | Vulnerability reporting policy |

---

## Project Goals

- Professional PowerShell engineering
- Modular architecture
- Automated testing
- Infrastructure health auditing
- AI-assisted development with human review

---

## Roadmap

AIHAT is progressing through its foundation and core-engine milestones: configuration, execution engine, System Health, Windows Update Health, console dashboard, and HTML reporting are complete. Upcoming work covers the remaining health modules (Defender, BitLocker, Network, Services, Event Logs), a health score, and additional export formats.

See [ROADMAP.md](ROADMAP.md) for the full version-by-version breakdown.

---

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md) before submitting a pull request.

Before opening a PR, run the full validation suite locally:

```powershell
Invoke-ScriptAnalyzer -Path ./src -Recurse -Settings ./PSScriptAnalyzerSettings.psd1 -Severity Error,Warning
Invoke-Pester -Path ./tests
```

---

## Security

To report a vulnerability, see [SECURITY.md](SECURITY.md).

---

## Known Limitations

- **Dashboard in non-interactive hosts**: `Show-AIHATDashboard` calls `Clear-Host`, which sets the console cursor position. In non-interactive or redirected PowerShell hosts (e.g. some CI runners or automation hosts without a real console handle), this can raise a non-terminating `SetValueInvocationException` ("The handle is invalid."). The dashboard output still renders correctly afterward, and the run itself is unaffected — this is a display-only limitation.

---

## Built By

Beyond Automation

Engineering Smarter IT Operations.
