CREATE TABLE IF NOT EXISTS user_levels (
    id text,
    create_date text,
    update_date text,
    world integer,
    state text,
    star integer,
    score integer,
    PRIMARY KEY('id')
);

CREATE TABLE IF NOT EXISTS eggs (
    id text,
    create_date text,
    update_date text,
    species_id integer,
    state text,
    start_time text,
    hatch_time text,
    PRIMARY KEY('id')
);

CREATE TABLE IF NOT EXISTS dinosaur (
    id text,
    create_date text,
    update_date text,
    species_id integer,
    name text,
    hunger integer,
    happiness integer,
    PRIMARY KEY('id')
);

CREATE TABLE IF NOT EXISTS sanctuary (
    id text,
    create_date text,
    update_date text,
    dino_id integer,
    time_im integer,
    status text,
    PRIMARY KEY('id')
);
