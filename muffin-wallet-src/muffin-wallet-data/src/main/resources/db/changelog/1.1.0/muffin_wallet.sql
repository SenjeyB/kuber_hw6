--liquibase formatted sql

-- changeset Koshkin George:14af988c-0326-4d02-8b16-57ca8c1deae7
alter table muffin_wallet add column type varchar;
--rollback --do-nothing
