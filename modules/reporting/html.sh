#!/bin/bash

generate_html_report(){

OUTPUT="$HOME/lab-report.html"

cat > "$OUTPUT" <<EOF
<html>

<head>

<title>LABCTL Report</title>

</head>

<body>

<h1>Cybersecurity Lab Report</h1>

<p>Date: $(date)</p>

</body>

</html>
EOF

echo "$OUTPUT"

}