USE msdb;
GO

DECLARE @i int = 1;
DECLARE @jobName sysname;

WHILE @i <= 10
BEGIN
    SET @jobName = N'TestJob_' + CAST(@i AS nvarchar(10));

    EXEC dbo.sp_add_job
        @job_name = @jobName,
        @enabled = 1;

    EXEC dbo.sp_add_jobstep
        @job_name = @jobName,
        @step_name = N'Empty Step',
        @subsystem = N'TSQL',
        @database_name = N'master',
        @command = N'SELECT 1';

    SET @i += 1;
END
GO
