import os
import re
from collections import Counter
from urllib import urlencode
import logging
from collections import OrderedDict
from operator import itemgetter

from django.conf import settings
from django.shortcuts import render, render_to_response
from django.http import HttpResponse, Http404
from django.core.paginator import Paginator, InvalidPage, EmptyPage
from django.template import RequestContext
from django.contrib.sites.models import Site

from frenchrevolution_app.models import Pamphlet, Text
from frenchrevolution_app.forms import SearchForm

from eulxml.xmlmap.core import load_xmlobject_from_file
from eulxml.xmlmap.teimap import Tei, TeiDiv, _TeiBase, TEI_NAMESPACE, xmlmap
from eulcommon.djangoextras.http.decorators import content_negotiation
from eulexistdb.query import escape_string
from eulexistdb.exceptions import DoesNotExist, ReturnedMultiple

logger = logging.getLogger(__name__)


#Home
def index(request):
  return render_to_response('index.html', context_instance=RequestContext(request))

#Keyword Search
def searchform(request):
  "Search by keyword"
  form = SearchForm(request.GET)
  context = {'searchform': form}
  search_opts = {}
  number_of_results = 20

  if form.is_valid():
    keyword = form.cleaned_data['keyword']
    if 'keyword' in form.cleaned_data and form.cleaned_data['keyword']:
      search_opts['fulltext_terms'] = '%s' % form.cleaned_data['keyword']          
      pamphlets = Text.objects.filter(**search_opts).also('match_count').order_by('-match_count')
      for pamphlet in pamphlets:
        count = pamphlet.match_count
              
      context['pamphlets'] = pamphlets
      context['keyword'] = keyword
      context['form'] = form
      context['count'] = 'count'
           
  return render_to_response('search_results.html', context, context_instance=RequestContext(request))

#Overview
  
def overview(request):
  return render_to_response('overview.html', context_instance=RequestContext(request))

def tag_guide(request):
  return render_to_response('tag_guide.html', context_instance=RequestContext(request))

def handbook(request):
  return render_to_response('handbook.html', context_instance=RequestContext(request))



#Pamphlet List

def pamphlet_list(request, sort='title'):
  doc = xmlmap.load_xmlobject_from_file(filename=os.path.join(settings.BASE_DIR, 'static', 'xml', 'pamphletlist.xml'), xmlclass=Pamphlet)
  doc_list = []
  for doc.pamphlet in doc.pamphlets:
    doc_list.append(doc.pamphlet)
  doc_count = len(doc_list)

  if sort == 'title':
    doc_list = sorted(doc_list, key=lambda x: x.title)
  if sort == 'author':
    doc_list = sorted(doc_list, key=lambda x: x.author)
  if sort == 'date':
    doc_list = sorted(doc_list, key=lambda x: x.date)

  return render_to_response('pamphlet_list.html', {'sort': sort, 'doc_list': doc_list, 'doc_count': doc_count}, context_instance=RequestContext(request))

def digital_editions(request, sort='title'):
  doc = xmlmap.load_xmlobject_from_file(filename=os.path.join(settings.BASE_DIR, 'static', 'xml', 'pamphletlist.xml'), xmlclass=Pamphlet)
  doc_list = []
  for doc.pamphlet in doc.pamphlets:
    if doc.pamphlet.id:
      doc_list.append(doc.pamphlet)
    else:
      pass
  doc_count = len(doc_list)

  if sort == 'title':
    doc_list = sorted(doc_list, key=lambda x: x.title)
  if sort == 'author':
    doc_list = sorted(doc_list, key=lambda x: x.author)
  if sort == 'date':
    doc_list = sorted(doc_list, key=lambda x: x.date)
 
  return render_to_response('digital_editions.html', {'sort': sort, 'doc_list': doc_list, 'doc_count': doc_count}, context_instance=RequestContext(request)) 
    

def pamphlet_display(request, doc_id):
  if 'keyword' in request.GET:
    search_terms = request.GET['keyword']
    url_params = '?' + urlencode({'keyword': search_terms})
    filter = {'highlight': search_terms}    
  else:
    url_params = ''
    filter = {}
  pamphlet = Text.objects.filter(**filter).get(id__exact=doc_id)
  format = pamphlet.xsl_transform(filename=os.path.join(settings.BASE_DIR, '..', 'frenchrevolution_app', 'xslt', 'view.xsl'))
  return render_to_response('pamphlet_display.html', {'pamphlet': pamphlet, 'format': format.serialize()}, context_instance=RequestContext(request)) 

def pamphlet_xml(request, doc_id):
  "Display xml of a single issue."
  try:
    doc = Text.objects.get(id__exact=doc_id)
  except:
    raise Http404
  tei_xml = doc.serializeDocument(pretty=True)
  return HttpResponse(tei_xml, mimetype='application/xml')
  

#Research Guide
def research_guide(request):
  return render_to_response('research_guide.html', context_instance=RequestContext(request))

def bibliography(request):
  return render_to_response('bibliography.html', context_instance=RequestContext(request))

def vol_set1(request):
  return render_to_response('vol_set1.html', context_instance=RequestContext(request))

def vol_set2(request):
  return render_to_response('vol_set2.html', context_instance=RequestContext(request))

def vol_set3(request):
  return render_to_response('vol_set3.html', context_instance=RequestContext(request))


