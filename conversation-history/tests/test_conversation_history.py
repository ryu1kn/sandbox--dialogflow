import os
import shutil

from conversation_history import App

project_dir = f'{os.path.dirname(__file__)}/..'
test_output_dir = f'{project_dir}/test-tmp'
sample_log_entry = open(f'{project_dir}/sample-log-entry.txt', 'r').read()


def recreate_output_dir():
    shutil.rmtree(test_output_dir, ignore_errors=True)
    os.mkdir(test_output_dir)


def output_csv(id):
    return f'{test_output_dir}/{id}.csv'


def assert_file(filename, expected_contents):
    with open(filename, 'r') as file:
        assert file.read() == expected_contents


class FakeLogEntry:
    def __init__(self):
        self.text_payload = sample_log_entry


def test_app():
    recreate_output_dir()

    App(lambda: [FakeLogEntry()], output_csv('base')).run()

    assert_file(output_csv('base'), """\
timestamp,score,intent_name,speech
2020-04-01t22:44:37.445z,0.9,greeting.care-other,"I'm good, thank you."
""")
