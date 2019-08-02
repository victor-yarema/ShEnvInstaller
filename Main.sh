Main() {
	(
		set -xuC &&
		set -o pipefail &&
		true
	) &&
	InstallShTools 'https://raw.githubusercontent.com/victor-yarema/ShToolsCoreInstaller/master/main.sh?md5=a35be7aa375670baedace672a14c0a99' &&
	true
} &&
Exists() (
	set -uC &&
	set -o pipefail &&
	command -v "$1" >/dev/null 2>&1
) &&
EnsureTool() (
	set -uC &&
	set -o pipefail &&
	T="$1" &&
	{
		Exists "${T}" ||
		{
			Res=0 &&
			Exists apt &&
			{
				{
					Exists sudo &&
					{
						sudo apt install -y "${T}" ||
						Res=$?
					}
				} ||
				{
					apt install -y "${T}" ||
					Res=$?
				}
			} &&
			( exit $Res ; )
		}
	}
) &&
InstallShTools() {

SysDir="${HOME}/.Sys" &&
(
set -uC &&
set -o pipefail &&
EnsureTool curl &&
Url="$1" &&
"${SHELL}" -c "$( curl -fsSLv "${Url}" )" \
	'' "${HOME}/Tools/ShToolsCore" "${HOME}/Tools/ShToolsText" "${SysDir}" &&
. "${SysDir}/ShTools" &&
touch "${SysDir}/UnstrictShRc" &&
touch "${SysDir}/ShOptions" &&
AppendText "${SysDir}/StrictShRc" \
	'# ShTools' \
	". '${SysDir}/ShTools'"$'\n' &&
AppendText "${SysDir}/ShRc" \
	'# All' \
	". '${SysDir}/UnstrictShRc'
. '${SysDir}/ShOptions'
. '${SysDir}/StrictShRc'"$'\n' &&
AppendText "${SysDir}/ZshRc" \
	'# ShRc' \
	". '${SysDir}/ShRc'"$'\n' &&
AppendText "${HOME}/.zshrc" \
	'# ZshRc' \
	". '${SysDir}/ZshRc'"$'\n' &&
AppendText "${SysDir}/BashRc" \
	'# ShRc' \
	". '${SysDir}/ShRc'"$'\n' &&
AppendText "${HOME}/.bash_profile" \
	'# BashRc' \
	". '${SysDir}/BashRc'"$'\n' &&
true
) &&
. "${SysDir}/ShTools"

} &&
Main "$@"

Res=$?
{
	( exit $Res ) &&
	echo Success
} ||
echo Error
( exit $Res )

