create database healthcare;
use healthcare;
select * from health_care;
alter table healthcare_dataset rename health_care;
SET SQL_SAFE_UPDATES = 0;
UPDATE health_care SET `Date of Admission` = STR_TO_DATE(`Date of Admission`, '%d-%m-%Y');
UPDATE health_care SET `Discharge Date` = STR_TO_DATE(`Discharge Date`, '%d-%m-%Y');

ALTER TABLE health_care MODIFY COLUMN `Date of Admission` DATE;
ALTER TABLE health_care MODIFY COLUMN `Discharge Date` DATE;

SET SQL_SAFE_UPDATES = 1; -- turn safety back on
-- 1. Counting total records in the database
select count(*) as total_records from health_care;
-- 2. Finding the maximum age of a patient admitted
select max(age) as maximum_age from health_care;
-- 3. Finding the average age of hospitalized patients
select round(avg(age)) as average_age from health_care;
-- 4. Calculating patients hospitalized age-wise from maximum to minimum
select age, count(age) from health_care group by age order by  age desc;
-- 5. Calculating the maximum count of patients based on total patients hospitalized with respect to age
select count(*) as total, age from health_care group by age order by total desc ,age desc;
-- 6. Ranking age based on the number of patients hospitalized
select age, count(*)as total, dense_rank() over (order by count(*) desc , age desc) as age_rank from health_care group by age ;
-- 7. Finding the count of medical conditions of patients and listing them by the maximum number of patients
select `Medical Condition`,count(*) as patients from health_care group by `Medical Condition` order by patients desc ;
-- 8. Finding the rank and maximum number of medicines recommended to patients based on their medical condition
SELECT `Medical Condition`, `Medication`, COUNT(*) AS Total_Medications_to_Patients, RANK() OVER(PARTITION BY `Medical Condition` ORDER BY COUNT(*) DESC) AS Rank_Medicine FROM health_care GROUP BY `Medical Condition`, `Medication` ORDER BY `Medical Condition`;
-- 9. Identifying the most preferred insurance provider by hospitalized patients.
select `insurance provider`, count(*) as most_insurence from health_care group by `insurance provider`order by most_insurence desc;
-- 10. Identifying the most preferred hospital.
select hospital , count(*) as most_preffered from health_care group by hospital order by most_preffered desc;
-- 11. Identifying the average billing amount by medical condition.
select `medical condition`, round(avg(`billing amount`),2) as avg_bill from health_care group by `medical condition` order by avg_bill desc;
-- 12. Finding the billing amount of admitted patients and the number of days spent in their respective hospital.
SELECT `Name`,
    `Hospital`,
    `Billing Amount`,
    `Date of Admission`,
    `Discharge Date`,
    DATEDIFF(`Discharge Date`, `Date of Admission`) AS Number_of_Days
FROM health_care
ORDER BY Number_of_Days desc; 

-- 13. Finding the total number of days spent by a patient in a hospital for a given medical condition.
SELECT`Medical Condition`,DATEDIFF(`Discharge Date`, `Date of Admission`) AS Number_of_Days,`Hospital` FROM health_care ORDER BY Number_of_Days desc; 

-- 14. Finding hospitals successful in discharging patients with 'Normal' test results, along with the count of days taken
select hospital ,`test results`, count(*) as successful, round(avg(DATEDIFF(`Discharge Date`, `Date of Admission`))) as number_days
 from health_care where `test results`= 'Normal' group by hospital order by successful desc;
 
-- 15. Calculating the number of blood types of patients aged between 20 and 45
select`blood type`, count(`blood type`) as blood_types from health_care where age between 20 and 45 group by `blood type`; 

-- 16. Finding how many patients are universal blood donors (`O-`) and universal blood receivers (`AB+`)
select (select count(*) from health_care where `blood type` = 'O-') as unoiversal_blood_donor, (select count(*)from health_care where `blood type`='AB+') as universal_blood_receivers;
select `blood type` , count(*) as total from health_care where `blood type` in ('o-','ab+') group by `blood type`;

-- 17. Creating a procedure (`Blood_Matcher`) to find a universal blood donor for a universal blood receiver, prioritizing the same hospital
DELIMITER $$
 
CREATE PROCEDURE Blood_Matcher(IN Name_of_patient VARCHAR(200))
BEGIN 
SELECT D.Name as Donor_name, D.Age as Donor_Age, D.`Blood type` as Donors_Blood_type,D.Hospital as Donors_Hospital, 
R.Name as Reciever_name, R.Age as Reciever_Age, R.`Blood type` as Recievers_Blood_type, R.Hospital as Receivers_hospital
FROM Health_care D 
INNER JOIN Health_care R ON (D.`Blood type`= 'O-' AND R.`Blood type` = 'AB+') AND ((D.Hospital = R.Hospital) OR (D.Hospital != R.Hospital))
WHERE (R.Name REGEXP Name_of_patient) AND (D.AGE BETWEEN 20 AND 40);
END $$
DELIMITER ;
CALL Blood_Matcher('Matthew Cruz'); 

-- 18. Providing a list of hospitals along with the count of patients admitted in the years 2024 and 2025
SELECT DISTINCT Hospital,YEAR(`Date of Admission`) as admission_year, Count(*) as Total_Admitted
FROM health_care
WHERE YEAR(`Date of Admission`) IN (2024, 2025)
GROUP BY Hospital,YEAR(`Date of Admission`)
ORDER by Total_Admitted,admission_year DESC;

-- 19. Finding the average, minimum, and maximum billing amount for each insurance provider
SELECT 
    `insurance provider`,
    ROUND(AVG(`billing amount`), 2) AS avg_amount,
    ROUND(MIN(`billing amount`), 2) AS minimum_amount,
    ROUND(MAX(`billing amount`), 2) AS max_amount
FROM
    health_care
GROUP BY `insurance provider`;
 
-- 20. Creating a new column categorizing patients as high, medium, or low risk based on their medical condition and test results
alter table health_care add column risk_category varchar(20);
SELECT Name, `Medical Condition`, `Test Results`,
CASE 
		WHEN `Test Results` = 'Inconclusive' THEN 'medium risk'
        WHEN `Test Results` = 'Normal' THEN 'low risk' 
        WHEN `Test Results` =  'Abnormal' THEN 'high risk'
        END AS 'Srisk_category', Hospital
FROM Health_care;

-- 21. Finding the total number of patients for each blood group
select `blood type`, count(*) as total_number from health_care group by `blood type`;

-- 22. Calculating the total billing amount by each insurance provider
select `insurance provider`, round(sum(`billing amount`),2) as total_bill from health_care group by `insurance provider`; 