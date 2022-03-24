root = exports ? this
# !!!! Hotpoor root object
root.Hs or= {}
Hs = root.Hs

$ ->
    console.log "article coffee"
    root.imgs = {}
    root.check_imgs = ()->
        for k,v of imgs
            console.log k,v
    img_link_with_head_do = (d,h,num)->
        bw = 900
        bh = 1200
        aw = 100
        ah = 100
        cw = 360
        ch = 90
        # pzcx = -500+parseInt(Math.random()*1000)
        # pzcy = -500+parseInt(Math.random()*1000)
        pzcx = 0
        pzcy = 300
        d_w = d.width
        d_h = d.height
        h_w = h.width
        h_h = h.height
        c = document.createElement("canvas")
        c.width = bw
        c.height = bh
        ct = c.getContext("2d")
        x0 = 0
        y0 = 0
        x1 = bw
        y1 = bh
        if d_w >= d_h
            x0 = 0
            x1 = bw
            y0 = parseInt((y1 - (bw / d_w * d_h))/2)
            y1 = parseInt(bw / d_w * d_h)
        else
            y0 = 0
            y1 = bh
            x0 = parseInt((x1 - (bh / d_h * d_w))/2)
            x1 = parseInt(x0 + (bh / d_h * d_w))
        console.log x0,y0,x1,y1
        ct.drawImage(d,0,0,d_w,d_h,x0,y0,x1,y1)
        # ct.drawImage(h,0,0,h_w,h_h,parseInt((bw-aw)/2)+pzcx,parseInt((bh-ah)/2)+pzcy,aw,ah)
        
        ct.font = '30px "微软雅黑"'
        ct.fillStyle = "white"
        ct.textAlign = "center"
        ct.textBaseline = "middle"
        ct.fillText("@"+$(".line_author_info_name").val(), parseInt(bw/2)+pzcx, parseInt(bh/2)+pzcy);

        cover_logo = $("#cover_logo")[0]
        ct.drawImage(cover_logo,0,0,1000,250,parseInt((bw-cw)/2)+pzcx,parseInt((bh)/2+ah/2)+pzcy,cw,ch)
        
        $(".img_made[data-num=#{num}]").attr "src",c.toDataURL()
    img_link_with_head = (url,headimgurl,num)->
        imgs[num]={
            "d_done":false
            "h_done":false
        }
        d = document.createElement("img")
        d.src = url
        d.onload = ()->
            imgs[num]["d"]=d
            imgs[num]["url"] = url 
            imgs[num]["d_done"] = true
            if imgs[num]["h_done"] == true
                img_link_with_head_do(imgs[num]["d"],imgs[num]["h"],num)

        if typeof img != 'object'
            console.log "link",img
            tem = new Image()
            tem.crossOrigin = ''
            tem.src = headimgurl
            img = tem
        tem.onload = ()->
            if img.width > img.height
                w = img.height
                h = img.height
            else
                w = img.width
                h = img.width
            _canv = document.createElement('canvas')
            _canv.width = w
            _canv.height = h
            _contex = _canv.getContext("2d")
            cli =
                x: w / 2
                y: h / 2
                r: w / 2
            _contex.clearRect(0, 0, w, h)
            _contex.save()
            _contex.beginPath()
            _contex.arc(cli.x, cli.y, cli.r, 0, Math.PI * 2, false)
            _contex.clip()
            _contex.drawImage(img, 0, 0)
            console.log _canv.toDataURL()
            h = document.createElement("img")
            h.src = _canv.toDataURL()
            h.onload = ()->
                imgs[num]["h"]=h
                imgs[num]["headimgurl"] = headimgurl
                imgs[num]["h_done"] = true
                if imgs[num]["d_done"] == true
                    img_link_with_head_do(imgs[num]["d"],imgs[num]["h"],num)
        
    $("body").on "click",".get_info",(evt)->
        dom  = $(this)
        dom.text("解析中")
        short_link_val = $("input[data-name=short_link]").val()
        short_link = "http://"+short_link_val.split("，")[1].split("http://")[1]
        $.ajax
            url:"/api/tool/article/get_info"
            type: "GET"
            dataType: "json"
            data:
                short_link:short_link
            success:(data)->
                dom.text("查询")
                if data.info == "ok"
                    result = data.result
                    title = result["title"].toLocaleUpperCase().replaceAll("PUCO","口红博主").replaceAll("唇泥","唇釉")
                    content = result["content"].toLocaleUpperCase().replaceAll("PUCO","口红博主").replaceAll("唇泥","唇釉")
                    $("input[data-name=json_file]").val(result["t"])
                    $("input[data-name=article_title]").val(title)
                    $("textarea[data-name=article_content]").val(content)
                    $(".line_images").empty()
                    $(".line_author_info_img").attr "src",result["user_headimgurl"]
                    $(".line_author_info_name").val result["user_name"]
                    time_now = (new Date()).getTime()
                    num = 0
                    headimgurl_now = result["user_headimgurl"]
                    for i in result["image_links"]
                        img_link_with_head(i,headimgurl_now,num)
                        $(".line_images").append """
                            <div><img class="line_images_div_img img_made" src="#{i}" data-num="#{num}"></div>
                        """
                        num +=1
            error:(data)->
                dom.text("解析失败")
    $("body").on "click",".get_json",(evt)->
        dom  = $(this)
        dom.text("解析中")

        $.ajax
            url:"/api/tool/article/get_json"
            type: "GET"
            dataType: "json"
            data:
                t:$("input[data-name=json_file]").val()
            success:(data)->
                dom.text("查询")
                if data.info == "ok"
                    result = data.result
                    title = result["title"].toLocaleUpperCase().replaceAll("PUCO","口红博主").replaceAll("唇泥","唇釉")
                    content = result["content"].toLocaleUpperCase().replaceAll("PUCO","口红博主").replaceAll("唇泥","唇釉")
                    $("input[data-name=article_title]").val(title)
                    $("textarea[data-name=article_content]").val(content)
                    $(".line_images").empty()
                    time_now = (new Date()).getTime()
                    for i in result["image_links"]
                        $(".line_images").append """
                            <div><img class="line_images_div_img" src="#{i}"></div>
                        """
                    $(".line_author_info_img").attr "src",result["user_headimgurl"]
                    $(".line_author_info_name").val result["user_name"]
            error:(data)->
                dom.text("解析失败")
    $("body").on "click", ".copy_plus", (evt)->
        dom = $(this)
        copy_aim = dom.parents(".line").find(".copy_plus_content").select()
        document.execCommand("Copy")

    $("body").on "click",".make_video",(evt)->
        $(".download_video").remove()
        img_doms = $(".img_made")
        imgs = []
        for img_dom in img_doms
            imgs.push img_dom.src
        $.ajax
            url:"/api/tool/article/make_video"
            type: "POST"
            dataType: "json"
            data:
                t:$("input[data-name=json_file]").val()
                imgs:JSON.stringify(imgs)
            success:(data)->
                console.log data
                $(".make_video").after """
                    <button class="line_btns_btn download_video">Download</button>
                """
            error:(data)->
                console.log data









