# AIHAT Project Board

## Current Sprint

**Sprint 3 – Core Engine**

---

## Completed Features

| ID | Feature | Status |
|----|---------|--------|
| AIHAT-001 | Get-SystemHealth | ✅ |
| AIHAT-002 | Logging Engine | ✅ |

---

## Current Work

| ID | Feature | Status |
|----|---------|--------|
| AIHAT-003 | Configuration Engine | 🚧 |
| AIHAT-004 | Invoke-AIHAT | Planned |

---

## Backlog

- Windows Update Health
- Microsoft Defender Health
- Disk Health
- Network Health
- Services Health
- Event Log Health
- BitLocker Health

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

---

## Next Sprint Goal

Build the AIHAT Engine.