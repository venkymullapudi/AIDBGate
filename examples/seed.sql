-- Demo dataset for the example policy (SQLite dialect).
-- Two tenants — 'acme' and 'globex' — so tenant row-scoping is observable:
-- the ACME support agent must never see a globex row.

CREATE TABLE customers (
    id        INTEGER PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    name      TEXT NOT NULL,
    email     TEXT,
    ssn       TEXT,            -- PII: redacted from support/billing agents
    plan      TEXT
);

CREATE TABLE tickets (
    id         INTEGER PRIMARY KEY,
    tenant_id  TEXT NOT NULL,
    subject    TEXT NOT NULL,
    status     TEXT NOT NULL DEFAULT 'open',
    priority   TEXT NOT NULL DEFAULT 'normal',
    customer_id INTEGER
);

CREATE TABLE ticket_comments (
    id         INTEGER PRIMARY KEY,
    tenant_id  TEXT NOT NULL,
    ticket_id  INTEGER NOT NULL,
    author     TEXT NOT NULL,
    body       TEXT NOT NULL
);

CREATE TABLE invoices (
    id         INTEGER PRIMARY KEY,
    tenant_id  TEXT NOT NULL,
    customer_id INTEGER NOT NULL,
    amount_cents INTEGER NOT NULL,
    status     TEXT NOT NULL DEFAULT 'due'
);

INSERT INTO customers (id, tenant_id, name, email, ssn, plan) VALUES
    (1, 'acme',   'Ada Lovelace',   'ada@acme.example',   '111-11-1111', 'pro'),
    (2, 'acme',   'Alan Turing',    'alan@acme.example',  '222-22-2222', 'free'),
    (3, 'globex', 'Grace Hopper',   'grace@globex.example','333-33-3333','enterprise');

INSERT INTO tickets (id, tenant_id, subject, status, priority, customer_id) VALUES
    (1, 'acme',   'Cannot log in',        'open',     'high',   1),
    (2, 'acme',   'Billing question',     'open',     'normal', 2),
    (3, 'globex', 'Feature request',      'open',     'low',    3);

INSERT INTO ticket_comments (id, tenant_id, ticket_id, author, body) VALUES
    (1, 'acme',   1, 'ada@acme.example', 'Still stuck on the login page.');

INSERT INTO invoices (id, tenant_id, customer_id, amount_cents, status) VALUES
    (1, 'acme',   1, 4900, 'due'),
    (2, 'acme',   2, 0,    'paid'),
    (3, 'globex', 3, 99000,'due');
