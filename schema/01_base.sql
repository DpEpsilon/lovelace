BEGIN;

CREATE TABLE IF NOT EXISTS _meta (
  version INTEGER PRIMARY KEY,
  ctime   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Update schema version
INSERT INTO _meta (version) VALUES (1);


CREATE TABLE access_sets (
    competitor INTEGER NOT NULL REFERENCES competitors(id),
    set        TEXT NOT NULL REFERENCES sets(name),
    granted    TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (competitor, set)
);

CREATE TABLE competitors (
    id             BIGSERIAL PRIMARY KEY,
    username       TEXT NOT NULL,
    password       TEXT NOT NULL,
    firstname      TEXT NOT NULL,
    lastname       TEXT NOT NULL,
    default_lang   TEXT REFERENCES languages(id),
    email          TEXT NOT NULL,
    school         TEXT NOT NULL,
    year           TEXT NOT NULL,
    phone          TEXT,
    address        TEXT,
    state          TEXT NOT NULL,
    country        TEXT NOT NULL,
    registered     TIMESTAMP WITH TIME ZONE NOT NULL,
    registered_ip  TEXT NOT NULL,
    approved       TIMESTAMP WITH TIME ZONE,
    approved_by    TEXT,
    last_seen      TIMESTAMP WITH TIME ZONE,
    last_submitted TIMESTAMP WITH TIME ZONE,
    full_access    BOOLEAN DEFAULT false,
    suspended      BOOLEAN DEFAULT false,
    show_done      BOOLEAN DEFAULT false,
    open_source    BOOLEAN DEFAULT true
);

CREATE TABLE problems (
    id    BIGSERIAL PRIMARY KEY,
    name  TEXT NOT NULL,
    title TEXT NOT NULL,
    files TEXT
);

CREATE TABLE set_contents (
    set      TEXT NOT NULL REFERENCES sets(name),
    problem  INTEGER NOT NULL REFERENCES problems(id),
    priority INTEGER,
    PRIMARY KEY (set, problem)
);

CREATE TABLE sets (
    name     TEXT PRIMARY KEY,
    title    TEXT NOT NULL,
    public   BOOLEAN DEFAULT false,
    priority INTEGER
);

CREATE TABLE access_prereqs (
    set         TEXT NOT NULL REFERENCES sets(name),
    requirement TEXT NOT NULL REFERENCES sets(name),
    percentage  INTEGER NOT NULL,
    PRIMARY KEY (set, requires)
);

CREATE TABLE fame_problems (
    problem INTEGER PRIMARY KEY REFERENCES problems(id),
    set     TEXT NOT NULL REFERENCES sets(name),
    type    TEXT DEFAULT 't' NOT NULL
);

CREATE TABLE languages (
    id   TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE notify_prereqs (
    set         TEXT NOT NULL REFERENCES sets(name),
    requirement TEXT NOT NULL REFERENCES sets(name),
    PRIMARY KEY (set, requires)
);

CREATE TABLE progress (
    competitor    INTEGER NOT NULL REFERENCES competitors(id),
    problem       INTEGER NOT NULL REFERENCES problems(id),
    viewed        TIMESTAMP WITH TIME ZONE NOT NULL,
    best_score    INTEGER,
    best_score_at TIMESTAMP WITH TIME ZONE,
    time_taken   INTEGER, -- milliseconds
    PRIMARY KEY (competitor, problem)
);

CREATE TABLE result_types (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    explanation TEXT
);

CREATE TABLE results (
    competitor INTEGER NOT NULL,
    problem    INTEGER NOT NULL,
    attempt    INTEGER NOT NULL,
    test_case  TEXT NOT NULL,
    result     TEXT NOT NULL REFERENCES result_types(id),
    mark       INTEGER NOT NULL,
    PRIMARY KEY (competitor, problem, attempt, testcase),
    FOREIGN KEY (competitor, problem, attempt)
        REFERENCES submissions(competitor, problem, attempt),
);

CREATE TABLE status_types (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    explanation TEXT
);

CREATE TABLE submissions (
    competitor     INTEGER NOT NULL REFERENCES competitors(id),
    problem        INTEGER NOT NULL REFERENCES problems(id),
    attempt        INTEGER NOT NULL,
    language       TEXT NOT NULL REFERENCES languages(id),
    status         TEXT REFERENCES status_types(id),
    submitted_file TEXT NOT NULL,
    created_at     TIMESTAMP WITH TIME ZONE NOT NULL,
    ip_address     TEXT,
    mark           INTEGER,
    comment        TEXT,
    judge_output   TEXT,
    PRIMARY KEY (competitor, problem, attempt)
);

CREATE TABLE watchers (
    competitor INTEGER NOT NULL REFERENCES competitors(id),
    email      TEXT NOT NULL,
    PRIMARY KEY (competitor, email)
);

COMMIT;
