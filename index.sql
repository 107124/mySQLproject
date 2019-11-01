USE university_schema;

INSERT INTO courses (course_subject, course_professor_id)
VALUES ("math", 2);

INSERT INTO grades (grades_score, grade_course_id, grade_student_id)
VALUES (90, 1, 1); 

BEGIN;
INSERT grades (student_first_name)
VALUES ("Steve");

INSERT grades (grades_score, grade_course_id, grade_student_id)
VALUES (3.2, 4, 4);

ROLLBACK;

DELETE FROM courses
WHERE course_id = 4;

DESC grades;

SET SQL_SAFE_UPDATES = 0;
    
SELECT MAX(grades_score)
FROM grades;
SELECT *
FROM students;

SELECT *
from students, grades;

SELECT *
FROM students, grades;

SELECT *
FROM grades
WHERE grades_score IN (
  SELECT grades_score
  FROM grades
  WHERE grades_score < 60
);

SELECT *
FROM addresses
WHERE addresses_city IN ('Manhattan', 'Queens');

INSERT INTO grades(grades_score, grade_course_id, grade_student_id)
VALUES(11,(SELECT course_id FROM courses WHERE course_subject = 'biotech' LIMIT 1), 4);

SELECT grade_student_id
FROM grades
WHERE grades_score = (
  SELECT MAX(CAST(grades_score AS UNSIGNED))
  FROM grades
);

SELECT grades.grade_id, students.student_first_name
FROM grades
INNER JOIN students
ON grade_id = students.student_id;

-- Finding which student and professor have the most courses in common
SELECT COUNT(*), student_first_name AS "student", professor_last_name AS "Professor"
FROM students
JOIN professors
ON professors.professor_id = student_id
GROUP BY student_first_name, professor_last_name;

-- group students in courses that they are enrolled in 
SELECT student_first_name AS "Student", course_subject AS "Enrolled Course"
FROM courses
JOIN students
ON  courses.course_id = student_id
GROUP BY student_first_name, course_subject;

/*column name we need the average grade given by each professor*/
SELECT professor_last_name AS "Teacher", AVG(grades_score) AS "Average Grade"
FROM grades
JOIN professors
ON  grades.grade_course_id = professor_id
GROUP BY professor_last_name;

-- Create a summary report of courses and their average grades, sorted by the most challenging course 
-- (course with the lowest average grade) to the easiest course 
SELECT course_subject AS "Class", AVG(grades_score) AS "Average Grade"
FROM grades
JOIN courses
ON  grades.grade_course_id = course_id
GROUP BY course_subject
ORDER BY course_subject DESC;

-- find the max grade for each student 
SELECT student_first_name AS "Student", MAX(grades_score) AS "Top Grade"
FROM grades
JOIN students
ON  grades.grade_student_id = student_id
GROUP BY student_first_name;


-- All the tables -->
ALTER TABLE `university_schema`.`grades` 
DROP FOREIGN KEY `grade_course_id`;
ALTER TABLE `university_schema`.`grades` 
ADD CONSTRAINT `grade_course_id`
  FOREIGN KEY (`grade_course_id`)
  REFERENCES `university_schema`.`courses` (`course_id`)
  ON DELETE CASCADE
  ON UPDATE RESTRICT;

  ALTER TABLE `university_schema`.`courses` 
DROP FOREIGN KEY `course_professor_id`;
ALTER TABLE `university_schema`.`courses` 
ADD CONSTRAINT `course_professor_id`
  FOREIGN KEY (`course_professor_id`)
  REFERENCES `university_schema`.`professors` (`professor_id`)
  ON DELETE CASCADE
  ON UPDATE RESTRICT;

ALTER TABLE `university_schema`.`professors`;

ALTER TABLE `university_schema`.`students` 
CHANGE COLUMN `student_first_name` `student_first_name` VARCHAR(45) NOT NULL ;

