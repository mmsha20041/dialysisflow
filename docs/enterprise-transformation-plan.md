# Enterprise Transformation Plan: DialysisFlow

## 1) Executive Summary
DialysisFlow has early product momentum, but current implementation patterns indicate a prototype-stage application (single `MaterialApp`, in-memory scheduling data, minimal layering, and limited automated testing).

This plan defines a pragmatic path to move DialysisFlow to an enterprise-ready healthcare platform with strong reliability, security, compliance posture, observability, and delivery governance.

## 2) Current-State Assessment (from codebase review)

### Architecture and code organization
- Presentation-heavy implementation with limited domain/data separation across most modules.
- Centralized route registry but no route guards or role-based authorization middleware.
- Shared exports in `app_export.dart` simplify imports but can hide dependency boundaries.

### Data and persistence
- Appointment scheduling currently relies on an in-memory repository implementation (`InMemoryAppointmentRepository`).
- No durable data synchronization contract for offline-first healthcare workflows.

### Security and compliance posture
- No visible token lifecycle management, secrets hardening, or audit-trail framework.
- No explicit HIPAA-aligned controls documented in-code (PII/PHI logging policy, retention, encryption controls).

### Quality and operations
- Minimal test surface (single baseline widget test + new scheduler unit tests).
- No CI quality gates or release governance artifacts in-repo.
- No telemetry standards (structured logs, traces, metrics, crash reporting) codified.

## 3) Enterprise Target State

### Platform qualities
- **Security-first:** encrypted data, strong authn/authz, auditability.
- **Reliability-first:** resilient networking, retries/backoff, graceful degradation.
- **Compliance-ready:** HIPAA-oriented controls and evidence artifacts.
- **Observable-by-default:** logs, traces, metrics, actionable alerts.
- **Scalable delivery:** CI/CD with quality gates, automated checks, staged rollouts.

### Architecture target
Adopt a modular Clean Architecture approach per feature:
- `presentation` (UI, state controllers)
- `domain` (entities, use-cases, policies)
- `data` (DTOs, repositories, local/remote sources)

Back each feature with explicit contracts and test layers (unit/widget/integration).

## 4) Transformation Workstreams

### WS1: Architecture & Modularization
**Goal:** enforce clear boundaries and maintainability.

Tasks:
1. Introduce feature modules (`appointments`, `patients`, `auth`, `centers`, `reports`).
2. Move business rules from widgets into domain use-cases.
3. Add dependency injection (e.g., `get_it` + environment configs).
4. Define architecture rules (lint + folder conventions) and enforce in CI.

Exit criteria:
- New features implemented via `domain` + `data` + `presentation` layers.
- No direct remote/local data calls from widgets.

### WS2: Data Platform & Offline Reliability
**Goal:** production-grade persistence and sync.

Tasks:
1. Replace in-memory repositories with local persistent store (`drift`/`sqflite`) + remote API adapters.
2. Implement sync engine (queue + retry + conflict resolution policy).
3. Add versioned schema migrations and rollback testing.
4. Define data ownership and source-of-truth rules per entity.

Exit criteria:
- Appointments survive restarts and network outages.
- Sync reconciliation is deterministic and tested.

### WS3: Security, Privacy, and Compliance
**Goal:** healthcare-grade controls.

Tasks:
1. Add secure auth (OIDC/JWT or enterprise SSO integration) with refresh-token rotation.
2. Implement role-based access control middleware for routes and actions.
3. Enforce encryption at rest/in transit; secure key storage.
4. Add audit trails for PHI-affecting actions (create/edit/view/export).
5. Define PHI-safe logging redaction and retention policy.

Exit criteria:
- Security threat model completed.
- Audit event coverage for high-risk workflows.

### WS4: Testing Strategy & Quality Gates
**Goal:** predictable quality at scale.

Tasks:
1. Establish test pyramid targets:
   - Unit tests for domain logic.
   - Widget tests for key screens/flows.
   - Integration tests for critical paths (login → dashboard → scheduling).
2. Add golden tests for core UI components.
3. Add contract tests for repository interfaces.
4. Configure CI gates (format/lint/test/coverage thresholds).

Exit criteria:
- Minimum 70% domain coverage in phase 1, 85% for critical modules.
- Release blocked on failing gates.

### WS5: Observability & Incident Response
**Goal:** rapid detection and recovery.

Tasks:
1. Add structured logging with correlation IDs.
2. Instrument app performance metrics and user journey traces.
3. Integrate crash/error reporting and alert routing.
4. Define runbooks (auth outage, API degradation, sync backlog, notification failure).

Exit criteria:
- P1 incidents detectable within minutes.
- On-call runbooks tested via tabletop exercises.

### WS6: DevSecOps & Release Management
**Goal:** safe, repeatable delivery.

Tasks:
1. Create CI/CD pipelines (PR checks, signed builds, staged deployment).
2. Add SAST/dependency scanning and license checks.
3. Adopt feature flags for risky rollouts.
4. Define release train cadence and rollback playbook.

Exit criteria:
- Every release traceable to build metadata and approvals.
- One-click rollback available for production builds.

### WS7: Product Governance & Operational Readiness
**Goal:** enterprise operating model.

Tasks:
1. Define SLAs/SLOs (latency, crash-free sessions, sync success, notification delivery).
2. Create RACI for engineering, QA, security, ops, product.
3. Introduce architecture decision records (ADRs).
4. Standardize definition-of-done with security + observability + tests.

Exit criteria:
- Quarterly governance review with objective KPI dashboard.

## 5) 90-Day Execution Plan

### Days 0–30 (Foundation)
- Finalize target architecture and ADR templates.
- Set up CI gates and baseline coverage reporting.
- Implement DI foundation and module skeletons.
- Replace scheduler in-memory path with persistent repository abstraction.

### Days 31–60 (Core hardening)
- Deliver auth lifecycle + route authorization.
- Add local persistence + sync queue for appointments.
- Expand tests for scheduler and role-based dashboard workflows.
- Integrate crash reporting + structured logging.

### Days 61–90 (Production readiness)
- Security hardening and compliance evidence pack.
- Release pipeline with staged rollout and rollback automation.
- Run performance and chaos-like resilience checks.
- Conduct production readiness review and controlled go-live.

## 6) Priority Backlog (first 12 enterprise tickets)
1. Introduce `appointments/domain` use-cases for create/list/update-status.
2. Add persistent appointment datasource + migration v1.
3. Implement route guard and role policy engine.
4. Create auth session manager with token refresh.
5. Add PHI redaction utility for logs.
6. Add scheduler widget tests (validation, conflicts, empty state).
7. Add repository contract tests for conflict logic and status rules.
8. Add integration test for staff scheduling flow.
9. Add crash reporting integration and error boundaries.
10. Add CI pipeline with lint/test/coverage gates.
11. Add feature flag for scheduler rollout.
12. Add release checklist + rollback playbook docs.

## 7) Success Metrics (Enterprise KPIs)
- Crash-free sessions ≥ 99.5%.
- Scheduling API success rate ≥ 99.9%.
- Conflict-prevention accuracy ≥ 99.99% in regression suite.
- Mean time to detect (MTTD) < 5 minutes for P1 incidents.
- Mean time to restore (MTTR) < 30 minutes for high-severity issues.
- 100% of PHI-touching actions represented in audit logs.

## 8) Key Risks and Mitigations
- **Risk:** Velocity drop during refactor.  
  **Mitigation:** Strangler pattern; migrate feature-by-feature with compatibility adapters.
- **Risk:** Unclear compliance ownership.  
  **Mitigation:** Assign Security Champion + compliance signoff gates in release workflow.
- **Risk:** Test maintenance burden.  
  **Mitigation:** Test templates + shared fixtures + contract-first interfaces.

## 9) Immediate Next Steps (this sprint)
1. Approve this plan and nominate owners per workstream.
2. Create ADR-001 (target architecture and module boundaries).
3. Stand up CI checks and baseline code coverage reporting.
4. Convert appointment flow from UI-managed state to use-case-driven orchestration.
5. Prepare production readiness checklist v0.1 for next sprint planning.
