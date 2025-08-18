NIX_CONFIG="/etc/nixos"
REPOSITORY_LOCATION=$(pwd)
COMMIT_MESSAGE="Automated Update"

echo "=== COPYING $NIX_CONFIG to $REPOSITORY_LOCATION ==="
cp -r $NIX_CONFIG . || { echo "FAILURE TO COPY CONFIGURATION FILES."; exit 1; }
echo "=== COPIED $NIX_CONFIG to $REPOSITORY_LOCATION ==="
echo "=== PUSHING NEW NIX CONFIGURATION === "
git add ./nixos && git commit -m "$COMMIT_MESSAGE" && git push || { echo "FAILURE TO PUSH TO REPOSITORY."; exit 1 }
echo "=== SUCCESSFULLY PUSHED NEW NIX CONFIGURATION === "

