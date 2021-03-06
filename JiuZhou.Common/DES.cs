using System;
using System.IO;
using System.Text;
using System.Security.Cryptography;
/// <summary>
/// Version: 1.0
/// Author: Atai Lu
/// </summary>

namespace JiuZhou.Common
{ 
	/// <summary> 
	/// ����
	/// </summary> 
	public class AES
    {

        #region EncryptKey
        public static string EncryptKey
        {
            get { return "hiatai.com"; }
        }
        #endregion
		//Ĭ����Կ����
		//private static byte[] Keys = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };
		private static byte[] Keys = { 0x41, 0x72, 0x65, 0x79, 0x6F, 0x75, 0x6D, 0x79, 0x53, 0x6E, 0x6F, 0x77, 0x6D, 0x61, 0x6E, 0x3F };
		/// <summary>
		/// DES�����ַ���
		/// </summary>
		/// <param name="encryptString">�����ܵ��ַ���</param>
		/// <param name="encryptKey">������Կ,Ҫ��Ϊ8λ</param>
		/// <returns>���ܳɹ����ؼ��ܺ���ַ���,ʧ�ܷ���Դ��</returns>


		public static string Encode(string encryptString, string encryptKey)
		{
			encryptKey = Utils.CutString(encryptKey, 0, 32);
			encryptKey = encryptKey.PadRight(32, ' ');

			RijndaelManaged rijndaelProvider = new RijndaelManaged();
			rijndaelProvider.Key = Encoding.UTF8.GetBytes(encryptKey.Substring(0, 32));
			rijndaelProvider.IV = Keys;
			ICryptoTransform rijndaelEncrypt = rijndaelProvider.CreateEncryptor();
 
			byte[] inputData = Encoding.UTF8.GetBytes(encryptString);
			byte[] encryptedData = rijndaelEncrypt.TransformFinalBlock(inputData,0,inputData.Length);

			return Convert.ToBase64String(encryptedData);
		}
        public static string Encode(string encryptString)
        {
            return Encode(encryptString, AES.EncryptKey);
        }


		public static string Decode(string decryptString, string decryptKey)
		{
			try
			{
                decryptKey = Utils.CutString(decryptKey, 0, 32);
				decryptKey = decryptKey.PadRight(32, ' ');

				RijndaelManaged rijndaelProvider = new RijndaelManaged();
				rijndaelProvider.Key = Encoding.UTF8.GetBytes(decryptKey);
				rijndaelProvider.IV = Keys;
				ICryptoTransform rijndaelDecrypt = rijndaelProvider.CreateDecryptor();
 
				byte[] inputData = Convert.FromBase64String(decryptString);
				byte[] decryptedData = rijndaelDecrypt.TransformFinalBlock(inputData,0,inputData.Length);

				return Encoding.UTF8.GetString(decryptedData);
			}
			catch
			{
				return "";
			}

		}
        public static string Decode(string decryptString)
        {
            return Decode(decryptString, AES.EncryptKey);
        }

        public static string Encode2(string encryptString, string encryptKey)
        {
            encryptKey = Utils.CutString(encryptKey, 0, 32);
            encryptKey = encryptKey.PadRight(32, ' ');

            RijndaelManaged rijndaelProvider = new RijndaelManaged();
            rijndaelProvider.Key = Encoding.UTF8.GetBytes(encryptKey);
            rijndaelProvider.IV = Keys;
            rijndaelProvider.Mode = CipherMode.ECB;
            rijndaelProvider.Padding = PaddingMode.PKCS7;
            ICryptoTransform rijndaelEncrypt = rijndaelProvider.CreateEncryptor();

            byte[] inputData = Encoding.UTF8.GetBytes(encryptString);
            byte[] encryptedData = rijndaelEncrypt.TransformFinalBlock(inputData, 0, inputData.Length);

            return Convert.ToBase64String(encryptedData);
        }

        public static string Decode2(string decryptString, string decryptKey)
        {
            try
            {
                decryptKey = Utils.CutString(decryptKey, 0, 32);
                decryptKey = decryptKey.PadRight(32, ' ');

                RijndaelManaged rijndaelProvider = new RijndaelManaged();
                rijndaelProvider.Key = Encoding.UTF8.GetBytes(decryptKey);
                rijndaelProvider.IV = Keys;
                rijndaelProvider.Mode = CipherMode.ECB;
                rijndaelProvider.Padding = PaddingMode.PKCS7;
                ICryptoTransform rijndaelDecrypt = rijndaelProvider.CreateDecryptor();

                byte[] inputData = Convert.FromBase64String(decryptString);
                byte[] decryptedData = rijndaelDecrypt.TransformFinalBlock(inputData, 0, inputData.Length);

                return Encoding.UTF8.GetString(decryptedData);
            }
            catch
            {
                return "";
            }

        }

	}

	/// <summary> 
	/// ����
	/// </summary> 
    [Serializable]
	public class DES
	{

        #region EncryptKey
        public static string EncryptKey
        {
            get { return "hiatai.com"; }
        }
        #endregion
		//Ĭ����Կ����
		private static byte[] Keys = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };
		
		
		/// <summary>
		/// DES�����ַ���
		/// </summary>
		/// <param name="encryptString">�����ܵ��ַ���</param>
		/// <param name="encryptKey">������Կ,Ҫ��Ϊ8λ</param>
		/// <returns>���ܳɹ����ؼ��ܺ���ַ���,ʧ�ܷ���Դ��</returns>
		public static string Encode(string encryptString, string encryptKey)
		{
            encryptKey = Utils.CutString(encryptKey, 0, 8);
			encryptKey = encryptKey.PadRight(8, ' ');
			byte[] rgbKey = Encoding.UTF8.GetBytes(encryptKey.Substring(0, 8));
			byte[] rgbIV = Keys;
			byte[] inputByteArray = Encoding.UTF8.GetBytes(encryptString);
			DESCryptoServiceProvider dCSP = new DESCryptoServiceProvider();
			MemoryStream mStream = new MemoryStream();
			CryptoStream cStream = new CryptoStream(mStream, dCSP.CreateEncryptor(rgbKey, rgbIV), CryptoStreamMode.Write);
			cStream.Write(inputByteArray, 0, inputByteArray.Length);
			cStream.FlushFinalBlock();
			return Convert.ToBase64String(mStream.ToArray());
		
		}
        public static string Encode(string encryptString)
        {
            return Encode(encryptString, DES.EncryptKey);
        }

		/// <summary>
		/// DES�����ַ���
		/// </summary>
		/// <param name="decryptString">�����ܵ��ַ���</param>
		/// <param name="decryptKey">������Կ,Ҫ��Ϊ8λ,�ͼ�����Կ��ͬ</param>
		/// <returns>���ܳɹ����ؽ��ܺ���ַ���,ʧ�ܷ�Դ��</returns>
		public static string Decode(string decryptString, string decryptKey)
		{
			try
			{
                decryptKey = Utils.CutString(decryptKey, 0, 8);
				decryptKey = decryptKey.PadRight(8, ' ');
				byte[] rgbKey = Encoding.UTF8.GetBytes(decryptKey);
				byte[] rgbIV = Keys;
				byte[] inputByteArray = Convert.FromBase64String(decryptString);
				DESCryptoServiceProvider DCSP = new DESCryptoServiceProvider();
		
				MemoryStream mStream = new MemoryStream();
				CryptoStream cStream = new CryptoStream(mStream, DCSP.CreateDecryptor(rgbKey, rgbIV), CryptoStreamMode.Write);
				cStream.Write(inputByteArray, 0, inputByteArray.Length);
				cStream.FlushFinalBlock();
				return Encoding.UTF8.GetString(mStream.ToArray());
			}
			catch
			{
				return "";
			}
		
		}
        public static string Decode(string decryptString)
        {
            return Decode(decryptString, DES.EncryptKey);
        }


	} 
}