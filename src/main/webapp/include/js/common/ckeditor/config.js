/**
 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function(config)  {
	config.language  = 'ko';
	
	config.toolbar_Basic = [
	      ['Font', 'FontSize', 'lineheight'],
	      ['BGColor', 'TextColor'],
	      ['Bold', 'Italic', 'Strike', 'Superscript', 'Subscript', 'Underline', 'RemoveFormat'],   
	      ['BidiLtr', 'BidiRtl'],
	      '/',
	      ['Image', 'SpecialChar', 'Smiley'],
	      ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'],
	      ['Blockquote', 'NumberedList', 'BulletedList'],
	      ['Link', 'Unlink'],
	      ['Source'],
	      ['Undo', 'Redo']
	 ];	
};
