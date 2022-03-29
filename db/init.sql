create table books
(
    title text not null,
    id    serial
        constraint books_pk
            primary key
);

alter table books
    owner to postgres;

create table users
(
    password text not null,
    username text constraint users_pk primary key
);

alter table users
    owner to postgres;
