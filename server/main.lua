lib.versionCheck('Qbox-project/qbx_binoculars')

exports.qbx_core:CreateUseableItem('binoculars', function(source)
    TriggerClientEvent('qbx_binoculars:client:toggle', source)
end)
