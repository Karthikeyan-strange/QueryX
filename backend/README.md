# QueryX database module

Spring Boot 3.5 / Java 21 / PostgreSQL / Flyway / Spring Data JPA database layer only.

## Configuration
Set `DB_URL`, `DB_USERNAME`, and `DB_PASSWORD`. Hibernate is validation-only (`ddl-auto=validate`); Flyway owns schema creation.

## Run
From this directory, run `mvn spring-boot:run` after setting the three environment variables. Flyway applies `src/main/resources/db/migration/V1__create_initial_schema.sql`, then Hibernate validates the mappings.

`sql/sample_data.sql` is intentionally separate from Flyway so sample rows are never inserted automatically. Apply it only in a development database. `sql/verification_queries.sql` contains table, foreign-key, relationship, and constraint verification queries.

## Design approval assumptions
See `Database-design.md`. The primary open decision is whether the proposed domain attributes and response-parent model match the intended business rules. No REST APIs, services, security, frontend integration, or AI code is included.
