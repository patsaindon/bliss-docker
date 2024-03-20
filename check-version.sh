cat bliss-version
VER="$(curl -Ls http://www.blisshq.com/app/latest-linux-version | awk -F'[-.]' '{print $5}')"
echo "${{ VER }}"
if [ "$(cat bliss-version)" != "$VER" ] ; then
    echo "$VER" > bliss-version
    git config --global init.defaultBranch main
    git config --global user.name "${{ USER_NAME }}"
    git config --global user.email "${{ USER_EMAIL }}"
    git add bliss-version
    git commit -m "Bump bliss version to $VER"
    git push
else
    echo "Version is unchanged ("$VER")"
fi