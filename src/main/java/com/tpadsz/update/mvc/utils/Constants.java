package com.tpadsz.update.mvc.utils;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;

public class Constants {
	private Properties pro;
	private InputStreamReader instream;

	public void init() throws IOException,FileNotFoundException{
		pro=new Properties();
		instream=new InputStreamReader(this.getClass().getClassLoader().getResourceAsStream("setup.demo.properties"),"UTF-8");

		if(instream !=null){
			pro.load(instream);
		}else{
			throw new FileNotFoundException("property file not found in the classpath");
		}
	}

	public static final String BACKGROUND_ENCRPTION_KEY = "encrypted";

	public String getLdapUrl(){
		return pro.getProperty("ldapUrl");
	}

	public String getBasedn(){
		return pro.getProperty("basedn");
	}

	public String getRoot(){
		return pro.getProperty("root");
	}

	public String getAdPassword(){
		return pro.getProperty("adPassword");
	}

	public String getUploadPath() { return pro.getProperty("uploadPath");}

	public String getAaptPath() { return pro.getProperty("aaptPath");}

	public String getDownPath() { return pro.getProperty("downPath");}

}
