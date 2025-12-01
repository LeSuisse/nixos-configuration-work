{ ... }:
{
  services.usbguard = {
    enable = true;
    rules = ''
      allow hash "6N1TzJjHwwpfxs1tKPqEW87V2i+tHyyRUvFlgF5cGtw=" parent-hash "SnsOOjjMpOpERReA2LN1+REpSYWXke1WQeUhO0X7e8g=" # xHCI Host Controller
      allow hash "hUMPrpUUWjXN6LOshdE/S/HI1Kx/9TvIRabxmN272oA=" parent-hash "SnsOOjjMpOpERReA2LN1+REpSYWXke1WQeUhO0X7e8g=" # xHCI Host Controller
      allow hash "SQO9g2Bt21p8dKkNmw9lqWKzphaGisG3dmz0QWJVjzc=" parent-hash "T5AHPbumyvtJmkwKMGdQ5v4Lin/ywbMb8JI3Pchy/l8=" # xHCI Host Controller
      allow hash "vtM3uheObXFIOQNcFII3a6Jan4oRRxULqAzx+5d2q/E=" parent-hash "T5AHPbumyvtJmkwKMGdQ5v4Lin/ywbMb8JI3Pchy/l8=" # xHCI Host Controller
      allow hash "vL+E5pTms/14TMT1FF36bNufC5tB/6+/dKHVKIZVAMI=" parent-hash "QDGVdqsxHzKBI0zVf2cM2Rq1MjgB2hI/5Dc3W25GkUw=" # xHCI Host Controller
      allow hash "FSUlLgr+5NdCCGPoOf/fKZ11rPFjo/VhPyeE6gFk/70=" parent-hash "QDGVdqsxHzKBI0zVf2cM2Rq1MjgB2hI/5Dc3W25GkUw=" # xHCI Host Controller
      allow hash "4a4NgfdUaJO43rkCzmWRSeHHR/uUh5+SNsXnhosm9qs=" parent-hash "nXC6r8lLj6337Yty38A8t0DEql7ahMYVca2u7U4LH2g=" # xHCI Host Controller
      allow hash "d+DNGWARDtv9nEK2ZvnNOCtFernuMu5/e/oZ7kCppqQ=" parent-hash "nXC6r8lLj6337Yty38A8t0DEql7ahMYVca2u7U4LH2g=" # xHCI Host Controller
      allow hash "icotY3rI59mWiKsGxc59BGZZeBjfbuH0b4NUByj3cbQ=" parent-hash "QdrZZ7PQrVglLbKdtMKPSKnlSJXRlVARBWvCFw0L8K0=" # xHCI Host Controller
      allow hash "UbEoCZW8HT2ldc3qDeiK+IiQlGeaBC7F63681OwmKhI=" parent-hash "QdrZZ7PQrVglLbKdtMKPSKnlSJXRlVARBWvCFw0L8K0=" # xHCI Host Controller
      allow hash "p0xurg8ayXbgrHAmFBL5BElzY8M/rvDA/w3li6d/wtw=" # Hub
      allow hash "5zeNOFQHsaZg43M4KgvCUwvU8C+GNCY8Rgdlwxc+Vpk=" # USB Receiver
      allow hash "6EDtllo4GWG8DhK8mWWDJp82Lf0U0qrlfpXwOZ6CRoc=" parent-hash "vL+E5pTms/14TMT1FF36bNufC5tB/6+/dKHVKIZVAMI=" # Internal webcam
      allow hash "mTdOffb7mmvXIBSsKY1Hwrfi8DYYO/Xgrk08IXikyTs=" # Hub
      allow hash "bCcnMVE8/SnBApnpwjQ5W3SYyVBU7sqDfFcM5UFLNz0=" # Hub
      allow hash "8b8zBAJ2E2H+F5kJY3VOV+MHz3/54QQUnxBnArGBgVc=" # Hub
      allow hash "ZnUNQGWjMSYwpU/qOKA6r6genSs+Eu8v/9b6sBhs9y8=" # Dock
      allow hash "5WDr9ntSnFdccsOWiXKgSqrJmp3MdOdyu2N5DoXt+xk=" # LAN Dock
      allow hash "WNJV1t5LPJQonobotnmsPGxF9G+BkFyagO5uEuQ6f+8=" # Hub
      allow hash "r255KJIIpV4M314Eo0HqqSx6OHdDVEMSJvCOby3oSK8=" # Hub
      allow hash "ILNcnIRUGuv0jCrjR5DM6GJGsCkV9tWx/flaidHN2rI=" # Hub
      allow hash "LBV1U4rNBXyWhdQ6zsac2Qo472jWNTBqOeaJP9rUnuE=" # Hub
      allow hash "WdV4xLeUaKdU0cUxojDR6LqDwdW0BB6wsExS5wvB7mo=" # Hub
      allow hash "kXJQxbZwmkrG6r5PXEOto4JrR7nKCNbG8CIcm8WJe80=" # External mic
      allow hash "+r3EEFJKf9hVZ/KywO/KODwyNkTXiyI5mzgtLgN9r7Q=" # External webcam
      allow hash "QAUP826MbSSvZRtz0pO3TQeA8cDKNYeMrwu8ll0cH/0=" # Headset
      allow hash "C/pSWjFfc02DHVYCSvx2xS+YviL/at1LOSyP+5jVoYU=" # USB Receiver
      allow hash "ImMr8fP9hBpHpQv9YtYOS+vCU//DPQFH+K/E6Dah4tg=" # YK
      allow hash "uyFKChH/eGqYUGi2d8Pg/zD+NrfUp1BEBp5QoNaUSi8=" # YK
    '';
  };
}
