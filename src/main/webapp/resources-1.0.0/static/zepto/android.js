$(function() {
	var a = new SQ.LoadMore({
		eventType : "click",
		triggerTarget : window,
		ajaxBox : ".J_ajaxWrap",
		stateBox : ".J_scrollLoadMore",
		stateStyle : "load-btn",
		startPageIndex : 2,
		scrollMaxPage : 0,
		loadingTip : "正在加载请稍后...",
		initTips : "点击加载更多",
		clickTips : "点击加载更多",
		loadedError : "加载错误请重试"
	});
	$(".go-top").click(function(b) {
		b.preventDefault();
		window.scrollTo(0, 0)
	})
});
var SQ = SQ || {};
(function(b, a) {
	function c(d) {
		var e = this;
		e.config = d;
		e.$triggerTarget = b(e.config.triggerTarget);
		e.$ajaxBox = b(e.config.ajaxBox);
		e.$stateBox = b(e.config.stateBox).addClass(e.config.stateStyle).text(
				e.config.initTips);
		e.api = e.$stateBox.attr("data-api");
		e.page = e.config.startPageIndex || 0;
		e.maxPage = e.config.scrollMaxPage + e.page;
		e.currentState = "none";
		e._init()
	}
	c.prototype = {
		constructor : c,
		_init : function() {
			var d = this;
			if (d.$triggerTarget.length > 0 && d.$ajaxBox.length > 0
					&& d.$stateBox.length > 0) {
				d._bind(d.$stateBox, d.config.eventType)
			}
		},
		_bind : function(e, d) {
			var f = this;
			e.bind(d, function() {
				f._trigger(d)
			})
		},
		_unbind : function(e, d) {
			e.unbind(d)
		},
		_trigger : function(f) {
			var h = this;
			var e = h.api.indexOf("?") === -1 ? "?" : "&";
			var d = h.$stateBox.hasClass("J_loading");
			var g = h.$stateBox.hasClass("J_noMore");
			if (d && g) {
				return

			}
			if (f === "click") {
				h._loadDate(h.api + h.page + '.json')
			}
		},
		_changeState : function(e) {
			var d = this;
			if (d.currentState === e) {
				return
			}
			d.currentState = e;
			if (d.config.eventType === "click") {
				switch (e) {
				case "loading":
					d.$stateBox.addClass("J_loading").show().text(
							d.config.loadingTip);
					break;
				case "loaded":
					d.$stateBox.removeClass("J_loading").text(
							d.config.clickTips);
					d.page += 1;
					break
				}
			}
			switch (e) {
			case "noMore":
				d.$stateBox.addClass("J_noMore").text("已经到底了");
				break;
			case "loadedError":
				d.$stateBox.removeClass("J_loading").text(d.config.loadedError);
				break;
			case "unknowError":
				d.$stateBox.removeClass("J_loading").text("未知错误，请重试");
				break
			}
		},
		_loadDate : function(d) {
			var f = this;
			f._changeState("loading");
			var e = b.ajax({
				type : "POST",
				url : d,
				timeout : 5000,
				success : function(g) {
					f._render(g)
				},
				error : function() {
					f._changeState("loadedError")
				}
			})
		},
		_render : function(g) {
			var f = this;
			var d = typeof g === "string" ? b.parseJSON(g) : g;
			var e = parseInt(d.code, 10);
			switch (e) {
			case 200:
				f.$ajaxBox.append(d.data);
				f._changeState("loaded");
				break;
			case 900:
				f.$ajaxBox.append(d.data);
				f._changeState("noMore");
				break;
			default:
				f._changeState("unknowError")
			}
		}
	};
	SQ.LoadMore = c
}(Zepto, window));
$(document).ready(function() {
	$(".toggle-btn").bind("click", function() {
		var c = $(this);
		var b = c.prev();
		var d = b.height();
		a(b, c, d)
	});
	$(".J_info").each(function() {
		var c = $(this);
		var d = c.height();
		var b = $(this).next();
		a(c, b, d)
	});
	function a(d, c, e) {
		if (e > 86) {
			b()
		} else {
			if (e == 86) {
				d.height("auto");
				c.addClass("arr-d")
			} else {
				c.hide()
			}
		}
		function b() {
			d.height("86px");
			c.removeClass("arr-d");
			c.show()
		}
	}
});
function goDownload(b, a) {
	$.ajax({
		type : "POST",
		url : "log/log!saveDownload.action?id=" + b + "&${queryString}",
		dataType : "text",
		data : {
			queryString : a,
			cs : "${queryString}"
		},
		complete : function() {
			location.href = a
		}
	});
	return false
};