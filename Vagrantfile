require 'yaml'

Vagrant.require_version ">= 1.5"
settings = YAML.load_file('vagrant.yml')

def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable? exe
        }
    end
    return nil
end

Vagrant.configure("2") do |config|

    config.vm.provider :virtualbox do |v|
        v.name = settings['vm']['name']
        v.customize [
            "modifyvm", :id,
            "--name", settings['vm']['name'],
            "--memory", settings['vm']['memory'],
            "--natdnshostresolver1", "on",
            "--cpus", settings['vm']['cpus'],
        ]
    end

    config.vm.box = "ubuntu/trusty64"
    
    config.vm.box_url = "https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box"
    
    config.vm.network :private_network, ip: settings['vm']['ip_address']
    config.ssh.forward_agent = true
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # If ansible is in your path it will provision from your HOST machine
    # If ansible is not found in the path it will be instaled in the VM and provisioned from there
    if which('ansible-playbook')
        config.vm.provision "ansible" do |ansible|
            ansible.playbook = "ansible/playbook.yml"
            ansible.inventory_path = "ansible/inventories/dev"
            ansible.limit = 'all'
            ansible.extra_vars = {
                hostname: settings['vm']['name']
            }
        end
    else
        config.vm.provision :shell, path: "ansible/windows.sh", args: [settings['vm']['name']]
    end

    is_windows = Vagrant::Util::Platform.windows?

    if is_windows
        config.vm.synced_folder "./", "/vagrant", type: "smb"
        config.vm.synced_folder "~/web", "/home/vagrant/web", type: "smb"
    else
        config.vm.synced_folder "./", "/vagrant", type: "nfs", mount_options: ['rw', 'vers=3', 'tcp', 'fsc' ,'actimeo=2']
        config.vm.synced_folder "~/web", "/home/vagrant/web", type: "nfs", mount_options: ['rw', 'vers=3', 'tcp', 'fsc' ,'actimeo=2']
        config.nfs.map_uid = Process.uid
        config.nfs.map_gid = Process.gid
    end
end
