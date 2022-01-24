DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS organisations;
DROP TABLE IF EXISTS members;

-- *** MEMBER STUFF *** --
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(32) NOT NULL,
    email VARCHAR(64) NOT NULL UNIQUE,
    username VARCHAR(16) NOT NULL, -- may be ommitted
    password TEXT NOT NULL,
    admin BOOLEAN NOT NULL
    --password. Looking for necessary specs for SHA3-256
    --salt? -||-
    --link to character table for character settings per member
);

CREATE TABLE organisations (
    organisation_id SERIAL PRIMARY KEY,
    organisation_name VARCHAR(64) NOT NULL,
	fk_leader SERIAL REFERENCES members(member_id)
);

-- *** FILE STUFF *** --
CREATE TABLE documents(
    document_id SERIAL PRIMARY KEY,
    document_name VARCHAR(128) NOT NULL,
    document_description TEXT,
    shared BOOLEAN NOT NULL,
    owner INTEGER,
    FOREIGN KEY(owner) REFERENCES members(member_id)

	-- SERIAL REFERENCES members(member_id)
	
    --categorisation! IMPORTANT, hear with users.
    --constraint for organisation??? Guessing it breaks the normalization, however, it may significantly increase query performance.
);

-- *** GENERATING EXAMPLE ENTRIES *** --
INSERT INTO members (first_name, last_name, email, username, password, admin)
VALUES ('Test', 'Testy', 'test@test.test', 'tester', '$2b$10$6ODjd7kCmvzZ0tmoOr.hk.QOR13zTFcXdFMtOP4P40IDkrAX0D2Iu', true),
    ('Tronny', 'Hilly', 'member@member.member', 'Tdog', '$2b$10$6ODjd7kCmvzZ0tmoOr.hk.QOR13zTFcXdFMtOP4P40IDkrAX0D2Iu', false);

INSERT INTO documents (document_name, document_description, shared, owner)
VALUES ('Document 1', 'Hocus, pocus', true, 1),
    ('Document', 'Blablabla', true, 2),
    ('Doc Oc', 'This doc is verry oc', false, 1),
    ('Adoc', 'Should be first in sorted list', true, 2);
