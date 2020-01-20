SELECT changed_date,
       salary_changed,
       CASE
           WHEN salary_changed = 'No' THEN summed
           ELSE current_salary
       END AS 'current_salary',
       previous_salary,
	    total_hrs,
       last_worked,
       worked_hrs
FROM
  (SELECT MAX(changed_date) AS changed_date,
          CASE
              WHEN COUNT(*) > 1 THEN 'Yes'
              ELSE 'No'
          END AS salary_changed,
          SUM(new_salary) AS summed,

     (SELECT TOP 1 new_salary
      FROM salary AS my_sal
      WHERE my_sal.e_id = e.e_id
      ORDER BY my_sal.new_salary DESC) AS current_salary,
          CASE
              WHEN COUNT(*) > 1 THEN
                     (SELECT TOP 1 *
                      FROM
                        (SELECT TOP 2 new_salary
                         FROM salary AS my_sal
                         WHERE my_sal.e_id = e.e_id
                         ORDER BY my_sal.new_salary DESC) AS something
                      ORDER BY new_salary ASC)
          END AS previous_salary,

     (SELECT SUM(end_hrs)
      FROM attendance
      WHERE e.e_id = attendance.e_id
      GROUP BY attendance.e_id) AS total_hrs,

     (SELECT activity_desc
      FROM activity
      WHERE ac_id =
          (SELECT TOP 1 ac_id
           FROM attendance
           WHERE attendance.e_id=e.e_id
           ORDER BY CONVERT(datetime, logtime) DESC) ) AS last_worked,

     (SELECT TOP 1 end_hrs
      FROM attendance
      WHERE attendance.e_id=e.e_id
      ORDER BY CONVERT(datetime, logtime) DESC) AS worked_hrs
   FROM emp AS e
   LEFT JOIN attendance ON e.e_id = attendance.e_id
   LEFT JOIN salary ON e.e_id = salary.e_id
   GROUP BY e.e_id,
            e.f_name,
            e.m_name)s1;