# lightroom-classic-plugin

## Dark Rush Photography's Adobe Lightroom Classic Plugin

In order to simplify the process of publishing images, we've written this Adobe Lightroom Classic Plugin that uploads images directly to an Azure Durable Function.  Our plugin is a simplified version of the Flickr example part of the Lightroom SDK from [Lightroom Classic Downloads](https://console.adobe.io/servicesandapis).

### Publisher Manager Settings

We've found the following settings to work best in the Publisher Manager

| Property          | Value                           |
| ----------------- | ------------------------------- |
| Image Format      | JPEG                            |
| Color Space       | sRGB                            |
| Quality           | 100%                            |
| ResizeToFit       | LongEdge 2048 pixels            |
| Resolution        | 300 pixels per inch             |  
| No Sharpening     |                                 |
| All Metadata      | remove person and location info |
The following values are used as metadata values for images

| Property          | Value       |
| ----------------- | ----------- |
| JPEG Quality      | 100%        |
| ...               | ...         |

We also process all of our images using [JPEG mini](https://www.jpegmini.com/)

----

## References

- [Lightroom Classic Plugin SDK](https://www.adobe.io/apis/creativecloud/lightroomclassic.html)
- [Tips for Lightroom Classic to run faster](https://digital-photography-school.com/10-tips-to-make-lightroom-classic-cc-run-faster/)
