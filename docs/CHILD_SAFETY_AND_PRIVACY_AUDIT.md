# Child Safety, Data Privacy & Regulatory Compliance Evidence Matrix

**Monster Lab: Educational Electronics & Robotics Companion**  
*Document Version:* 1.0.0  
*Audience:* Parents, Educators, Developers, Security & Privacy Auditors  
*Target Age Group:* Children 6–14+ years (Elementary through Early Secondary)  
*Regulatory Frameworks Evaluated:* Children's Online Privacy Protection Act (COPPA), Family Educational Rights and Privacy Act (FERPA), General Data Protection Regulation - Kids (GDPR-K).

---

## 1. Executive Privacy Architecture & Guarantees

Monster Lab is engineered with a **Zero-Network, Local-First, Privacy-by-Design** architecture.

```
+-------------------------------------------------------------------------+
|                           CHILD SANDBOX                                 |
|                                                                         |
|  +-------------------+    +--------------------+    +----------------+  |
|  |  Learn Lab & Flow |    |  Parts Lab (Specs) |    |  Simulators    |  |
|  +---------+---------+    +---------+----------+    +--------+-------+  |
|            |                        |                        |          |
|            v                        v                        v          |
|     [Local State]            [Local State]            [Local State]     |
+------------+------------------------+------------------------+----------+
             |                        |                        |
             +------------------------+------------------------+
                                      |
                                      v
                      +-------------------------------+
                      |   Local Storage / Device Disk |
                      |  (Plain SharedPreferences; OS sandbox)
                      +---------------+---------------+
                                      |
                      [NO OUTBOUND CLOUD / INTERNET CALLS]
                      [NO ANALYTICS / ZERO THIRD-PARTY SDKS]
```

### Core Architecture Invariants
1. **Zero External Telemetry:** The application contains 0 tracking SDKs, 0 third-party advertising frameworks, 0 analytics beacons, and 0 external telemetry dispatchers.
2. **100% Offline Functional Guarantee:** All curriculum courses, interactive activities, wiring diagrams, simulator engines, and challenges operate completely offline with no internet access required.
3. **Local-Only Data Residency:** All profile nicknames, avatars, XP points, progress ledgers, and unlock statuses reside exclusively on the user's local physical device disk.
4. **No Child PII Collection:** The app never collects real names, email addresses, phone numbers, geolocation coordinates, audio recordings, camera photos, or biometric markers.

> **Encryption-at-rest status:** Monster Lab currently stores profiles and progress
> as plaintext in the platform's private `SharedPreferences` store and exports
> plaintext JSON backups. The app relies on the operating-system app sandbox and
> device-level storage encryption; it does not yet provide application-level encryption.
> Protect exported backup files accordingly.

---

## 2. Child-Facing Data Inventory & Data Flow Map (#34)

| Data Element | Purpose | Storage Mechanism | Retention Period | PII Classification |
| :--- | :--- | :--- | :--- | :--- |
| **Profile ID** (`id`) | Unique local profile reference | Local SharedPreferences | Until deleted by parent | Non-PII (UUID/Random String) |
| **Nickname** (`nickname`) | In-app child display greeting | Local SharedPreferences | Until deleted by parent | Non-PII (Pseudonym/First name) |
| **Avatar ID** (`avatarId`) | Visual character selection | Local SharedPreferences | Until deleted by parent | Non-PII (Static asset reference) |
| **Age Bracket** (`ageBracket`) | UI text scaling & safety tiering | Local SharedPreferences | Until deleted by parent | Non-PII (Coarse bracket: e.g. `ages7_9`) |
| **Progress Ledger** (`events`) | Reconstruct course XP and completed lessons | Local SharedPreferences | Until reset or deleted | Non-PII (Curriculum IDs + Timestamps) |
| **Transaction IDs** (`processedTransactionIds`) | Idempotent duplicate reward prevention | Local SharedPreferences | Until reset or deleted | Non-PII (Cryptographic hash tokens) |
| **Parent Pin / Math Gate** | Verification barrier for adult controls | In-memory only (ephemeral) | Discarded immediately after verification | Non-PII (Mathematical calculation) |
| **Parent Session Token** (`sessionId`) | Authorization duration control | Ephemeral in-memory | Expires after 15 minutes | Non-PII (Internal session counter) |

---

## 3. Operating System Permissions Inventory (#34)

| OS Permission | Android Manifest / iOS Info / Desktop | Educational Justification | Child Safety Safeguard |
| :--- | :--- | :--- | :--- |
| **Internet / Network** | `android.permission.INTERNET` (Disabled/Not Requested) | N/A — App is completely offline | Zero network traffic permitted; network calls fail fast. |
| **Camera** | `android.permission.CAMERA` (Not Requested) | N/A — No camera functionality | Not requested or declared in manifests. |
| **Microphone / Audio** | None declared in app manifest | None — Simulated sound sensor uses mathematical noise model | Zero physical microphone recording or eavesdropping. |
| **USB / Serial** | Web Serial API (web only) | Arduino connection | User-prompted port picker; local UART only. |

| **Storage / Files** | Scoped app sandbox | Local JSON backup export/import | Confined strictly to application private documents directory. |

---

## 4. COPPA & FERPA Regulatory Review Matrix (#35)

### COPPA (15 U.S.C. §§ 6501–6506 / 16 CFR Part 312) Evidence Assessment
- **Applicability:** Software targeted directly or indirectly at children under 13 years of age.
- **Rule 312.3 (Notice & Consent):** 
  - *Status: COMPLIANT (Safe Harbor).*
  - *Evidence:* Monster Lab does not collect, use, or disclose personal information from children. Because no personal information is transmitted across public networks or stored on remote servers, verifiable parental consent (VPC) for external cloud processing is not required.
- **Rule 312.5 (Parental Verification Gate):**
  - *Status: IMPLEMENTED.*
  - *Evidence:* Adult controls, destructive actions, and backup imports are protected behind a multi-step mathematical challenge (`ParentGateDialog`) and expiring authorization session (`ParentSessionService`).
- **Rule 312.10 (Data Retention & Deletion):**
  - *Status: FULLY SATISFIED.*
  - *Evidence:* Parents have absolute, instant control to purge all learner profiles, erase progress ledgers, or wipe app data through the Parent Dashboard with double confirmation.

### FERPA (34 CFR Part 99) Educational Records Assessment
- **Applicability:** Educational agencies and institutions utilizing digital learning materials.
- **Direct Control Requirement:**
  - *Status: FULLY SATISFIED.*
  - *Evidence:* Because no pupil records or educational analytics are shared with commercial entities or stored on vendor cloud platforms, educational institutions maintain 100% custody and control of classroom devices.
- **Non-Disclosure of Student Records:**
  - *Status: FULLY SATISFIED.*
  - *Evidence:* Progress and challenge attempts cannot leak to external systems.

---

## 5. Destructive Action & Safety Interlock Verification

1. **Pre-Destructive Snapshot Protection:** Prior to executing profile deletion, data purge, or backup replacement, `ParentDataService.executeDestructiveAction` automatically generates an in-memory snapshot.
2. **Safe Rollback:** If any I/O error or disk corruption occurs during deletion or write phases, the system automatically rolls back to the pre-destructive state.
3. **Explicit Phrase Confirmation:** High-risk actions require the user to explicitly submit `'CONFIRM'` or matching challenge strings, preventing accidental taps by minors.
4. **Hardware Safe State Interlock:** When high-voltage relays, laser diodes, or DC motors are driven via hardware companion, emergency stop (`EMERGENCY_STOP`) and disconnection triggers revert all outputs to safe defaults (0V / LOW).

---

## 6. Auditor Sign-Off & Verification Checklist

- [x] **Zero Cloud Traffic Audit:** Wireshark / Network Profiler inspection reveals 0 outbound packets during normal app operation.
- [x] **Manifest Permission Review:** Verified no intrusive background permissions (`CAMERA`, `RECORD_AUDIO`, `ACCESS_FINE_LOCATION`) exist.
- [x] **Local Storage Inspection:** Checked SharedPreferences contents — confirmed zero personal identifiers or unhashed sensitive credentials.
- [x] **Parent Gate Robustness:** Confirmed route authorization guards block direct URL navigation to `/parent` without valid authorization session.
- [x] **Automated Regression Suite:** Automated tests pass for session expiry, route protection, restricted component unlocks, and destructive action rollbacks.

*Audit Conducted By:* Monster Lab Engineering & Safety Verification Team  
*Status:* Approved for Educational Distribution (Ages 6+)
