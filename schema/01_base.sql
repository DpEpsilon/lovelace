-- Original PostgreSQL version: 8.4.22

-- TODO: Put constraints and sequences into the table definitions

CREATE TABLE access_sets (
    competitorid integer NOT NULL,
    set character varying(40) NOT NULL,
    granted timestamp with time zone,
    PRIMARY KEY (competitorid, set)
);

CREATE TABLE competitors (
    id SERIAL PRIMARY KEY,
    username character varying(15) NOT NULL,
    password character varying(15) NOT NULL,
    firstname character varying(40) NOT NULL,
    lastname character varying(40) NOT NULL,
    defaultlang character varying(10),
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
    set character varying(40) NOT NULL,
    problemid integer NOT NULL,
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
    set character varying(40) NOT NULL,
    requires character varying(40) NOT NULL,
    percentage integer NOT NULL,
    PRIMARY KEY (set, requires)
);

CREATE TABLE fame_problems (
    problemid integer PRIMARY KEY,
    set character varying(40) NOT NULL,
    type character(1) DEFAULT 't'::bpchar NOT NULL
);

CREATE TABLE languages (
    id character varying(10) PRIMARY KEY,
    name character varying(40) NOT NULL
);

CREATE TABLE notify_prereqs (
    set character varying(40) NOT NULL,
    requires character varying(40) NOT NULL,
    PRIMARY KEY (set, requires)
);

CREATE TABLE progress (
    competitorid integer NOT NULL,
    problemid integer NOT NULL,
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
    resultid character varying(10) NOT NULL,
    mark integer NOT NULL,
    PRIMARY KEY (competitorid, problemid, attempt, testcaseid)
);

CREATE TABLE status_types (
    id character varying(15) PRIMARY KEY,
    name character varying(255) NOT NULL,
    explanation text
);

CREATE TABLE submissions (
    competitorid integer NOT NULL,
    problemid integer NOT NULL,
    attempt integer NOT NULL,
    languageid character varying(10) NOT NULL,
    statusid character varying(15),
    submitted_file text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    ipaddress character varying(50),
    mark integer,
    comment text,
    judge text,
    PRIMARY KEY (competitorid, problemid, attempt)
);

CREATE TABLE watchers (
    competitorid integer NOT NULL,
    email character varying(255) NOT NULL,
    PRIMARY KEY (competitorid, email)
);

ALTER TABLE ONLY access_prereqs
    ADD CONSTRAINT access_prereqs_requires FOREIGN KEY (requires) REFERENCES sets(name);

ALTER TABLE ONLY access_prereqs
    ADD CONSTRAINT access_prereqs_set FOREIGN KEY (set) REFERENCES sets(name);

ALTER TABLE ONLY access_sets
    ADD CONSTRAINT access_sets_competitorid FOREIGN KEY (competitorid) REFERENCES competitors(id);

ALTER TABLE ONLY access_sets
    ADD CONSTRAINT access_sets_set FOREIGN KEY (set) REFERENCES sets(name);

ALTER TABLE ONLY competitors
    ADD CONSTRAINT competitors_defaultlang FOREIGN KEY (defaultlang) REFERENCES languages(id);

ALTER TABLE ONLY fame_problems
    ADD CONSTRAINT fame_problems_problemid FOREIGN KEY (problemid) REFERENCES problems(id);

ALTER TABLE ONLY fame_problems
    ADD CONSTRAINT fame_problems_set FOREIGN KEY (set) REFERENCES sets(name);

ALTER TABLE ONLY notify_prereqs
    ADD CONSTRAINT notify_prereqs_requires FOREIGN KEY (requires) REFERENCES sets(name);

ALTER TABLE ONLY notify_prereqs
    ADD CONSTRAINT notify_prereqs_set FOREIGN KEY (set) REFERENCES sets(name);

ALTER TABLE ONLY progress
    ADD CONSTRAINT progress_competitorid FOREIGN KEY (competitorid) REFERENCES competitors(id);

ALTER TABLE ONLY progress
    ADD CONSTRAINT progress_problemid FOREIGN KEY (problemid) REFERENCES problems(id);

ALTER TABLE ONLY results
    ADD CONSTRAINT results_attempt FOREIGN KEY (competitorid, problemid, attempt) REFERENCES submissions(competitorid, problemid, attempt);

ALTER TABLE ONLY results
    ADD CONSTRAINT results_resultid FOREIGN KEY (resultid) REFERENCES result_types(id);

ALTER TABLE ONLY set_contents
    ADD CONSTRAINT set_contents_problemid FOREIGN KEY (problemid) REFERENCES problems(id);

ALTER TABLE ONLY set_contents
    ADD CONSTRAINT set_contents_set FOREIGN KEY (set) REFERENCES sets(name);

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_competitorid FOREIGN KEY (competitorid) REFERENCES competitors(id);

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_languageid FOREIGN KEY (languageid) REFERENCES languages(id);

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_problemid FOREIGN KEY (problemid) REFERENCES problems(id);

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_statusid FOREIGN KEY (statusid) REFERENCES status_types(id);

ALTER TABLE ONLY watchers
    ADD CONSTRAINT watchers_competitorid FOREIGN KEY (competitorid) REFERENCES competitors(id);
