#
#  2023/01/12 - cp - This one applies to both AIX and VIOS in our environment,
#		so it's a little more complicated that the first one.
#
#		cp - Fixed some non-variable things from the first class where
#		not everything was based on the $ifixName variable.
#
#  2023/02/17 - cp - Fixed an issue with the hash check of ifixes.
#
#  2023/02/24 - cp - New "b" spin of this patch
#
#-------------------------------------------------------------------------------
#
#  From Advisory.asc:
#
#    Fileset                 Lower Level  Upper Level  KEY
#    ----------------------------------------------------------
#    bos.net.tcp.server      7.1.5.0      7.1.5.35     key_w_fs
#    bos.net.tcp.client      7.1.5.0      7.1.5.40     key_w_fs
#    bos.net.tcp.bind        7.2.5.0      7.2.5.1      key_w_fs
#    bos.net.tcp.bind_utils  7.2.5.0      7.2.5.2      key_w_fs
#    bos.net.tcp.bind        7.2.5.100    7.2.5.101    key_w_fs
#    bos.net.tcp.bind_utils  7.2.5.100    7.2.5.101    key_w_fs
#|   bos.net.tcp.bind        7.2.5.200    7.2.5.200    key_w_fs
#|   bos.net.tcp.bind_utils  7.2.5.200    7.2.5.200    key_w_fs
#    bos.net.tcp.bind        7.3.0.0      7.3.0.1      key_w_fs
#    bos.net.tcp.bind_utils  7.3.0.0      7.3.0.1      key_w_fs
#    bind.rte                7.1.916.0    7.1.916.2600 key_w_fs
#
#    AIX Level APAR     Availability  SP        KEY
#    -----------------------------------------------------
#    7.1.5     IJ44422  **            SP11      key_w_apar
#    7.2.5     IJ44425  **            SP06      key_w_apar
#    7.3.0     IJ44427  **            SP03      key_w_apar
#    7.3.1     IJ44426  **            SP02      key_w_apar
#
#    VIOS Level APAR    Availability  SP        KEY
#    -----------------------------------------------------
#    3.1.2      IJ44423 **            3.1.2.50  key_w_apar
#    3.1.3      IJ44425 **            3.1.3.30  key_w_apar
#    3.1.4      IJ44425 **            3.1.4.20  key_w_apar
#
#    AIX Level  Interim Fix (*.Z)         KEY
#    ----------------------------------------------
#    7.1.5.8    IJ44422mAa.221220.epkg.Z  key_w_fix
#    7.1.5.9    IJ44422mAa.221220.epkg.Z  key_w_fix
#    7.1.5.10   IJ44422mAa.221220.epkg.Z  key_w_fix
#|   7.2.5.3    IJ44425m4b.230217.epkg.Z  key_w_fix
#|   7.2.5.4    IJ44425m4b.230217.epkg.Z  key_w_fix
#|   7.2.5.5    IJ44425s5b.230214.epkg.Z  key_w_fix
#    7.3.0.1    IJ44427m2a.221220.epkg.Z  key_w_fix
#    7.3.0.2    IJ44427m2a.221220.epkg.Z  key_w_fix
#
#    Please note that the above table refers to AIX TL/SP level as
#    opposed to fileset level, i.e., 7.2.5.4 is AIX 7200-05-04.
#
#    Please reference the Affected Products and Version section above
#    for help with checking installed fileset levels.
#
#    VIOS Level  Interim Fix (*.Z)         KEY
#    -----------------------------------------------
#|   3.1.2.21    IJ44423m2b.230217.epkg.Z  key_w_fix
#|   3.1.2.30    IJ44423m2b.230217.epkg.Z  key_w_fix
#|   3.1.2.40    IJ44423m2b.230217.epkg.Z  key_w_fix
#|   3.1.3.10    IJ44425m4b.230217.epkg.Z  key_w_fix
#|   3.1.3.14    IJ44425m4b.230217.epkg.Z  key_w_fix
#|   3.1.3.21    IJ44425m4b.230217.epkg.Z  key_w_fix
#|   3.1.4.10    IJ44425s5b.230214.epkg.Z  key_w_fix
#
#    For bind.rte on 7.3 TL1 and if installed on 7.2 TL5:
#
#    AIX Level  Interim Fix (*.Z)         KEY
#    ----------------------------------------------
#    7.2.5      IJ44426s2.221130.epkg.Z   key_w_fix
#    7.3.1      IJ44426s2.221130.epkg.Z   key_w_fix
#
#-------------------------------------------------------------------------------
#
class aix_ifix_ij44425_b {

    #  Make sure we can get to the ::staging module (deprecated ?)
    include ::staging

    #  This only applies to AIX and VIOS 
    if ($::facts['osfamily'] == 'AIX') {

        #  Set the ifix ID up here to be used later in various names
        $ifixName = 'IJ44425'

        #  Make sure we create/manage the ifix staging directory
        require aix_file_opt_ifixes

        #
        #  For now, we're skipping anything that reads as a VIO server.
        #  We have no matching versions of this ifix / VIOS level installed.
        #
        unless ($::facts['aix_vios']['is_vios']) {

            #
            #  Friggin' IBM...  The ifix ID that we find and capture in the fact has the
            #  suffix allready applied.
            #
            if ($::facts['kernelrelease'] in ['7200-05-03-2148', '7200-05-04-2220']) {
                $ifixSuffix = 'm4b'
                $ifixBuildDate = '230217'
            }
            else {
                if ($::facts['kernelrelease'] == '7200-05-05-2246') {
                    $ifixSuffix = 's5b'
                    $ifixBuildDate = '230214'
                }
                else {
                    $ifixSuffix = 'unknown'
                    $ifixBuildDate = 'unknown'
                }
            }

        }

        #
        #  This one applies equally to AIX and VIOS in our environment, so deal with VIOS as well.
        #
        else {
            if ($::facts['aix_vios']['version'] in ['3.1.3.14', '3.1.3.21']) {
                $ifixSuffix = 'm4b'
                $ifixBuildDate = '230217'
            }
            else {
                if ($::facts['aix_vios']['version'] == '3.1.4.10') {
                    $ifixSuffix = 's5b'
                    $ifixBuildDate = '230214'
                }
                else {
                    $ifixSuffix = 'unknown'
                    $ifixBuildDate = 'unknown'
                }
            }
        }

        #================================================================================
        #  Re-factor this code out of the AIX-only branch, since it applies to both.
        #================================================================================

        #  If we set our $ifixSuffix and $ifixBuildDate, we'll continue
        if (($ifixSuffix != 'unknown') and ($ifixBuildDate != 'unknown')) {

            #  Add the name and suffix to make something we can find in the fact
            $ifixFullName = "${ifixName}${ifixSuffix}"

            #  Don't bother with this if it's already showing up installed
            unless ($ifixFullName in $::facts['aix_ifix']['hash'].keys) {
 
                #  Build up the complete name of the ifix staging source and target
                $ifixStagingSource = "puppet:///modules/aix_ifix_ij44425_b/${ifixName}${ifixSuffix}.${ifixBuildDate}.epkg.Z"
                $ifixStagingTarget = "/opt/ifixes/${ifixName}${ifixSuffix}.${ifixBuildDate}.epkg.Z"

                #  Stage it
                staging::file { "$ifixStagingSource" :
                    source  => "$ifixStagingSource",
                    target  => "$ifixStagingTarget",
                    before  => Exec["emgr-install-${ifixName}"],
                }

                #  GAG!  Use an exec resource to install it, since we have no other option yet
                exec { "emgr-install-${ifixName}":
                    path     => '/bin:/sbin:/usr/bin:/usr/sbin:/etc',
                    command  => "/usr/sbin/emgr -e $ifixStagingTarget",
                    unless   => "/usr/sbin/emgr -l -L $ifixFullName",
                }

                #  Explicitly define the dependency relationships between our resources
                File['/opt/ifixes']->Staging::File["$ifixStagingSource"]->Exec["emgr-install-${ifixName}"]

                #  Make sure the old spin is gone first (whether it was there or not)
                Class['aix_ifix_ij44425_a_remover']->Class['aix_ifix_ij44425_b']

            }

        }

    }

}
