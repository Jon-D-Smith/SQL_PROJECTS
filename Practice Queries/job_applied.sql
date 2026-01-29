CREATE TABLE job_applied (
    job_id INT,
    application_spent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);


INSERT INTO
    job_applied(
        job_id,
        application_spent_date,
        custom_resume,
        resume_file_name,
        cover_letter_sent,
        cover_letter_file_name,
        status
    )
VALUES
    (
        1,
        '2025-12-31',
        true,
        'resume_1.pdf',
        true,
        'cover_letter_01.pdf',
        'submitted'
    ),(
        2,
        '2026-01-01',
        true,
        'resume_12.pdf',
        true,
        'cover_letter_sent.pdf',
        'denied'
    ),(
        3,
        '2026-01-02',
        true,
        'resume_1.pdf',
        false,
        NULL,
        'IN REVIEW'
    );

SELECT
    *
FROM
    job_applied;

ALTER TABLE job_applied
ADD contact VARCHAR(50);

ALTER TABLE job_applied
RENAME COLUMN application_spent_date TO application_sent_date;


UPDATE job_applied
SET contact = 'Erlich Bachman'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Dinesh Chugtaia'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Bertman Gilfoyle'
WHERE job_id = 3;


SELECT
    *
FROM
    job_applied;


ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;


ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;


ALTER TABLE job_applied
DROP COLUMN contact_name;

DROP TABLE job_applied;