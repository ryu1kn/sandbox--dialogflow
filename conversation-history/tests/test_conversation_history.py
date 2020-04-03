from conversation_history import parser


def test_string():
    assert parser.parse('"text"') == 'text'


def test_number():
    assert parser.parse('4') == 4


def test_number_negative():
    assert parser.parse('-4') == -4


def test_object_empty():
    assert parser.parse('{}') == {}


def test_object_without_brackets():
    assert parser.parse('first_name: "foo"') == {'first_name': 'foo'}


def test_object_with_brackets():
    assert parser.parse('{first_name: "foo"}') == {'first_name': 'foo'}


def test_object_nested():
    assert parser.parse('person {first_name: "foo"}') == {'person': {'first_name': 'foo'}}


def test_object_nested_3_levels():
    assert parser.parse('person {father {first_name: "foo"}}') == {'person': {'father': {'first_name': 'foo'}}}


def test_object_multiple_keys():
    assert parser.parse("""\
        first_name: "foo"
        father {
          first_name: "foo-dad"
        }
        """) == {'first_name': 'foo', 'father': {'first_name': 'foo-dad'}}


def test_string_with_double_quote():
    assert parser.parse('"foo\\"bar"') == 'foo"bar'
