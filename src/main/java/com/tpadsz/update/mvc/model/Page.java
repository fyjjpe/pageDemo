package com.tpadsz.update.mvc.model;

import java.util.List;

/**
 * Created by yuanjie.fang on 2017/6/8.
 */
public class Page<T> {
    //页号
    private int pageno;
    //查询数据
    private List<T> data;
    //每页显示数
    private int pagesize = 2;
    //总条数
    private long totalNumber;

    public Page(int pageno) {
        super();
        this.pageno = pageno;
    }

    public int getPageno() {
        if (pageno < 0) {
            pageno = 1;

        }
        if (pageno > getTotalpagenumber()) {
            pageno = getTotalpagenumber();
        }
        return pageno;
    }

    public void setPageno(int pageno) {
        this.pageno = pageno;
    }

    public List<T> getData() {
        return data;
    }

    public void setData(List<T> data) {
        this.data = data;
    }

    public int getPagesize() {
        return pagesize;
    }

    public long getTotalNumber() {
        return totalNumber;
    }

    public void setTotalNumber(long totalNumber) {
        this.totalNumber = totalNumber;
    }

    //得到总共有多少页
    public int getTotalpagenumber() {
        int totalpagenumber = (int) (totalNumber / pagesize);
        if (totalNumber % pagesize != 0) {
            totalpagenumber++;
        }
        return totalpagenumber;
    }

    //判断是否有下一页
    public boolean ishasnext() {
        if (getPageno() < getTotalpagenumber()) {
            return true;
        }
        return false;
    }

    //判断是否有上一页
    public boolean ishasprev() {
        if (getPageno() > 1) {
            return true;
        }
        return false;
    }

    //得到上一页的页码
    public int getprevpage() {
        if (ishasprev()) {
            return getPageno() - 1;
        }
        return getPageno();
    }

    //得到下一页的页码
    public int getnextpage() {
        if (ishasnext()) {
            return getPageno() + 1;
        }
        return getPageno();
    }

    @Override
    public String toString() {
        return "Page{" +
                "pageno=" + pageno +
                ", data=" + data +
                ", pagesize=" + pagesize +
                ", totalNumber=" + totalNumber +
                '}';
    }
}
