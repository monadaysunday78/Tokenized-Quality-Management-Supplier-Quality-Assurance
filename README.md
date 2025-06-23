# Tokenized Quality Management - Supplier Quality Assurance

A comprehensive blockchain-based quality management system for supplier quality assurance built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides a complete solution for managing supplier quality through tokenized processes, ensuring transparency, immutability, and automated compliance tracking.

## Features

### 🔐 Quality Manager Verification
- Verify and manage quality assurance managers
- Track certifications and credentials
- Role-based access control

### 📊 Supplier Assessment
- Comprehensive supplier capability assessments
- Quality scoring and rating system
- ISO certification tracking
- Risk level categorization

### 🔍 Audit Coordination
- Schedule and manage quality audits
- Track audit findings and compliance
- Automated status updates
- Priority-based scheduling

### ✅ Corrective Action Management
- Create and track corrective actions
- Progress monitoring and updates
- Escalation for overdue actions
- Effectiveness scoring

### 📈 Performance Tracking
- Real-time performance metrics
- Trend analysis and reporting
- Supplier rankings and comparisons
- KPI dashboard

## Smart Contracts

### 1. Quality Manager Verification (\`quality-manager-verification.clar\`)
Manages the verification and authorization of quality managers who can perform assessments and audits.

**Key Functions:**
- \`verify-manager\`: Verify a quality manager
- \`revoke-verification\`: Revoke manager verification
- \`is-verified-manager\`: Check if a manager is verified

### 2. Supplier Assessment (\`supplier-assessment.clar\`)
Handles comprehensive supplier quality capability assessments and scoring.

**Key Functions:**
- \`create-assessment\`: Create new supplier assessment
- \`update-supplier-capabilities\`: Update supplier capabilities
- \`is-assessment-valid\`: Check assessment validity

### 3. Audit Coordination (\`audit-coordination.clar\`)
Manages the scheduling, coordination, and results of supplier quality audits.

**Key Functions:**
- \`schedule-audit\`: Schedule a new audit
- \`submit-audit-results\`: Submit audit findings
- \`reschedule-audit\`: Reschedule existing audit

### 4. Corrective Action (\`corrective-action.clar\`)
Tracks and manages corrective actions for quality issues and non-conformances.

**Key Functions:**
- \`create-corrective-action\`: Create new corrective action
- \`add-progress-update\`: Add progress updates
- \`close-action\`: Close completed action

### 5. Performance Tracking (\`performance-tracking.clar\`)
Monitors and tracks supplier performance metrics and KPIs over time.

**Key Functions:**
- \`record-performance\`: Record performance data
- \`calculate-defect-rate\`: Calculate defect rates
- \`set-supplier-ranking\`: Set supplier rankings

## Getting Started

### Prerequisites
- Stacks CLI
- Clarinet (for local development)
- Node.js (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd tokenized-quality-management
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

1. Configure your Stacks network settings
2. Deploy contracts in the following order:
    - quality-manager-verification
    - supplier-assessment
    - audit-coordination
    - corrective-action
    - performance-tracking

## Usage Examples

### Verify a Quality Manager
\`\`\`clarity
(contract-call? .quality-manager-verification verify-manager
'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
"John Smith"
"ISO 9001 Lead Auditor")
\`\`\`

### Create Supplier Assessment
\`\`\`clarity
(contract-call? .supplier-assessment create-assessment
'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
u85 u90 u80 u365)
\`\`\`

### Schedule Audit
\`\`\`clarity
(contract-call? .audit-coordination schedule-audit
'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
'ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP
"ISO 9001 Audit"
u1000 u3 "HIGH"
(list "Check documentation" "Review processes"))
\`\`\`

## Testing

The project includes comprehensive test suites for all contracts using Vitest:

\`\`\`bash
# Run all tests
npm test

# Run specific test file
npm test quality-manager-verification.test.js

# Run tests in watch mode
npm run test:watch
\`\`\`

## Architecture

The system follows a modular architecture where each contract handles a specific aspect of quality management:

1. **Verification Layer**: Manages user authentication and authorization
2. **Assessment Layer**: Handles supplier evaluations and capabilities
3. **Audit Layer**: Coordinates quality audits and findings
4. **Action Layer**: Manages corrective actions and follow-ups
5. **Performance Layer**: Tracks metrics and performance trends

## Security Considerations

- All contracts implement proper access controls
- Input validation for all public functions
- Error handling with descriptive error codes
- Immutable audit trails for compliance

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue in the GitHub repository.
