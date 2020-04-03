import lark
import json

_parser = lark.Lark(r"""
    value: dict
         | pairs
         | list
         | ESCAPED_STRING
         | SIGNED_NUMBER
         | "true" | "false" | "null"

    list : "[" [value ("," value)*] "]"

    dict : "{" pairs "}"
    pairs: [pair (pair)*]
    pair : CNAME ":" value
         | CNAME dict

    %import common.CNAME
    %import common.ESCAPED_STRING
    %import common.SIGNED_NUMBER
    %import common.WS
    %ignore WS

    """, start='value')


class TreeToJson(lark.Transformer):
    null = lambda self, _: None
    true = lambda self, _: True
    false = lambda self, _: False

    def CNAME(self, v):
        return v.value

    def ESCAPED_STRING(self, v):
        return json.loads(v.value)

    def SIGNED_NUMBER(self, v):
        return float(v.value)

    def value(self, v):
        return v[0]

    list = list
    pair = tuple
    pairs = dict

    def dict(self, v):
        return v[0]


def parse(log_entry):
    tree = _parser.parse(log_entry)
    return TreeToJson().transform(tree)
