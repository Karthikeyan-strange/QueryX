CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), username VARCHAR(100) NOT NULL UNIQUE,
  display_name VARCHAR(200) NOT NULL, email VARCHAR(320) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), customer_number VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(200) NOT NULL, email VARCHAR(320) NOT NULL UNIQUE, phone VARCHAR(50), address TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE warehouses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), warehouse_code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(200) NOT NULL, region VARCHAR(100) NOT NULL, address TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), order_number VARCHAR(50) NOT NULL UNIQUE,
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  warehouse_id UUID REFERENCES warehouses(id) ON DELETE RESTRICT,
  status VARCHAR(30) NOT NULL CHECK (status IN ('PENDING','PROCESSING','SHIPPED','DELIVERED','CANCELLED')),
  ordered_at TIMESTAMPTZ NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE shipments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), tracking_number VARCHAR(100) NOT NULL UNIQUE,
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
  status VARCHAR(30) NOT NULL CHECK (status IN ('LABEL_CREATED','IN_TRANSIT','OUT_FOR_DELIVERY','DELIVERED','EXCEPTION')),
  shipped_at TIMESTAMPTZ, delivered_at TIMESTAMPTZ, created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (delivered_at IS NULL OR shipped_at IS NULL OR delivered_at >= shipped_at)
);
CREATE TABLE tracking_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), shipment_id UUID NOT NULL REFERENCES shipments(id) ON DELETE RESTRICT,
  event_type VARCHAR(50) NOT NULL, location VARCHAR(200), description TEXT, occurred_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE complaints (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), complaint_number VARCHAR(50) NOT NULL UNIQUE,
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  order_id UUID REFERENCES orders(id) ON DELETE RESTRICT, subject VARCHAR(200) NOT NULL, description TEXT NOT NULL,
  status VARCHAR(30) NOT NULL CHECK (status IN ('OPEN','IN_PROGRESS','RESOLVED','CLOSED')),
  priority VARCHAR(20) NOT NULL CHECK (priority IN ('LOW','MEDIUM','HIGH','URGENT')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(), resolved_at TIMESTAMPTZ,
  CHECK (resolved_at IS NULL OR status IN ('RESOLVED','CLOSED'))
);
CREATE TABLE regional_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), event_code VARCHAR(50) NOT NULL UNIQUE,
  region VARCHAR(100) NOT NULL, event_type VARCHAR(50) NOT NULL, title VARCHAR(200) NOT NULL,
  description TEXT, starts_at TIMESTAMPTZ NOT NULL, ends_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(), CHECK (ends_at IS NULL OR ends_at >= starts_at)
);
CREATE TABLE investigations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), investigation_number VARCHAR(50) NOT NULL UNIQUE,
  complaint_id UUID NOT NULL REFERENCES complaints(id) ON DELETE RESTRICT,
  assigned_user_id UUID REFERENCES users(id) ON DELETE RESTRICT, title VARCHAR(200) NOT NULL, summary TEXT,
  status VARCHAR(30) NOT NULL CHECK (status IN ('OPEN','IN_PROGRESS','RESOLVED','CLOSED')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(), closed_at TIMESTAMPTZ,
  CHECK (closed_at IS NULL OR status IN ('RESOLVED','CLOSED'))
);
CREATE TABLE investigation_events (
  investigation_id UUID NOT NULL REFERENCES investigations(id) ON DELETE RESTRICT,
  regional_event_id UUID NOT NULL REFERENCES regional_events(id) ON DELETE RESTRICT,
  PRIMARY KEY (investigation_id, regional_event_id)
);
CREATE TABLE responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), response_text TEXT NOT NULL,
  responded_by_user_id UUID REFERENCES users(id) ON DELETE RESTRICT,
  complaint_id UUID REFERENCES complaints(id) ON DELETE RESTRICT,
  investigation_id UUID REFERENCES investigations(id) ON DELETE RESTRICT,
  regional_event_id UUID REFERENCES regional_events(id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (((complaint_id IS NOT NULL)::int + (investigation_id IS NOT NULL)::int + (regional_event_id IS NOT NULL)::int) = 1)
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_warehouse_id ON orders(warehouse_id);
CREATE INDEX idx_shipments_order_id ON shipments(order_id);
CREATE INDEX idx_tracking_events_shipment_occurred ON tracking_events(shipment_id, occurred_at);
CREATE INDEX idx_complaints_customer_id ON complaints(customer_id);
CREATE INDEX idx_complaints_status_priority ON complaints(status, priority);
CREATE INDEX idx_investigations_complaint_id ON investigations(complaint_id);
CREATE INDEX idx_investigations_assigned_user_id ON investigations(assigned_user_id);
CREATE INDEX idx_investigations_status ON investigations(status);
CREATE INDEX idx_investigation_events_regional_event_id ON investigation_events(regional_event_id);
CREATE INDEX idx_regional_events_region ON regional_events(region);
CREATE INDEX idx_responses_complaint_id ON responses(complaint_id);
CREATE INDEX idx_responses_investigation_id ON responses(investigation_id);
CREATE INDEX idx_responses_regional_event_id ON responses(regional_event_id);
