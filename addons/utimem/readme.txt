Changelog:
v. 1 (05/11/2013)
- Properly handles loss of database connection
- Workaround for a rare case where the time would get saved after a player 
  joined but before the db responded, causing their time to reset to zero
- Brought back the utime_welcome cvar