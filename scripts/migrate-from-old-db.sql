BEGIN;

CREATE TABLE IF NOT EXISTS _meta (
  version INTEGER PRIMARY KEY,
  ctime   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Update schema version
INSERT INTO _meta (version) VALUES (1);

-- Renaming
ALTER TABLE access_sets RENAME competitorid TO competitor;

ALTER TABLE competitors RENAME defaultlang TO default_lang;
ALTER TABLE competitors RENAME registeredip TO registered_ip;
ALTER TABLE competitors RENAME approvedby TO approved_by;
ALTER TABLE competitors RENAME lastseen TO last_seen;
ALTER TABLE competitors RENAME lastsubmitted TO last_submitted;
ALTER TABLE competitors RENAME fullaccess TO full_access;
ALTER TABLE competitors RENAME optshowdone TO show_done;
ALTER TABLE competitors RENAME opensource TO open_source;

ALTER TABLE set_contents RENAME problemid TO problem;
ALTER TABLE set_contents RENAME "order" TO priority;

ALTER TABLE fame_problems RENAME problemid TO problem;

ALTER TABLE notify_prereqs RENAME requires TO requirement;

ALTER TABLE progress RENAME competitorid TO competitor;
ALTER TABLE progress RENAME problemid TO problem;
ALTER TABLE progress RENAME bestscore TO best_score;
ALTER TABLE progress RENAME bestscoreon TO best_score_at;
ALTER TABLE progress RENAME "time" TO time_taken; --

ALTER TABLE results RENAME competitorid TO competitor;
ALTER TABLE results RENAME problemid TO problem;
ALTER TABLE results RENAME testcaseid TO test_case; --
ALTER TABLE results RENAME resultid TO "result";

ALTER TABLE submissions RENAME competitorid TO competitor;
ALTER TABLE submissions RENAME problemid TO problem;
ALTER TABLE submissions RENAME languageid TO "language";
ALTER TABLE submissions RENAME statusid TO status;
ALTER TABLE submissions RENAME "timestamp" TO "created_at";
ALTER TABLE submissions RENAME ipaddress TO ip_address;
ALTER TABLE submissions RENAME judge TO judge_output;

ALTER TABLE watchers RENAME competitorid TO competitor;

-- Altering types
ALTER TABLE access_sets
  ALTER competitor TYPE BIGINT,
  ALTER "set"      TYPE TEXT;

ALTER TABLE competitors
  ALTER id            TYPE BIGINT, -- BIGSERIAL?
  ALTER username      TYPE TEXT,
  ALTER password      TYPE TEXT,
  ALTER firstname     TYPE TEXT,
  ALTER lastname      TYPE TEXT,
  ALTER default_lang  TYPE TEXT,
  ALTER email         TYPE TEXT,
  ALTER school        TYPE TEXT,
  ALTER "year"        TYPE TEXT,
  ALTER phone         TYPE TEXT,
  ALTER address       TYPE TEXT,
  ALTER "state"       TYPE TEXT,
  ALTER country       TYPE TEXT,
  ALTER registered_ip TYPE TEXT,
  ALTER approved_by   TYPE TEXT;

ALTER TABLE problems
  ALTER id     TYPE BIGINT, -- BIGSERIAL?
  ALTER "name" TYPE TEXT,
  ALTER title  TYPE TEXT,
  ALTER files  TYPE TEXT;

ALTER TABLE set_contents
  ALTER "set"   TYPE TEXT,
  ALTER problem TYPE BIGINT;

ALTER TABLE sets
  ALTER name  TYPE TEXT,
  ALTER title TYPE TEXT;

ALTER TABLE access_prereqs
  ALTER "set"    TYPE TEXT,
  ALTER requires TYPE TEXT;

ALTER TABLE fame_problems
  ALTER problem TYPE BIGINT,
  ALTER "set"   TYPE TEXT,
  ALTER "type"  TYPE TEXT;

ALTER TABLE languages
  ALTER id     TYPE TEXT,
  ALTER "name" TYPE TEXT;

ALTER TABLE notify_prereqs
  ALTER "set"       TYPE TEXT,
  ALTER requirement TYPE TEXT;

ALTER TABLE progress
  ALTER competitor   TYPE BIGINT,
  ALTER problem      TYPE BIGINT,
  ALTER "time_taken" TYPE BIGINT USING (time_taken * 1000);

ALTER TABLE result_types
  ALTER id     TYPE TEXT,
  ALTER "name" TYPE TEXT;

ALTER TABLE results
  ALTER competitor TYPE BIGINT,
  ALTER problem    TYPE BIGINT,
  ALTER attempt    TYPE BIGINT,
  ALTER test_case  TYPE TEXT,
  ALTER "result"   TYPE TEXT;

ALTER TABLE status_types
  ALTER id     TYPE TEXT,
  ALTER "name" TYPE TEXT;

ALTER TABLE submissions
  ALTER competitor   TYPE BIGINT,
  ALTER problem      TYPE BIGINT,
  ALTER attempt      TYPE BIGINT,
  ALTER "language"   TYPE TEXT,
  ALTER status       TYPE TEXT,
  ALTER ip_address   TYPE TEXT,
  ALTER judge_output TYPE TEXT;

ALTER TABLE watchers
  ALTER competitor TYPE BIGINT,
  ALTER email      TYPE TEXT;

COMMIT;
