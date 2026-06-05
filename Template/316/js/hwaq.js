$(document).ready(function () {
    $.plugin = {
        NUMBER_plus: function (obj, set_num, speed) {
            if (!speed)
                speed = 60;
            if (!set_num)
                set_num = 50;
            var scroll_lock = true;
            $(window).scroll(function () {
                if ($(document).scrollTop() + $(window).height() > obj.offset().top && obj.offset().top + obj.innerHeight() > $(document).scrollTop() && scroll_lock) {
                    scroll_lock = false;
                    var time_lock = 0,
                        This = obj.find('span'), // 获取对象
                        num = [];  // 数据容器
                    var set_plus = setInterval(function () {
                        // 数字相加
                        This.each(function (index) {
                            if (!num[index])
                                num[index] = $(this).find('em').attr('data-num')*1/set_num;
                            else
                                num[index] += $(this).find('em').attr('data-num')*1/set_num;
                            $(this).find('em').text(parseInt(num[index]));
                            if (num[index] > $(this).find('em').attr('data-num')*1) {
                                $(this).find('em').text($(this).find('em').attr('data-num')*1);
                                time_lock++;
                            }
                        });
                        if (time_lock >= num.length) {
                            // 清理多余执行
                            clearInterval(set_plus);
                        }
                    }, speed);
                }
            })
        },
        BG_parallax: function (obj, speed) {
            if (!speed)
                speed = .5;
            $(window).scroll(function () {
                obj.css({
                    'background-position-y': (((obj.offset().top + obj.innerHeight() / 2) - ($(document).scrollTop() + $(window).height() / 2)) * speed)
                })
            })
        },
        Interval_Fun: function (obj, means, cycle, position) {
            if (!position)
                position = 2;
            if (!cycle)
                var cycle_num = 0;
            $(window).scroll(function () {
                if (obj.offset().top + obj.innerHeight() / position < $(document).scrollTop() + $(window).height() && obj.offset().top + obj.innerHeight() / position > $(document).scrollTop()) {
                    cycle_num++;
                    if (!cycle && cycle_num <= 1)
                        means();
                    else if (cycle)
                        means()
                }
            })
        },
        Video_open: function (obj) {
            var src, btn, img, tag, method = obj.attr('data-mode');
            if (obj.attr('data-src'))
                src = obj.attr('data-src');
            else
                return;
            if (obj.attr('data-img'))
                img = obj.attr('data-img');
            btn = obj.attr('data-btn') ? obj.attr('data-btn') : '#000';
            if (!method)
                tag = '<video controls poster=' + img + ' src=' + src + '></video>';
            else
                tag = '<iframe width="1000" height="540" src="' + src + '" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>';
            var video = "<div class='video_box active'>" + tag + "<i class='video_close fa fa-close'></i></div><i class='video_mask active'></i>",
                css = "<style type='text/css' id='video_css'>.video_box {position: fixed;display: inline-block;top: 50%;left: 50%;-webkit-transform: translate(-50%, -50%) scale(1, 1);-moz-transform: translate(-50%, -50%) scale(1, 1);-ms-transform: translate(-50%, -50%) scale(1, 1);-o-transform: translate(-50%, -50%) scale(1, 1);transform: translate(-50%, -50%) scale(1, 1);z-index: 1000;max-width: 90%; max-height: 90%;-webkit-transition: .5s;-moz-transition: .5s;-ms-transition: .5s;-o-transition: .5s;transition: .5s;-webkit-transform-origin: center center;-moz-transform-origin: center center;-ms-transform-origin: center center;-o-transform-origin: center center;transform-origin: center center;zoom: 1;}.video_box video,.video_box iframe {max-width: 100%;max-height: 100%;-webkit-transition: .5s;-moz-transition: .5s;-ms-transition: .5s;-o-transition: .5s;transition: .5s;}.video_box i.video_close {position: absolute;height: 40px;width: 40px;border-radius: 100%;background: " + btn + ";display: block;right: -20px;top: -20px;cursor: pointer;cursor: hand;text-align: center;line-height: 40px;color: white;font-size: 18px;opacity: 0;-webkit-transition: .5s;-moz-transition: .5s;-ms-transition: .5s;-o-transition: .5s;transition: .5s;}.video_box:hover i.video_close {opacity: 1;}.video_box.active {-webkit-transform: translate(-50%, -50%) scale(0.3, 0.3);-moz-transform: translate(-50%, -50%) scale(0.3, 0.3);-ms-transform: translate(-50%, -50%) scale(0.3, 0.3);-o-transform: translate(-50%, -50%) scale(0.3, 0.3);transform: translate(-50%, -50%) scale(0.3, 0.3);zoom: .3;}i.video_mask {position: fixed;top: 0;left: 0;z-index: 900;background: rgba(0, 0, 0, 0.5);height: 100%;width: 100%;-webkit-transition: .5s .2s;-moz-transition: .5s .2s;-ms-transition: .5s .2s;-o-transition: .5s .2s;transition: .5s .2s;opacity: 1;}i.video_mask.active {opacity: 0;-webkit-transition: .5s;-moz-transition: .5s;-ms-transition: .5s;-o-transition: .5s;transition: .5s;}.video_box video, .video_box iframe {min-width: 900px;}@media screen and (max-width: 1000px) { .video_box video, .video_box iframe {min-width: 600px;display: block;max-height: 340px !important;}}@media screen and (max-width: 700px) {.video_box video, .video_box iframe { min-width: 400px; display: block;max-height: 240px !important;}}@media screen and (max-width: 500px) {.video_box video, .video_box iframe {min-width: 300px;display: block; max-height: 170px !important;}}</style>"
            obj.click(function () {
                $("body").append(video).append(css).animate(200, function () {
                    $(".video_box").add($(".video_mask")).removeClass('active');
                });
                $("i.video_mask").add($("i.video_close")).one('click', function () {
                    $(".video_box").add($("i.video_mask")).add($("#video_css")).remove();
                })
            });
        },
        Pop_Ups: function(obj,model){
            var css = '<style type=\'text/css\' id=\'Pop_Ups_css\'>#pups_from{position:fixed;top:50%;left:50%;-webkit-transform:translate(-50%,-50%);-moz-transform:translate(-50%,-50%);-ms-transform:translate(-50%,-50%);transform:translate(-50%,-50%);max-height:80%;width:500px;max-width:90%;-o-box-shadow:0 0 10px rgba(0,0,0,0.1);-webkit-box-shadow:0 0 10px rgba(0,0,0,0.1);box-shadow:0 0 10px rgba(0,0,0,0.1);z-index:22;background:white;padding:30px;overflow:auto}#pups_from h4{font-size:24px;color:black;text-transform:capitalize;line-height:1;margin-bottom:30px;font-weight:bold}#pups_from i.close{width:30px;height:30px;position:absolute;top:25px;right:25px;background:#eee;cursor:pointer;cursor:hand}#pups_from i.close:after,#pups_from i.close:before{content:\'\';width:70%;height:2px;margin-top:-1px;background:black;position:absolute;top:50%;left:15%;-webkit-transform:rotate(45deg);-moz-transform:rotate(45deg);-ms-transform:rotate(45deg);transform:rotate(45deg)}#pups_from i.close:after{-webkit-transform:rotate(-45deg);-moz-transform:rotate(-45deg);-ms-transform:rotate(-45deg);transform:rotate(-45deg)}#pups_from form ul li{margin-bottom:10px;padding-left:60px;position:relative}#pups_from form ul li label{position:absolute;font-size:14px;left:0;top:5px}#pups_from form ul li label em{color:red;margin-right:2px}#pups_from form ul li input,#pups_from form ul li textarea{width:100%;line-height:24px;padding:6px 15px;border:1px solid #eee;-webkit-transition:.5s;-moz-transition:.5s;transition:.5s;font-size:16px}#pups_from form ul li input:focus,#pups_from form ul li textarea:focus{border-color:black}#pups_from form ul li textarea{height:80px}#pups_from form ul li input[type="submit"]{width:auto;padding:6px 40px;display:inline-block;background:black;color:white}#pups_from form ul li:last-child{margin-bottom:0}</style>',
                html = '<div id="pups_from" hidden>\n' +
                    '        <h4>Submit feedback</h4>\n' +
                    '        <i class="close"></i>\n' +
                    '        <form onsubmit="return false;"><input type="hidden" name="your-message" value=""><input type="hidden" name="your-email" value="">\n' +
                    '            <ul>\n' +
                    '                <li>\n' +
                    '                    <label><em>*</em>Name:</label>\n' +
                    '                    <input type="text" autocomplete="off" name="name" placeholder="">\n' +
                    '                </li>\n' +
                    '                <li>\n' +
                    '                    <label><em>*</em>Email:</label>\n' +
                    '                    <input type="text" autocomplete="off" name="mail" placeholder="">\n' +
                    '                </li>\n' +
                    '                <li>\n' +
                    '                    <label>Phone:</label>\n' +
                    '                    <input type="text" autocomplete="off" name="phone" placeholder="">\n' +
                    '                </li>\n' +
                    '                <li>\n' +
                    '                    <label>Message:</label>\n' +
                    '                    <textarea autocomplete="off" name="content" placeholder=""></textarea>\n' +
                    '                </li>\n' +
                    '                <li>\n' +
                    '                    <input type="submit" value="Send">\n' +
                    '                </li>\n' +
                    '            </ul>\n' +
                    '        </form>\n' +
                    '    </div>',
                lock = true,
                model_form = false,
                model_url = '';
            $("body").append(css).append(html);
            $.getScript('/static/js/layer/layer.js',function (response,status) {
                if (status==='success') {
                    lock = false;
                }
            });
            obj.on('click',function (e) {
                if (model && !model_form) {
                    e.preventDefault();
                    e.stopPropagation();
                    model_url = $(this).attr('href')?$(this).attr('href'):$(this).find('a').attr('href');
                }
                if (!model_form)
                    $("#pups_from").stop().fadeToggle(200);
            });
            $("#pups_from i.close").on('click',function () {
                $("#pups_from").stop().fadeToggle(200);
            });
            $("#pups_from form input[type=submit]").on('click',function () {
                layer.load(0,{shade:0.1,shadeClose:false});
                $.ajax({
                    type: 'post',
                    url: '/Api/contact/submit/uid/1.html',
                    data: $("#pups_from form").serialize(),
                    dataType: 'json',
                    success: function (data) {
                        layer.closeAll();
                        if (data.status == 200) {
                            layer.msg(data.result,{icon:1,time:4000});
                            if (model && !model_form) {
                                model_form = true;
                                $("#pups_from").stop().fadeToggle(200);
                                var a = document.createElement('a');
                                a.setAttribute('href',model_url);
                                a.setAttribute('download','');
                                document.body.appendChild(a);
                                a.click();
                                a.remove();
                            }
                        } else {
                            layer.msg(data.result,{icon:2,time:4000})
                        }
                    }
                })
            });
        },
        Line_curve: function (obj, origin, coordinate, color,img, speed) {
            if (!speed)
                speed = 0.01;
            if (!color)
                color = '#000';
            var con = document.getElementById(obj).appendChild(document.createElement('canvas'));
            var ctx = con.getContext('2d');
            con.width = document.getElementById(obj).offsetWidth ? document.getElementById(obj).offsetWidth : window.innerWidth;
            con.height = document.getElementById(obj).offsetHeight ? document.getElementById(obj).offsetHeight : window.innerHeight;
            var percent = 0;
            ctx.lineWidth = 2;
            origin = [origin[0] * (con.width / 100), origin[1] * (con.height / 100)];

            function animate() {
                ctx.clearRect(0, 0, con.width, con.height);
                ctx.drawImage(img,0,0,con.width,con.height);
                for (var i = 0; i < coordinate.length; i++) {
                    var x0 = coordinate[i][0][0] * (con.width / 100);
                    var y0 = coordinate[i][0][1] * (con.height / 100);
                    var x1 = coordinate[i][1][0] * (con.width / 100);
                    var y1 = coordinate[i][1][1] * (con.height / 100);
                    ctx.strokeStyle = color;
                    ctx.beginPath();
                    formula(ctx, origin, [x0, y0], [x1, y1], percent);
                    ctx.stroke();
                }
                if (percent < 1)
                    percent += speed;
                else {
                    return;
                }
                requestAnimationFrame(animate);
            }

            function formula(ctx, start, end, control, percent) {
//            二次贝塞尔曲线坐标计算公式
                var v01 = [control[0] - start[0], control[1] - start[1]];     // 向量<p0, p1>
                var v12 = [end[0] - control[0], end[1] - control[1]];     // 向量<p1, p2>
                var q0 = [start[0] + v01[0] * percent, start[1] + v01[1] * percent];
                var q1 = [control[0] + v12[0] * percent, control[1] + v12[1] * percent];
                var v = [q1[0] - q0[0], q1[1] - q0[1]];       // 向量<q0, q1>
                var b = [q0[0] + v[0] * percent, q0[1] + v[1] * percent];
                ctx.moveTo(start[0], start[1]);
                ctx.quadraticCurveTo(
                    q0[0], q0[1],
                    b[0], b[1]
                );
            }

            animate();
        },
        shopping_cart: function (text_, element, cart_page,product) {
            // 对象数据汇总
            if (!cart_page)
                cart_page = false;
            if (!element) {
                element = {
                    shopping_cart: '.shopping_cart',
                    shopping_form: '.shopping_form',
                    shopping_list: '.shopping_list',
                    product_box: '.product_box', //多增加一个data-id 属性
                    product_name: '.product_name',
                    product_link: '.product_link',
                    product_det: '.product_det',
                    product_img: '.product_img',
                    product_tag: '.product_tag',
                    product_add: '.product_add'
                };
            }
            if (!text_) {
                text_ = {
                    close: 'Close All',
                    title: 'Feedback',
                    submit: 'Send',
                    number: 'Number:',
                    cart: 'There are no products, just add them!',
                    required: 'Can not be empty!'
                }
            }
            var css = '<style type=\'text/css\' id=\'\'>#cart{position:fixed;max-width:100%;width:1000px;top:50%;left:50%;-webkit-transform:translate(-50%,-50%);-moz-transform:translate(-50%,-50%);-ms-transform:translate(-50%,-50%);-o-transform:translate(-50%,-50%);transform:translate(-50%,-50%);max-height:80%;overflow:auto;padding: 15px;z-index:100;background:white;-moz-box-shadow:0 0 10px rgba(0,0,0,.2);-o-box-shadow:0 0 10px rgba(0,0,0,.2);box-shadow:0 0 10px rgba(0,0,0,.2);}#cart.active{position:static;width:auto;top:0;left:0;-webkit-transform:translate(0);-moz-transform:translate(0);-ms-transform:translate(0);-o-transform:translate(0);transform:translate(0);max-height:none;overflow:unset}#cart .left{padding-right:15px;color:black}#cart .left ul{max-height:560px;overflow:auto}#cart .left ul li{margin-bottom:15px;padding:15px;background:#f9f9f9}#cart .left ul li .box2{position:relative}#cart .left ul li .img{width:25%;overflow:hidden;vertical-align:middle;max-height:140px}#cart .left ul li .img img{min-height:140px;width:auto;min-width:100%}#cart .left ul li .text{width:75%;padding-left:3%;vertical-align:middle}#cart .left ul li .text h4{font-size:18px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden}#cart .left ul li .text p{display:inline-block;max-width:50%;padding-right:15px}#cart .left ul li .text input{width:50%;max-width:80px;color:black;padding:5px;display:inline-block;border:1px solid #eee}#cart .left ul li .text textarea{width:100%;padding:10px;color:black;margin-top:10px;border:1px solid #eee}#cart .left ul li i.del{position:absolute;top:-8px;right:-5px;font-size:16px;cursor:pointer;cursor:hand}#cart .left span.close_all{display:inline-block;line-height:40px;height:40px;padding:0 25px;background:#111;color:white;font-size:15px;cursor:pointer;cursor:hand;margin-top:10px}#cart .right{padding-left:15px}#cart .right .shopping_form{background:#f9f9f9;color:black;padding:15px}#cart .right h4{font-size:24px}#cart .right ul li label{display:block;font-size:14px;margin:10px 0 5px}#cart .right ul li input,#cart .right ul li textarea{width:100%;padding:5px 15px;border:1px solid #eee;font-size:14px}#cart .right ul li textarea{height:160px}#cart .right ul li input[type="submit"]{max-width:200px;background:#111;border:0;font-size:18px;margin-top:20px;padding:10px;color:white}#cart i.fa-close{position:absolute;right:15px;top:15px;font-size:16px;width:30px;height:30px;line-height:30px;text-align:center;background:#000;color:white;cursor:pointer;cursor:hand}@media screen and (max-width:1000px){#cart .left{width:100%;padding-right:0}#cart .right{width:100%;padding-left:0;padding-top:20px}#cart .left ul{overflow:unset;max-height:none}}</style>',
                html = '<div id="cart" hidden><div class="box grid-box two"><div class="left column"><ul class="shopping_list"></ul><span class="close_all">' + text_.close + '</span></div><div class="right column"><div class="shopping_form"><h4>' + text_.title + '</h4><form onsubmit="return false;"><ul><li><label for="company">The company:</label><input type="text" id="company" name="name" placeholder=""></li><li><label for="phone">Phone:</label><input type="text" id="phone" name="phone" placeholder=""></li><li><label for="mail">E-mail:</label><input type="text" id="mail" name="mail" placeholder=""></li><li><label for="content">Detailed message:</label><textarea id="content" name="content" placeholder=""></textarea></li><li><input type="submit" value="' + text_.submit + '"></li></ul></form></div></div></div><i class="close fa fa-close"></i></div>';


            // 初始化
            var data = [], lock = true;
            if ($.cookie !== undefined) {
                if ($.cookie('the_product_info') !== undefined && $.cookie('the_product_info') !== '') {
                    data = $.cookie('the_product_info').split('?');
                }
            } else {
                alert('需要cookie插件支持！');
                return;
            }
            $(element.shopping_cart).find('em').html(data.length);


            // 列表
            function click_car(T) {
                lock = true;
                var name = T.parents(element.product_box).find(element.product_name).length ? T.parents(element.product_box).find(element.product_name).text() : '',
                    url = T.parents(element.product_box).find(element.product_link).length ? T.parents(element.product_box).find(element.product_link).attr('href') : '',
                    det = T.parents(element.product_box).find(element.product_det).length ? T.parents(element.product_box).find(element.product_det).text() : '',
                    img = T.parents(element.product_box).find(element.product_img).length ? T.parents(element.product_box).find(element.product_img).attr('src') : '',
                    tag = T.parents(element.product_box).find(element.product_tag).length ? T.parents(element.product_box).find(element.product_tag).children('*') : '';
                if ($.isArray(data)) {
                    data.map(function (value, index) {
                        var key = Object.keys(JSON.parse(value))[0];
                        if (key === T.parents(element.product_box).attr('data-id')) {
                            lock = false;
                            data.splice(index, 1);
                        }
                    });
                }

                var tag_arr = [];
                if (tag !== '') {
                    tag.filter(function () {
                        tag_arr.push($(this).text())
                    });
                }

                var text = '{"' + T.parents(element.product_box).attr('data-id') + '":{"name":"' + name.replace(/\s/g, " ") + '","url":"' + url + '","det":"' + det + '","img":"' + img + '","tag":"' + tag_arr.join('/') + '"}}';
                if (lock) {
                    data.push(text);
                }
                $(element.shopping_cart).find('em').html(data.length);
                $.cookie('the_product_info', data.join('?'), {path: '/'});
            }

            $(document).on('click', element.product_add, function (e) {
                click_car($(this));
                $(this).toggleClass('active');
            });

            function cart_detect() {
                data.map(function (value, index) {
                    var detect = JSON.parse(value);
                    $(element.product_box).filter(function () {
                        if (Object.keys(detect)[0] === $(this).attr('data-id')) {
                            $(this).find(element.product_add).addClass('active')
                        }
                    })
                });
            }

            //购物车
            function Structure_injection() {
                if (cart_page) {
                    return data;
                }else {
                    var data_ = [];
                    $(element.shopping_list).html('');
                    data.map(function (value, index) {
                        data_ = JSON.parse(value);
                        $(element.shopping_list).append('<li>\n' +
                            '               <div class="box2 grid-box">\n' +
                            '                   <div class="img column"><a href="' + data_[Object.keys(data_)[0]].url + '"><img src="' + data_[Object.keys(data_)[0]].img + '?imageView2/2/w/400/h/400/format/jpg/q/80" alt=""></a></div>\n' +
                            '                   <div class="text column">\n' +
                            '                       <h4><a href="' + data_[Object.keys(data_)[0]].url + '">' + data_[Object.keys(data_)[0]].name + '</a></h4><p>' + text_.number + '</p>\n' +
                            '                       <input class="num" type="number" value="1"/><div class="Item" hidden>' + data_[Object.keys(data_)[0]].tag + '</div>\n' +
                            '                       <textarea class="msg" placeholder=""></textarea>\n' +
                            '                       <i class="del fa fa-trash"></i>\n' +
                            '                   </div>\n' +
                            '               </div>\n' +
                            '           </li>')
                    });
                }
            }
            function cart() {
                if (!cart_page) {
                    $('body').append(html,css);
                    $.getScript('/static/js/layer/layer.js');
                    Structure_injection();
                    $(document).on('click','#cart i.del', function (e) {
                        var info_ = $(this).parents('li');
                        if (data.length) {
                            data.splice(info_.index(), 1);
                            $(element.shopping_cart).find('em').html(data.length);
                            $.cookie('the_product_info', data.join('?'), {path: '/'});
                            info_.remove();
                            if (!data.length) {
                                $(element.shopping_list).html(text_.cart);
                            }
                        }
                    });
                    $(document).on('blur','#cart input', function (e) {
                        if ($(this).val() === '') {
                            layer.msg(text_.required, {icon: 2, time: 4000});
                        }
                    })
                    $(document).on('click','#cart input[type=\'submit\']', function (e) {
                        e.preventDefault();
                        var content = '';
                        $(element.shopping_list).find('li').filter(function () {
                            content += '\n' + $(this).find('h4').text() + '\n' +
                                'Qty:' + $(this).find('input').val() + '\n' +
                                'Message:' + $(this).find('textarea').val() + '\n' +
                                'Url:' + $(this).find('a').attr('href') + '\n' +
                                '-------------------------------------------\n'
                        });
                        var textarea = $(element.shopping_form).find("textarea").val();
                        $(element.shopping_form).find("textarea").val(textarea + content);
                        layer.load(0, {shade: 0.1, shadeClose: false});
                        $.ajax({
                            type: 'post',
                            url: '/Api/contact/submit/uid/1.html',
                            data: $(element.shopping_form).find('form').serialize(),
                            dataType: 'json',
                            success: function (ret) {
                                layer.closeAll();
                                $(element.shopping_form).find("textarea").val(textarea);
                                if (ret.status == 200) {
                                    layer.msg(ret.result, {icon: 1, time: 4000});
                                    $(element.shopping_cart).find('em').html(0);
                                    $.cookie('the_product_info', '', {path: '/'});
                                } else {
                                    layer.msg(ret.result, {icon: 2, time: 4000})
                                }
                            }
                        })
                    });
                    $(document).on('click','#cart span.close_all', function (e) {
                        $(element.shopping_list).find('li').remove();
                        $(element.shopping_cart).find('em').html(0);
                        $.cookie('the_product_info', '', {path: '/'});
                    });
                    $(document).on('click',element.shopping_cart, function (e) {
                        $("#cart").fadeIn(300);
                        Structure_injection();
                    })
                    $(document).on('click','#cart i.fa-close', function (e) {
                        $("#cart").fadeOut(300)
                    })
                }else {
                    product(Structure_injection())
                }
            }

            cart_detect();
            cart();
        }
    };


    /**
     * 全局效果说明
     * ---------------------Dividing line--------------------
     * @num_plus 数字相加
     * 参数 (obj,set_num,speed = 60)
     * 详解 obj
     *      获取容器对象
     *     set_num
     *      设置相加比例 公式: 数字 / set_num = 每次相加数字(整数)
     *     speed
     *      动画速度 默认 60ms
     * html 结构
     *      <ul>
     *          <li>*<em data-num="Number">0</em>*</li>
     *      </ul>
     *
     * ---------------------Dividing line--------------------
     * @BG_parallax 背景视差
     * 参数 (obj,speed = 0.5)
     * 详解 obj
     *      获取容器对象
     *     speed
     *      动画速度 默认 0.5
     *
     * ---------------------Dividing line--------------------
     * @Interval_Fun 区间判断
     * 参数 (obj,means,cycle,position)
     * 详解 obj
     *      获取容器对象
     *     means
     *      执行方法
     *     cycle
     *      是否多次执行  boolean值
     *     position
     *      当容器自身多少出现在屏幕中时执行 公式：容器高度 / position
     *
     * ---------------------Dividing line--------------------
     * @Video_open 视频弹窗
     * 参数 (obj,url,btn,img)
     * 详解 obj
     *       获取点击对象 ( html标签 data-src="视频地址" data-img="video第一帧" data-btn="关闭按钮颜色")
     *      method
     *       切换模式 (video / iframe) false / true
     *
     * ---------------------Dividing line--------------------
     * @Line_curve 画曲线
     * 参数 (obj,origin,coordinate,color,speed)
     * 详解 obj
     *       获取ID属性
     *     origin
     *       中心点 （数组） 百分比
     *     coordinate
     *       其它点 （控制点+终点）
     *       [
     *          [[终点],[控制点]] 百分比
     *       ]
     *     color
     *       线条颜色
     *     img
     *       图片
     *     speed
     *       速度
     * @shopping_cart 伪购物车
     * 参数 (text_, element, cart_page = false)
     * 详解 text_ = {
                    close: 'Close All',
                    title: 'Feedback',
                    submit: 'Send',
                    number: 'Number:',
                    cart: 'There are no products, just add them!',
                    required: 'Can not be empty!'
                }
     cart_page 是否启用自定义购物弹窗
     product 不启用时 返回数据
     注意 若提交失败 检查是否存在对应字段
     *
     */


})