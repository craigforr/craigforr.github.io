---
draft: false
title: "Display Dates and Times with PowerShell"
slug: "display-dates-and-times-with-powershell"
date: "2018-04-20T00:00:00-05:00"
categories: ["Scripting"]
tags: ["powershell", "time"]
series: ["PowerShell Notebook"]

---

> [!NOTE] Last Revision: 2025-07-12

In the course of any given week, I find myself having to determine dates and times for future and past days, weeks, months --- even years.  PowerShell makes this extremely easy. In thise post, we'll discuss how... 

## Getting Dates and Times with PowerShell

First let's show how to get the current local time:

```powershell
Get-Date
```

You can display a different date and time by specifying it after `Get-Date` (as an unnamed parameter):

```powershell
Get-Date "December 21, 2012"
```

You can specify this in other formats as well:

```powershell
Get-Date "2012-12-21"
```

Or, using only part of a whole date and time:

```powershell
# When is Christmas this year?
Get-Date "December 25"
```

You can even specify it relative to the current date and time:

```powershell
# What is the date a week from today?
(Get-Date).AddDays(7)
```

Notice there that I had to wrap `Get-Date` in parentheses `()` in order to use the `AddDays`. By wrapping a command in parens, we can access its output object properties and methods interactively.

There are other methods we can use as well.  To find out what they are, we can either use tab completion...

```
(Get-Date).|
           ^ Press <TAB> multiple times to cycle through possibilities
```

Or, more directly, we can just look at the methods `Get-Date` lets us use:


```powershell
Get-Date | Get-Member -MemberType Method
```

Here is an excerpt of the output:

```nohighlight
   TypeName: System.DateTime

   Name                 MemberType Definition
   ----                 ---------- ----------
   Add                  Method     datetime Add(timespan value)
   AddDays              Method     datetime AddDays(double value)
   AddHours             Method     datetime AddHours(double value)
   AddMilliseconds      Method     datetime AddMilliseconds(double value)
   AddMinutes           Method     datetime AddMinutes(double value)
   AddMonths            Method     datetime AddMonths(int months)
   AddSeconds           Method     datetime AddSeconds(double value)
   AddTicks             Method     datetime AddTicks(long value)
   AddYears             Method     datetime AddYears(int value)
```

Now, if you're paying attention, you'll notice that there are no subtraction methods --- such as `.SubtractDays()`, for example.  How, then, do we get the date one week ago or the day 90 days from today?  We simply use negative numbers:

```powershell
# What is the date one week ago?
(Get-Date).AddDays(-7)

# What day was it 90 days ago?
(Get-Date).AddDays(-90)
```

I hope you find that helpful. In my next PowerShell tip, I'll show how to convert dates and times between time zones.

## Additional Reading

- Documentation: [Get-Date](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date "Get-Date - PowerShell")


