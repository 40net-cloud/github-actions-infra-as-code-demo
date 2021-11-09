Content-Type: multipart/mixed; boundary="==AWS=="
MIME-Version: 1.0

--==AWS==
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0

config system global
set hostname FGTVM
set admin-sport ${adminsport}
end
config system interface
edit port1
set alias public
set mode dhcp
set allowaccess ping https ssh fgfm
next
edit port2
set alias private
set mode dhcp
set allowaccess ping https ssh fgfm
set defaultgw disable
next

%{ if type == "byol" && fgt_license_file != "" }
--==AWS==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="${fgt_license_file}"

${file(fgt_license_file)}

%{ endif }
--==AWS==--
