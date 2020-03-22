@AbapCatalog.sqlViewName: 'ZCAL_I_HOLID_ZNK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Public Holidays'
define root view ZCAL_I_HOLIDAY_ZNK
  as select from zcal_holiday_znk
{
      //zcal_holiday_znk
      @Semantics.user.createdBy: true
  key holiday_id,
      @Semantics.user.lastChangedBy: true
      month_of_holiday,
      @Semantics.systemDateTime.lastChangedAt: true
      day_of_holiday,
      @Semantics.systemDateTime.lastChangedAt: true
      changedat
}
