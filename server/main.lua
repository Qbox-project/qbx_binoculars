lib.versionCheck('Qbox-project/qbx_binoculars')

exports.qbx_core:CreateUseableItem('binoculars', function(source)
    lib.callback('qbx_binoculars:client:toggle', source)
end)
