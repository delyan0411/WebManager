﻿using System;

namespace JiuZhou.Model
{
    public enum EStatus
    {
        /// <summary>
        /// 所有状态
        /// </summary>
        ALL_STATUS = -2,
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 正常
        /// </summary>
        NORMAL = 1,
        /// <summary>
        /// 锁定
        /// </summary>
        LOCK = 2,
        /// <summary>
        /// 禁用
        /// </summary>
        DISABLE = 3,
        /// <summary>
        /// 删除
        /// </summary>
        DELETE = 4
    }
}