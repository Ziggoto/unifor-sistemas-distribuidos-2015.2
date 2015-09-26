#!/usr/bin/python

class ParseTimes:

	def __init__(self):
		self.new_file = ""
		self.table_body = ""

		with open("output_times.csv", "r") as output_times_file:
			for time_line in output_times_file.readlines():
				self._parse_line(time_line)

		self._build_html()

	def _build_html(self):
		header = """<thead>
			<tr>
				<th></th>
				<th>Sequencial</th>
				<th>Paralelo</th>
			</tr>
		</thead>
		<tbody>
		"""

		footer = "</tbody>"
		self.new_file = header+self.table_body+footer

		with open("docs/main.html", "w") as table_file:
			table_file.write(self.new_file)

	def _parse_line(self, line):
		file_size,qtde,time_sequencial,time_paralelo = line.split(',')
		test_name = "%sx%s" % (qtde, file_size)

		self.table_body += "<tr>"
		self.table_body += "<th>%s</th>" % test_name
		self.table_body += "<td>%s</td>" % self._parse_time(time_sequencial)
		self.table_body += "<td>%s</td>" % self._parse_time(time_paralelo)
		self.table_body += "</tr>"

	def _parse_time(self, time):
		return time
	

if __name__ == "__main__":
	ParseTimes()