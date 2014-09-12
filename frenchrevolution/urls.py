from django.conf.urls.defaults import *
from django.conf import settings
from django.conf.urls.static import static
from django.contrib.staticfiles.urls import staticfiles_urlpatterns

from django.contrib import admin
admin.autodiscover()

from frenchrevolution_app.views import index, overview, tag_guide, handbook, pamphlet_list,  pamphlet_display, digital_editions, research_guide, bibliography, vol_set1, vol_set2, vol_set3, searchform

urlpatterns = patterns('frenchrevolution_app.views',
    url(r'^$', 'index', name='index'),
    url(r'^search$', 'searchform', name='searchform'),
    #overview
    url(r'^overview$', 'overview', name='overview'),
    url(r'^tagguide$', 'tag_guide', name='tag_guide'),
    url(r'^frevhdbk$', 'handbook', name='handbook'),
    #pamphlet list
    url(r'^list$', 'pamphlet_list', name='pamphlet_list'),
    url(r'^list/(?P<sort>[^/]+)/$', 'pamphlet_list', name='pamphlet_list'),
    url(r'^list/digital$', 'digital_editions', name='digital_editions'),
    url(r'^list/digital/(?P<sort>[^/]+)/$', 'digital_editions', name='digital_editions'),
    url(r'^view/(?P<doc_id>[^/]+)$', 'pamphlet_display', name='pamphlet_display'),
    url(r'^view/(?P<doc_id>[^/]+)/xml$', 'pamphlet_xml', name='pamphlet_xml'),
    #research guide
    url(r'^revguide$', 'research_guide', name='research_guide'),
    url(r'^biblioguide$', 'bibliography', name='bibliography'),
    url(r'^vols1-3$', 'vol_set1', name='vol_set1'),
    url(r'^vols4-7$', 'vol_set2', name='vol_set2'),
    url(r'^vols8-13$', 'vol_set3', name='vol_set3'),
    (r'^sitemap\.xml$', 'django.contrib.sitemaps.views.sitemap', {'sitemaps': sitemaps}),
    )
   

#if settings.DEBUG:
  #urlpatterns += staticfiles_urlpatterns(
       #url(r'^static/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT } ),
    #)
