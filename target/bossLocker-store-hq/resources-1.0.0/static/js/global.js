function getQueryString(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	var r = window.location.search.substr(1).match(reg);
	if (r != null) {
		return unescape(r[2]);
	}
	return null;
}

function getQueryStringUrl() {
	var url = location.search.split("?");
	return url[1];
}

function jump(href) {
	var qs = getQueryStringUrl();
	if (qs != undefined) {
		href += "?" + qs;
	}
	window.location.href = href;
}

function appendQueryString(href) {
	var qs = getQueryStringUrl();
	if (qs != undefined) {
		href += "?" + qs;
	}
	return href;
}

