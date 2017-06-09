package com.tpadsz.update.mvc.service;

import org.apache.commons.lang3.StringUtils;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

public class StringUtil {
	// Use SimpleDateFormat as a field is probable to cause some thread issues. It is suggested that use FastDateFormat which is part of apache common-lang instead. R.K. scripsit.
	private static SimpleDateFormat sdf = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private static SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");

	private static SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd");

	private static SimpleDateFormat sdf4 = new SimpleDateFormat(
			"yyyyMMddHHmmss");

	public static String valueOf(Object obj) {
		String str = (obj == null || "null".equalsIgnoreCase(obj.toString()
				.trim())) ? "" : obj.toString();
		return str;
	}

	public static boolean isValidFileName(String fileName) {
		if (fileName == null || fileName.length() > 255)
			return false;
		else if(fileName.length() == 1){
			return fileName
					.matches("^(\\x20|[^\\s\\\\/:\\*\\?\\\"<>\\|])$");
		}
		else
			return fileName
					.matches("[^\\s\\\\/:\\*\\?\\\"<>\\|](\\x20|[^\\s\\\\/:\\*\\?\\\"<>\\|])*[^\\s\\\\/:\\*\\?\\\"<>\\|\\.]$");
	}

	public static boolean isWordAndDotFileName(String fileName) {
		if (fileName == null || fileName.length() > 255)
			return false;
		else if(fileName.length() == 1){
			return fileName
					.matches("^[0-9a-zA-Z\\.]$");
		}
		else
			return fileName
					.matches("[^\\s\\\\/:\\*\\?\\\"<>\\|]([0-9a-zA-Z\\.])*[^\\s\\\\/:\\*\\?\\\"<>\\|\\.]$");
	}

	public static boolean isChnglishFileName(String fileName){
		if (fileName == null || fileName.length() > 255)
			return false;
		else if(fileName.length() == 1){
			return fileName
					.matches("^[0-9a-zA-Z\\u4e00-\\u9fa5\\.]$");
		}
		else
			return fileName
					.matches("[^\\s\\\\/:\\*\\?\\\"<>\\|]([0-9a-zA-Z\\u4e00-\\u9fa5\\.])*[^\\s\\\\/:\\*\\?\\\"<>\\|\\.]$");
	}

	public static Date stringToDate(String str) {
		if (StringUtils.isBlank(str)) {
			return null;
		}
		Date d = null;
		try {
			d = sdf.parse(str);
		} catch (ParseException e) {
			throw new RuntimeException("日期格式转换错误:" + str);
		}
		return d;
	}

	public static String dateToString(Date date) {
		if (date == null) {
			return " ";
		}
		return sdf.format(date);
	}

	public static Date stringToDateFullNumber(String str) {
		if (StringUtils.isBlank(str)) {
			return null;
		}
		Date d = null;
		try {
			d = sdf4.parse(str);
		} catch (ParseException e) {
			throw new RuntimeException("日期格式转换错误:" + str);
		}
		return d;
	}

	public static String dateToStringWithFullNumber(Date date) {
		// System.out.println("here");
		if (date == null) {
			return " ";
		}
		return sdf4.format(date);
	}

	public static String dateToStringWithDate(Date date) {
		if (date == null) {
			return null;
		}
		return sdf2.format(date);
	}

	public static String dateToStringWithNumber(Date date) {
		if (date == null) {
			return " ";
		}
		return sdf3.format(date);
	}

	public static Date stringToDateWithDate(String str) {
		if (StringUtils.isBlank(str)) {
			return null;
		}
		Date d = null;
		try {
			d = sdf2.parse(str);
		} catch (ParseException e) {
			// e.printStackTrace();
			throw new RuntimeException("日期格式转换错误");
		}
		return d;
	}

	public static Date stringToDateWithNumber(String str) {
		if (StringUtils.isBlank(str)) {
			return null;
		}
		Date d = null;
		try {
			d = sdf3.parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
			throw new RuntimeException("日期格式转换错误");
		}
		return d;
	}

	public static String getUUID() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}

	public static void main(String[] args) {
//		String a = "1c99329bc7a4426f83745856f77a7eb0";
		String a = "1c9939bc7a446f83745856f77a7eb0";

		System.out.println(a.length());


	}


	public static boolean isNumeric(String str){
		Pattern pattern = Pattern.compile("[0-9a-zA-Z]*");
		return pattern.matcher(str).matches();
	}


}