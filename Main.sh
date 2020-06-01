Main() {
	(
		set -xuC &&
		set -o pipefail &&
		true
	) &&
	InstallShTools 'https://raw.githubusercontent.com/victor-yarema/ShToolsCoreInstaller/master/main.sh?md5=a35be7aa375670baedace672a14c0a99' &&
	InstallShOptions &&
	InstallOhMyZsh 'https://raw.githubusercontent.com/victor-yarema/oh-my-zsh/master/tools/install.sh?md5=328b041c98ff0f170e79e411203c1768' &&
	exec "${SHELL}" &&
	true
} &&
: &&
: &&
Exists() (
	set -uC &&
	set -o pipefail &&
	command -v "$1" >/dev/null 2>&1
) &&
: &&
: &&
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
: &&
: &&
InstallShTools() {
SysDir="${HOME}/.Sys" &&
(
set -uC &&
set -o pipefail &&
EnsureTool git &&
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
: &&
: &&
InstallShOptions() {
SysDir="${HOME}/.Sys" &&
(
set -uC &&
set -o pipefail &&
mkdir -p "${SysDir}" &&
AppendText "${SysDir}/ShOptions" \
	'# Shell basics' \
	"set -uC
set -o pipefail"$'\n' &&
AppendText "${SysDir}/StrictShRc" \
	'# Less options' \
	"#export LESS='-RSFX -#4'
export LESS='-RS -#4'
export LESSCHARSET=utf-8"$'\n' &&
AppendText "${SysDir}/StrictShRc" \
	'# Language' \
	"export LANGUAGE=C.UTF-8"$'\n' &&
AppendText "${SysDir}/StrictShRc" \
	'# Make multithreaded' \
	"alias Make='make -j 8 -O'"$'\n' &&
AppendText "${SysDir}/StrictShRc" \
	'# LS_COLORS' \
'[ -z ${LS_COLORS+x} ] &&
	eval "$(dircolors -b)"
export LS_COLORS="$( echo $LS_COLORS | '"tr : '\n' | sed -E 's/(^ow=).*/\133;40/' | grep -v '^$' | tr '\n' :"' )"'$'\n' &&
true
) &&
. "${SysDir}/ShOptions" &&
. "${SysDir}/StrictShRc"
} &&
: &&
: &&
InstallOhMyZsh() {
Url="$1" &&
SysDir="${HOME}/.Sys" &&
{
	! [ -z ${OhMyZshDir+x} ] ||
	OhMyZshDir="${SysDir}/Tools/OhMyZsh"
} &&
AppendText "${SysDir}/OhMyZshCfg" \
	'# Theme' \
	$'ZSH_THEME="robbyrussell"\n' &&
AppendText "${SysDir}/OhMyZshCfg" \
	'# Plugins' \
	$'plugins=(git)\n' &&
AppendText "${SysDir}/OhMyZshCfg" \
	'# Case sensitive' \
	$'CASE_SENSITIVE="true"\n' &&
AppendText "${SysDir}/OhMyZshCfg" \
	'# Updates' \
	$'#export UPDATE_ZSH_DAYS=1\n' &&
AppendText "${SysDir}/OhMyZshCfg" \
	'# Completion dots' \
	$'COMPLETION_WAITING_DOTS="true"\n' &&
AppendText "${SysDir}/OhMyZshCfg" \
	'# History time format' \
	$'HIST_STAMPS="yyyy-mm-dd"\n' &&
AppendText "${SysDir}/OhMyZshCfg" \
	'# HistSaveTrimSize' \
	$'SAVEHIST=1000000\n' &&
AppendText "${SysDir}/OhMyZsh" \
	'# All' \
	". '${SysDir}/OhMyZshCfg'
export OhMyZshDir='${OhMyZshDir}'
. "'"${OhMyZshDir}/oh-my-zsh.sh"'$'\n' &&
AppendText "${SysDir}/ZshRc" \
	'# OhMyZsh' \
	". '${SysDir}/OhMyZsh'"$'\n' &&
AppendText "${HOME}/.zshrc" \
	'# ZshRc' \
	". '${SysDir}/ZshRc'"$'\n' &&
"${SHELL}" -c "set -x && set +u && OhMyZshDir='${OhMyZshDir}' && $( curl -fsSLv "${Url}" )"
} &&
: &&
: &&
Main "$@"

Res=$?
{
	( exit $Res ) &&
	echo Success
} ||
echo Error
( exit $Res )

