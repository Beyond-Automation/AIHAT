# AIHAT

> AI Infrastructure Health Audit Toolkit

![Status](https://img.shields.io/badge/Status-In%20Development-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-7+-5391FE)
![License](https://img.shields.io/badge/License-MIT-green)

---

## About

AIHAT is an open-source PowerShell toolkit built for Windows System Administrators.

Its purpose is simple:

**Help administrators determine whether a Windows computer is healthy in under five minutes.**

Instead of collecting information manually, AIHAT gathers health data, identifies issues, and provides clear recommendations.

---

## Planned Features

- System Health
- Windows Updates
- Defender Status
- BitLocker Status
- Network Configuration
- Service Health
- Event Log Analysis
- Health Score

---

## HTML Reporting

Every run of `Invoke-AIHAT` generates a self-contained HTML report summarizing the health audit — executive summary, System Health, Windows Update Health, and execution details, styled with embedded CSS (no external assets required).

- **Output directory**: `Reports\` (created automatically if it doesn't exist)
- **Filename pattern**: `AIHAT_yyyy-MM-dd_HHmmss.html`
- **Result property**: when run with `-PassThru`, the returned result object includes `ReportFilePath`, the full path to the generated report. If report generation fails, the run continues and `ReportFilePath` is `$null`.

### Example

```powershell
. .\src\Invoke-AIHAT.ps1

$result = Invoke-AIHAT -PassThru

$result.ReportFilePath
# C:\AIHAT\Reports\AIHAT_2026-07-18_134441.html
```

---

## Known Limitations

- **Dashboard in non-interactive hosts**: `Show-AIHATDashboard` calls `Clear-Host`, which sets the console cursor position. In non-interactive or redirected PowerShell hosts (e.g. some CI runners or automation hosts without a real console handle), this can raise a non-terminating `SetValueInvocationException` ("The handle is invalid."). The dashboard output still renders correctly afterward, and the run itself is unaffected — this is a display-only limitation and is tracked separately from the HTML Reporting Engine.

---

## Project Status

🚧 Sprint 1

Building the project foundation.

---

## Built By

Beyond Automation

Engineering Smarter IT Operations.
