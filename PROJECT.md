# AIHAT Project Board

## Current Status

**Preparing release v0.4.0** — feature-complete for this milestone; validating and finalizing documentation ahead of tagging.

---

## Completed Features

| ID | Feature | Status |
|----|---------|--------|
| AIHAT-001 | Get-SystemHealth | ✅ |
| AIHAT-002 | Logging Engine | ✅ |
| AIHAT-003 | Configuration Engine & Invoke-AIHAT (Execution Engine) | ✅ |
| AIHAT-005 | Windows Update Health | ✅ |
| AIHAT-006 | Console Dashboard | ✅ |
| AIHAT-007 | Security & Community Standards | ✅ |
| AIHAT-008 | PowerShell CI Workflow | ✅ |
| AIHAT-009 | HTML Reporting Engine | ✅ |

> Note: AIHAT-004 (`Invoke-AIHAT`) shipped as part of AIHAT-003 alongside the configuration engine rather than as a separate change.

---

## Current Work

| ID | Feature | Status |
|----|---------|--------|
| — | Release preparation for v0.4.0 (versioning, docs accuracy, validation) | 🚧 |

---

## Backlog

- Microsoft Defender Health
- BitLocker Health
- Network Health
- Service Health
- Event Log Health
- Health Score
- JSON / CSV Export

---

## Engineering Decisions

### ED-001
AIHAT uses a modular architecture.

### ED-002
Each execution creates its own timestamped log.

### ED-003
PowerShell is the primary development interface.

### ED-004
Every module returns a PowerShell object.

### ED-005
HTML report generation failures are logged but non-fatal — `Invoke-AIHAT` continues and leaves `ReportFilePath` as `$null` rather than aborting the run.

---

## Validation Status

- PSScriptAnalyzer: 0 issues (`src/`, `tests/`, Error/Warning severity)
- Pester: 11/11 tests passing
- End-to-end execution verified on a live Windows host

---

## Next Milestone Goal

Expand health coverage (Defender, BitLocker, Network, Services, Event Logs) and introduce a composite Health Score.
