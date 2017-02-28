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

--                           id      name
INSERT INTO languages VALUES('cpp',  'C++');
INSERT INTO languages VALUES('pas',  'Pascal');
INSERT INTO languages VALUES('caml', 'Caml');
INSERT INTO languages VALUES('c',    'C');
INSERT INTO languages VALUES('hs',   'Haskell');
INSERT INTO languages VALUES('zip',  'Zip archive');
INSERT INTO languages VALUES('py',   'Python');
INSERT INTO languages VALUES('php',  'PHP');
INSERT INTO languages VALUES('java', 'Java');

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

--                               id            name                 explanation
INSERT INTO result_types VALUES ('ok',         'Ok',                'The program produced an output file which was evaluated');
INSERT INTO result_types VALUES ('timeout',    'Timeout',           'The program exceeded the time limit allocated for that problem.');
INSERT INTO result_types VALUES ('noout',      'No output file',    'The program did not produce an output file.');
INSERT INTO result_types VALUES ('emptyout',   'Empty output file', 'The program produced an empty output file.');
INSERT INTO result_types VALUES ('crash',      'Crashed',           'The program crashed, and whatever output it did manage to produce scored zero.');
INSERT INTO result_types VALUES ('outofmem',   'Out of memory',     'The program exceeded the memory limit allocated for that problem.');
INSERT INTO result_types VALUES ('unsafe',     'Unsafe program',    'The program executed an unsafe or malicious function call.');
INSERT INTO result_types VALUES ('blockingio', 'Blocking I/O',      'The program would have blocked on I/O (e.g., reading from standard input when I/O files should be used).');

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

--                               id             name                                        explanation
INSERT INTO status_types VALUES ('ok',          'Submission OK',                            'Submission OK');
INSERT INTO status_types VALUES ('iopath',      'Uses I/O Path',                            'Submissions should not use path names when accessing I/O files.  Instead they should simply read from and write to files in the current directory.  For instance, if the output file is named ''test.out'' then you should simply open ''test.out'', not ''c:\test.out'' or ''../test.out''.');
INSERT INTO status_types VALUES ('apppath',     'VB: Uses App.Path',                        'The App.Path variable is used in this submission.  Since you should not be using path names when accessing I/O files, this will almost certainly cause the submission to score zero.');
INSERT INTO status_types VALUES ('nosubmain',   'VB: Missing Sub ''main''',                 'All Visual Basic submissions must be run from the routine ''sub main''.  Forms or other graphical user interface components must not be used.');
INSERT INTO status_types VALUES ('nosolnclass', 'Java: No ''Solution'' Class',              'All Java submissions must be contained in a single class called ''Solution''.');
INSERT INTO status_types VALUES ('nojavamain',  'Java: Missing/Incorrect ''main'' Routine', 'All Java submissions must be run from the routine ''public static void main(String[] args)'' within the class ''Solution''.');
INSERT INTO status_types VALUES ('noiofiles',   'Missing I/O Filenames',                    'The input and/or output filenames for this problem appear to be missing from the source file.  Since all input in the problem must come from the input file(s) and all output must go to the output file(s), this will almost certainly cause the submission to score zero.  Please note that filenames are case sensitive.');

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
