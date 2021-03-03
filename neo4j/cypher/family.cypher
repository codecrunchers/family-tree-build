MATCH (n) DETACH DELETE n;

LOAD  CSV WITH HEADERS
FROM "file:///family.csv" AS row
WITH row WHERE (row.full_name IS NOT NULL) and (row.gender = "male") 
MERGE (:male:Person {person_id:toInteger(row.person_id), placeOfBirth:coalesce(row.place_of_birth, "unknown") , fullName:row.full_name, dob:coalesce(row.dob, "unknown"), dod: coalesce(row.dod, "unknown"), gender:coalesce(row.gender, "unknown")});

LOAD  CSV WITH HEADERS
FROM "file:///family.csv" AS row
WITH row WHERE (row.full_name IS NOT NULL) and (row.gender = "female") 
MERGE (:female:Person {person_id:toInteger(row.person_id), placeOfBirth:coalesce(row.place_of_birth, "unknown") , fullName:row.full_name, dob:coalesce(row.dob, "unknown"), dod: coalesce(row.dod, "unknown"), gender:coalesce(row.gender, "unknown")});

CREATE INDEX FOR (m:male) On (m.person_id);
CREATE INDEX FOR (m:male) On (m.fullName);

CREATE INDEX FOR (f:female) On (f.person_id);
CREATE INDEX FOR (f:female) On (f.fullName);

LOAD  CSV WITH HEADERS
FROM "file:///relationships.csv" AS row
MATCH (m{person_id:toInteger(row.id_male)}),(w{person_id:toInteger(row.id_female)})
CREATE (m)-[:IS_MAN_OF]->(r:relationship {id:toInteger(row.rel_id)})<-[:IS_WOMAN_OF]-(w);

LOAD  CSV WITH HEADERS
FROM "file:///children.csv" AS row
MATCH (p{person_id:toInteger(row.person_id)}) , (r{id:toInteger(row.rel_id)})
CREATE (p)-[:CHILD_OF]->(r);

match (child)-[:CHILD_OF]->(rel:relationship)-[:IS_MAN_OF]-(father:male),
(rel)<-[:IS_WOMAN_OF]-(mother:female)
create (mother)-[:MOTHER_OF]->(child)<-[:FATHER_OF]-(father);

