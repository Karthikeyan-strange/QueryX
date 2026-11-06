# QueryX Database Design

## Scope
This is the proposed database design derived from the supplied QueryX database-development brief and the current frontend scaffold. The scaffold contains no domain forms or persisted fields, so domain-specific attributes below are conservative proposals for approval.

## Assumptions requiring confirmation
1. `users` represents internal QueryX users; authentication credentials are intentionally out of scope.
2. A customer has one canonical email and customer number; both are unique.
3. An order belongs to one customer and may optionally be assigned to a warehouse.
4. A shipment belongs to one order. Multiple shipments per order are allowed.
5. `investigation_events` is a pure many-to-many join table with a composite key and no extra attributes.
6. Responses belong to a complaint, investigation, or regional event through nullable foreign keys. Exactly one parent is enforced with a CHECK constraint.
7. Status, priority, shipment/order state, and event type are stored as constrained VARCHAR values rather than PostgreSQL ENUMs to keep Flyway evolution simple.
8. Monetary values are optional because the brief does not define pricing requirements; no monetary columns are included.
9. Historical records are retained: foreign keys use RESTRICT/NO ACTION rather than cascading deletes.

## Tables

### users
`id UUID PK`, `username VARCHAR(100) NOT NULL UNIQUE`, `display_name VARCHAR(200) NOT NULL`, `email VARCHAR(320) NOT NULL UNIQUE`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`.

### customers
`id UUID PK`, `customer_number VARCHAR(50) NOT NULL UNIQUE`, `name VARCHAR(200) NOT NULL`, `email VARCHAR(320) NOT NULL UNIQUE`, `phone VARCHAR(50)`, `address TEXT`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`.

### warehouses
`id UUID PK`, `warehouse_code VARCHAR(50) NOT NULL UNIQUE`, `name VARCHAR(200) NOT NULL`, `region VARCHAR(100) NOT NULL`, `address TEXT`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`.

### orders
`id UUID PK`, `order_number VARCHAR(50) NOT NULL UNIQUE`, `customer_id UUID NOT NULL FK customers`, `warehouse_id UUID NULL FK warehouses`, `status VARCHAR(30) NOT NULL`, `ordered_at TIMESTAMPTZ NOT NULL`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`. Status: `PENDING`, `PROCESSING`, `SHIPPED`, `DELIVERED`, `CANCELLED`.

### shipments
`id UUID PK`, `tracking_number VARCHAR(100) NOT NULL UNIQUE`, `order_id UUID NOT NULL FK orders`, `status VARCHAR(30) NOT NULL`, `shipped_at TIMESTAMPTZ`, `delivered_at TIMESTAMPTZ`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`. Status: `LABEL_CREATED`, `IN_TRANSIT`, `OUT_FOR_DELIVERY`, `DELIVERED`, `EXCEPTION`.

### tracking_events
`id UUID PK`, `shipment_id UUID NOT NULL FK shipments`, `event_type VARCHAR(50) NOT NULL`, `location VARCHAR(200)`, `description TEXT`, `occurred_at TIMESTAMPTZ NOT NULL`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`.

### complaints
`id UUID PK`, `complaint_number VARCHAR(50) NOT NULL UNIQUE`, `customer_id UUID NOT NULL FK customers`, `order_id UUID NULL FK orders`, `subject VARCHAR(200) NOT NULL`, `description TEXT NOT NULL`, `status VARCHAR(30) NOT NULL`, `priority VARCHAR(20) NOT NULL`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`, `resolved_at TIMESTAMPTZ`. Status: `OPEN`, `IN_PROGRESS`, `RESOLVED`, `CLOSED`; priority: `LOW`, `MEDIUM`, `HIGH`, `URGENT`.

### regional_events
`id UUID PK`, `event_code VARCHAR(50) NOT NULL UNIQUE`, `region VARCHAR(100) NOT NULL`, `event_type VARCHAR(50) NOT NULL`, `title VARCHAR(200) NOT NULL`, `description TEXT`, `starts_at TIMESTAMPTZ NOT NULL`, `ends_at TIMESTAMPTZ`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`. `ends_at` must not precede `starts_at`.

### investigations
`id UUID PK`, `investigation_number VARCHAR(50) NOT NULL UNIQUE`, `complaint_id UUID NOT NULL FK complaints`, `assigned_user_id UUID NULL FK users`, `title VARCHAR(200) NOT NULL`, `summary TEXT`, `status VARCHAR(30) NOT NULL`, `started_at TIMESTAMPTZ NOT NULL DEFAULT now()`, `closed_at TIMESTAMPTZ`. Status: `OPEN`, `IN_PROGRESS`, `RESOLVED`, `CLOSED`.

### investigation_events
`investigation_id UUID NOT NULL FK investigations`, `regional_event_id UUID NOT NULL FK regional_events`, composite PK `(investigation_id, regional_event_id)`.

### responses
`id UUID PK`, `response_text TEXT NOT NULL`, `responded_by_user_id UUID NULL FK users`, `complaint_id UUID NULL FK complaints`, `investigation_id UUID NULL FK investigations`, `regional_event_id UUID NULL FK regional_events`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`. Exactly one of the three parent IDs must be non-null.

## Relationship summary
- customers 1-to-many orders and complaints.
- warehouses 1-to-many orders.
- orders 1-to-many shipments and optionally complaints.
- shipments 1-to-many tracking_events.
- complaints 1-to-many investigations.
- users 1-to-many assigned investigations and responses.
- investigations many-to-many regional_events through investigation_events.
- responses are polymorphic to one supported parent using three nullable foreign keys plus an XOR CHECK.

Approval is requested for the assumptions above, especially the proposed columns and polymorphic response ownership.
