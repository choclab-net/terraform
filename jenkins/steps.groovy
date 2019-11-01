
def structure() {
    sh """
    |if [ -d code ] ; then
    |    find . -maxdepth 1 -type f -exec rm {} \\;
    |    mv code/* .
    |    rm -rf code
    |    echo "==================================================="
    |    ls
    |    echo "==================================================="
    |fi
    |""".stripMargin()
}

return this;
