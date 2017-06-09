package com.tpadsz.update.mvc.utils;

import com.tpadsz.update.mvc.web.vo.StoreOrderVo;
import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.usermodel.*;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by yuanjie.fang on 2017/5/18.
 */
public class ExcelUtil {

    /**
     * 将页面查询的订单生成excel表格
     *
     * @param list
     */
    public static void expOrdersExcel(List<StoreOrderVo> list) {
        // 第一步，创建一个webbook，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        // 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
        HSSFSheet sheet = wb.createSheet("sheet0");
        // 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
        HSSFRow row = sheet.createRow((int) 0);
        // 第四步，创建单元格，并设置值表头 设置表头居中
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式

        HSSFCell cell = row.createCell(0);
        cell.setCellValue("订单状态");
        cell.setCellStyle(style);
        cell = row.createCell(1);
        cell.setCellValue("订单编号");
        cell.setCellStyle(style);
        cell = row.createCell(2);
        cell.setCellValue("订单时间");
        cell.setCellStyle(style);
        cell = row.createCell(3);
        cell.setCellValue("购买人信息");
        cell.setCellStyle(style);
        cell = row.createCell(4);
        cell.setCellValue("收货人姓名");
        cell.setCellStyle(style);
        cell = row.createCell(5);
        cell.setCellValue("收货人手机号");
        cell.setCellStyle(style);
        cell = row.createCell(6);
        cell.setCellValue("收货人地址");
        cell.setCellStyle(style);
        cell = row.createCell(7);
        cell.setCellValue("商品名称");
        cell.setCellStyle(style);
        cell = row.createCell(8);
        cell.setCellValue("购买数量");
        cell.setCellStyle(style);
        cell = row.createCell(9);
        cell.setCellValue("总价(元)");
        cell.setCellStyle(style);

        for (int i = 0; i < list.size(); i++) {
            row = sheet.createRow(i + 1);
            StoreOrderVo vo = (StoreOrderVo) list.get(i);
            // 第四步，创建单元格，并设置值
            if (vo.getStatus() == 0) {
                row.createCell(0).setCellValue("未发货");
            } else if (vo.getStatus() == 1) {
                row.createCell(0).setCellValue("未收货");
            } else if (vo.getStatus() == 2) {
                row.createCell(0).setCellValue("交易完成");
            } else {
                row.createCell(0).setCellValue("交易失败");
            }
            row.createCell(1).setCellValue(vo.getSerialno());
            row.createCell(2).setCellValue(vo.getCreateDate());
            row.createCell(3).setCellValue(vo.getUserPhone());
            row.createCell(4).setCellValue(vo.getFullName());
            row.createCell(5).setCellValue(vo.getMobile());
            row.createCell(6).setCellValue(vo.getAddress());
            row.createCell(7).setCellValue(vo.getName());
            row.createCell(8).setCellValue(vo.getGoodsNum());
            row.createCell(9).setCellValue(vo.getPrice());
        }

        try {
            /*
		    * 在当前目录中创建目录demo
		    */
            File dir = new File("C:\\bosslocker_store");
            if(!dir.exists()){
                dir.mkdirs();
                System.out.println("创建完毕");
            }
            //创建文件保存路径
            FileOutputStream out = new FileOutputStream("C:\\bosslocker_store\\orders.xls");
            wb.write(out);
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        StoreOrderVo vo1 = new StoreOrderVo();
        vo1.setStatus(0);
        vo1.setSerialno("20170517164342015Wzd");
        vo1.setCreateDate("2017-05-17 16:43:42");
        vo1.setUserPhone("15850221536");
        vo1.setFullName("辰昊");
        vo1.setMobile("15850221536");
        vo1.setAddress("江苏苏州");
        vo1.setName("白色恋人18枚");
        vo1.setGoodsNum(1);
        vo1.setPrice(2);

        StoreOrderVo vo2 = new StoreOrderVo();
        vo2.setStatus(1);
        vo2.setSerialno("20170517164342015xxx");
        vo2.setCreateDate("2017-05-17 16:43:42");
        vo2.setUserPhone("15850221536");
        vo2.setFullName("辰昊2222");
        vo2.setMobile("15850221536");
        vo2.setAddress("江苏苏州");
        vo2.setName("白色恋人9枚");
        vo2.setGoodsNum(1);
        vo2.setPrice(5);

        List<StoreOrderVo> list = new ArrayList<>();
        list.add(vo1);
        list.add(vo2);

        expOrdersExcel(list);
    }

}
