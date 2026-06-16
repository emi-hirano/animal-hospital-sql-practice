USE animal_hospital;
-- 問1
SELECT pet_name,species,breed FROM pets ORDER BY pet_name;

-- 問2
SELECT pets.pet_name,pets.species,owners.owner_name
FROM pets
JOIN owners
ON pets.owner_id = owners.owner_id;

-- 問3
SELECT visits.visited_at,
	   pets.pet_name,
	   doctors.doctor_name,
	   visits.symptom,
	   visits.diagnosis
FROM visits
JOIN doctors
ON visits.doctor_id = doctors.doctor_id
JOIN pets
ON visits.pet_id = pets.pet_id
ORDER BY visits.visited_at DESC;

-- 問4
SELECT COUNT(species) AS counter,species
FROM pets
GROUP BY species
ORDER BY counter DESC,species;

-- 問5
SELECT pets.pet_name,
	pets.species
FROM pets
LEFT JOIN visits
ON pets.pet_id = visits.pet_id
WHERE visits.pet_id is NULL;

-- 問6
SELECT 
    pets.pet_name AS pet_name,
    COUNT(visits.pet_id) AS COUNTER
FROM 
    pets
LEFT JOIN 
	visits
ON pets.pet_id = visits.pet_id
GROUP BY 
    pets.pet_id, pets.pet_name
ORDER BY COUNTER DESC,pets.pet_name;

-- 問7
SELECT 
    p.pet_name AS pet_name,
    COUNT(v.pet_id) AS COUNTER
FROM 
    pets p
JOIN 
	visits v
ON p.pet_id = v.pet_id
GROUP BY
	p.pet_name
HAVING COUNT(v.pet_id) >= 2
ORDER BY COUNTER DESC;

-- 問8
SELECT d.doctor_name,
	d.specialty,
	COUNT(v.doctor_id) AS COUNTER
FROM
	doctors d
LEFT JOIN
	visits v
ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_name,d.specialty
ORDER BY COUNTER DESC,d.doctor_name;

-- 問9
SELECT 
    v.visit_id AS 診察ID,
    v.visited_at AS 診察日,
    p.pet_name AS ペット名,
    v.consultation_fee AS 診察料,
    SUM(t.actual_price * t.quantity) AS 処置費,
    v.consultation_fee + SUM(t.actual_price * t.quantity) AS 合計金額
FROM 
    visits v
JOIN 
    pets p ON v.pet_id = p.pet_id
LEFT JOIN 
    visit_treatments t ON v.visit_id = t.visit_id
GROUP BY 
    v.visit_id, 
    v.visited_at, 
    p.pet_name, 
    v.consultation_fee
ORDER BY 
    合計金額 DESC;

-- 問10
SELECT 
    o.owner_name AS 飼い主名,
    COUNT(v_total.visit_id) AS 診察回数,
    SUM(v_total.each_visit_total) AS 支払総額
FROM 
    owners o
JOIN 
    (
        SELECT 
            p.owner_id,
            v.visit_id AS visit_id,
            v.visited_at AS 診察日,
            p.pet_name AS ペット名,
            v.consultation_fee AS 診察料,
            SUM(t.actual_price * t.quantity) AS 処置費,
            v.consultation_fee + SUM(t.actual_price * t.quantity) AS each_visit_total
        FROM 
            visits v
        JOIN 
            pets p ON v.pet_id = p.pet_id
        LEFT JOIN 
            visit_treatments t ON v.visit_id = t.visit_id
        GROUP BY 
            p.owner_id,
            v.visit_id, 
            v.visited_at, 
            p.pet_name, 
            v.consultation_fee
    ) v_total ON o.owner_id = v_total.owner_id
GROUP BY 
    o.owner_id, o.owner_name
HAVING 
    SUM(v_total.each_visit_total) >= 15000
ORDER BY 
    支払総額 DESC;