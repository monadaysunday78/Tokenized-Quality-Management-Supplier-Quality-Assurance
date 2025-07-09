;; Corrective Action Contract
;; Manages supplier corrective actions and follow-ups

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_INVALID_PRIORITY (err u401))
(define-constant ERR_ACTION_EXISTS (err u402))
(define-constant ERR_NOT_FOUND (err u403))
(define-constant ERR_INVALID_STATUS (err u404))

;; Data structures
(define-map corrective-actions uint {
    supplier: principal,
    issue-description: (string-ascii 200),
    root-cause: (string-ascii 200),
    corrective-plan: (string-ascii 300),
    responsible-person: principal,
    due-date: uint,
    priority: (string-ascii 10),
    status: (string-ascii 20),
    created-date: uint
})

(define-map action-progress uint {
    action-id: uint,
    progress-updates: (list 10 (string-ascii 150)),
    completion-evidence: (list 5 (string-ascii 100)),
    verification-status: (string-ascii 20),
    effectiveness-score: uint
})

(define-data-var action-counter uint u0)

;; Public functions
(define-public (create-corrective-action
    (supplier principal)
    (issue (string-ascii 200))
    (root-cause (string-ascii 200))
    (plan (string-ascii 300))
    (responsible principal)
    (due-date uint)
    (priority (string-ascii 10)))
    (let ((action-id (+ (var-get action-counter) u1)))
        (asserts! (> due-date block-height) ERR_INVALID_PRIORITY)
        (asserts! (is-none (map-get? corrective-actions action-id)) ERR_ACTION_EXISTS)

        (map-set corrective-actions action-id {
            supplier: supplier,
            issue-description: issue,
            root-cause: root-cause,
            corrective-plan: plan,
            responsible-person: responsible,
            due-date: due-date,
            priority: priority,
            status: "OPEN",
            created-date: block-height
        })

        (var-set action-counter action-id)
        (ok action-id)
    )
)

(define-public (update-action-status (action-id uint) (new-status (string-ascii 20)))
    (match (map-get? corrective-actions action-id)
        action-data (begin
            (map-set corrective-actions action-id (merge action-data { status: new-status }))
            (ok true)
        )
        ERR_NOT_FOUND
    )
)

(define-public (add-progress-update
    (action-id uint)
    (update (string-ascii 150))
    (evidence (list 5 (string-ascii 100)))
    (verification (string-ascii 20)))
    (let (
        (current-progress (default-to
            { action-id: action-id, progress-updates: (list), completion-evidence: (list), verification-status: "PENDING", effectiveness-score: u0 }
            (map-get? action-progress action-id)
        ))
        (updated-progress (merge current-progress {
            progress-updates: (unwrap-panic (as-max-len? (append (get progress-updates current-progress) update) u10)),
            completion-evidence: evidence,
            verification-status: verification
        }))
    )
        (map-set action-progress action-id updated-progress)
        (ok true)
    )
)

(define-public (close-action (action-id uint) (effectiveness-score uint))
    (begin
        (asserts! (<= effectiveness-score u100) ERR_INVALID_STATUS)
        (match (map-get? action-progress action-id)
            progress-data (begin
                (map-set action-progress action-id (merge progress-data {
                    effectiveness-score: effectiveness-score,
                    verification-status: "VERIFIED"
                }))
                (update-action-status action-id "CLOSED")
            )
            ERR_NOT_FOUND
        )
    )
)

(define-public (escalate-action (action-id uint))
    (match (map-get? corrective-actions action-id)
        action-data (begin
            (map-set corrective-actions action-id (merge action-data {
                priority: "HIGH",
                status: "ESCALATED"
            }))
            (ok true)
        )
        ERR_NOT_FOUND
    )
)

;; Read-only functions
(define-read-only (get-corrective-action (action-id uint))
    (map-get? corrective-actions action-id)
)

(define-read-only (get-action-progress (action-id uint))
    (map-get? action-progress action-id)
)

(define-read-only (is-action-overdue (action-id uint))
    (match (map-get? corrective-actions action-id)
        action-data (and
            (not (is-eq (get status action-data) "CLOSED"))
            (> block-height (get due-date action-data))
        )
        false
    )
)
