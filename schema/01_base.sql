BEGIN;

CREATE TABLE IF NOT EXISTS _meta (
  version INTEGER PRIMARY KEY,
  ctime   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Update schema version
INSERT INTO _meta (version) VALUES (1);


CREATE TABLE access_sets (
    competitorid integer NOT NULL REFERENCES competitors(id),
    set character varying(40) NOT NULL REFERENCES sets(name),
    granted timestamp with time zone,
    PRIMARY KEY (competitorid, set)
);

CREATE TABLE competitors (
    id SERIAL PRIMARY KEY,
    username character varying(15) NOT NULL,
    password character varying(15) NOT NULL,
    firstname character varying(40) NOT NULL,
    lastname character varying(40) NOT NULL,
    defaultlang character varying(10) REFERENCES languages(id),
    email character varying(255) NOT NULL,
    school character varying(255) NOT NULL,
    year character varying(10) NOT NULL,
    phone character varying(40),
    address character varying(512),
    state character varying(15) NOT NULL,
    country character varying(255) NOT NULL,
    registered timestamp with time zone NOT NULL,
    registeredip character varying(50) NOT NULL,
    approved timestamp with time zone,
    approvedby character varying(15),
    lastseen timestamp with time zone,
    lastsubmitted timestamp with time zone,
    fullaccess boolean DEFAULT false,
    suspended boolean DEFAULT false,
    optshowdone boolean DEFAULT false,
    opensource boolean DEFAULT true
);

CREATE TABLE problems (
    id SERIAL PRIMARY KEY,
    name character varying(40) NOT NULL,
    title character varying(255) NOT NULL,
    files character varying(255)
);

CREATE TABLE set_contents (
    set character varying(40) NOT NULL REFERENCES sets(name),
    problemid integer NOT NULL REFERENCES problems(id),
    "order" integer,
    PRIMARY KEY (set, problemid)
);

CREATE TABLE sets (
    name character varying(40) PRIMARY KEY,
    title character varying(255) NOT NULL,
    public boolean DEFAULT false,
    priority integer
);

CREATE TABLE access_prereqs (
    set character varying(40) NOT NULL REFERENCES sets(name),
    requires character varying(40) NOT NULL REFERENCES sets(name),
    percentage integer NOT NULL,
    PRIMARY KEY (set, requires)
);

CREATE TABLE fame_problems (
    problemid integer PRIMARY KEY REFERENCES problems(id),
    set character varying(40) NOT NULL REFERENCES sets(name),
    type character(1) DEFAULT 't'::bpchar NOT NULL
);

CREATE TABLE languages (
    id character varying(10) PRIMARY KEY,
    name character varying(40) NOT NULL
);

CREATE TABLE notify_prereqs (
    set character varying(40) NOT NULL REFERENCES sets(name),
    requires character varying(40) NOT NULL REFERENCES sets(name),
    PRIMARY KEY (set, requires)
);

CREATE TABLE progress (
    competitorid integer NOT NULL REFERENCES competitors(id),
    problemid integer NOT NULL REFERENCES problems(id),
    viewed timestamp with time zone NOT NULL,
    bestscore integer,
    bestscoreon timestamp with time zone,
    "time" real,
    PRIMARY KEY (competitorid, problemid)
);

CREATE TABLE result_types (
    id character varying(10) PRIMARY KEY,
    name character varying(255) NOT NULL,
    explanation text
);

CREATE TABLE results (
    competitorid integer NOT NULL,
    problemid integer NOT NULL,
    attempt integer NOT NULL,
    testcaseid character varying(40) NOT NULL,
    resultid character varying(10) NOT NULL REFERENCES result_types(id),
    mark integer NOT NULL,
    PRIMARY KEY (competitorid, problemid, attempt, testcaseid),
    CONSTRAINT results_attempt FOREIGN KEY (competitorid, problemid, attempt)
        REFERENCES submissions(competitorid, problemid, attempt),
);

CREATE TABLE status_types (
    id character varying(15) PRIMARY KEY,
    name character varying(255) NOT NULL,
    explanation text
);

CREATE TABLE submissions (
    competitorid integer NOT NULL REFERENCES competitors(id),
    problemid integer NOT NULL REFERENCES problems(id),
    attempt integer NOT NULL,
    languageid character varying(10) NOT NULL REFERENCES languages(id),
    statusid character varying(15) REFERENCES status_types(id),
    submitted_file text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    ipaddress character varying(50),
    mark integer,
    comment text,
    judge text,
    PRIMARY KEY (competitorid, problemid, attempt)
);

CREATE TABLE watchers (
    competitorid integer NOT NULL REFERENCES competitors(id),
    email character varying(255) NOT NULL,
    PRIMARY KEY (competitorid, email)
);

COMMIT;
