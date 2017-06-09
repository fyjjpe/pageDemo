package com.tpadsz.update.mvc.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {
    public static String format(Date date, String pattern) {
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        return format.format(date);
    }

    public static Date parse(String date, String pattern) throws ParseException {
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        return format.parse(date);
    }

    public static Date getPerDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.DAY_OF_MONTH,
                calendar.get(Calendar.DAY_OF_MONTH) - 1);
        return calendar.getTime();
    }

    public static Date getNextDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.DAY_OF_MONTH,
                calendar.get(Calendar.DAY_OF_MONTH) + 1);
        return calendar.getTime();
    }

    public static Date getPerMonthDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH) - 1);
        return calendar.getTime();
    }

    public static Date getNextMonthDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH) + 1);
        return calendar.getTime();
    }

    public static Date getPerWeekDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 7);
        return calendar.getTime();
    }
}

