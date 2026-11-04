SELECT
    j.name AS JobName,
    h.run_date,
    h.run_time,
    h.message
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobhistory h
    ON j.job_id = h.job_id
WHERE h.step_id = 0
  AND h.run_status = 0
  AND h.instance_id IN
  (
      SELECT MAX(instance_id)
      FROM msdb.dbo.sysjobhistory
      GROUP BY job_id
  )
ORDER BY h.run_date DESC, h.run_time DESC;