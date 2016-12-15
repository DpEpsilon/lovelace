BEGIN;

CREATE TABLE IF NOT EXISTS _meta (
  version INTEGER PRIMARY KEY,
  ctime   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Update schema version
INSERT INTO _meta (version) VALUES (1);


CREATE TABLE access_sets (
    competitorid INTEGER NOT NULL REFERENCES competitors(id),
    set          TEXT NOT NULL REFERENCES sets(name),
    granted      TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (competitorid, set)
);

CREATE TABLE competitors (
    id            BIGSERIAL PRIMARY KEY,
    username      TEXT NOT NULL,
    password      TEXT NOT NULL,
    firstname     TEXT NOT NULL,
    lastname      TEXT NOT NULL,
    defaultlang   TEXT REFERENCES languages(id),
    email         TEXT NOT NULL,
    school        TEXT NOT NULL,
    year          TEXT NOT NULL,
    phone         TEXT,
    address       TEXT,
    state         TEXT NOT NULL,
    country       TEXT NOT NULL,
    registered    TIMESTAMP WITH TIME ZONE NOT NULL,
    registeredip  TEXT NOT NULL,
    approved      TIMESTAMP WITH TIME ZONE,
    approvedby    TEXT,
    lastseen      TIMESTAMP WITH TIME ZONE,
    lastsubmitted TIMESTAMP WITH TIME ZONE,
    fullaccess    BOOLEAN DEFAULT false,
    suspended     BOOLEAN DEFAULT false,
    optshowdone   BOOLEAN DEFAULT false,
    opensource    BOOLEAN DEFAULT true
);

CREATE TABLE problems (
    id    BIGSERIAL PRIMARY KEY,
    name  TEXT NOT NULL,
    title TEXT NOT NULL,
    files TEXT
);

CREATE TABLE set_contents (
    set       TEXT NOT NULL REFERENCES sets(name),
    problemid INTEGER NOT NULL REFERENCES problems(id),
    priority  INTEGER,
    PRIMARY KEY (set, problemid)
);

CREATE TABLE sets (
    name     TEXT PRIMARY KEY,
    title    TEXT NOT NULL,
    public   BOOLEAN DEFAULT false,
    priority INTEGER
);

CREATE TABLE access_prereqs (
    set        TEXT NOT NULL REFERENCES sets(name),
    requires   TEXT NOT NULL REFERENCES sets(name),
    percentage INTEGER NOT NULL,
    PRIMARY KEY (set, requires)
);

CREATE TABLE fame_problems (
    problemid INTEGER PRIMARY KEY REFERENCES problems(id),
    set       TEXT NOT NULL REFERENCES sets(name),
    type      TEXT DEFAULT 't' NOT NULL
);

CREATE TABLE languages (
    id   TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE notify_prereqs (
    set      TEXT NOT NULL REFERENCES sets(name),
    requires TEXT NOT NULL REFERENCES sets(name),
    PRIMARY KEY (set, requires)
);

CREATE TABLE progress (
    competitorid INTEGER NOT NULL REFERENCES competitors(id),
    problemid    INTEGER NOT NULL REFERENCES problems(id),
    viewed       TIMESTAMP WITH TIME ZONE NOT NULL,
    bestscore    INTEGER,
    bestscoreon  TIMESTAMP WITH TIME ZONE,
    time_taken   INTEGER, -- milliseconds
    PRIMARY KEY (competitorid, problemid)
);

CREATE TABLE result_types (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    explanation TEXT
);

CREATE TABLE results (
    competitorid INTEGER NOT NULL,
    problemid    INTEGER NOT NULL,
    attempt      INTEGER NOT NULL,
    testcaseid   TEXT NOT NULL,
    resultid     TEXT NOT NULL REFERENCES result_types(id),
    mark         INTEGER NOT NULL,
    PRIMARY KEY (competitorid, problemid, attempt, testcaseid),
    FOREIGN KEY (competitorid, problemid, attempt)
        REFERENCES submissions(competitorid, problemid, attempt),
);

CREATE TABLE status_types (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    explanation TEXT
);

CREATE TABLE submissions (
    competitorid   INTEGER NOT NULL REFERENCES competitors(id),
    problemid      INTEGER NOT NULL REFERENCES problems(id),
    attempt        INTEGER NOT NULL,
    languageid     TEXT NOT NULL REFERENCES languages(id),
    statusid       TEXT REFERENCES status_types(id),
    submitted_file TEXT NOT NULL,
    created_at     TIMESTAMP WITH TIME ZONE NOT NULL,
    ipaddress      TEXT,
    mark           INTEGER,
    comment        TEXT,
    judge          TEXT,
    PRIMARY KEY (competitorid, problemid, attempt)
);

CREATE TABLE watchers (
    competitorid INTEGER NOT NULL REFERENCES competitors(id),
    email        TEXT NOT NULL,
    PRIMARY KEY (competitorid, email)
);

COMMIT;
