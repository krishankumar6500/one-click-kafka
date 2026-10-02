def call(Map config = [:]) {

    def ansibleDir = config.get('ansibleDir', 'ansible')
    def inventory  = config.get('inventory', 'inventory.ini')
    def playbook   = config.get('playbook', 'site.yml')

    echo "======================================"
    echo "   SHARED LIBRARY: KAFKA DEPLOYMENT"
    echo "======================================"
    echo "Ansible Directory : ${ansibleDir}"
    echo "Inventory         : ${inventory}"
    echo "Playbook          : ${playbook}"
    echo "======================================"

    dir(ansibleDir) {

        sh """
            set -e

            echo "===== ANSIBLE SYNTAX CHECK ====="

            ansible-playbook \
              -i ${inventory} \
              ${playbook} \
              --syntax-check

            echo
            echo "===== KAFKA DEPLOYMENT ====="

            ansible-playbook \
              -i ${inventory} \
              ${playbook}

            echo
            echo "===== SHARED LIBRARY DEPLOYMENT COMPLETE ====="
        """
    }
}
