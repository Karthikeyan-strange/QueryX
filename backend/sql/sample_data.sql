INSERT INTO users (id, username, display_name, email) VALUES
('00000000-0000-0000-0000-000000000001','jdoe','Jane Doe','jane.doe@example.com');
INSERT INTO customers (id, customer_number, name, email) VALUES
('00000000-0000-0000-0000-000000000011','CUST-1001','Acme Retail','ops@acme.example');
INSERT INTO warehouses (id, warehouse_code, name, region) VALUES
('00000000-0000-0000-0000-000000000021','WH-EAST','East Warehouse','East');
INSERT INTO orders (id, order_number, customer_id, warehouse_id, status, ordered_at) VALUES
('00000000-0000-0000-0000-000000000031','ORD-1001','00000000-0000-0000-000000000011','00000000-0000-0000-0000-000000000021','SHIPPED',now());
INSERT INTO shipments (id, tracking_number, order_id, status, shipped_at) VALUES
('00000000-0000-0000-0000-000000000041','TRK-1001','00000000-0000-0000-0000-000000000031','IN_TRANSIT',now());
INSERT INTO tracking_events (shipment_id,event_type,location,occurred_at) VALUES
('00000000-0000-0000-0000-000000000041','DEPARTED','East Warehouse',now());
INSERT INTO complaints (id, complaint_number, customer_id, order_id, subject, description, status, priority) VALUES
('00000000-0000-0000-0000-000000000051','CMP-1001','00000000-0000-0000-0000-000000000011','00000000-0000-0000-0000-000000000031','Delayed delivery','Shipment has not arrived.','OPEN','HIGH');
INSERT INTO regional_events (id,event_code,region,event_type,title,starts_at) VALUES
('00000000-0000-0000-0000-000000000061','EVT-1001','East','WEATHER','Severe weather',now()),
('00000000-0000-0000-0000-000000000062','EVT-1002','East','CLOSURE','Road closure',now());
INSERT INTO investigations (id,investigation_number,complaint_id,assigned_user_id,title,status) VALUES
('00000000-0000-0000-0000-000000000071','INV-1001','00000000-0000-0000-0000-000000000051','00000000-0000-0000-0000-000000000001','Delivery investigation','IN_PROGRESS');
INSERT INTO investigation_events VALUES
('00000000-0000-0000-0000-000000000071','00000000-0000-0000-0000-000000000061'),
('00000000-0000-0000-0000-000000000071','00000000-0000-0000-0000-000000000062');
INSERT INTO responses (response_text,responded_by_user_id,investigation_id) VALUES
('Investigation opened and regional events linked.','00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000071');
