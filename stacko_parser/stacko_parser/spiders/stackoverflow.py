# -*- coding: utf-8 -*-
import scrapy
import os
from stacko_parser.items import Question
import html2text

class StackoverflowSpider(scrapy.Spider):
    name = "stackoverflow"
    allowed_domains = ["stackoverflow.com"]

    start_urls = []
    for page in range(0, 65000):
        print('PARSING STACKOVERFLOW PAGE NUMBER ', page)
        start_urls.append('http://stackoverflow.com/questions?page=' + str(page))

    def parse(self, response):
        self.logger.info('A response from %s just arrived!', response.url)

        for url in response.css('.question-hyperlink').xpath('@href'):
            yield scrapy.Request(response.urljoin(url.extract()), self.parse_question)

    def parse_question(self, response):
        question = response.css('div.question')
        titleSelector = response.css('#question-header h1')
        owner = question.css('.post-signature.owner')
        userurl = question.css('.post-signature.owner a').xpath('@href').extract().pop()
        created_at = owner.css('.relativetime').xpath('@title').extract().pop()
        last_edittime = question.css('.post-signature').xpath('a[@href="*/revisions"]/span[@class="relativetime"]').xpath('@title').extract()

        item = {
            'title': titleSelector.css('a::text').extract().pop(),
            'url': titleSelector.css('a').xpath('@href').extract().pop(),

            'description': html2text.html2text(question.css('div.post-text').extract().pop()),
            'vote': int(question.css('.vote-count-post::text').extract().pop()),

            'created_at': created_at,
            'updated_at': created_at if len(last_edittime) == 0 else last_edittime.pop(),

            'user': {
                'name': os.path.basename(userurl),
                'url': userurl
            },
            'comments': []
        }
        item['slug'] = os.path.basename(item['url'])

        item['tags'] = question.css('.post-taglist .post-tag::text').extract()

        comments_selector = question.css('.comments .comment')
        for comment in comments_selector:
            comment_text_selector = comment.css('.comment-text')
            userurl = comment_text_selector.css('.comment-body .comment-user').xpath('@href').extract().pop()
            comment_date = comment_text_selector.css('.comment-body .comment-date span').xpath('@title').extract().pop()

            c = {
                'id': int(comment.xpath('@id').extract().pop().split('-')[1]),
                'text': html2text.html2text(comment.css('.comment-text .comment-body .comment-copy').extract().pop()),
                'user': {
                    'name': os.path.basename(userurl),
                    'url': userurl
                },
                'updated_at': comment_date,
                'created_at': comment_date
            }
            item['comments'].append(c)

        return item
