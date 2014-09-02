(function($targetObject) {
	
	var namespace = "com.latcha.tesseract.uploadpage";
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);
	
	ns.Main = function(onSubmitResult) {
		
		// --------------------------------------------------------------------------
		//
		// Private properties
		//
		// --------------------------------------------------------------------------
		
		var checkAutoSubmit = $("#check_autoSubmit");
		var divImageSubmitFormContainer = $("#div_imageSubmitFormContainer");
		var inputImageFileBrowse = divImageSubmitFormContainer.find("form input:file");
		var buttonOriginalImgSubmit = divImageSubmitFormContainer.find("form input:submit");
		var img = $("#img_display");
		var scaledImageContainer = $(".scaledImageContainer");
		var buttonScaledImageSubmit = scaledImageContainer.find("form input[type='submit']");
		
		// --------------------------------------------------------------------------
		//
		// Private methods
		//
		// --------------------------------------------------------------------------
		
		var dataURItoBlob = $targetObject.com.altoinu.javascript.utils.NetUtils.dataURItoBlob;
		
		var scaleAndCopytoCanvas = function(imageFile, canvas, width, height, onComplete) {
			
			// set canvas to specified size
			$(canvas).attr({
				width: width,
				height: height
			});
			
			// copy image to canvas, scaled to that size
			var context = canvas.getContext("2d");
			
			canvasResize(imageFile, {
				width: width,
				height: 0,
				crop: false,
				quality: 80,
				callback: function(data, width, height) {
					
					var tempImg = new Image();
					tempImg.onload = function() {
						context.drawImage(tempImg, 0, 0, width, height);
					};
					tempImg.src = data;
					
					if (onComplete != null)
						onComplete(data, width, height);
					
				}
			});
			
		};
		
		var submitImage = function(form, canvasOrBase64Image) {
			
			var formData = new FormData(form);
			
			if (canvasOrBase64Image != null) {
				
				// If canvas or base64 image specified, submit this image instead
				if (canvasOrBase64Image instanceof HTMLCanvasElement)
					console.log("Using canvas image");
				else
					console.log("Using base64 image data");
				
				console.log(canvasOrBase64Image);
				
				// base64
				var dataURL = (canvasOrBase64Image instanceof HTMLCanvasElement) ? canvasOrBase64Image.toDataURL("image/jpeg") : canvasOrBase64Image;
				// var dataURL = canvasOrBase64Image.toDataURL("image/png");
				
				// convert to blob and append to FormData
				var blob = dataURItoBlob(dataURL); // image blob
				// for FormData
				formData.append("photo", blob, "image.jpg");
				// formData.append("photo", blob, "image.png");
				
			}
			
			$.ajax({
				url: form.action,
				type: form.method,
				processData: false,
				contentType: false,
				data: formData,
				
				beforeSend: function(jqXHR, settings) {
					
					$(".loadingIndicator").css("display", "inline");
					
				},
				
				complete: function(data, textStatus, jqXHR) {
					
					console.log("submit complete");
					console.log(data);
					console.log(textStatus);
					console.log(jqXHR);
					//alert("Submit complete: " + data.responseText);
					
					$(".loadingIndicator").css("display", "none");
					
					if (onSubmitResult != null)
						onSubmitResult(data.responseText);
					
				},
				
				error: function(jqXHR, textStatus, errorThrown) {
					
					console.log("submit fail");
					console.log(jqXHR);
					console.log(textStatus);
					console.log(errorThrown);
					alert("Submit failed: " + textStatus);
					
				}
				
			});
			
		};
		
		// --------------------------------------------------------------------------
		//
		// Event handlers
		//
		// --------------------------------------------------------------------------
		
		checkAutoSubmit.on("change", function(event) {
			
			//var displayStyle = checkAutoSubmit.is(":checked") ? "hidden" : "visible";
			//buttonOriginalImgSubmit.css("visibility", displayStyle);
			//scaledImageContainer.css("visibility", displayStyle);
			
			var displayStyle = checkAutoSubmit.is(":checked") ? "none" : "inline";
			buttonOriginalImgSubmit.css("display", displayStyle);
			scaledImageContainer.css("display", displayStyle);
			
		});
		
		inputImageFileBrowse.on("change", function(event) {
			
			// read image file and display it in <img>
			var inputFile = this;
			var fileReader = new FileReader();
			fileReader.onload = function() {
				
				// display image in <img>
				img.attr("src", fileReader.result);
				
				// enable submit button
				buttonOriginalImgSubmit.prop("disabled", false);
				
				// auto submit
				// if (checkAutoSubmit.is(":checked"))
				// inputFile.form.submit();
				
			};
			fileReader.readAsDataURL(inputFile.files[0]);
			
		});
		
		// display image file in canvas
		img.on("load", function() {
			
			var onCopyComplete = function(data) {
				
				// enable submit button
				buttonScaledImageSubmit.prop("disabled", false);
				
				// auto submit?
				if (checkAutoSubmit.is(":checked")) {
					
					console.log("Auto submit GO!");
					
					// original image submit
					//divImageSubmitFormContainer.find("form")[0].submit();
					submitImage(divImageSubmitFormContainer.find("form")[0]);
					
					// canvas image submit
					/*
					var scaledImageForm = scaledImageContainer.find("form:has(canvas.scale640x480)")[0];
					console.log(scaledImageForm);
					console.log(data);
					submitImage(scaledImageForm, data);
					 */
					
				}
				
			};
			
			// 1/2 scale
			console.log(scaledImageContainer.find("canvas.scaleHalf"));
			if (scaledImageContainer.find("canvas.scaleHalf").length > 0)
				scaleAndCopytoCanvas(inputImageFileBrowse[0].files[0], scaledImageContainer.find("canvas.scaleHalf")[0], this.width / 2, this.height / 2);
			
			// scale to fit in 640x480
			if (scaledImageContainer.find("canvas.scale640x480").length > 0) {
				
				var scaleX = 640 / this.width;
				var scaleY = 480 / this.height;
				var fitScale = Math.min(scaleX, scaleY);
				scaleAndCopytoCanvas(inputImageFileBrowse[0].files[0], scaledImageContainer.find("canvas.scale640x480")[0], (this.width * fitScale), (this.height * fitScale), onCopyComplete);
				
			}
			
		});
		
		divImageSubmitFormContainer.find("form:has(input[type='file'])").on("submit", function(event) {
			
			// not doing normal submit, instead ajax
			submitImage(this);
			return false;
			
		});
		
		scaledImageContainer.find("form").on("submit", function(event) {
			
			// not doing normal submit, instead ajax
			console.log(this);
			submitImage(this, $(this).find("canvas")[0]); // submit canvas image
			return false;
			
		});
		
		// --------------------------------------------------------------------------
		//
		// Initializations
		//
		// --------------------------------------------------------------------------
		
		$("#check_autoSubmit").prop("checked", false);
		buttonOriginalImgSubmit.prop("disabled", true);
		buttonScaledImageSubmit.prop("disabled", true);
		
	};
	
	return ns;
	
})(window);