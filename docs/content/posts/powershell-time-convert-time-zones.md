---
draft: false
title: "Convert Times Between Time Zones with PowerShell"
slug: "convert-times-between-time-zones-with-powershell"
date: "2018-04-25T17:00:00-05:00"
categories: ["Scripting"]
tags: ["powershell", "time"]
series: ["PowerShell Notebook"]

---

## Convert Time for different World Time Zone

> [!NOTE] Last Revision: 2025-07-12

If you work in a multinational organization like me or you have loved ones or friends who live in other parts of the country or world, then you have, no doubt, found yourself needing to convert time from one time zone to another.  In this post, I'm going to show you how to do this really easily in PowerShell.

### TL;DR

In a hurry?  Here's how to convert the current date and time from the local time zone to another one:

```powershell
# Convert the Local Date and Time to Greenwich Standard
[System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId( `
    (Get-Date), 'Greenwich Standard Time')
```

Where we have 'Greenwich Standard Time' here, you can put any time zone you wish and get the current time in that time zone (Note, too, that I have used the backtick (\`) to split this into two lines in order to make it easier to read, which you do not have to do).

We are essentially providing two date and time objects --- one to convert _from_, the other to convert _to:_

```powershell
# $convert_from and $to here must be PowerShell DateTime objects
[System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId( $convert_from , $to )
```

### Picking a Date and Time

Breaking it down, you first want to get the time to convert _from_, using the `Get-Date` command.  We'll call this the "input time" from now on.

```powershell
Get-Date
```

What if you want to use a different time then the current time though?  Well, the solution is as simple as giving `Get-Date` the time you want to use:

```powershell
Get-Date "2018-12-25 00:00"
```

### Choosing a Time Zone

Next, you want to determine the name of the time zone you are converting that input time _to_.  In my first example, I used "Greenwich Standard Time", but what about other time zones?  And how did I know that "Greenwich Standard Time" was a valid time zone anyway?

To list valid time zones, we can access the .Net [TimeZoneInfo Class][tzinfo-class], as follows:

```powershell
[System.TimeZoneInfo]::GetSystemTimeZones( )
```

This will output a list of time zones as objects.  Here is an example:

```nohighlight
Id                         : India Standard Time
DisplayName                : (UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi
StandardName               : India Standard Time
DaylightName               : India Daylight Time
BaseUtcOffset              : 05:30:00
SupportsDaylightSavingTime : False
```

Using this information, we can convert from the input time to whatever time zone we choose by using [TimeZoneInfo.ConvertTimeBySystemTimeZoneId Method][tz-method]:


```powershell
[System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId( `
    (Get-Date), 'India Standard Time')
#
# Example Output:
# 
# Tuesday, April 25, 2018 4:30:00 AM
```

`ConvertTimeBySystemTimeZoneId` uses the local system's time zone to determine the input time zone, since the output object of `Get-Date` does not have the `Kind` property and [the default is Unspecified][datetime-kind].  So, if we want to convert from a time zone different from the one our system is in, we need to do a bit more work...

### Converting Between Two Different Time Zones

First, we need time zone information for both the source and destination. We'll assign both of these to variable that we can use later:

```powershell
# Assign India time zone info to a variable
$intz = [System.TimeZoneInfo]::GetSystemTimeZones() | 
    Where-Object { $_.Id -match "India Standard" }

# Assign Eastern Australia time zone info to a variable
$autz = [System.TimeZoneInfo]::GetSystemTimeZones() |
    Where-Object { $_.Id -match "AUS Eastern" }
```

Next we need the date and time we would like to convert. We will use a string here, because we will be specifying the input time zone using the variables we just created:

```powershell
# This will work
$time_to_convert = "2018-12-25 00:00"

# This will also work
$time_to_convert = ((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss'))

# This will NOT work, because the string contains the local time zone
$time_to_convert = ((Get-Date).ToString('yyyy-MM-ddTHH:mm:ssz'))
#                                                           ^
# Note the `z` here tells the ToString method to include the 
# system's time zone offset, which will confuse ConvertTime()
# See the example, below...
```

Once we have an input time, input time zone, and output time zone, all that remains is to piece them all together in a call to `ConvertTime()`:

```powershell
[System.TimeZoneInfo]::ConvertTime( `
    "2018-12-25 00:00", $intz, $autz)

# Output:
#
# Tuesday, December 25, 2018 5:30:00 AM 
#
```

Remember earlier when we said adding `z` to the `ToString` formatting wouldn't work?  Here's the error you will get if you do:

```powershell
# This will NOT work, because the string contains the local time zone
$time_to_convert = '2018-12-25T00:00:00-4'

[System.TimeZoneInfo]::ConvertTime($time_to_convert, $intz, $autz)

#
# Output:
# 
# Exception calling "ConvertTime" with "3" argument(s): "The conversion could not be completed because the supplied DateTime did not have the Kind property set correctly.
# For example, when the Kind property is DateTimeKind.Local, the source time zone must be TimeZoneInfo.Local.
# Parameter name: sourceTimeZone"
# At line:1 char:1
# + [System.TimeZoneInfo]::ConvertTime( `
# + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : NotSpecified: (:) [], MethodInvocationException
#     + FullyQualifiedErrorId : ArgumentException
# 

# Here's the working example:
$time_to_convert = '2018-12-25T00:00:00'

[System.TimeZoneInfo]::ConvertTime($time_to_convert, $intz, $autz)

#
# Output:
# 
# Tuesday, December 25, 2018 5:30:00 AM
```

In the next post, we'll cover how to put all this together into a time zone converter that we can use to easily convert dates and times whenever we have  the need.

## Additional Reading

- Documentation: [TimeZoneInfo Class][tzinfo-class]
- Documentation: [TimeZoneInfo.ConvertTimeBySystemTimeZoneId Method][tz-method]
- Documentation: [DateTime.Kind Property][datetime-kind]

[tzinfo-class]: https://learn.microsoft.com/en-us/dotnet/api/system.timezoneinfo "TimeZoneInfo Class"
[tz-method]: https://learn.microsoft.com/en-us/dotnet/api/system.timezoneinfo.converttimebysystemtimezoneid "TimeZoneInfo.ConvertTimeBySystemTimeZoneId Method"
[datetime-kind]: https://learn.microsoft.com/en-us/dotnet/api/system.datetime.kind "DateTime.Kind Property"

