# Release Recovery, Rollback Procedures & Incident Response Plan

**Monster Lab: Release Engineering & Distribution Runbook**  
*Document Version:* 1.0.0  
*Applicability:* GitHub Releases, Android APK/AAB, Linux APT Repository, Windows Installers, Web Docker Images  
*Incident Severity:* P0 Release Blocker / Hotfix Rollback

---

## 1. Overview & Rollback Principles

When a production defect, security regression, or platform incompatibility is identified following a tagged release, the primary objective is to **restore learner and classroom availability immediately** without data loss.

### Rollback Cardinal Rules
1. **Never mutate prior tag history:** Git tags (`vX.Y.Z`) are immutable. A rollback is executed via automated version advance (`vX.Y.(Z+1)`) reverting offending commits, or explicitly deprecating release artifacts.
2. **Preserve Learner Data Backwards Compatibility:** Rollback releases must never corrupt or erase local user databases or progression event ledgers created under the rolled-back version.
3. **Artifact Quarantine:** Corrupt or compromised binaries on GitHub Releases or distribution mirrors must be immediately unpinned and replaced with a verified hotfix.

---

## 2. Platform-Specific Rollback Runbooks

### A. Android Play Store & APK Distribution (#38)
1. **Halt Rollout:** In Google Play Console -> Production / Open Testing -> Select current track -> Click **Halt Rollout**.
2. **Revert or Hotfix Build:**
   - In repo: revert offending commit(s) or cherry-pick fix.
   - Run `python3 scripts/bump_version.py --auto` to produce a new smart-bumped release and build number.
   - Build verified bundle: `flutter build appbundle --release`.
3. **Emergency Sideload APK:**
   - Deploy signed APK to GitHub Releases with hotfix tag so sideload users can update directly.

### B. Linux APT & Debian Repository Rollback (#39)
1. **Remove Offending Package from Repository Index:**
   - On the APT archive server / repository dispatch workflow:
     ```bash
     # Remove offending package
     reprepro -b /var/packages/monster-lab remove stable monster-lab
     # Re-index repository metadata and regenerate Release file
     reprepro -b /var/packages/monster-lab export stable
     ```
2. **Re-publish Known Stable Version:**
   - Re-index previous `.deb` artifact or publish incremented hotfix package.
   - In package clients: `apt-get update && apt-get --reinstall install monster-lab`.

### C. Windows Inno Setup & MSIX Rollback (#40)
1. **GitHub Releases Deprecation:**
   - Edit the affected GitHub Release -> Delete the faulty `MonsterLab_Setup_x64.exe` artifact.
   - Add warning banner: `**CRITICAL NOTE: v0.3.0 retracted due to regression. Please use v0.2.9 or v0.3.1 hotfix.**`
2. **Hotfix Distribution:**
   - Build hotfix installer using `windows/installer/monster_lab_setup.iss`.
   - Publish hotfix asset and updated `SHA256SUMS.txt`.

### D. Docker & Web PWA Container Rollback (#41)
1. **Re-tag Previous Known Good Image:**
   ```bash
   # Re-point latest and stable tags to prior verified SHA digest
   docker pull ghcr.io/jakej985-rgb/monster-lab-web:0.2.9
   docker tag ghcr.io/jakej985-rgb/monster-lab-web:0.2.9 ghcr.io/jakej985-rgb/monster-lab-web:latest
   docker push ghcr.io/jakej985-rgb/monster-lab-web:latest
   ```
2. **Container Health Verification:**
   - Verify health probe on `http://localhost:8080/healthz` or index endpoint.

---

## 3. Automated Rollback Simulation & Smoke Test Verification

Automated release checks must demonstrate:
- Verified hash matches using `scripts/generate_release_provenance.py`.
- Automated version synchronization using `scripts/verify_version_sync.py`.
- Automated sanity checks on packaging manifests.
