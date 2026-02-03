--liquibase formatted sql

--changeset Koshkin George:1d682896-3de3-48a9-9fb4-b568939abeaf
alter table muffin_transaction add column currency decimal;
--rollback  --do-nothing