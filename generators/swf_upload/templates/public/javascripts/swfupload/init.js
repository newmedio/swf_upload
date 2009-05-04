swfu = null;
SWFUpload.init = function(settingsObjectLiteral) {
    var handlerSettings = {
      file_queued_handler          : fileQueued,
      file_queue_error_handler     : fileQueueError,
      file_dialog_complete_handler : fileDialogComplete,
      upload_start_handler         : uploadStart,
      upload_progress_handler      : uploadProgress,
      upload_complete_handler      : uploadComplete,
      upload_success_handler       : uploadSuccess
    }
  swfu = new SWFUpload(Object.extend(handlerSettings,eval(settingsObjectLiteral)))
}
