-- ============================================
-- SAMPLE SQL QUERIES — Security Scan Test
-- Database: prod_users_db
-- ============================================

-- 1. User credentials query (exposes password hash)
SELECT user_id, username, email, password_hash, api_token, created_at
FROM users
WHERE email = 'admin@corp.com'
  AND password = 'SuperSecret@999';

-- 2. Hardcoded credentials in connection string
-- jdbc:mysql://db.corp.com:3306/prod?user=root&password=Prod@DBPass#2026

-- 3. Insert with sensitive data in plain text
INSERT INTO audit_log (user_email, action, raw_token, ip_address)
VALUES (
  'john.doe@company.com',
  'data_export',
  'sk-prod-live-xK9mN2pQrT8vWjYuZ',
  '192.168.1.100'
);

-- 4. API key stored in DB config table
UPDATE system_config
SET config_value = 'sk-openai-aBcDeFgHiJkLmNoPqRsTuVwXyZ'
WHERE config_key = 'openai_api_key';

UPDATE system_config
SET config_value = 'stripe_live_key_xK9mN2pQrT8v'
WHERE config_key = 'payment_gateway_key';

-- 5. Password reset with plaintext password
UPDATE users
SET password = 'NewPass@123',
    reset_token = 'reset-tok-ghp_aBcDeFgHiJkLmNo'
WHERE email = 'alice@example.com';

-- 6. Logging sensitive phone and email
INSERT INTO contact_backup (name, email, phone, notes)
VALUES ('Bob Smith', 'bob@gmail.com', '+91-98765-43210', 'VIP customer');

-- 7. Join leaking internal IP + credentials
SELECT u.email, u.password_hash, s.session_token, s.client_ip
FROM users u
JOIN sessions s ON u.user_id = s.user_id
WHERE s.client_ip IN ('10.0.0.1', '172.16.0.50', '192.168.0.1');

-- ============================================
-- END OF QUERIES
-- ============================================
