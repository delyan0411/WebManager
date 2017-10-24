﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	int tid = DoRequest.GetQueryInt("tid");
%>
<div id="moduleModifyCarousel-boxControl" class="moveBox" style="width:960px;height:660px;">
	<div class="name">
		编辑信息
		<div class="close" id="moduleModifyCarousel-boxControl-close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" method="post" onsubmit="return postModuleCarousel(this)">
<input type="hidden" id="st-id-list" name="tid" value="<%=tid %>"/>
<input type="hidden" id="module-mid-list" name="mid" value=""/>
	<div id="moduleModifyCarousel-tips-text" class="tips-text" style="margin:2px auto">&nbsp;</div>
<table>
  <tr>
    <td class="left" style="width:40px">名称：</td>
    <td><input type="text" id="module-name-list" name="name" class="input" value=""/>
    &nbsp;
    <input type="checkbox" id="module-allowShowName-list" name="allowShowName" onclick="checkedname(this)" value="0"/> 显示名称
    </td>
  </tr>
   <tr>
    <td class="left" style="width:40px">高度：</td>
    <td>
      <input type="text" id="moduleheight" name="moduleheight" class="input" value=""/> px
    </td>
  </tr>

</table>
<div class="console">&nbsp;&nbsp;
    &nbsp;
	<a href="javascript:;" onclick="ajaxUploadClick2(Atai.$('#moduleModifyCarousel-tips-text'))">本地传图</a>
    <a href="javascript:;" onclick="showImageListBox(moduleCarouseItem2)">图库选图</a>
</div>
<%--数据列表开始--%>
<div class="module-box-data-list">
<div class="search-result">
<table>
<thead>
  <tr>
    <th style="width:60px;">
      图片
    </th>
    <th>
      名字
    </th>
    <th>
      Url
    </th>
</tr>
</thead>
</table>
<ul id="module-box-result" class="module-box-list" style="height:300px;width:940px;">

</ul>
</div>
<div class="clear"></div>
</div>
<%--数据列表结束--%>
<table>
  <tr>
    <td class="left" style="width:40px;height:680px;">&nbsp;</td>
    
    <td>
<input type="submit" class="submit" value="保 存" style="width:160px;text-align:center;"/>
    </td>
  </tr>
</table>
</form>
</div>
 <script type="text/javascript">
     var __moduleModifyCarouselDialog = false;
     function moduleModifyCarousel(mId) {
         __moduleModifyCarouselDialog = false;
         var boxId = "#moduleModifyCarousel-boxControl";
         var box = Atai.$(boxId);
         var _dialog = _dialog = new AtaiShadeDialog();
         _dialog.zIndex = 99;
         _dialog.init({
             obj: box
		, sure: function () { }
		, CWCOB: false
         });
         __moduleModifyCarouselDialog = _dialog;

         $.ajax({
             url: "/MPromotions/GetModuleItems?t=" + new Date().getTime()
		, type: "post"
		, data: { "mid": mId }
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {

		        $(__moduleModifyCarouselDialog.dialog).find("input[name='mid']").val(json.data.st_module_id);
		        $(__moduleModifyCarouselDialog.dialog).find("input[name='name']").val(json.data.module_name);
		        $(__moduleModifyCarouselDialog.dialog).find("input[name='moduleheight']").val(json.data.module_height);
		        $(__moduleModifyCarouselDialog.dialog).find("input[name='allowShowName']").attr("checked", json.data.allow_show_name == "1");
		        moduleCarouseItem(json.items);
		        $(__moduleModifyCarouselDialog.dialog).find("#moduleModifyCarousel-tips-text").html("");
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
         });
         return false;
     }

     function moduleCarouseItem2(path, fullpath) {
         var _len = $("#module-box-result li").length + 1;
         var html = '';
         html += '<li order="' + _len + '" name="carouseli">';
         html += '<input type="hidden" name="itemid" value="0"/>';
         html += '<div class="img"><input name="imgsrc" type="hidden" value="' + path + '" /><img src="' + (formatImageUrl(fullpath, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>';
         html += '<div>&nbsp;&nbsp;<input name="itemname" value="" style="height:28px;"/></div><div>&nbsp;&nbsp;<input name="itemurl" value="" style="height:28px;width:200px;"/>&nbsp;&nbsp;</div>';
         html += '<div><p class="move-links">';
         html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
         html += '</p></div>';
         html += '<div class="op-link"><a href="javascript:;" onclick="removeModuleDataItem2(this)">移除</a></div>';
         html += '<p class="clear"></p>';
         html += '</li>';
         $(__moduleModifyCarouselDialog.dialog).find("#module-box-result").append(html);
         var nodes = $(__moduleModifyCarouselDialog.dialog).find("#module-box-result li");
         $(__moduleModifyCarouselDialog.dialog).find("#module-box-result").scrollTop(nodes.length * 70);
     }

     function moduleCarouseItem(items, fullpath, path) {
         var _len = $("#module-box-result li").length + 1;
         if (items != null && items != "") {
             var html = '';
             for (var i = 0; i < items.length; i++) {
                 var json = items[i];
                 html += '<li order="' + _len + '" name="carouseli">';
                 html += '<input type="hidden" name="itemid" value="' + json.st_item_id + '"/>';
                 html += '<div class="img"><input name="imgsrc" type="hidden" value="' + json.item_img_src.substr(58) + '" /><img src="' + (formatImageUrl(json.item_img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>';
                 html += '<div >&nbsp;&nbsp;<input name="itemname" value="' + json.item_name + '" style="height:28px;"/></div><div>&nbsp;&nbsp;<input name="itemurl" value="' + json.page_src + '" style="height:28px;width:200px;"/>&nbsp;&nbsp;</div>';
                 html += '<div><p class="move-links">';
                 html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
                 html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
                 html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
                 html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
                 html += '</p></div>';
                 html += '<div class="op-link"><a href="javascript:;" onclick="removeModuleDataItem2(this)">移除</a></div>';
                 html += '<p class="clear"></p>';
                 html += '</li>';
                 _len++;
             }
             $(__moduleModifyCarouselDialog.dialog).find("#module-box-result").append(html);
             var nodes = $(__moduleModifyCarouselDialog.dialog).find("#module-box-result li");
             $(__moduleModifyCarouselDialog.dialog).find("#module-box-result").scrollTop(nodes.length * 70);
         } else {
         if (fullpath != null && fullpath != "") {
             var html = '';
             html += '<li order="' + _len + '" name="carouseli">';
             html += '<input type="hidden" name="itemid" value="0"/>';
             html += '<div class="img"><input name="imgsrc" type="hidden" value="' + path + '" /><img src="' + fullpath + '" alt="" style=\"width:60px;height:60px;\"/></div>';
             html += '<div>&nbsp;&nbsp;<input name="itemname" value="" style="height:28px;"/></div><div>&nbsp;&nbsp;<input name="itemurl" value="" style="height:28px;width:200px;"/>&nbsp;&nbsp;</div>';
             html += '<div><p class="move-links">';
             html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsMove2(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
             html += '</p></div>';
             html += '<div class="op-link"><a href="javascript:;" onclick="removeModuleDataItem2(this)">移除</a></div>';
             html += '<p class="clear"></p>';
             html += '</li>';
             $(__moduleModifyCarouselDialog.dialog).find("#module-box-result").append(html);
             var nodes = $(__moduleModifyCarouselDialog.dialog).find("#module-box-result li");
             $(__moduleModifyCarouselDialog.dialog).find("#module-box-result").scrollTop(nodes.length * 70);
         }
         }
     }


     function removeModuleDataItem2(obj) {
         $(obj).parent().parent().remove();
     }

     function moduleItemsMove2(obj,type) {
         var mObj = $(obj).parent().parent().parent();
         var nodes = $(__moduleModifyCarouselDialog.dialog).find("#module-box-result li");
         var idx = mObj.index();
         var len = nodes.length;
         if (mObj && len > 0) {
             switch (type) {
                 case "first":
                     if (idx > 0) {
                         mObj.insertBefore(nodes[0]);
                     }
                     break;
                 case "up":
                     if (idx > 0) {
                         mObj.insertBefore(nodes[idx - 1]);
                     }
                     break;
                 case "down":
                     if (idx + 1 < len) {
                         mObj.insertAfter(nodes[idx + 1]);
                     }
                     break;
                 case "last":
                     if (idx + 1 < len) {
                         mObj.insertAfter(nodes[len - 1]);
                     }
                     break;
             }
         }
     }

     function parseCarouseModuleItems(json, items) {
         var module = $("#module-" + json.st_module_id);
         if (module) {
             if (json.allow_show_name == "1") {
                 $(module).children(".module-hd").css({ "display": "block" });
             } else {
                 $(module).children(".module-hd").css({ "display": "none" });
             }
             $(module).children(".module-hd").children("h3").html("<b>@</b>" + json.module_name);

             var html = '<div class="effect"><div id="slideBox' + json.st_module_id + '" class="slideBox"><div class="hd"><ul>';
             for (var i = 0; i < items.length; i++) {
                 html += '<li class="on">' + (i + 1) + '</li>';
             }
             html += '</ul></div><div class="bd"><div class="tempWrap" style="overflow:hidden; position:relative; width:1680px;">';
             html += '<ul style="width: 1680px;; position: relative; overflow: hidden; padding: 0px; margin: 0px; left: -313.634128665252px;">';
             for (var i = 0; i < items.length; i++) {
                 var em = items[i];
                 html += '<li style="float: left; width: 1680px;"><img src="' + em.item_img_src2 + '"/></li>';
             }
             html += '</ul></div></div></div>';
             $(module).children(".module-bd").html(html);
             jQuery("#slideBox"+json.st_module_id).slide({ mainCell: ".bd ul", effect: "left", autoPlay: true });
             $("#slideBox"+json.st_module_id).css("height",""+json.module_height +"px");
         }
     }

     function createXmlDocument(nodes) {
         var xml = '<?xml version="1.0" encoding="utf-8"?>';
         xml += '<items>';
         if (nodes != undefined) {
             for (var i = 0; i < nodes.length; i++) {
                 xml += nodes[i];
             }
         }
         xml += '</items>';
         return xml;
     }

     function postModuleCarousel(form) {
         var nodes = [];
         var _error = false;
         var _ermsg = "";
         var list = $("li[name='carouseli']").each(function () {
             var itemid = $(this).find("input[name='itemid']").val();
             var imgsrc = $(this).find("input[name='imgsrc']").val();
             var itemname = $(this).find("input[name='itemname']").val();
             var itemurl = $(this).find("input[name='itemurl']").val();

             if (imgsrc.length < 1) {
                 _error = true;
                 _ermsg = "【图片】不能为空";
             }

             if (itemname.length < 1) {
                 _error = true;
                 _ermsg = "【名字】不能为空";
             }

             if (itemurl.length < 1) {
                 _error = true;
                 _ermsg = "【Url】不能为空";
             }

             var node = '<item itemid="' + itemid + '" imgsrc="' + imgsrc + '" itemname="' + itemname + '" itemurl="' + itemurl + '">';

             node += '</item>';

             nodes.push(node);
         });
         
         if (nodes.length < 1) {
             $(__moduleModifyCarouselDialog.dialog).find("#moduleModifyCarousel-tips-text").html("请添加至少一个图片");
             return false;
         }

         if (nodes.length > 4) {
             $(__moduleModifyCarouselDialog.dialog).find("#moduleModifyCarousel-tips-text").html("添加图片不能超过4张");
             return false;
         }

         if (_error) {
             $(__moduleModifyCarouselDialog.dialog).find("#moduleModifyCarousel-tips-text").html(_ermsg);
             return false;
         }

         var xml = createXmlDocument(nodes);

         var postData = getPostDB(form);
         $.ajax({
             url: "/MPromotions/PostCarouselModuleItems"
		, type: "post"
		, data: postData + "&xml=" + encodeURIComponent(xml)
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        $(__moduleModifyCarouselDialog.dialog).find("#moduleModifyCarousel-tips-text").html(json.message);
		    } else {
		        $(__moduleModifyCarouselDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
		        parseCarouseModuleItems(json.data, json.items);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    $(__moduleModifyCarouselDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
		    jsbox.error(errorThrown);
		}
         });
         return false;
     }
    </script>
