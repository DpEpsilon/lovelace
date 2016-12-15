BEGIN;

CREATE TABLE IF NOT EXISTS _meta (
  version INTEGER PRIMARY KEY,
  ctime   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Update schema version
INSERT INTO _meta (version) VALUES (1);


CREATE TABLE access_sets (
    competitorid INTEGER NOT NULL REFERENCES competitors(id),
    set          VARCHAR(40) NOT NULL REFERENCES sets(name),
    granted      TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (competitorid, set)
);

CREATE TABLE competitors (
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(15) NOT NULL,
    password      VARCHAR(15) NOT NULL,
    firstname     VARCHAR(40) NOT NULL,
    lastname      VARCHAR(40) NOT NULL,
    defaultlang   VARCHAR(10) REFERENCES languages(id),
    email         VARCHAR(255) NOT NULL,
    school        VARCHAR(255) NOT NULL,
    year          VARCHAR(10) NOT NULL,
    phone         VARCHAR(40),
    address       VARCHAR(512),
    state         VARCHAR(15) NOT NULL,
    country       VARCHAR(255) NOT NULL,
    registered    TIMESTAMP WITH TIME ZONE NOT NULL,
    registeredip  VARCHAR(50) NOT NULL,
    approved      TIMESTAMP WITH TIME ZONE,
    approvedby    VARCHAR(15),
    lastseen      TIMESTAMP WITH TIME ZONE,
    lastsubmitted TIMESTAMP WITH TIME ZONE,
    fullaccess    BOOLEAN DEFAULT false,
    suspended     BOOLEAN DEFAULT false,
    optshowdone   BOOLEAN DEFAULT false,
    opensource    BOOLEAN DEFAULT true
);

CREATE TABLE problems (
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(40) NOT NULL,
    title VARCHAR(255) NOT NULL,
    files VARCHAR(255)
);

CREATE TABLE set_contents (
    set       VARCHAR(40) NOT NULL REFERENCES sets(name),
    problemid INTEGER NOT NULL REFERENCES problems(id),
    "order"   INTEGER,
    PRIMARY KEY (set, problemid)
);

CREATE TABLE sets (
    name     VARCHAR(40) PRIMARY KEY,
    title    VARCHAR(255) NOT NULL,
    public   BOOLEAN DEFAULT false,
    priority INTEGER
);

CREATE TABLE access_prereqs (
    set        VARCHAR(40) NOT NULL REFERENCES sets(name),
    requires   VARCHAR(40) NOT NULL REFERENCES sets(name),
    percentage INTEGER NOT NULL,
    PRIMARY KEY (set, requires)
);

CREATE TABLE fame_problems (
    problemid INTEGER PRIMARY KEY REFERENCES problems(id),
    set       VARCHAR(40) NOT NULL REFERENCES sets(name),
    type      CHAR(1) DEFAULT 't'::bpchar NOT NULL
);

CREATE TABLE languages (
    id   VARCHAR(10) PRIMARY KEY,
    name VARCHAR(40) NOT NULL
);

CREATE TABLE notify_prereqs (
    set      VARCHAR(40) NOT NULL REFERENCES sets(name),
    requires VARCHAR(40) NOT NULL REFERENCES sets(name),
    PRIMARY KEY (set, requires)
);

CREATE TABLE progress (
    competitorid INTEGER NOT NULL REFERENCES competitors(id),
    problemid    INTEGER NOT NULL REFERENCES problems(id),
    viewed       TIMESTAMP WITH TIME ZONE NOT NULL,
    bestscore    INTEGER,
    bestscoreon  TIMESTAMP WITH TIME ZONE,
    "time"       REAL,
    PRIMARY KEY (competitorid, problemid)
);

CREATE TABLE result_types (
    id          VARCHAR(10) PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    explanation TEXT
);

CREATE TABLE results (
    competitorid INTEGER NOT NULL,
    problemid    INTEGER NOT NULL,
    attempt      INTEGER NOT NULL,
    testcaseid   VARCHAR(40) NOT NULL,
    resultid     VARCHAR(10) NOT NULL REFERENCES result_types(id),
    mark         INTEGER NOT NULL,
    PRIMARY KEY (competitorid, problemid, attempt, testcaseid),
    CONSTRAINT results_attempt FOREIGN KEY (competitorid, problemid, attempt)
        REFERENCES submissions(competitorid, problemid, attempt),
);

CREATE TABLE status_types (
    id          VARCHAR(15) PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    explanation TEXT
);

CREATE TABLE submissions (
    competitorid   INTEGER NOT NULL REFERENCES competitors(id),
    problemid      INTEGER NOT NULL REFERENCES problems(id),
    attempt        INTEGER NOT NULL,
    languageid     VARCHAR(10) NOT NULL REFERENCES languages(id),
    statusid       VARCHAR(15) REFERENCES status_types(id),
    submitted_file TEXT NOT NULL,
    "timestamp"    TIMESTAMP WITH TIME ZONE NOT NULL,
    ipaddress      VARCHAR(50),
    mark           INTEGER,
    comment        TEXT,
    judge          TEXT,
    PRIMARY KEY (competitorid, problemid, attempt)
);

CREATE TABLE watchers (
    competitorid INTEGER NOT NULL REFERENCES competitors(id),
    email        VARCHAR(255) NOT NULL,
    PRIMARY KEY (competitorid, email)
);

COMMIT;
