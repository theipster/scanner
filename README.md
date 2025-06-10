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

  2. _(Host)_ Identify your USB scanner:

     ```powershell
     PS > usbipd list
     Connected:
     BUSID  VID:PID    DEVICE                                                        STATE
     ...
     7-1    043d:007d  X1200 Series                                                  Not shared
     ...
     ```

  3. _(Host, admin privileges)_ Register it with `usbipd`:

     ```powershell
     PS > usbipd bind --hardware-id 043d:007d
     usbipd: info: Device with hardware-id '043d:007d' found at busid '7-1'.

     PS > usbipd list
     Connected:
     BUSID  VID:PID    DEVICE                                                        STATE
     ...
     7-1    043d:007d  X1200 Series                                                  Shared
     ...
     ```

  4. _(Host)_ Expose it to WSL:

     ```powershell
     PS > usbipd attach --wsl --hardware-id 043d:007d
     usbipd: info: Device with hardware-id '043d:007d' found at busid '7-1'.
     usbipd: info: Using WSL distribution 'Ubuntu' to attach; the device will be available in all WSL 2 distributions.
     usbipd: info: Loading vhci_hcd module.
     usbipd: info: Detected networking mode 'nat'.
     usbipd: info: Using IP address 192.168.112.1 to reach the host.

     PS > usbipd list
     Connected:
     BUSID  VID:PID    DEVICE                                                        STATE
     ...
     7-1    043d:007d  X1200 Series                                                  Attached
     ...
     ```

  3. _(WSL)_ Verify the USB device is available:

     ```sh
     $ lsusb -d 043d:007d
     Bus 001 Device 002: ID 043d:007d Lexmark International, Inc. Photo 3150
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
