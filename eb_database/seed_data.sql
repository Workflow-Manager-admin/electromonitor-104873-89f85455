-- ==================================================================
-- Seed Data for Electricity Monitoring App (EB)
-- Provides: Roles, Users (Officer & Customer), Sample Usage, Bills, Notifications
-- ==================================================================

-- 1. Clear existing data (in dependency order)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE notifications;
TRUNCATE TABLE bills;
TRUNCATE TABLE electricity_usage;
TRUNCATE TABLE users;
TRUNCATE TABLE roles;
SET FOREIGN_KEY_CHECKS = 1;

-- 2. Seed Roles
INSERT INTO roles (role_id, name, description) VALUES
    (1, 'officer', 'EB Officer who inputs usage and manages users.'),
    (2, 'customer', 'Customer who views usage and receives notifications.');

-- 3. Seed Users
-- Passwords should be hashed in live systems; here, plaintext for demo only!
INSERT INTO users (user_id, username, email, password, full_name, role_id, is_active, created_at) VALUES
    (1, 'officer.amy', 'amy.officer@eb.com',   'password123', 'Amy Officer',    1, true,  NOW()),
    (2, 'cust.john',   'john.cust@eb.com',     'passwordabc', 'John Customer',  2, true,  NOW()),
    (3, 'cust.sue',    'sue.cust@eb.com',      'testpass456', 'Sue Customer',   2, true,  NOW());

-- 4. Seed Electricity Usage (officer input for two customers)
INSERT INTO electricity_usage (usage_id, user_id, reading_date, reading_value, input_by, created_at) VALUES
    (1, 2, '2024-04-01', 350.50, 1, '2024-04-01 10:00:00'),
    (2, 2, '2024-05-01', 401.30, 1, '2024-05-01 10:10:00'),
    (3, 3, '2024-04-01', 220.10, 1, '2024-04-01 10:05:00'),
    (4, 3, '2024-05-01', 243.70, 1, '2024-05-01 10:13:00');

-- 5. Seed Bills (generated for each usage)
-- Assume Rs. 6.5 per KWh
INSERT INTO bills (bill_id, user_id, usage_id, amount, due_date, status, generated_at, paid_at) VALUES
    (1, 2, 1, 2278.25, '2024-04-20', 'paid', '2024-04-02 12:00:00', '2024-04-10 13:55:00'),
    (2, 2, 2, 2638.45, '2024-05-20', 'unpaid', '2024-05-02 12:00:00', NULL),
    (3, 3, 3, 1430.65, '2024-04-20', 'paid', '2024-04-02 13:00:00', '2024-04-11 09:20:00'),
    (4, 3, 4, 1584.05, '2024-05-20', 'overdue', '2024-05-02 13:00:00', NULL);

-- 6. Seed Notifications (bills, payments, general)
INSERT INTO notifications (notification_id, user_id, message, type, is_read, sent_at) VALUES
    (1, 2, 'Your bill for April (Rs. 2278.25) has been paid. Thank you!',    'bill_paid',     1, '2024-04-12 06:00:00'),
    (2, 2, 'Your May bill (Rs. 2638.45) is due by 2024-05-20',               'payment_due',   0, '2024-05-15 08:00:00'),
    (3, 3, 'Payment for your April bill (Rs. 1430.65) received.',            'bill_paid',     1, '2024-04-13 15:30:00'),
    (4, 3, 'Your May bill (Rs. 1584.05) is overdue. Please pay soon.',        'alert',         0, '2024-05-22 10:55:00'),
    (5, 2, 'New energy-saving tips available in your dashboard!',            'general',       1, '2024-04-04 13:00:00'),
    (6, 1, 'Officer system update: new analytics features available.',       'general',       1, '2024-04-10 15:00:00');

-- ==================================================================
-- End of seed data.
-- To load: mysql -u appuser -pdbuser123 -h localhost -P 5000 myapp < seed_data.sql
-- ==================================================================
