import cron from 'node-cron';
import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

const API_URL = `${process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000'}/api/cron`;
const CRON_SECRET = process.env.CRON_SECRET;

// 定义运行间隔，默认每小时运行一次
const CRON_SCHEDULE = process.env.CRON_SCHEDULE || '0 * * * *';

// 验证环境变量
if (!CRON_SECRET) {
  console.warn('警告: CRON_SECRET 环境变量未设置，这可能导致安全问题');
}

// 执行任务
async function runTask() {
  const now = new Date();
  console.log(`[${now.toISOString()}] 开始执行定时任务...`);
  
  try {
    const response = await axios.get(API_URL, {
      headers: {
        Authorization: `Bearer ${CRON_SECRET || ''}`
      },
      timeout: 300000 // 5分钟超时
    });
    
    console.log(`[${new Date().toISOString()}] 任务完成:`, response.data.message);
  } catch (error) {
    if (axios.isAxiosError(error)) {
      console.error('任务执行失败:', error.message);
      if (error.response) {
        console.error('响应状态:', error.response.status);
        console.error('响应数据:', error.response.data);
      }
    } else {
      console.error('任务执行过程中发生错误:', error);
    }
  }
}

// 立即执行一次，便于调试
if (process.argv.includes('--run-now')) {
  console.log('立即执行定时任务...');
  runTask();
}

// 启动定时任务
cron.schedule(CRON_SCHEDULE, runTask);

console.log(`定时任务已启动，调度: "${CRON_SCHEDULE}"`);
console.log('按 Ctrl+C 停止');

// 保持进程运行
process.on('SIGINT', () => {
  console.log('定时任务已停止');
  process.exit(0);
}); 