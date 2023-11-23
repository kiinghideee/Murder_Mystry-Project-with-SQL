SELECT *
FROM crime_scene_report
WHERE type = 'murder' AND city = 'SQL City' AND date = 20180115;

-- description Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". 
--The second witness, named Annabel, lives somewhere on "Franklin Ave".

SELECT name, id, address_number
from person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number desC 
LIMIT 1;

-- first witnes is Morty Schspiro with Id number 14887

SELECT *
FROM person
WHERE name LIKE 'Annabel%' AND address_street_name = 'Franklin Ave'

-- 2nd witness is Annabel Miller with id number 16371


SELECT *
FROM interview
where person_id = 14887 OR person_id = 16371
-- First witnes; I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". 
--Only gold members have those bags. The man got into a car with a plate that included "H42W".
-- Second witness;I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
CREATE TEMP TABLE suspect1 AS
SELECT get_fit_now_member.person_id, person.name
from get_fit_now_member
JOIN person
ON get_fit_now_member.person_id = person.id
JOIN drivers_license
ON person.license_id = drivers_license.id
where get_fit_now_member.id LIKE '48Z%' AND get_fit_now_member.membership_status = 'gold' AND drivers_license.plate_number LIKE '%H42W%'

CREATE temp TABLE suspect2 as
SELECT person_id, name
from get_fit_now_check_in
JOIN get_fit_now_member
on get_fit_now_check_in.membership_id = get_fit_now_member.id
WHERE check_in_date = 20180109

SELECT *
from suspect2
JOIN suspect1
ON suspect2.person_id = suspect1.person_id

-- Suspect according to the witness statements is Jeremy Bowers with Id 67318

INSERT INTO solution (user, value)
VALUES (67318, 'Jeremy Bowers')

SELECT *
FROM interview
where person_id = 67318
--I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. 
--I know that she attended the SQL Symphony Concert 3 times in December 2017.
CREATE TEMP TABLE ds1 AS
SELECT ps.name, ps.id, ps.ssn FROM drivers_license AS ds 
JOIN person AS ps ON ds.id = ps.license_id
JOIN income AS ic ON ps.ssn = ic.ssn
WHERE  height BETWEEN 65 AND 67 AND car_make = 'Tesla' And car_model = 'Model S' AND gender = 'female' AND ic.annual_income > 53257

-- 2nd clue
CREATE TEMP TABLE ds2 AS
SELECT person_id
FROM facebook_event_checkin
where event_name = 'SQL Symphony Concert' AND date LIKE '201712%'
GROUP BY person_id
HAVING COUNT(person_id) = 3;

SELECT person_id, name, ssn FROM ds1
JOIN ds2 On ds1.id = ds2.person_id

-- THe details of suspect who hired the jerem bowers;
-- ID             SSN              NAME             
-- 99716       987756388         Miranda Priestly    