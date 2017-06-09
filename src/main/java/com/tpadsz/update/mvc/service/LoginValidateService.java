package com.tpadsz.update.mvc.service;

import com.tpadsz.update.mvc.utils.Constants;
import org.springframework.stereotype.Service;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.Control;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
import java.io.IOException;
import java.util.Hashtable;

@Service("LoginValidateService")
public class LoginValidateService {
	
//	private final String URL = "ldap://10.132.53.209:389/";
//	private final String BASEDN = "ou=苏州天平先进科技有限公司,dc=tpadsz,dc=cn";
//	private final String ldapAccount = "ldap";
//	private final String ldapPwd = "h57E5fSEsD&OQm&B";
//	private final String FACTORY = "com.sun.jndi.ldap.LdapCtxFactory";
	private String URL;
	private String BASEDN;
	private String ldapAccount;
	private String ldapPwd;
	private final String FACTORY = "com.sun.jndi.ldap.LdapCtxFactory";

	LdapContext ctx = null;
	private final Control[] connCtls = null;
	private SearchResult si = null;
	public String msg = null;

	public LoginValidateService() throws IOException {
		Constants constants = new Constants();
		constants.init();

		this.URL = constants.getLdapUrl();
		this.BASEDN = constants.getBasedn();
		this.ldapAccount = constants.getRoot();
		this.ldapPwd = constants.getAdPassword();
	}

	private void ldapConnect() {
		Hashtable<String, String> env = new Hashtable<String, String>();
		env.put(Context.INITIAL_CONTEXT_FACTORY, FACTORY);
		env.put(Context.PROVIDER_URL, URL + BASEDN);
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.SECURITY_PRINCIPAL, ldapAccount);
		env.put(Context.SECURITY_CREDENTIALS, ldapPwd);
		try {
			ctx = new InitialLdapContext(env, connCtls);
		} catch (Exception e) {
			System.out.println("连接失败！" + e.toString());
			e.printStackTrace();
		}
	}

	private void closeContext() {
		if (ctx != null) {
			try {
				ctx.close();
			} catch (NamingException e) {
				e.printStackTrace();
			}
		}
	}

	private String getUserDN(String uid) {
		ldapConnect();
		String userDN = "";
		try {
			SearchControls constraints = new SearchControls();
			constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);
			constraints.setReturningAttributes(null);
			NamingEnumeration<SearchResult> en = ctx.search("",
					"sAMAccountName=" + uid, constraints);
			if (en == null || !en.hasMoreElements()) {
				msg = "该用户不存在！";
				return null;
			}
			while (en != null && en.hasMoreElements()) {
				Object obj = en.nextElement();
				if (obj instanceof SearchResult) {
					si = (SearchResult) obj;
					userDN += si.getName();
					userDN += "," + BASEDN;

				} else {
					System.out.println(obj);
				}
			}
		} catch (Exception e) {
			msg = "查询用户时异常！";
			e.printStackTrace();
		}
		return userDN;
	}

	public String authenricate(String user, String password) {
		String userRealName = "";
		String userDN = getUserDN(user);
		if (userDN != null) {
			try {
				ctx.addToEnvironment(Context.SECURITY_PRINCIPAL, userDN);
				ctx.addToEnvironment(Context.SECURITY_CREDENTIALS, password);
				ctx.reconnect(connCtls);
				userRealName = si.getName().split(",")[0].split("=")[1];
				String attr = si.getAttributes().get("memberof").toString();
				if (!attr.contains("padsz_update_web")) {
					msg = "权限不足,请找管理员开通权限";
					return null;
				}
			} catch (Exception e) {
				msg = "用户名或密码错误！";
				return null;
			}
		}
		closeContext();
		return userRealName;
	}
}
