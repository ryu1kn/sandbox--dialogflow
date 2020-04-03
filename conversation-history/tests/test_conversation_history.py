from conversation_history import __version__, parser


def test_version():
    assert __version__ == '0.1.0'


def test_string():
    assert parser.parse('"text"') == 'text'


def test_number():
    assert parser.parse('4') == 4


def test_object_without_brackets():
    assert parser.parse('first_name: "foo"') == {'first_name': 'foo'}


def test_object_with_brackets():
    assert parser.parse('{first_name: "foo"}') == {'first_name': 'foo'}


def test_object_multiple_keys():
    assert parser.parse("""\
        first_name: "foo"
        last_name: "bar"
        """) == {'first_name': 'foo', 'last_name': 'bar'}


def test_string_with_double_quote():
    assert parser.parse('"foo\\"bar"') == 'foo"bar'
