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
Main() (
	set -xuC &&
	set -o pipefail &&
	EnsureTool git
) &&
Main "$@"
