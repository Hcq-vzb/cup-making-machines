(function () {
  'use strict';

  var WA_PHONE = '8617751189576';
  var WA_SITE = 'https://www.cupmakingmachines.com';

  function getPageUrl() {
    var href = window.location.href;
    if (href.indexOf('file://') === 0 || href.indexOf('localhost') !== -1) {
      var path = window.location.pathname.replace(/\\/g, '/');
      if (path.slice(-1) === '/' || /\/index\.html$/i.test(path)) {
        return WA_SITE + path.replace(/index\.html$/i, '');
      }
      return WA_SITE + path;
    }
    return href.split('#')[0];
  }

  function getProductLabel() {
    return document.title
      .replace(/\s*[-|]\s*KIWL.*$/i, '')
      .replace(/\s*[-|]\s*Jiangsu.*$/i, '')
      .replace(/\s*[-|]\s*Page \d+.*$/i, '')
      .replace(/\s*\|\s*KIWL.*$/i, '')
      .trim() || 'KIWL Machinery';
  }

  function getWaText(lang) {
    var pageUrl = getPageUrl();
    var product = getProductLabel();
    if (lang === 'ar') {
      return '\u0645\u0631\u062D\u0628\u0627\u064B! \u0648\u062C\u062F\u062A KIWL \u0639\u0628\u0631 ' + pageUrl + ' \u0648\u0623\u0646\u0627 \u0645\u0647\u062A\u0645 \u0628\u0640: ' + product + '. \u064A\u0631\u062C\u0649 \u0627\u0644\u062A\u062D\u0642\u0642 \u0645\u0646 \u0627\u0633\u062A\u0641\u0633\u0627\u0631\u064A.';
    }
    return 'Hello! I found KIWL on ' + pageUrl + ' and I\'m interested in: ' + product + '. Please verify my inquiry.';
  }

  function getWaUrl(lang) {
    return 'https://wa.me/' + WA_PHONE + '?text=' + encodeURIComponent(getWaText(lang));
  }

  var STRINGS = {
    en: {
      agentName: 'KIWL Support',
      agentRole: 'Online · Sales Team',
      greeting: 'Hello! 👋 Welcome to <strong>Jiangsu KIWL Machinery</strong>.',
      intro: 'We are a leading manufacturer in Zhangjiagang, Jiangsu, China — specializing in <strong>high-speed paper cup machines</strong>, <strong>paper bowl machines</strong>, <strong>salad bowl machines</strong>, double-wall machines, and coffee cup machines. With over 10 years of experience, our machines are exported worldwide and certified with ISO9001 & CE.',
      askInterest: 'What are you interested in today?',
      optCup: 'Paper Cup Machine',
      optBowl: 'Paper Bowl Machine',
      optSalad: 'Salad Bowl Machine',
      optQuote: 'Get a Quote',
      replyCup: 'Our <strong>Paper Cup Machines</strong> include high-speed, automatic, and disposable models — ideal for food & beverage packaging at scale. We can customize cup sizes per your requirements.',
      replyBowl: 'Our <strong>Paper Bowl Machines</strong> deliver efficient, precise production for food service — including high-speed, automatic, and disposable bowl lines.',
      replySalad: 'Our <strong>Salad Bowl Machines</strong> are designed for square and round salad bowl production with full servo control and high output capacity.',
      replyQuote: 'We\'d love to help with pricing, specifications, and custom solutions. Our sales team will respond promptly with drawings based on your cup/bowl size requirements.',
      contactPrompt: 'For detailed pricing, technical specs, or a factory visit — chat with our sales manager on WhatsApp:',
      waBtn: 'Chat on WhatsApp',
      toggleLabel: 'Customer service'
    },
    ar: {
      agentName: 'دعم KIWL',
      agentRole: 'متصل · فريق المبيعات',
      greeting: 'مرحباً! 👋 أهلاً بك في <strong>Jiangsu KIWL Machinery</strong>.',
      intro: 'نحن مصنع رائد في Zhangjiagang، Jiangsu، الصين — متخصصون في <strong>آلات الأكواب الورقية عالية السرعة</strong>، <strong>آلات وعاء الورق</strong>، <strong>آلات وعاء السلطة</strong>، آلات الجدار المزدوج، وماكينات فنجان القهوة. لدينا أكثر من 10 سنوات من الخبرة، وتُصدَّر آلاتنا إلى جميع أنحاء العالم وهي معتمدة ISO9001 و CE.',
      askInterest: 'ما الذي يهمك اليوم؟',
      optCup: 'آلة الأكواب الورقية',
      optBowl: 'آلة وعاء الورق',
      optSalad: 'آلة وعاء السلطة',
      optQuote: 'طلب عرض سعر',
      replyCup: '<strong>آلات الأكواب الورقية</strong> لدينا تشمل موديلات عالية السرعة وأوتوماتيكية ومخصصة للاستخدام الواحد — مثالية لتعبئة الأغذية والمشروبات على نطاق واسع.',
      replyBowl: '<strong>آلات وعاء الورق</strong> لدينا توفر إنتاجاً دقيقاً وفعالاً لقطاع المطاعم — بما في ذلك خطوط عالية السرعة والأوتوماتيكية.',
      replySalad: '<strong>آلات وعاء السلطة</strong> لدينا مصممة لإنتاج أوعية السلطة المربعة والمستديرة مع تحكم servo كامل وقدرة إنتاج عالية.',
      replyQuote: 'يسعدنا مساعدتك في الأسعار والمواصفات والحلول المخصصة. سيرد فريق المبيعات بسرعة مع رسومات وفقاً لمتطلبات حجم الكوب/الوعاء.',
      contactPrompt: 'للحصول على الأسعار التفصيلية والمواصفات الفنية — تواصل مع مدير المبيعات عبر WhatsApp:',
      waBtn: 'محادثة على WhatsApp',
      toggleLabel: 'خدمة العملاء'
    }
  };

  function getLang() {
    var html = document.documentElement;
    if (html.lang === 'ar' || /\/ar\//.test(location.pathname)) {
      return 'ar';
    }
    return 'en';
  }

  function getAssetBase() {
    var scripts = document.getElementsByTagName('script');
    for (var i = 0; i < scripts.length; i++) {
      var src = scripts[i].getAttribute('src') || '';
      if (src.indexOf('live-chat.js') !== -1) {
        return src.replace(/js\/live-chat\.js(\?.*)?$/, '');
      }
    }
    return 'Template/316/';
  }

  function loadCss(href) {
    if (document.querySelector('link[href*="live-chat.css"]')) return;
    var link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = href + 'css/live-chat.css';
    document.head.appendChild(link);
  }

  function el(tag, cls, html) {
    var node = document.createElement(tag);
    if (cls) node.className = cls;
    if (html != null) node.innerHTML = html;
    return node;
  }

  function ChatWidget(base, lang) {
    this.base = base;
    this.lang = lang;
    this.t = STRINGS[lang];
    this.isOpen = false;
    this.started = false;
    this.step = 0;
    this.root = null;
    this.messagesEl = null;
    this.optionsEl = null;
    this.typingEl = null;
  }

  ChatWidget.prototype.init = function () {
    var self = this;
    var isRtl = this.lang === 'ar';
    var waUrl = getWaUrl(this.lang);

    this.root = el('div', 'kiwl-live-chat' + (isRtl ? ' is-rtl' : ''));
    this.root.id = 'kiwl-live-chat';

    this.root.innerHTML =
      '<div class="kiwl-chat-panel" role="dialog" aria-label="' + this.t.toggleLabel + '">' +
        '<div class="kiwl-chat-header">' +
          '<div class="kiwl-chat-avatar"><svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/></svg></div>' +
          '<div class="kiwl-chat-header-info"><h4>' + this.t.agentName + '</h4><p class="kiwl-chat-status">' + this.t.agentRole + '</p></div>' +
        '</div>' +
        '<div class="kiwl-chat-messages"></div>' +
        '<div class="kiwl-chat-options"></div>' +
        '<div class="kiwl-chat-footer">' +
          '<a class="kiwl-chat-wa-btn" href="' + waUrl + '" target="_blank" rel="noopener noreferrer">' +
            '<svg viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.435 9.884-9.884 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>' +
            this.t.waBtn +
          '</a>' +
        '</div>' +
      '</div>' +
      '<button type="button" class="kiwl-chat-toggle" aria-label="' + this.t.toggleLabel + '">' +
        '<span class="kiwl-chat-badge"></span>' +
        '<svg class="kiwl-chat-open-icon" viewBox="0 0 24 24"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z"/></svg>' +
        '<svg class="kiwl-chat-close-icon" viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12 19 6.41z"/></svg>' +
      '</button>';

    document.body.appendChild(this.root);

    this.messagesEl = this.root.querySelector('.kiwl-chat-messages');
    this.optionsEl = this.root.querySelector('.kiwl-chat-options');

    this.root.querySelector('.kiwl-chat-toggle').addEventListener('click', function () {
      self.toggle();
    });
  };

  ChatWidget.prototype.toggle = function () {
    this.isOpen = !this.isOpen;
    this.root.classList.toggle('is-open', this.isOpen);
    if (this.isOpen && !this.started) {
      this.started = true;
      this.root.classList.add('has-interacted');
      this.runConversation();
    }
  };

  ChatWidget.prototype.addMessage = function (text, isUser) {
    var msg = el('div', 'kiwl-chat-msg ' + (isUser ? 'is-user' : 'is-bot'));
    msg.appendChild(el('div', 'kiwl-chat-bubble', text));
    this.messagesEl.appendChild(msg);
    this.scrollToBottom();
  };

  ChatWidget.prototype.showTyping = function () {
    this.typingEl = el('div', 'kiwl-chat-msg is-bot');
    this.typingEl.appendChild(el('div', 'kiwl-chat-typing', '<span></span><span></span><span></span>'));
    this.messagesEl.appendChild(this.typingEl);
    this.scrollToBottom();
  };

  ChatWidget.prototype.hideTyping = function () {
    if (this.typingEl && this.typingEl.parentNode) {
      this.typingEl.parentNode.removeChild(this.typingEl);
    }
    this.typingEl = null;
  };

  ChatWidget.prototype.scrollToBottom = function () {
    var el = this.messagesEl;
    el.scrollTop = el.scrollHeight;
  };

  ChatWidget.prototype.delay = function (ms) {
    return new Promise(function (resolve) { setTimeout(resolve, ms); });
  };

  ChatWidget.prototype.botSay = function (text, pause) {
    var self = this;
    pause = pause == null ? 900 : pause;
    return self.delay(pause).then(function () {
      self.showTyping();
      return self.delay(700 + Math.random() * 400);
    }).then(function () {
      self.hideTyping();
      self.addMessage(text, false);
    });
  };

  ChatWidget.prototype.showOptions = function (options) {
    var self = this;
    this.optionsEl.innerHTML = '';
    options.forEach(function (opt) {
      var btn = el('button', 'kiwl-chat-option', opt.label);
      btn.type = 'button';
      btn.addEventListener('click', function () {
        self.optionsEl.innerHTML = '';
        self.addMessage(opt.label, true);
        opt.action();
      });
      self.optionsEl.appendChild(btn);
    });
    self.scrollToBottom();
  };

  ChatWidget.prototype.runConversation = function () {
    var self = this;
    var t = this.t;

    self.botSay(t.greeting, 400)
      .then(function () { return self.botSay(t.intro, 600); })
      .then(function () { return self.botSay(t.askInterest, 500); })
      .then(function () {
        self.showOptions([
          { label: t.optCup, action: function () { self.handleProduct('cup'); } },
          { label: t.optBowl, action: function () { self.handleProduct('bowl'); } },
          { label: t.optSalad, action: function () { self.handleProduct('salad'); } },
          { label: t.optQuote, action: function () { self.handleProduct('quote'); } }
        ]);
      });
  };

  ChatWidget.prototype.handleProduct = function (type) {
    var self = this;
    var t = this.t;
    var replies = {
      cup: t.replyCup,
      bowl: t.replyBowl,
      salad: t.replySalad,
      quote: t.replyQuote
    };

    self.botSay(replies[type], 500)
      .then(function () { return self.botSay(t.contactPrompt, 600); });
  };

  function boot() {
    var base = getAssetBase();
    loadCss(base);
    var widget = new ChatWidget(base, getLang());
    widget.init();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
})();
