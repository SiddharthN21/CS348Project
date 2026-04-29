ALTER TABLE student AUTO_INCREMENT = 1;

INSERT INTO student (username, password, full_name, email, phone, address, catalog_year)
VALUES
('jdoe', 'pass123', 'John Doe', 'jdoe@example.com', '317-555-1001', '123 Main St, Indianapolis, IN', NULL),

('asmith', 'welcome1', 'Alice Smith', 'asmith@example.com', '317-555-1002', '45 Oak Drive, Carmel, IN', NULL),

('bpatel', 'mypassword', 'Bhavesh Patel', 'bpatel@example.com', '317-555-1003', '78 River Rd, Fishers, IN', NULL),

('sreddy', 'test1234', 'Sanjana Reddy', 'sreddy@example.com', '317-555-1004', '90 Maple Ave, Noblesville, IN', NULL),

('mjohnson', 'hello2024', 'Michael Johnson', 'mjohnson@example.com', '317-555-1005', '12 Pine St, Westfield, IN', NULL),

('sidk', 'NormalUser#1', 'Siddharth K', 'sidk@example.com', '317-555-1006', '200 Tech Park Blvd, Wabash, IN', NULL),

-- ⭐ New Students Below ⭐

('rthomas', 'rtpass2024', 'Rachel Thomas', 'rthomas@example.com', '317-555-1007', '55 Elm St, Greenwood, IN', NULL),

('dnguyen', 'dnsecure1', 'Duy Nguyen', 'dnguyen@example.com', '317-555-1008', '88 Willow Ct, Avon, IN', NULL),

('ksharma', 'ks2024!', 'Karan Sharma', 'ksharma@example.com', '317-555-1009', '140 Cedar Lane, Zionsville, IN', NULL),

('lmartin', 'lmWelcome#2', 'Laura Martin', 'lmartin@example.com', '317-555-1010', '300 Brookside Dr, Brownsburg, IN', NULL),

('hcho', 'hcPass321', 'Hannah Cho', 'hcho@example.com', '317-555-1011', '22 Birchwood Rd, Plainfield, IN', NULL),

('tgarcia', 'tgSecure99', 'Tomás Garcia', 'tgarcia@example.com', '317-555-1012', '500 Meadow Ridge, Lebanon, IN', NULL);

SELECT * FROM student;