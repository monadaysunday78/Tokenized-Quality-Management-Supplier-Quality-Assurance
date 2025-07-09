;; Audit Coordination Contract
;; Manages supplier quality audits scheduling and coordination

(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_INVALID_DATE (err u301))
(define-constant ERR_AUDIT_EXISTS (err u302))
(define-constant ERR_NOT_FOUND (err u303))
(define-constant ERR_INVALID_STATUS (err u304))

;; Data structures
(define-map scheduled-audits uint {
    supplier: principal,
    auditor: principal,
    audit-type: (string-ascii 30),
    scheduled-date: uint,
    duration-days: uint,
    status: (string-ascii 20),
    priority: (string-ascii 10),
    checklist-items: (list 20 (string-ascii 50))
})

(define-map audit-results uint {
    audit-id: uint,
    findings: (list 10 (string-ascii 100)),
    compliance-rate: uint,
    risk-issues: (list 5 (string-ascii 100)),
    recommendations: (list 10 (string-ascii 100)),
    completion-date: uint
})

(define-data-var audit-counter uint u0)

;; Public functions
(define-public (schedule-audit
    (supplier principal)
    (auditor principal)
    (audit-type (string-ascii 30))
    (scheduled-date uint)
    (duration uint)
    (priority (string-ascii 10))
    (checklist (list 20 (string-ascii 50))))
    (let ((audit-id (+ (var-get audit-counter) u1)))
        (asserts! (> scheduled-date block-height) ERR_INVALID_DATE)
        (asserts! (is-none (map-get? scheduled-audits audit-id)) ERR_AUDIT_EXISTS)

        (map-set scheduled-audits audit-id {
            supplier: supplier,
            auditor: auditor,
            audit-type: audit-type,
            scheduled-date: scheduled-date,
            duration-days: duration,
            status: "SCHEDULED",
            priority: priority,
            checklist-items: checklist
        })

        (var-set audit-counter audit-id)
        (ok audit-id)
    )
)

(define-public (update-audit-status (audit-id uint) (new-status (string-ascii 20)))
    (match (map-get? scheduled-audits audit-id)
        audit-data (begin
            (map-set scheduled-audits audit-id (merge audit-data { status: new-status }))
            (ok true)
        )
        ERR_NOT_FOUND
    )
)

(define-public (submit-audit-results
    (audit-id uint)
    (findings (list 10 (string-ascii 100)))
    (compliance-rate uint)
    (risks (list 5 (string-ascii 100)))
    (recommendations (list 10 (string-ascii 100))))
    (begin
        (asserts! (<= compliance-rate u100) ERR_INVALID_STATUS)
        (map-set audit-results audit-id {
            audit-id: audit-id,
            findings: findings,
            compliance-rate: compliance-rate,
            risk-issues: risks,
            recommendations: recommendations,
            completion-date: block-height
        })
        (update-audit-status audit-id "COMPLETED")
    )
)

(define-public (reschedule-audit (audit-id uint) (new-date uint))
    (match (map-get? scheduled-audits audit-id)
        audit-data (begin
            (asserts! (> new-date block-height) ERR_INVALID_DATE)
            (map-set scheduled-audits audit-id (merge audit-data {
                scheduled-date: new-date,
                status: "RESCHEDULED"
            }))
            (ok true)
        )
        ERR_NOT_FOUND
    )
)

;; Read-only functions
(define-read-only (get-audit-details (audit-id uint))
    (map-get? scheduled-audits audit-id)
)

(define-read-only (get-audit-results (audit-id uint))
    (map-get? audit-results audit-id)
)

(define-read-only (get-audit-status (audit-id uint))
    (match (map-get? scheduled-audits audit-id)
        audit-data (some (get status audit-data))
        none
    )
)
