DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id             SERIAL      NOT NULL,
    username       TEXT UNIQUE NOT NULL,
    hashedPassword TEXT        NOT NULL,
    salt           TEXT        NOT NULL,
    primary key (id)
);

DROP TABLE IF EXISTS _authtoken;
CREATE TABLE _authtoken
(
    id             SERIAL NOT NULL,
    code           TEXT UNIQUE,
    accessToken    TEXT UNIQUE,
    refreshToken   TEXT UNIQUE,
    scope          TEXT,
    issueDate      TIMESTAMP,
    expirationDate TIMESTAMP,
    resourceOwner  INT    NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    client         INT    NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    type           TEXT,
    primary key (id)
);

DROP TABLE IF EXISTS notes;
CREATE TABLE notes
(
    id        SERIAL NOT NULL,
    title     TEXT   NOT NULL,
    content   TEXT   NOT NULL,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP,
    owner_id  INT    NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    primary key (id)
);
