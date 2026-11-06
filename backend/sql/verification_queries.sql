-- Table count and names
SELECT count(*) AS table_count FROM information_schema.tables WHERE table_schema='public' AND table_name IN ('users','customers','warehouses','orders','shipments','tracking_events','complaints','regional_events','investigations','investigation_events','responses');
-- Foreign keys
SELECT conrelid::regclass AS table_name, conname FROM pg_constraint WHERE contype='f' AND connamespace='public'::regnamespace ORDER BY 1,2;
-- Many-to-many relationship
SELECT i.investigation_number, r.event_code FROM investigation_events ie JOIN investigations i ON i.id=ie.investigation_id JOIN regional_events r ON r.id=ie.regional_event_id;
-- Repository-oriented relationship checks
SELECT c.customer_number, o.order_number FROM customers c JOIN orders o ON o.customer_id=c.id;
SELECT s.tracking_number, te.event_type FROM shipments s JOIN tracking_events te ON te.shipment_id=s.id;
SELECT cmp.complaint_number, inv.investigation_number FROM complaints cmp JOIN investigations inv ON inv.complaint_id=cmp.id;
-- Constraint probes (run individually and expect failure): duplicate customer email, NULL required values, invalid status, invalid response parent count.
