# scanner

Linux-based container image for operating scanner hardware.

Effectively allows using Linux drivers on a Windows host, which is convenient for older hardware that no longer has Windows drivers available.

## Pre-requisites

Ensure your scanner device is turned on (obviously), and made available to the container.

<details>
  <summary>Example: expose a Lexmark 1270 scanner to WSL2</summary>

  1. _(Host)_ Install the [`usbipd` service](https://github.com/dorssel/usbipd-win):

     ```powershell
     PS > winget install usbipd
     ```

  2. _(Host)_ Identify your USB scanner, and then expose it:

     ```powershell
     PS > usbipd attach --wsl --hardware-id 043d:007d    # Lexmark 1270's hardware ID is 043d:007d
     ```

  3. _(WSL)_ Verify the USB device is available:

     ```sh
     $ lsusb -d 043d:007d
     ```
</details>

## Usage

Run `docker run --device=/dev/bus/usb/<bus-id>/<device-id> --rm theipster/scanner > my-doc.pdf` to produce a scanned document named `my-doc.pdf`.

### Advanced (multiple page documents)

When the above command is run with `--interactive` (`-i`), there will be an extra option to execute additional scans and append those pages to the same document:

```sh
$ docker run --interactive [...] theipster/scanner > my-doc.pdf
> Scanning infinity pages, incrementing by 1, numbering from 1
> Place document no. 1 on the scanner.
> Press <RETURN> to continue.
> Press Ctrl + D to terminate.
>
> Scanning page 1
> Scanned page 1. (scanner status = 5)
> Place document no. 2 on the scanner.
> Press <RETURN> to continue.
> Press Ctrl + D to terminate.
>
> Scanning page 2
> Scanned page 2. (scanner status = 5)
> Place document no. 3 on the scanner.
> Press <RETURN> to continue.
> Press Ctrl + D to terminate.
> Batch terminated, 2 pages scanned
> Finalising document... done.
```

### Configuration options

This uses [`scanimage`](http://sane-project.org/man/scanimage.1.html) (from `sane-utils` lib) for interacting with the hardware. To configure args, pass the `SCANIMAGE_OPTS` environment variable.

This also uses [`convert`](https://imagemagick.org/script/convert.php) (from `imagemagick` lib) for post-processing the image. To configure args, pass the `CONVERT_OPTS` environment variable.
