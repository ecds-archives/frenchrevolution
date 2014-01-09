import re
import datetime

from django.utils.safestring import mark_safe

from eulexistdb.manager import Manager
from eulexistdb.models import XmlModel
from eulxml.xmlmap.core import XmlObject 
from eulxml.xmlmap.dc import DublinCore
from eulxml.xmlmap.fields import StringField, NodeField, StringListField, NodeListField, Field
from eulxml.xmlmap.teimap import Tei, TeiDiv, _TeiBase, TEI_NAMESPACE, xmlmap, TeiInterpGroup, TeiInterp


'''
declare namespace xml=\'http://www.w3.org/XML/1998/namespace\';
\n
declare namespace tei=\'http://www.tei-c.org/ns/1.0\';
\n
collection("/db/fr_django/")
'''

class Fields(XmlObject):
    id = StringField('@id')
    figure = StringField('figure')
    author = StringField('author')
    date = StringField('date')
    title = StringField('title') 

class Pamphlet(XmlObject):
    pamphlets = NodeListField('//pamphlet', Fields)
    

class Text(XmlModel, Tei):
    ROOT_NAMESPACES = {'tei' : TEI_NAMESPACE}
    objects = Manager('/tei:TEI')
    id = StringField('@xml:id')
    title = StringField('//tei:docTitle')
    author = StringField('//tei:docAuthor')
    text_string = StringField('tei:text')
    
