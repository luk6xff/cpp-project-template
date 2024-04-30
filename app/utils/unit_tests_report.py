import xml.etree.ElementTree as ET
import os
import argparse
import datetime


def combine_xml_files(directory, output_file):
    main_root = None
    main_tree = None

    # Walk through the directory, and find all XML files
    for root_dir, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.xml'):
                path = os.path.join(root_dir, file)
                tree = ET.parse(path)
                root = tree.getroot()
                if main_root is None:
                    main_tree = tree
                    main_root = root
                else:
                    # Append each testcase element to the main root
                    for testcase in root.findall('.//testcase'):
                        main_root.append(testcase)

    # Write the combined XML to file if there are any test cases
    if main_root is not None:
        main_tree.write(output_file)

    return output_file



def xml_to_html(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()

    # Retrieve all testcases and sort them by 'classname'
    testcases = root.findall('.//testcase')
    testcases.sort(key=lambda x: x.get('classname', ''))

    now = datetime.datetime.now()
    current_time = now.strftime("%Y-%m-%d %H:%M:%S")

    passed_count = 0
    failed_count = 0

    html = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Unit Tests Report</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .failed {
                background-color: #f8d7da; /* Light red background for failed tests */
            }
            .passed {
                background-color: #d4edda; /* Light green background for passed tests */
            }
            @media (max-width: 768px) {
                .table-responsive-sm {
                    overflow-x: auto;
                }
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <h1 class="text-center mb-4">Unit Tests Report</h1>
            <div class="table-responsive-sm">
                <div id="summary" class="alert alert-info" role="alert">
                    Processing test results...
                </div>
                <table class="table table-bordered table-hover table-sm">
                    <thead class="thead-light">
                        <tr>
                            <th scope="col">Test Case</th>
                            <th scope="col">Status</th>
                            <th scope="col">Time</th>
                            <th scope="col">Timestamp</th>
                            <th scope="col">File</th>
                            <th scope="col">Line</th>
                            <th scope="col">Failure Details</th>
                        </tr>
                    </thead>
                    <tbody>
    """

    for testcase in testcases:
        classname = testcase.get('classname')
        name = testcase.get('name')
        time = testcase.get('time')
        timestamp = testcase.get('timestamp')
        file = testcase.get('file')
        line = testcase.get('line')
        failure = testcase.find('failure')
        if failure is not None:
            failed_count += 1
            row_class = "failed"
            status_text = "FAILED"
            failure_text = failure.text.strip() if failure.text else "Failure details not available"
        else:
            passed_count += 1
            row_class = "passed"
            status_text = "PASSED"
            failure_text = "N/A"

        html += f"""
                        <tr class="{row_class}">
                            <td>{classname}-{name}</td>
                            <td>{status_text}</td>
                            <td>{time}</td>
                            <td>{timestamp}</td>
                            <td>{file}</td>
                            <td>{line}</td>
                            <td>{failure_text}</td>
                        </tr>
        """

    summary_text = f"Total Tests: {passed_count + failed_count}, Passed: {passed_count}, Failed: {failed_count}"
    html = html.replace('Processing test results...', summary_text)  # Replace placeholder with actual summary

    html += f"""
                    </tbody>
                </table>
            </div>
            <footer class="footer mt-auto py-3 bg-light text-center">
                <div class="container">
                    <span class="text-muted text-danger"{summary_text}</span><br>
                    <span class="text-muted">Report generated on: {current_time}</span><br>
                    <span class="text-muted">Report file path: {xml_path}</span>
                </div>
            </footer>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
    """
    return html



def main(xml_dir, output_dir):
    combined_xml_path = os.path.join(output_dir, "combined_results.xml")
    combined_xml_path = combine_xml_files(xml_dir, combined_xml_path)
    if os.path.exists(combined_xml_path):
        html_content = xml_to_html(combined_xml_path)
        html_path = os.path.join(output_dir, 'unit_tests_report.html')  # Output as 'results.html' in output_dir
        with open(html_path, 'w') as file:
            file.write(html_content)
        print(f"Generated HTML report: {html_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert XML test results to HTML format.")
    parser.add_argument('xml_dir', type=str, help="Directory containing XML files to process.")
    parser.add_argument('output_dir', type=str, help="Directory to output the HTML results.")
    args = parser.parse_args()
    main(args.xml_dir, args.output_dir)

