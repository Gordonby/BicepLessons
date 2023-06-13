param bigNumberToFormat int = 9000
param smallNumberToFormat int = 9

output commaTest string = format('Formatted number: {0:N0}', bigNumberToFormat)
output padNumber string = padLeft(smallNumberToFormat, 2, '0')
