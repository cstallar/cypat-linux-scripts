echo "Generating oscap reports"
wget https://github.com/ComplianceAsCode/content/releases/download/v0.1.48/scap-security-guide-0.1.48-oval-510.zip
unzip scap-security-guide-0.1.48-oval-510.zip
OS_NAME = $(cat /etc/os-release | grep -o '^NAME="[^"]*' | cut -c7-)
if ["$OS_NAME"=="Ubuntu"]; then
  oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_anssi_np_nt28_high --results-arf arf.xml --report oscap-report.html --oval-results ./scap-security-guide-0.1.48-oval-5.10/ssg-ubuntu1604-ds-1.2.xml
else
  oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_anssi_np_nt28_high --results-arf arf.xml --report oscap-report.html --oval-results ./scap-security-guide-0.1.48-oval-5.10/ssg-debian8-ds-1.2.xml
fi
firefox oscap-report.html

echo "Firefox oscap report"
oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_stig --results-arf arf-firefox.xml --report report-firefox.html --oval-results ./scap-security-guide-0.1.48-oval-5.10/ssg-firefox-xccdf-1.2.xml
firefox report-firefox.html

echo "Lynis report"
sudo apt install ansi2html lynis #TODO: ADD THIS TO OTHER PROGRAM INSTALLS
lynis audit system | ansi2html -la > lynis-report.html
firefox lynis-report.html
