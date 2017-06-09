$(function(){

//	对cic进行验证
	$('#text1').focus(function(){
		if($('#text1').val()=='账号'){
			$('#text1').val("");
		}
	});
	$('#text1').blur(function(){
		if($('#text1').val()==''){
			$('#text1').val("账号");
		}
		
	});
	
	
	$('#password1').focus(function(){
		$('#password1').hide();
		$('#password2').show().focus();
		
	});
	$('#password2').focus(function(){
		if($('#password2').val()!=''){
			$('#password2').show();	
		}
		
		});
	$('#password2').blur(function(){
		if($('#password2').val()!=''){
			$('#password2').show();	
		}else{
			$('#password2').hide();
			$('#password1').show();
		}	
	});
	
//	$(document).click(function(){
//		$('#warningmsg').html('');
//	});
	
	$('#button1').click(function(){
		if($('#text1').val()=='账号'||$('#text1').val()==''){
			$('#warningmsg').html("账号不能为空！");
			return false;
		}
		if($('#password2').val()==''){
			$('#warningmsg').html("密码不能为空！");
			return false;
		}
	});
});
