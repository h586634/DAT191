DROP TABLE IF EXISTS members_organisations;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS organisations;
DROP TABLE IF EXISTS password_reset;
DROP TABLE IF EXISTS members;
DROP TYPE IF EXISTS member_permission;

-- *** MEMBER STUFF *** --
CREATE TYPE member_permission AS ENUM ('admin', 'verified', 'unverified');
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(32) NOT NULL,
    email VARCHAR(64) NOT NULL UNIQUE,
    username VARCHAR(16) NOT NULL, -- may be ommitted
    password TEXT NOT NULL,
    permission member_permission NOT NULL

    --password. Looking for necessary specs for SHA3-256
    --salt? -||-
    --link to character table for character settings per member
);

CREATE TABLE organisations (
    organisation_id SERIAL PRIMARY KEY,
    organisation_name VARCHAR(64) NOT NULL,
	fk_leader INTEGER,
    FOREIGN KEY(fk_leader) REFERENCES members(member_id) ON DELETE CASCADE
);

CREATE TABLE members_organisations (
    member_id INTEGER,
    organisation_id INTEGER,
    PRIMARY KEY(member_id, organisation_id),
    FOREIGN KEY(member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY(organisation_id) REFERENCES organisations(organisation_id) ON DELETE CASCADE
);

-- *** FILE STUFF *** --
CREATE TABLE documents(
    document_id SERIAL PRIMARY KEY,
    document_name VARCHAR(64) NOT NULL,
    document_description TEXT,
    public BOOLEAN NOT NULL,
    owner INTEGER NOT NULL,
    filename VARCHAR(64) NOT NULL,
    fileref VARCHAR(100) NOT NULL, 
    FOREIGN KEY(owner) REFERENCES members(member_id) ON DELETE CASCADE

    --categorisation! IMPORTANT, hear with users.
    --Should contain more metadata, publish date for example.
    --constraint for organisation??? Guessing it breaks the normalization, however, it may significantly increase query performance.
);

CREATE TABLE password_reset
(
	timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	reset_key CHAR(20) PRIMARY KEY, -- Must match passwordResetKeyLength in app.config
	email VARCHAR(64),
    FOREIGN KEY(email) REFERENCES members(email) ON DELETE CASCADE
);

-- *** GENERATING EXAMPLE ENTRIES *** --
INSERT INTO members (first_name, last_name, email, username, password, permission)
VALUES ('Test', 'Testy', 'test@test.test', 'tester', '$2b$10$6ODjd7kCmvzZ0tmoOr.hk.QOR13zTFcXdFMtOP4P40IDkrAX0D2Iu', 'admin'),
    ('Trond', 'Hauge', 'member@member.member', 'Tdog', '$2b$10$6ODjd7kCmvzZ0tmoOr.hk.QOR13zTFcXdFMtOP4P40IDkrAX0D2Iu', 'verified'),
    ('John', 'Smith', 'name@domain', 'Johnny', '$2b$10$6ODjd7kCmvzZ0tmoOr.hk.QOR13zTFcXdFMtOP4P40IDkrAX0D2Iu', 'unverified'),
	('Oliver', 'OLoughlin', 'oliveroloughlin@hotmail.com', 'olli', '$2b$10$6ODjd7kCmvzZ0tmoOr.hk.QOR13zTFcXdFMtOP4P40IDkrAX0D2Iu', 'admin'),
    ('Maria', 'Alme', 'mana@hvl.no', 'Mana', '$2b$10$vVzerBMt0s1FQqXxE4xmIea6skKQ7uas2f/GNuT.lLUDqiisjtLpu', 'admin'),
    ('Clark', 'Nowack', 'clark.nowack@han.nl', 'Clark', '$2b$10$nUMQlVqedCZIjCcRtbznmufk3.2i6PuJ6W1lB7mCq.Vy89hXL2NtW', 'admin');

INSERT INTO organisations(organisation_name, fk_leader)
VALUES ('HAN University of Applied Sciences', 6),
    ('Western Norway University of Applied Sciences', 5),
    ('University of Zaragoza', 1),
    ('Arcada University', 1),
    ('Humanity and Inclusion', 1),
    ('Center for Victims of Torture', 1);

INSERT INTO members_organisations (member_id, organisation_id)
VALUES (1, 3),
    (2,2),
    (3,4),
	(4,2),
	(5,2),
    (6,1);

INSERT INTO documents (document_name, document_description, public, filename, fileref, owner)
VALUES ('Document 1', 'Hocus, pocus. Avada kadavra.', true, 'Document.pdf', 'Document.pdf', 1),
    ('Document 2', 'Blablabla, testign testing, another test, hello there yes you hi', true, 'Document.pdf', 'Document.pdf', 3),
    ('Simple PDF', 'Yet another entry of this fine PDF example.', true, 'Document.pdf', 'Document.pdf', 2),
    ('A Document Of Great Importance', 'Should be first in sorted list. This is a test document, and this is the description. A document description may be quite long, perhaps over 100 characters. Therefore it might be desireable to cut the contents when displayed on the website in a card. Maybe this limit should be at about 200 characters, but that is why we have this test', true, 'Document.pdf', 'Document.pdf', 4),
    ('File copy 1', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 1),
    ('File copy 2', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 2),
    ('File copy 3', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 3),
    ('File copy 4', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 4),
    ('File copy 4', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 5),
    ('File copy 5', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 6),
    ('File copy 6', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 1),
    ('File copy 7', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 2),
    ('File copy 8', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 3),
    ('File copy 9', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 4),
    ('File copy 10', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 5),
    ('File copy 12', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 6),
    ('File copy 13', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 1),
    ('File copy 14', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 2),
    ('File copy 15', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 3),
    ('File copy 16', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 4),
    ('File copy 17', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 5),
    ('File copy 18', 'This is a copy of a file. There are many files like this indeed. We need them to do some testing. Help us test some html and css styling.', true, 'Document.pdf', 'Document.pdf', 6);
	