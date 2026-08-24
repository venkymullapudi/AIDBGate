-- Demo dataset for the example policy (PostgreSQL dialect).
-- Mirrors examples/seed.sql but uses Postgres-native types. Two tenants —
-- 'acme' and 'globex' — so tenant row-scoping is observable end-to-end.

DROP TABLE IF EXISTS ticket_comments, tickets, invoices, customers CASCADE;

CREATE TABLE customers (
    id         integer PRIMARY KEY,
    tenant_id  text NOT NULL,
    name       text NOT NULL,
    email      text,
    ssn        text,            -- PII: redacted from support/billing agents
    plan       text
);

CREATE TABLE tickets (
    id          integer PRIMARY KEY,
    tenant_id   text NOT NULL,
    subject     text NOT NULL,
    status      text NOT NULL DEFAULT 'open',
    priority    text NOT NULL DEFAULT 'normal',
    customer_id integer
);

CREATE TABLE ticket_comments (
    id         integer PRIMARY KEY,
    tenant_id  text NOT NULL,
    ticket_id  integer NOT NULL,
    author     text NOT NULL,
    body       text NOT NULL
);

CREATE TABLE invoices (
    id           integer PRIMARY KEY,
    tenant_id    text NOT NULL,
    customer_id  integer NOT NULL,
    amount_cents integer NOT NULL,
    status       text NOT NULL DEFAULT 'due'
);

INSERT INTO customers (id, tenant_id, name, email, ssn, plan) VALUES
    (1, 'acme',   'Ada Lovelace', 'ada@acme.example',    '111-11-1111', 'pro'),
    (2, 'acme',   'Alan Turing',  'alan@acme.example',   '222-22-2222', 'free'),
    (3, 'globex', 'Grace Hopper', 'grace@globex.example','333-33-3333', 'enterprise');

INSERT INTO tickets (id, tenant_id, subject, status, priority, customer_id) VALUES
    (1, 'acme',   'Cannot log in',    'open', 'high',   1),
    (2, 'acme',   'Billing question', 'open', 'normal', 2),
    (3, 'globex', 'Feature request',  'open', 'low',    3);

INSERT INTO ticket_comments (id, tenant_id, ticket_id, author, body) VALUES
    (1, 'acme', 1, 'ada@acme.example', 'Still stuck on the login page.');

INSERT INTO invoices (id, tenant_id, customer_id, amount_cents, status) VALUES
    (1, 'acme',   1, 4900,  'due'),
    (2, 'acme',   2, 0,     'paid'),
    (3, 'globex', 3, 99000, 'due');
