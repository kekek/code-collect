#! /bin/bash

## getopts


## doc https://www.jianshu.com/p/7ebe1dbdc316

package=""  # Default to empty package
target=""  # Default to empty target

while getopts ":h" opt; do
    case ${opt} in
        h )
            echo "Usage:"
            echo "      $(basename "$0") <command> [options]"
            echo ""
            echo "Commands"
            echo "      install     Install a Python package."
            echo ""
            echo "General Options:"
            echo "      -h          Show help."
            echo "      -t          Location where the package to install"
            exit 0
        ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
        ;;
    esac
done
shift $((OPTIND -1))  # remove options

subcommand=$1; shift  # Remove 'pip' from the argument list

echo "## $@"
echo "## $subcommand"

case "$subcommand" in
# Parse options to the install sub command
    "install")
        package=$1; shift  # Remove 'install' from the argument list

    echo "## $package"
    echo "## $@"
        # Process package options
        while getopts ":t:" opt; do
            case ${opt} in
                "t" )
                    target=$OPTARG
                    echo "install $package at $target"
                ;;
                \? )
                    echo "Invalid Option: -$OPTARG" 1>&2
                    exit 1
                ;;
                : )
                    echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                    exit 1
                ;;
            esac
        done
        shift $((OPTIND -1))
    ;;
esac
