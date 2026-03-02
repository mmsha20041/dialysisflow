# Feature Addition Plan: Dialysis Session Scheduling & Reminders

## Objective
Add a scheduling workflow that allows staff to create, update, and track dialysis session appointments, with reminder support for patients and operational visibility for clinic teams.

## Scope

### In scope
- New appointment domain model (`Appointment`) with persistence.
- Scheduling UI to create and edit appointments.
- Calendar/list view for upcoming sessions.
- Reminder settings and local notification triggers.
- Basic appointment status tracking (`scheduled`, `checked_in`, `completed`, `missed`, `cancelled`).

### Out of scope (initial release)
- Multi-clinic routing and load-balancing.
- Billing integration.
- Telemedicine/video visit support.

## Implementation Plan

### Phase 1: Discovery & Design
1. Confirm user stories for receptionist, nurse, and patient flows.
2. Define appointment data contract and validation rules.
3. Produce screen wireframes and navigation updates.
4. Identify migration requirements for local/storage layer.

Deliverables:
- Approved user stories.
- Appointment model and state transition diagram.
- UI flow map.

### Phase 2: Data & Domain
1. Add `Appointment` entity and repository interfaces.
2. Implement data source for local persistence.
3. Add business rules:
   - Prevent double-booking at the same chair/time.
   - Enforce required fields (patient, date/time, session type).
   - Validate editable statuses by role.
4. Add unit tests for validation and state transitions.

Deliverables:
- Domain models and repositories.
- Unit test coverage for core rules.

### Phase 3: UI & Interaction
1. Add route(s) for scheduling and appointment list views.
2. Build appointment creation/edit form.
3. Build upcoming sessions list with status tags and filters.
4. Add empty, loading, and error states.
5. Ensure responsive behavior for phone/tablet layouts.

Deliverables:
- End-to-end schedulable appointment workflow in app.
- Widget tests for key screens.

### Phase 4: Reminders & Notifications
1. Add reminder preference controls.
2. Integrate local notification scheduling.
3. Handle reminder updates when appointments are edited/cancelled.
4. Add fallback behavior for denied notification permissions.

Deliverables:
- Reminder configuration and notification triggers.
- Tests for reminder scheduling logic.

### Phase 5: QA & Release
1. Execute regression tests on patient registration flow.
2. Validate appointment lifecycle edge cases.
3. Run performance checks for list rendering and navigation.
4. Prepare release notes and rollout checklist.

Deliverables:
- QA sign-off report.
- Release readiness checklist.

## Technical Work Breakdown
- **Core/Data**
  - `lib/core`: appointment model, repository abstractions, validators.
- **Presentation**
  - `lib/presentation`: scheduler screens, form widgets, list cards.
- **Routes**
  - `lib/routes`: new route constants and route map entries.
- **Tests**
  - Unit tests for domain rules.
  - Widget tests for scheduling UI.

## Risks & Mitigations
- **Risk:** Notification timing inconsistencies across platforms.  
  **Mitigation:** Build platform-specific test matrix and verify timezone handling.
- **Risk:** Scheduling conflicts increase support burden.  
  **Mitigation:** Enforce strict validation and conflict feedback in form UX.
- **Risk:** Scope creep into staff-management features.  
  **Mitigation:** Keep v1 scoped to single-clinic scheduling.

## Success Metrics
- ≥ 95% successful appointment creation in QA test runs.
- < 2% invalid scheduling attempts reaching persistence layer.
- Reminder delivery success rate ≥ 90% on supported devices.
- No regressions in existing patient registration flow.

## Proposed Timeline (2-week sprint model)
- Sprint 1: Discovery + Data/Domain foundation.
- Sprint 2: UI implementation + tests.
- Sprint 3: Reminders + QA hardening + release prep.

## Enterprise Readiness Follow-up
For the broader production-hardening roadmap, refer to `docs/enterprise-transformation-plan.md`, which defines security, compliance, architecture, testing, observability, and release-management workstreams for enterprise rollout.
