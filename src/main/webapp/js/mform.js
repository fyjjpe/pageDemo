$(function(){
//	对cic进行验证
	$('#txtcid').focus(function(){
		if($('#txtcid').val()=='ID'){
			$('#txtcid').val("");
		}
	});
	$('#txtcid').blur(function(){
		if($('#txtcid').val()==''){
			$('#txtcid').val("ID");
		}
	});

	
	$('#txtdid').focus(function(){
		if($('#txtdid').val()=='DATAID'){
			$('#txtdid').val("");
		}
	});
	$('#txtdid').blur(function(){
		if($('#txtdid').val()==''){
			$('#txtdid').val("DATAID");
		}
	});
	

	
	$('.cicbutton').click(function(){
		var id = $('#txtcid').val();
		if(id==""||id=="ID"){
			$('#idinfo').html('ID不能为空哦').css('color','red');
			return false;
		}else{
				$('#form1').attr("action","cic");
				$('#form1').submit();  
		}
	});
	
	$('.ctcbutton').click(function(){
		var id = $('#txtcid').val();
		if(id==""||id=="ID"){
			$('#idinfo').html('ID不能为空哦').css('color','red');
			return false;
		}else{
			$('#form1').attr("action","ctc");
			$('#form1').submit();  
		}
	});
	
	$('.uicbutton').click(function(){
		var id = $('#txtcid').val();
		if(id==""||id=="ID"){
			$('#idinfo').html('ID不能为空哦').css('color','red');
			return false;
		}else{
			$('#form1').attr("action","uic");
			$('#form1').submit();  
		}
	});
	

	$(document).click(function(){
		$('#idinfo').html('');
	});
});
