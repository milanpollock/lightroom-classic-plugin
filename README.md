# lightroom-classic-plugin

## Dark Rush Photography's Adobe Lightroom Classic Plugin

In order to simplify the process of publishing images, we've written this Adobe Lightroom Classic Plugin that uploads images directly to an Azure Durable Function.  Our plugin is a simplified version of the Flickr example part of the Lightroom SDK from [Lightroom Classic Downloads](https://console.adobe.io/servicesandapis).

### Publisher Manager Settings

We've found the following settings to work best in the Publisher Manager

| Property          | Value       |
| ----------------- | ----------- |
| JPEG Quality      | 100%        |
| ...               | ...         |

The following values are used as metadata values for images

| Property          | Value       |
| ----------------- | ----------- |
| JPEG Quality      | 100%        |
| ...               | ...         |

We also process all of our images using [JPEG SomeName]()

----

## References

- [Lightroom Classic Plugin SDK](https://www.adobe.io/apis/creativecloud/lightroomclassic.html)
- [Tips for Lightroom Classic to run faster](https://digital-photography-school.com/10-tips-to-make-lightroom-classic-cc-run-faster/)
