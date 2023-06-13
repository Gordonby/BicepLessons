param stringDataBase string = '1900-01-01 00:00:00'
param baseTime string = utcNow('u')

var addingTimeHour = dateTimeAdd(stringDataBase, 'PT9H' )
var addingTimeMin = dateTimeAdd(stringDataBase, 'PT45M' )
//var startTime = dateTimeAdd(stringDataBase, 'PT1H')

output hourOut string = addingTimeHour
output minOut string = addingTimeMin
