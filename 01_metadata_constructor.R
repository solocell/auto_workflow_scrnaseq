

metadata.constructor <- function(raw.data,metadata) {

	if (is.null(dim.raw.dat)) {

		data.to.parse <- raw.data[[1]]

	} else {

		data.to.parse <- raw.data

	}

	#organize metadata path to match order samples were read

	sample.order <- match(files.to.read,metadata$sample)
	parsed.metadata <- data.frame(metadata[sample.order,])
	colnames(parsed.metadata) <- colnames(metadata)
	metadata <- parsed.metadata

	#start workflow for creating metadata

	num.cells.sample <- vector("logical",length=num.samples)

	for (i in 1:num.samples) {

	if (i==1) {
		length1 <- length(grep("^[A-z]",colnames(data.to.parse)))
		num.cells.sample[i] <- length1
	} else {
		length1 <- length(grep(paste("^",i,sep=""),colnames(data.to.parse)))
		num.cells.sample[i] <- length1
	}

	}

	meta.frame <- data.frame(matrix(data=NA,nrow=sum(num.cells.sample),ncol=ncol(metadata)))
	colnames(meta.frame) <- colnames(metadata)
	rownames(meta.frame) <- colnames(data.to.parse)

	for (i in 1:ncol(meta.frame)) {
		for (z in 1:length(num.cells.sample)) {

			if (z==1) {

				data.to.add <- as.character(metadata[z,i])
				meta.frame[1:num.cells.sample[z],i] <- data.to.add
				end.count <- num.cells.sample[z]

			} else {

				start.count <- end.count+1
				end.count <- sum(end.count,num.cells.sample[z])

				data.to.add <- as.character(metadata[z,i])

				meta.frame[start.count:end.count,i] <- data.to.add

			}


		}

	}

	meta.frame <- data.frame(lapply(meta.frame,as.factor))
	rownames(meta.frame) <- colnames(data.to.parse)
	return(meta.frame)

}
