---
layout: default
title: Homeworks
index_title: Homeworks
index_sort: 2
---

<!-- <div class="oldsitesm">
This schedule is tentative and subject to change (especially before the semester starts).
</div> -->

This page lists all homework assignments and their currently anticipated due times.
The schedule may change based on the actual pacing of the course material and other factors.

There are also [quizzes]({{site.quiz_site}}){:target="_top"} after each week of lecture.

Homeworks are due at 11:59pm Eastern Time unless otherwise noted. See [the policies page](policies.html)
regarding submitting homeworks late.

If an assignment is linked but tentative, there may be some changes to the assignment before it is officially released and/or it is possible we have not covered relevant material for the assignment yet in lecture.

{: #assignments}
{% for assignment in site.data.assignments %}
{%- if assignment.hide_web -%}
    {% continue %}
{%- endif -%}
{%- if assignment.lab -%}
{%- if assignment.page -%}
*  Lab: <a href="{{assignment.page | relative_url}}">{{assignment.name}}</a> {%- if assignment.tentative -%}&nbsp;(writeup tentative) {%- endif -%} &mdash; on {{assignment.due}}{{nl}}
{%- elsif assignment.no_due_link -%}
*  Lab: {{assignment.name}} ({{assignment.due}}){{nl}}
{%- else -%}
*  Lab: {{assignment.name}} (writeup not yet available) &mdash; on {{assignment.due}}{{nl}}
{%- endif -%}
{%- else -%} 
{%- if assignment.due_message -%}
{%- if assignment.page -%}
*  HW: <a href="{{assignment.page | relative_url}}">{{assignment.due_message}}</a> {%- if assignment.tentative -%}&nbsp;(tentative) {%- endif -%} &mdash; on {{assignment.due}}{{nl}}
{%- elsif assignment.url -%}
*  HW: <a href="{{assignment.url}}">{{assignment.due_message}}</a> {%- if assignment.tentative -%}&nbsp;(writeup tentative) {%- endif -%} &mdash; on {{assignment.due}}{{nl}}
{%- else -%}
*  HW: {{assignment.name}} (writeup not yet available) &mdash; due {{assignment.due}}{{nl}}
{%- endif -%}
{%- else -%}
{%- if assignment.page -%}
*  HW: <a href="{{assignment.page | relative_url}}">{{assignment.name}}</a> {%- if assignment.tentative -%}&nbsp;(tentative) {%- endif -%} &mdash; due {{assignment.due}}{{nl}}
{%- elsif assignment.url -%}
*  HW: <a href="{{assignment.url}}">{{assignment.name}}</a> {%- if assignment.tentative -%}&nbsp;(writeup tentative) {%- endif -%} &mdash; due {{assignment.due}}{{nl}}
{%- else -%}
*  HW: {{assignment.name}} (writeup not yet available) &mdash; due {{assignment.due}}{{nl}}
{%- endif -%}
{%- endif -%}
{%- endif -%}
{{nl}}
{% endfor %}
